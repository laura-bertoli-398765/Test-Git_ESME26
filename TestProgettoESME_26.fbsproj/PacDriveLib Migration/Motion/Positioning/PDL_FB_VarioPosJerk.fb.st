__METADATA__
{
  "v3Meta": {
    "objectGuid": "77c39bb0-833e-498d-b121-5a9a4e720fa3",
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
FUNCTION_BLOCK PDL_FB_VarioPosJerk

VAR_INPUT
	i_xEnable					: BOOL;				(* Enable of FB *)
	i_ifDrive					: MOIN.IF_Axis; 	(* Axis *)
	i_xStart					: BOOL;				(* Starts with pos. edge *)
	i_xStop						: BOOL;				(* Stops with pos. level *)
	i_lrTarget  				: LREAL;			(* target position or distance in [U] *)
	i_lrVel						: LREAL;			(* ceiling velocity in U/sec *)
	i_lrAcc						: LREAL;			(* Acceleration units/s^2, value: 0...lrLimitMaxAccDec *)
	i_lrDec						: LREAL;			(* Deceleration units/s^2, value: 0...lrLimitMaxAccDec *)
	i_lrJerk					: LREAL;			(* Jerk units/s^3, value: >0 *)
	i_etPosMode					: PDL_ET_PosMode;	(* POS_ENDLESS, POS_RELATIVE, POS_ABSOLUTE *)
END_VAR

VAR_OUTPUT
	q_xActive					: BOOL;				(* FB enabled *)
	q_xReady					: BOOL;
	q_etDiag					: GD.ET_Diag := GD.ET_Diag.OK;
	q_etDiagExt					: PDL_ET_DiagExt := PDL_ET_DiagExt.Disabled;
	q_sMsg						: STRING[80];
	q_xMotionInstructionActive	: BOOL;				(* axis is moving *)
	q_lrPosition				: LREAL;			(* axis position *)
	q_xInPosition				: BOOL;				(* target position reached *)
END_VAR

VAR
	xInterfacesInitialised		: BOOL; 
		
	xEnableFlag					: BOOL;
	diState						: DINT;
	fbRtrigStartEdge			: Standard.R_TRIG;
	lrTarget					: LREAL; //for setting diag msg
	etActivePosMode				: PDL_ET_PosMode;
	
	fbLoggerPoint				: APL.FB_LoggerPoint;

	fbHalt						: PLCO.MC_Halt;
	fbStop						: PLCO.MC_Stop;
	fbMoveAbsolute				: PLCO.MC_MoveAbsolute;
	fbMoveRelative				: PLCO.MC_MoveRelative;
	fbSetPos					: PLCO.MC_SetPosition;

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
	fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
								i_etDiag		:= q_etDiag,
								i_udiDiagExt	:= q_etDiagExt,
								i_sMessage		:= 'enable function block');
										
	q_xMotionInstructionActive	:= FALSE;
	q_xInPosition				:= FALSE;
	q_xActive					:= TRUE;
	q_xReady					:= FALSE;
	diState := 0;
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
					i_etDiagExt := PDL_ET_DiagExt.Initializing,
					i_sMsg		:= '');
					
	xInterfacesInitialised := Init();
	IF NOT xInterfacesInitialised THEN
		RETURN;
	END_IF

	q_xReady := TRUE;
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
					i_etDiagExt := PDL_ET_DiagExt.WaitForStart,
					i_sMsg		:= '');				
	diState	:= 10;		
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
		
	IF xInterfacesInitialised THEN

		q_xMotionInstructionActive	:= FALSE;
		q_xInPosition				:= FALSE;
		q_xReady 					:= FALSE;
		
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
						i_etDiagExt := PDL_ET_DiagExt.WaitUntilDisabled,
						i_sMsg		:= '');
						
		diState						:= 100;
	ELSE
		q_xActive					:= FALSE;
		q_xReady					:= FALSE;			
		q_xMotionInstructionActive	:= FALSE;
		q_xInPosition				:= FALSE;
		q_lrPosition				:= 0.0;
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
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

	//stop
	IF    i_xStop 
	  AND q_xMotionInstructionActive
	  AND diState = 10 //positioning active
	THEN
		fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
									i_etDiag		:= q_etDiag,
									i_udiDiagExt	:= q_etDiagExt,
									i_sMessage		:= 'stop positioning');
	
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK,
						i_etDiagExt := PDL_ET_DiagExt.Stopping,
						i_sMsg		:= '');
	
		diState := 30;
	END_IF

	//error
	IF  (	i_ifDrive.etAxisState = MOIN.ET_AxisState.ErrorStop
	  	OR  i_ifDrive.etAxisState = MOIN.ET_AxisState.Disabled
		)
		AND diState > 0 
		AND diState < 100 
	THEN
		q_xReady					:= FALSE;
		q_xMotionInstructionActive	:= FALSE;
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
		diState := 0;
	END_IF

	q_lrPosition := i_ifDrive.lrPosition;
END_IF
	
fbRtrigStartEdge(CLK := i_xStart);
{endregion}

(*--------------------------------------------------------------------------------------------------------------------------------------------*)
// State machine 
CASE  diState OF
(*********************************************************************************************************************)
	0: //Error or Not Enabled 
		;

(*********************************************************************************************************************)
	10:	//positioning
{region "positioniong"}			
		fbMoveAbsolute( Execute :=    q_xMotionInstructionActive 
								  AND (	 etActivePosMode = PDL_ET_PosMode.Absolute 
								  	  OR etActivePosMode = PDL_ET_PosMode.Endless
									  )
						);	
		fbMoveRelative( Execute :=    q_xMotionInstructionActive 
								  AND etActivePosMode = PDL_ET_PosMode.Relative
						);	
		
		fbStop( Execute := FALSE );
		fbHalt( Execute := FALSE );

		// Wait for pos. edge of Start
		IF fbRtrigStartEdge.Q  AND NOT i_xStop THEN

			IF q_xMotionInstructionActive THEN
				fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
											i_etDiag		:= q_etDiag,
											i_udiDiagExt	:= q_etDiagExt,
											i_sMessage		:= 'start new positioning');
			ELSE				
				fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
											i_etDiag		:= q_etDiag,
											i_udiDiagExt	:= q_etDiagExt,
											i_sMessage		:= 'start positioning');
			END_IF

			// error during parametercheck - diag output already set in method InputParameterCheck									
			IF NOT InputParameterCheck() THEN 
				q_xReady := FALSE;
				diState := 0;
				RETURN;
			END_IF

			q_xMotionInstructionActive	:= TRUE;
			q_xInPosition	:= FALSE;
			etActivePosMode	:= i_etPosMode;
				
			//execute  cmd
			SetPos();
			fbMoveAbsolute( Execute := FALSE );
			fbMoveRelative( Execute := FALSE );

			IF   i_etPosMode = PDL_ET_PosMode.Absolute 
			  OR i_etPosMode = PDL_ET_PosMode.Endless
			THEN
				IF 	  (i_etPosMode = PDL_ET_PosMode.Endless  AND i_lrTarget >= 0) 
				  OR  (i_etPosMode = PDL_ET_PosMode.Absolute AND (i_lrTarget - q_lrPosition) >= 0) 
				THEN
					fbMoveAbsolute.Direction := MOIN.ET_Direction.PositiveDirection;
				ELSE
					fbMoveAbsolute.Direction := MOIN.ET_Direction.NegativeDirection;
				END_IF
				fbMoveAbsolute.Acceleration 	:= i_lrAcc;
				fbMoveAbsolute.Deceleration 	:= i_lrDec;
				fbMoveAbsolute.Velocity 		:= i_lrVel;
				fbMoveAbsolute.Jerk 			:= i_lrJerk;
				fbMoveAbsolute.Position			:= i_lrTarget;
				fbMoveAbsolute( Execute := TRUE );
			ELSE
				fbMoveRelative.Acceleration 	:= i_lrAcc;
				fbMoveRelative.Deceleration 	:= i_lrDec;
				fbMoveRelative.Velocity 		:= i_lrVel;
				fbMoveRelative.Jerk 			:= i_lrJerk;
				fbMoveRelative.Distance			:= i_lrTarget;
				fbMoveRelative( Execute := TRUE );
			END_IF	

			//set diag msg
			IF    (i_etPosMode = PDL_ET_PosMode.Absolute) 
			  OR  (i_etPosMode = PDL_ET_PosMode.Endless) 
			THEN 
				lrTarget := i_lrTarget;
			ELSIF (i_etPosMode = PDL_ET_PosMode.Relative) THEN
				lrTarget := i_lrTarget + i_ifDrive.lrPosition;
			END_IF
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
							i_etDiagExt := PDL_ET_DiagExt.Positioning,
							i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1	:= 'Mode: ',
																	i_sString2	:= etPosModeToString(i_etPosMode := i_etPosMode),
																	i_sString3	:= ' Target: ',
																	i_sString4	:= TO_STRING(i_lrTarget)) );	
		//finished	
		ELSIF    fbMoveAbsolute.Done
			 AND (	etActivePosMode = PDL_ET_PosMode.Absolute 
				 OR etActivePosMode = PDL_ET_PosMode.Endless
				 )
			 OR  fbMoveRelative.Done
			 AND etActivePosMode = PDL_ET_PosMode.Relative
		THEN						
			q_xMotionInstructionActive	:= FALSE;
			q_xInPosition	:= TRUE;
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
							i_etDiagExt := PDL_ET_DiagExt.WaitForStart,
							i_sMsg		:= '');				
		END_IF

		//error
		IF fbMoveRelative.Error THEN
			q_xMotionInstructionActive	:= FALSE;
		
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
							i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
							i_sMsg		:= CONCAT('MC_MoveRelative.ErrorID: ', PLCO.FC_EtResultToString( fbMoveRelative.ErrorID ) ));	
			diState	:= 100;
		END_IF
	
		IF fbMoveAbsolute.Error THEN
			q_xMotionInstructionActive	:= FALSE;
		
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
							i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
							i_sMsg		:= CONCAT('MC_MoveAbsolute.ErrorID: ', PLCO.FC_EtResultToString( fbMoveAbsolute.ErrorID ) ));	
			diState	:= 100;
		END_IF
{endregion}

(*********************************************************************************************************************)
	30: //stop
{region "stop"}		
       	fbMoveAbsolute( Execute := FALSE  );
       	fbMoveRelative( Execute := FALSE  );
		fbStop(  Execute := FALSE );
		
		fbHalt( Execute 		:= TRUE,
				Deceleration 	:= i_lrDec, 
				Jerk 			:= i_lrJerk
				);

		//stopping done
		IF		fbHalt.Done 
			OR  i_ifDrive.etAxisState = MOIN.ET_AxisState.Standstill
		THEN
			q_xMotionInstructionActive := FALSE;		
			
			fbHalt(  Execute := FALSE );
			
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
							i_etDiagExt := PDL_ET_DiagExt.WaitForStart,
							i_sMsg		:= '');
							
			diState	:= 10;
		END_IF
		
		//error																			
		IF fbHalt.Error THEN
			q_xMotionInstructionActive	:= FALSE;
		
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
							i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
							i_sMsg		:= CONCAT('MC_Halt.ErrorID: ', PLCO.FC_EtResultToString( fbHalt.ErrorID ) ));
			diState	:= 100;
		END_IF
{endregion}

(*********************************************************************************************************************)
	100: //controller stop
{region "controllerStop"}	
       	fbMoveAbsolute( Execute := FALSE  );
       	fbMoveRelative( Execute := FALSE  );
		fbHalt( Execute := FALSE );
		
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
			fbStop( Axis := i_ifDrive, Execute := FALSE );
			q_xInPosition	:= FALSE;
			q_xActive		:= FALSE;
			q_xReady		:= FALSE;
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
							i_etDiagExt := PDL_ET_DiagExt.Disabled,
							i_sMsg		:= '');
							
			diState			:= 0;
		END_IF
		
		//error		
		IF fbStop.Error AND fbStop.ErrorId <> PLCO.ET_Result.StoppingInterrupted THEN
			q_xMotionInstructionActive	:= FALSE;
			
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
							i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
							i_sMsg		:= CONCAT('MC_Stop.ErrorID: ', PLCO.FC_EtResultToString( fbStop.ErrorID ) ));
			fbStop( Execute := FALSE );	
		END_IF
{endregion}

END_CASE
(*--------------------------------------------------------------------------------------------------------------------------------------------*)




