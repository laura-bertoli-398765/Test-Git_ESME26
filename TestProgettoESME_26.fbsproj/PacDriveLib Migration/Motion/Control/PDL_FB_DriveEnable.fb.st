__METADATA__
{
  "v3Meta": {
    "objectGuid": "497519fb-3693-4348-9459-dd1ef3c0ef02",
    "objectTypeGuid": "6f9dac99-8de1-4efc-8465-68ac443b7d08",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__DECLARATION__
FUNCTION_BLOCK PDL_FB_DriveEnable
VAR_INPUT
	i_xEnable      : BOOL; (* Enable of FB *)
	i_ifDrive      : MOIN.IF_Axis; (* Axis *)
	i_xEnableDrive : BOOL; (* Power on *)
	i_xDiagQuit    : BOOL; (* reset error *)
END_VAR

VAR_OUTPUT
	q_xActive       : BOOL; (* FB enabled*)
	q_xReady        : BOOL;
	q_etDiag        : GD.ET_Diag     := GD.ET_Diag.Ok;
	q_etDiagExt     : PDL_ET_DiagExt := PDL_ET_DiagExt.Disabled;
	q_sMsg          : STRING[80];
	q_xDriveEnabled : BOOL; (* power is on*)
END_VAR

VAR
	xInterfacesInitialised : BOOL;
	
	xEnableFlag : BOOL;
	diState     : DINT;
	
	rtrigDiagQuit    : Standard.R_TRIG;
	xDriveEnabledOld : BOOL;
	
	fbLoggerPoint : APL.FB_LoggerPoint;
	
	fbPower : PLCO.MC_Power;
	fbStop  : PLCO.MC_Stop;
	fbReset	: PLCO.MC_Reset;
	
	ifDeviceTreeObjectAccess      : UFMPLCI.IF_DeviceTreeObjectAccess;
	sDriveName                    : STRING(80);
	ifGetParentDevice             : DTSI.IF_GetParentDevice;
	ifDiagnostic                  : UFMPLCI.IF_Diagnostic;
	ifDiagnosticAccess            : UFMPLCI.IF_DiagnosticAccess;
	ifDeviceAccess                : DTSI.IF_DeviceAccess;
	ifPowerSupply                 : DDI.IF_PowerSupply;
	ifPowerSupplyAccess           : DDI.IF_PowerSupplyAccess;
	ifDrivePowerSupply            : DDI.IF_DrivePowerSupply;
	ifDrivePowerSupplyAccess      : DDI.IF_DrivePowerSupplyAccess;
	ifDriveConfigAccess           : DDI.IF_DriveConfigAccess;
	ifDriveConfig                 : DDI.IF_DriveConfig;
	ifWorkingModeAccess           : CFDI.IF_WorkingModeAccess;
	ifWorkingMode                 : CFDI.IF_WorkingMode;
	ifPowerSupplyDiagnosticAccess : UFMPLCI.IF_DiagnosticAccess;
	ifPowerSupplyDiagnostic       : UFMPLCI.IF_Diagnostic;
	ifPowerSupplyDevice           : DDI.DeviceTypeInterfaces.IF_Device_Type;
	xSuccess                      : BOOL;
	etSercosState                 : SMI.ET_SercosState;
	tonTimeOut                    : Standard.TON;
	xDriveIsReal                  : BOOL;
END_VAR
VAR CONSTANT
	c_timTimeoutPowerSupplyReady  : TIME := T#2000MS;
	c_timTimeoutPowerSupplyEnable : TIME := T#2000MS;
END_VAR
__IMPLEMENTATION__
(*--------------------------------------------------------------------------------------------------------------------------------------------*)
//Enable
{region "enable"}	
IF i_xEnable AND NOT xEnableFlag THEN
	xEnableFlag := TRUE;

	THIS^.fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
										i_etDiag		:= q_etDiag,
										i_udiDiagExt	:= q_etDiagExt,
										i_sMessage		:= 'enable function block',
										q_etDiag		=> ,
										q_etDiagExt		=> );
	q_xActive			:= TRUE;
	q_xDriveEnabled		:= FALSE;
					
	IF NOT Init() THEN
		q_xReady			    := FALSE;
		xInterfacesInitialised  := FALSE;
		diState := 200;	
	ELSE
		q_xReady 				:= TRUE;
		xInterfacesInitialised  := TRUE;
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok,
						i_etDiagExt := PDL_ET_DiagExt.WaitForEnableDrive,
						i_sMsg		:= '');	
		diState	:= 10;
	END_IF
{endregion}

(*--------------------------------------------------------------------------------------------------------------------------------------------*)
//Disable
{region "disable"}	
ELSIF NOT i_xEnable AND xEnableFlag THEN
	xEnableFlag := FALSE;
	THIS^.fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
										i_etDiag		:= q_etDiag,
										i_udiDiagExt	:= q_etDiagExt,
										i_sMessage		:= 'disable function block',
										q_etDiag		=> ,
										q_etDiagExt		=> );
	q_xReady			:= FALSE;
	IF xInterfacesInitialised THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok,
						i_etDiagExt := PDL_ET_DiagExt.WaitUntilDriveDisabled,
						i_sMsg		:= '');
						
		diState := 100; // whait till axis disabled
	ELSE
		q_xActive			:= FALSE;
		q_xDriveEnabled		:= FALSE;

		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok,
						i_etDiagExt := PDL_ET_DiagExt.Disabled,
						i_sMsg		:= '');
		diState	:= 0;
	END_IF	
END_IF
{endregion}

(*--------------------------------------------------------------------------------------------------------------------------------------------*)
// Cyclic when enabled
{region "cyclic"}
IF xInterfacesInitialised AND q_xActive THEN
	q_xDriveEnabled :=  i_ifDrive.etAxisState >= MOIN.ET_AxisState.Standstill;
	etSercosState := FC_GetSercosState();
	fbReset( Execute := FALSE );

	IF xDriveIsReal AND_THEN ifPowerSupplyDiagnostic.DiagClass >= 3 THEN
		fbPower( Enable := FALSE );				
		q_xReady	:= FALSE;
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.PowerSupplyConditionInvalid,
						i_etDiagExt := PDL_ET_DiagExt.PowerSupplyNotReady,
						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1 := 'DiagCode: ', 
														i_sString2 := TO_STRING(ifPowerSupplyDiagnostic.DiagCode), 
														i_sString3 := ' - DiagMsg: ', 
														i_sString4 := ifPowerSupplyDiagnostic.DiagMsg));
		diState := 200;

	//check for drive errors
	ELSIF ifDiagnostic.DiagClass >= 3 THEN
		fbPower( Enable := FALSE );	
		q_xReady		:= FALSE;
		q_xDriveEnabled := FALSE;
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.DriveConditionInvalid,
						i_etDiagExt := PDL_ET_DiagExt.DriveNotReady,
						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1 := 'DiagCode: ', 
																i_sString2 := TO_STRING(ifDiagnostic.DiagCode), 
																i_sString3 := ' - DiagMsg: ', 
																i_sString4 := ifDiagnostic.DiagMsg));		
		diState := 200;
	
	//check sercos state
	ELSIF etSercosState <> SMI.ET_SercosState.Phase4 THEN
		fbPower( Enable := FALSE );	
		q_xReady:= FALSE;
		q_xDriveEnabled:= FALSE;
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.SercosConditionInvalid, 
						i_etDiagExt := PDL_ET_DiagExt.SercosNotInPhaseFour,
						i_sMsg		:= 'Sercos not in phase four');
		diState:= 200;

	//check inverter enable
	ELSIF xDriveIsReal AND_THEN NOT ifDrivePowerSupply.InverterEnable AND i_xEnableDrive THEN
		fbPower( Enable := FALSE );	
		q_xReady			:= FALSE;
		q_xDriveEnabled		:= FALSE;
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.DriveConditionInvalid,
						i_etDiagExt := PDL_ET_DiagExt.InverterEnableOff,
						i_sMsg		:= sDriveName);
		diState := 200;
	END_IF

	//stop/disable drive
	IF    NOT i_xEnableDrive 
	  AND diState = 10  
	  AND fbPower.Enable 
	THEN
		THIS^.fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
											i_etDiag		:= q_etDiag,
											i_udiDiagExt	:= q_etDiagExt,
											i_sMessage		:= 'disable drive',
											q_etDiag		=> ,
											q_etDiagExt		=> );
	
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok,
						i_etDiagExt := PDL_ET_DiagExt.WaitUntilDriveDisabled,
						i_sMsg		:= '');
		
		//if power on -> stop first
		IF fbPower.Status THEN							
			diState := 30;
		ELSE
			diState := 100;
		END_IF
	END_IF


	
END_IF

IF q_xActive THEN
	rtrigDiagQuit(CLK := i_xDiagQuit);
END_IF
{endregion}

(*--------------------------------------------------------------------------------------------------------------------------------------------*)
//state machine
CASE diState OF
	
(*********************************************************************************************************************)
	0:	//Error or Not Enabled 
		;

(*********************************************************************************************************************)
	10:	//enable drive
{region "enableDrive"}	
		fbStop(Axis := i_ifDrive, Execute := FALSE );
		
		//set diag outpupt after enable cmd
		IF 	  i_xEnableDrive 
		  AND NOT fbPower.Enable
		  AND i_xEnable
		THEN
			IF xDriveIsReal AND_THEN NOT ifPowerSupply.PowerSupplyCheck THEN
				ifPowerSupply.PowerSupplyCheckSet	:= TRUE;
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok,
								i_etDiagExt := PDL_ET_DiagExt.WaitUntilPowerSupplyReady,
								i_sMsg		:= '');	
				tonTimeout(IN := FALSE, PT := c_timTimeoutPowerSupplyReady);		(* init Timeout for PS Ready *)
				diState	:= 20;
				RETURN;
			ELSE
				THIS^.fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
													i_etDiag		:= q_etDiag,
													i_udiDiagExt	:= q_etDiagExt,
													i_sMessage		:= 'enable drive',
													q_etDiag		=> ,
													q_etDiagExt		=> );
												
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok,
								i_etDiagExt := PDL_ET_DiagExt.WaitUntilDriveEnabled,
								i_sMsg		:= '');	
			END_IF
		END_IF

		//cmd power on 
		fbPower( Enable :=  i_xEnableDrive AND i_xEnable );
		q_xDriveEnabled :=  i_ifDrive.etAxisState >= MOIN.ET_AxisState.Standstill;
		
		//set diag output when on
		IF    q_xDriveEnabled 
		  AND NOT xDriveEnabledOld 
		THEN
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok,
							i_etDiagExt := PDL_ET_DiagExt.DriveEnabled,
							i_sMsg		:= '');
		END_IF
		
		//error
		IF fbPower.Error THEN
			q_xReady		:= FALSE;			
			q_xDriveEnabled	:= FALSE;
		
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
							i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
							i_sMsg		:= CONCAT('MC_Power.ErrorID: ', PLCO.FC_EtResultToString( fbPower.ErrorID ) ));	
							
			fbPower( Enable := FALSE );							
			diState	:= 200;
		END_IF
{endregion}

(*********************************************************************************************************************)
	20: (* Wait for PowerSupply GroupState >= 2 *)
{region "error"}		
		tonTimeout(IN := TRUE);
		IF ifPowerSupply.GroupState >= 2  THEN								(* GroupState on PS *)
			tonTimeout(IN := FALSE, PT := c_timTimeoutPowerSupplyEnable);	(* init Timeout for PS Enabled *)
			diState := 10;
		
		ELSIF tonTimeout.Q THEN			
			q_xReady	:= FALSE;
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.PowerSupplyConditionInvalid,
							i_etDiagExt := PDL_ET_DiagExt.PowerSupplyNotReady,
							i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1 := 'DiagCode: ', 
																	i_sString2 := TO_STRING(ifPowerSupplyDiagnostic.DiagCode), 
																	i_sString3 := ' - DiagMsg: ', 
																	i_sString4 := ifPowerSupplyDiagnostic.DiagMsg));		
			diState := 10;
		END_IF
{endregion}

(*********************************************************************************************************************)
	30: //controllerStop
{region "controllerStop"}		
		IF 	  i_ifDrive.etAxisState <> MOIN.ET_AxisState.Disabled
		  AND i_ifDrive.etAxisState <> MOIN.ET_AxisState.ErrorStop
		  AND i_ifDrive.etAxisState <> MOIN.ET_AxisState.Standstill
		  AND i_ifDrive.etAxisState <> MOIN.ET_AxisState.Stopping
		THEN
			fbStop.Execute 			:= TRUE; 
			fbStop.Deceleration 	:= i_ifDrive.lrErrorStopDec; 
			fbStop.Jerk 			:= i_ifDrive.lrErrorStopJerk; 
		END_IF
		
		fbStop();
		
		//stopping done
		IF 	  i_ifDrive.etAxisState = MOIN.ET_AxisState.Disabled
		  OR  i_ifDrive.etAxisState = MOIN.ET_AxisState.ErrorStop
		  OR  i_ifDrive.etAxisState = MOIN.ET_AxisState.Standstill
		  OR  fbStop.Done
		THEN
			fbStop( Axis := i_ifDrive, Execute := FALSE );

			diState := 100;
		END_IF

		//error
		IF fbStop.Error AND fbStop.ErrorId <> PLCO.ET_Result.StoppingInterrupted THEN
			q_xReady		:= FALSE;			
			q_xDriveEnabled	:= FALSE;
			
			fbStop( Axis := i_ifDrive, Execute := FALSE );
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
							i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
							i_sMsg		:= CONCAT('MC_Stop.ErrorID: ', PLCO.FC_EtResultToString(fbStop.ErrorID) ));	
			diState := 100;							
		END_IF
{endregion}

(*********************************************************************************************************************)
	100: //disable drive
{region "disableDrive"}		
		fbStop( Execute := FALSE );
		fbPower( Enable :=  FALSE );
		
		q_xDriveEnabled := i_ifDrive.etAxisState >= MOIN.ET_AxisState.Standstill;
	
		//wait for power off
		IF NOT q_xDriveEnabled THEN
			IF NOT i_xEnable THEN
				q_xActive := FALSE;
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok,
								i_etDiagExt := PDL_ET_DiagExt.Disabled,
								i_sMsg		:= '');
				diState	:= 0;
			ELSE
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok,
								i_etDiagExt := PDL_ET_DiagExt.WaitForEnableDrive,
								i_sMsg		:= '');					
				diState	:= 10;
			END_IF
		END_IF
		
		//error
		IF fbPower.Error THEN
			q_xReady		:= FALSE;			
			q_xDriveEnabled	:= FALSE;
		
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
							i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
							i_sMsg		:= CONCAT('MC_Power.ErrorID: ', PLCO.FC_EtResultToString( fbPower.ErrorID ) ));	
			fbStop( Execute := FALSE );							
		  	IF i_xEnable THEN							
				diState	:= 200;
			ELSE
				diState	:= 0;
			END_IF	
		END_IF
{endregion}

(*********************************************************************************************************************)
	200: //error
{region "error"}		
		IF rtrigDiagQuit.Q //wait for cmd diag quit
		THEN
			THIS^.fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
												i_etDiag		:= q_etDiag,
												i_udiDiagExt	:= q_etDiagExt,
												i_sMessage		:= 'diag quit',
												q_etDiag		=> ,
												q_etDiagExt		=> );
			IF NOT Init() THEN
				// error was not quittable -> keep error state
				xInterfacesInitialised := FALSE;

			ELSE
				// reset error
				IF i_ifDrive.etAxisState = MOIN.ET_AxisState.ErrorStop THEN
					fbReset( Execute := TRUE );
				END_IF
				
				xInterfacesInitialised := TRUE;
				q_xReady := TRUE;
				q_etDiag := GD.ET_Diag.Ok; // has to be done outside of SetDiagOutput too, because new Diagnosis is only set if FB does not signal Error
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok,
								i_etDiagExt := PDL_ET_DiagExt.WaitForEnableDrive,
								i_sMsg		:= '');
				diState := 10;
			END_IF
		END_IF
{endregion}

END_CASE
(*--------------------------------------------------------------------------------------------------------------------------------------------*)
xDriveEnabledOld := q_xDriveEnabled;


