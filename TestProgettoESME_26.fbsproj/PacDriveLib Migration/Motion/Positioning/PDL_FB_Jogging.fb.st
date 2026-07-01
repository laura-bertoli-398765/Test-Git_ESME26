__METADATA__
{
  "v3Meta": {
    "objectGuid": "0957db48-f6b8-447c-8c0c-5693f648c8bb",
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
FUNCTION_BLOCK PDL_FB_Jogging
VAR_INPUT
	i_xEnable					: BOOL;				(* enables the FB *)
	i_ifDrive					: MOIN.IF_Axis;		(* Axis *)	
	i_xJogForw					: BOOL;				(* Jogging Forward *)
	i_xJogBack					: BOOL;				(* Jogging Backward *)
	i_lrPeriod					: LREAL;			(* if Periode = 0 --> no Position manipulation *)
	i_xEndless					: BOOL;				(* TRUE = jogging endless, FALSE = jogging with max Distance of Step *)
	i_lrMaxDistance				: LREAL;			(* Step  in Units *)
	i_lrVel						: LREAL;			(* ceiling velocity in U/sec; 0<=Vel<Velmax*)
	i_lrAcc						: LREAL;			(* Acceleration units/s^2, value: 0...lrLimitMaxAccDec *)
	i_lrDec						: LREAL;			(* Deceleration units/s^2, value: 0...lrLimitMaxAccDec *)
	i_lrJerk					: LREAL;				
END_VAR

VAR_OUTPUT
	q_xActive					: BOOL;				(* TRUE if  FB is enabled *)
	q_xReady					: BOOL;
	q_etDiag					: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt					: PDL_ET_DiagExt := PDL_ET_DiagExt.Disabled;
	q_sMsg						: STRING[80];
	q_xMotionInstructionActive	: BOOL;				(* TRUE if motion is active *)
	q_lrPosition				: LREAL;			(* shows the Reference position of the axis *)
	q_xStepFinished				: BOOL;				(* TRUE if step is done *)
END_VAR

VAR
	xInterfacesInitialised		: BOOL;
	fbLoggerPoint				: APL.FB_LoggerPoint;
	
	diState						: DINT;
	xEnableFlag					: BOOL;
	iPeriodeCount				: INT;
	lrPosBuffer					: LREAL;

	fbSetPos					: PLCO.MC_SetPosition;	
	fbStop						: PLCO.MC_Stop;
	fbJog						: PLCO.MC_Jog;	
	xJogForwardStarted			: BOOL; //FALSE: jogging backward, TRUE: jogging forward, 
	
	xSuccess					: BOOL;
	ifGetParentDevice   		: DTSI.IF_GetParentDevice;
	ifDeviceAccess      		: DTSI.IF_DeviceAccess;
	ifDriveConfigAccess			: DDI.IF_DriveConfigAccess;
	ifDriveConfig				: DDI.IF_DriveConfig;

	ifDeviceTreeObjectAccess      : UFMPLCI.IF_DeviceTreeObjectAccess;
	sDriveName                    : STRING(80);

END_VAR

__IMPLEMENTATION__
(*--------------------------------------------------------------------------------------------------------------------------------------------*)
//Enable
{region "enable"}	
IF i_xEnable AND NOT xEnableFlag THEN
	xEnableFlag := TRUE;
	q_xActive					:= TRUE;
	q_xReady					:= FALSE;
	q_xMotionInstructionActive	:= FALSE;
	q_xStepFinished				:= FALSE;
	diState := 0;
	fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
								i_etDiag		:= q_etDiag,
								i_udiDiagExt	:= q_etDiagExt,
								i_sMessage		:= 'enable function block');
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
					i_etDiagExt := PDL_ET_DiagExt.Initializing,
					i_sMsg		:= '');

	xInterfacesInitialised := Init();
	IF NOT xInterfacesInitialised THEN
		RETURN;
	END_IF
	
	IF NOT InputParameterCheck( xCheckDistance := FALSE, xCheckPeriod := FALSE ) THEN
		RETURN;
	END_IF
	
	//check axis state
	IF  (	i_ifDrive.etAxisState = MOIN.ET_AxisState.ErrorStop
	  	OR  i_ifDrive.etAxisState = MOIN.ET_AxisState.Disabled
		)
	THEN
		IF i_ifDrive.etAxisState = MOIN.ET_AxisState.Disabled THEN
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.DriveConditionInvalid, 
							i_etDiagExt := PDL_ET_DiagExt.DriveNotReady,
							i_sMsg		:= STANDARD.CONCAT(sDriveName,' is DISABLED'));
		END_IF		
		IF i_ifDrive.etAxisState = MOIN.ET_AxisState.ErrorStop THEN				
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.DriveConditionInvalid, 
							i_etDiagExt := PDL_ET_DiagExt.DriveNotReady,
							i_sMsg		:= STANDARD.CONCAT(sDriveName,' is ERRORSTOP'));
		END_IF
	
	ELSE
		//set q_lrPosition 
		IF NOT SetPos() THEN
			RETURN; 
		END_IF
		q_xReady := TRUE;
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok, 
						i_etDiagExt := PDL_ET_DiagExt.WaitForJoggingInputsLow,
						i_sMsg		:= '');
						
		fbJog(	JogForward := FALSE, JogBackward := FALSE );
		fbStop( Execute := FALSE );						
		diState := 10;
	END_IF
{endregion}

(*--------------------------------------------------------------------------------------------------------------------------------------------*)
//Disable
{region "disable"}	
ELSIF NOT i_xEnable AND xEnableFlag THEN
	xEnableFlag := FALSE;
	fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
								i_etDiag		:= q_etDiag,
								i_udiDiagExt	:= q_etDiagExt,
								i_sMessage		:= 'disable function block');
	q_xReady		:= FALSE;
	q_xStepFinished	:= FALSE;
	IF xInterfacesInitialised THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok, 
						i_etDiagExt := PDL_ET_DiagExt.WaitUntilDisabled,
						i_sMsg		:= '');			
		diState := 100;
	ELSE
		q_xActive					:= FALSE;		
		q_xMotionInstructionActive	:= FALSE;			
		q_lrPosition				:= 0.0;			
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok, 
						i_etDiagExt := PDL_ET_DiagExt.Disabled,
						i_sMsg		:= '');	
		diState := 0;
	END_IF
END_IF
{endregion}

(*--------------------------------------------------------------------------------------------------------------------------------------------*)
// Cyclic when enabled
{region "cyclic"}
IF xInterfacesInitialised AND q_xActive THEN
	
	//error
	IF  (	i_ifDrive.etAxisState = MOIN.ET_AxisState.ErrorStop
	  	OR  i_ifDrive.etAxisState = MOIN.ET_AxisState.Disabled
		)
		AND diState > 0 
		AND diState < 100 
	THEN
		diState := 0;
		
		q_xReady					:= FALSE;
		q_xStepFinished				:= FALSE;
		q_xMotionInstructionActive	:= FALSE;
		
		IF i_ifDrive.etAxisState = MOIN.ET_AxisState.Disabled THEN
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.DriveConditionInvalid, 
							i_etDiagExt := PDL_ET_DiagExt.DriveNotReady,
							i_sMsg		:= ' Axis is DISABLED');
		END_IF		
		IF i_ifDrive.etAxisState = MOIN.ET_AxisState.ErrorStop THEN				
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.DriveConditionInvalid, 
							i_etDiagExt := PDL_ET_DiagExt.DriveNotReady,
							i_sMsg		:= ' Axis in ERRORSTOP');		
		END_IF				
	END_IF
	
	//set q_lrPosition 
	SetPos();
	
END_IF
{endregion}

(*--------------------------------------------------------------------------------------------------------------------------------------------*)
// State machine 
CASE  diState OF
	
(*********************************************************************************************************************)
	0://Error or Not Enabled 
		;

(*********************************************************************************************************************)
	10:	// Wait for jogging inputs low 
{region "wait for inputs reset"}
		IF NOT i_xJogForw AND NOT i_xJogBack THEN
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok, 
							i_etDiagExt := PDL_ET_DiagExt.WaitForJogging,
							i_sMsg		:= '');	
			diState := 20;
		END_IF
{endregion}

(*********************************************************************************************************************)
	20:	//Wait for start
{region "wait for start"}		
		IF i_xJogForw OR i_xJogBack THEN
			xJogForwardStarted := i_xJogForw;
			
			//set logger msg
			IF i_xJogForw THEN
				fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
											i_etDiag		:= q_etDiag,
											i_udiDiagExt	:= q_etDiagExt,
											i_sMessage		:= 'Jog Forward' );
			ELSE
				fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
											i_etDiag		:= q_etDiag,
											i_udiDiagExt	:= q_etDiagExt,
											i_sMessage		:= 'Jog Backward' );
			END_IF
			
			//check inputs												
			IF NOT InputParameterCheck() THEN
				q_xReady := FALSE;
				diState  := 0;				
				
			ELSE
				//start movement
				IF i_xEndless THEN
					fbJog.JogType := PLCO.MC_JogType.Velocity;
				ELSE
					fbJog.JogType := PLCO.MC_JogType.PositionOffset;
				END_IF

				fbJog(	JogForward		:= i_xJogForw, 
						JogBackward		:= i_xJogBack AND NOT i_xJogForw, //if both inputs are true -> move forward  
						Position		:= i_lrMaxDistance, 
						Velocity		:= i_lrVel, 
						Acceleration	:= i_lrAcc, 
						Deceleration	:= i_lrDec, 
						Jerk			:= i_lrJerk );
					
				IF fbJog.Error THEN
					diState:= 0;
					q_xMotionInstructionActive	:= FALSE;
					SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
									i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
									i_sMsg		:= CONCAT('MC_Jog.ErrorId: ', TO_STRING(fbJog.ErrorId)));
					fbJog( JogForward := FALSE, JogBackward := FALSE ); 								
					RETURN;
				END_IF
				
				q_xMotionInstructionActive	:= TRUE;
				q_xStepFinished				:= FALSE;
				
				//set diag output
				IF i_xJogForw THEN
					SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok, 
									i_etDiagExt := PDL_ET_DiagExt.JoggingForward,
									i_sMsg		:= '');	
				ELSE			
					SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok, 
									i_etDiagExt := PDL_ET_DiagExt.JoggingBackward,
									i_sMsg		:= '');	
				END_IF	

				diState := 30;
			END_IF
		END_IF
{endregion}

(*********************************************************************************************************************)
	30:	//jogging movement active
{region "jogging active"}	
		fbJog();
	
		//stop jogging movement 
		IF    fbJog.Busy 
		  AND (   NOT i_xJogForw AND xJogForwardStarted 
		      OR  NOT i_xJogBack AND NOT xJogForwardStarted
			  ) 
		THEN
			IF xJogForwardStarted THEN
				fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
											i_etDiag		:= q_etDiag,
											i_udiDiagExt	:= q_etDiagExt,
											i_sMessage		:= 'Hold jogging forward');
			ELSE
				fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
											i_etDiag		:= q_etDiag,
											i_udiDiagExt	:= q_etDiagExt,
											i_sMessage		:= 'Hold jogging backward');
			END_IF	
			
			fbJog(	JogForward := FALSE, JogBackward := FALSE ); 

			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok, 
							i_etDiagExt := PDL_ET_DiagExt.WaitUntilStopped,
							i_sMsg		:= '');
			diState := 50;

		//target pos reached: go to waiting step when inputs are false
		ELSIF fbJog.Done AND NOT i_xJogForw AND NOT i_xJogBack THEN
			fbJog(	JogForward := FALSE, JogBackward := FALSE );
			
			IF xJogForwardStarted THEN
				fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
											i_etDiag		:= q_etDiag,
											i_udiDiagExt	:= q_etDiagExt,
											i_sMessage		:= 'Finished jogging forward');
			ELSE									
				fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
											i_etDiag		:= q_etDiag,
											i_udiDiagExt	:= q_etDiagExt,
											i_sMessage		:= 'Finished jogging backward');
			END_IF
			q_xMotionInstructionActive	:= FALSE;
			q_xStepFinished				:= TRUE;
			
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok, 
							i_etDiagExt := PDL_ET_DiagExt.WaitForJogging,
							i_sMsg		:= '');
			diState := 20;

		//target pos reached: set diag mesg
		ELSIF fbJog.Done THEN
			IF NOT q_xStepFinished THEN
				fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.StatusMessage,
											i_etDiag		:= q_etDiag,
											i_udiDiagExt	:= q_etDiagExt,
											i_sMessage		:= 'Jog target reached',
											q_etDiag		=> ,
											q_etDiagExt		=> );
			END_IF
			q_xMotionInstructionActive	:= FALSE;
			q_xStepFinished				:= TRUE;
		END_IF	
			
		//error			
		IF fbJog.Error THEN
			q_xMotionInstructionActive	:= FALSE;
			q_xStepFinished				:= FALSE;
			q_xReady					:= FALSE;
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
							i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
							i_sMsg		:= CONCAT('MC_Jog.ErrorId: ', TO_STRING(fbJog.ErrorId)));
			fbJog( JogForward := FALSE, JogBackward := FALSE ); 	
			diState := 0;
		END_IF
{endregion}

(*********************************************************************************************************************)
	50://wait for jogging movement stopped 
{region "waitForJoggingMovementStopped"}	
		fbJog(	JogForward := FALSE, JogBackward := FALSE );
	
		IF i_ifDrive.etAxisState = MOIN.ET_AxisState.Standstill THEN
			q_xMotionInstructionActive	:= FALSE;
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok, 
							i_etDiagExt := PDL_ET_DiagExt.WaitForJogging,
							i_sMsg		:= '');
			diState := 20;

		ELSIF i_xJogForw OR i_xJogBack THEN
			diState := 20;
		END_IF
{endregion}

(*********************************************************************************************************************)
	100: //controller stop
{region "controllerstop"}
		fbJog(	JogForward := FALSE, JogBackward := FALSE );
		
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
			xInterfacesInitialised := FALSE;
			q_xMotionInstructionActive	:= FALSE;
			q_xStepFinished				:= FALSE;
			q_xActive					:= FALSE;
			q_xReady					:= FALSE;
			q_lrPosition				:= 0.0;
			fbStop( Execute := FALSE );
		
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
							i_etDiagExt := PDL_ET_DiagExt.Disabled,
							i_sMsg		:= '');
		
			diState := 0;
		END_IF
		
		//error		
		IF fbStop.Error AND fbStop.ErrorId <> PLCO.ET_Result.StoppingInterrupted THEN
			q_xMotionInstructionActive	:= FALSE;
			
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
							i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
							i_sMsg		:= CONCAT('MC_Stop.ErrorID: ', PLCO.FC_EtResultToString(fbStop.ErrorID) ));	
			fbStop( Execute := FALSE );							
		END_IF
{endregion}

END_CASE
(*--------------------------------------------------------------------------------------------------------------------------------------------*)





