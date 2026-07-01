__METADATA__
{
  "v3Meta": {
    "objectGuid": "53427b80-735d-476b-afdc-435f7af0ee51",
    "objectTypeGuid": "6f9dac99-8de1-4efc-8465-68ac443b7d08",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {
      "_3S.CoDeSys.LanguageModelManager.BuildProperty": "<?xml version=\"1.0\" encoding=\"utf-8\"?><Single xml:space=\"preserve\" Type=\"{24568a24-c491-472c-a21f-ee5d33859fab}\" Method=\"IArchivable\"><Single Name=\"MemoryReserveForOnlineChange\" Type=\"int\">0</Single><Single Name=\"ExcludeFromBuild\" Type=\"bool\">False</Single><Single Name=\"External\" Type=\"bool\">False</Single><Single Name=\"EnableSystemCall\" Type=\"bool\">False</Single><Single Name=\"CompilerDefines\" Type=\"string\"></Single><Single Name=\"LinkAlways\" Type=\"bool\">False</Single><Array Name=\"Undefines\" Type=\"string\" /></Single>"
    },
    "subObjects": {}
  }
}
__DECLARATION__
FUNCTION_BLOCK PDL_FB_EndlessFeed

VAR_INPUT
	i_xEnable					: BOOL;			(* Enable of FB *)
	i_ifDrive					: MOIN.IF_Axis;	(* Axis *) 
	i_lrVel 					: LREAL;		(* Ceiling velocity in units/sec, -MaxVel to +MaxVel *)
	i_lrAcc  					: LREAL;		(* Acceleration units/s^2, value: 0...lrLimitMaxAccDec *)
	i_lrDec 					: LREAL;		(* Deceleration units/s^2, value: 0...lrLimitMaxAccDec *)
	i_lrJerk					: LREAL;		(* Jerk units/s^3, value: >0 *)
	i_lrPeriod					: LREAL;		(* LINEAR axis: the position is kept within the period value (0 … i_lrPeriod), in units, must be > 0
												   MODULO axis: value is ignored -> period is read from axis (i_ifDrive.lrModuloPeriod)  *)
	i_lrStopPosition			: LREAL;		(* 0 <= StopPosition <= Periode*)
	i_xStart					: BOOL;			(* starts with pos. edge *)
END_VAR

VAR_OUTPUT
	q_xActive					: BOOL;			(* FB enabled*)
	q_xReady					: BOOL;
	q_etDiag					: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt					: PDL_ET_DiagExt := PDL_ET_DiagExt.Disabled;
	q_sMsg						: STRING[80];
	q_xMotionInstructionActive	: BOOL;			(* axis is moving *)
	q_lrPosition				: LREAL;		(* axis position *)
	q_xInVelocity				: BOOL;			(* Velocity > VEL*0.99 AND Velocity < VEL* 1.01) *)	
END_VAR

VAR
	xInterfacesInitialised		: BOOL;
	xEnableFlag					: BOOL;
	diState						: DINT;
	
	xMoveToStoppingStarted		: BOOL; //movement to lrStopPosition was started
	lrStopPosition				: LREAL;//calculated stopping position for linear axis when i_xStart = FALSE
	lrPeriodeCount				: LREAL;//periods needed for stopping
	lrStoppingDistance			: LREAL;//distance needed for stopping with actual vel, acc
	stStoppingDistance			: MOIN.ST_Trajectory;
	xErrorCalcStopping			: BOOL;
	etResultCalcStopping		: MOIN.ET_Result;

	//actual active values
	lrActVel					: LREAL;
	lrActJerk					: LREAL;
	lrAccel						: LREAL;
	lrDecel						: LREAL;

	fbLoggerPoint				: APL.FB_LoggerPoint;
	
	fbSetPos					: PLCO.MC_SetPosition;
	lrInchPos					: LREAL;
	
	fbStop						: PLCO.MC_Stop;
	fbMoveVelocity				: PLCO.MC_MoveVelocity;
	fbMoveAbsolute				: PLCO.MC_MoveAbsolute;
	fbHalt						: PLCO.MC_Halt;
	xExecuteHalt				: BOOL;
	
	xModuloAxis					: BOOL;
	lrModuloPeriod				: LREAL;
	
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
	
	THIS^.fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
										i_etDiag		:= q_etDiag,
										i_udiDiagExt	:= q_etDiagExt,
										i_sMessage		:= 'enable function block');
	
	xMoveToStoppingStarted 		:= FALSE;
	q_xActive					:= TRUE;
	q_xMotionInstructionActive	:= FALSE;
	q_xInVelocity				:= FALSE;
	q_xReady					:= FALSE;
	diState 					:= 0;
	
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
					i_etDiagExt := PDL_ET_DiagExt.Initializing,
					i_sMsg		:= '');

	xInterfacesInitialised := Init();
	IF NOT xInterfacesInitialised THEN	
		RETURN;
	END_IF

	IF NOT InputParameterCheck() THEN
		RETURN;
	END_IF

	q_xReady := TRUE;
	lrActVel := 0;
	
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
					i_etDiagExt := PDL_ET_DiagExt.WaitForStart,
					i_sMsg		:= '');					
	diState := 10;
{endregion}

(*--------------------------------------------------------------------------------------------------------------------------------------------*)
//Disable
{region "disable"}	
ELSIF NOT i_xEnable AND xEnableFlag THEN
	xEnableFlag := FALSE;
	
	THIS^.fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
										i_etDiag		:= q_etDiag,
										i_udiDiagExt	:= q_etDiagExt,
										i_sMessage		:= 'disable function block' );
	
	q_xInVelocity	:= FALSE;
	q_xReady		:= FALSE;
	
	IF xInterfacesInitialised THEN
		
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
						i_etDiagExt := PDL_ET_DiagExt.WaitUntilDisabled,
						i_sMsg		:= '');	
							
		diState := 100;	
	ELSE
		q_xActive					:= FALSE;	
		q_xMotionInstructionActive	:= FALSE;		
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
	

	//restart after i_lrVel was 0 
	IF    ABS(i_lrVel) > 0 
	  AND diState = 30
	THEN
		xExecuteHalt := FALSE;
		THIS^.fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
											i_etDiag		:= q_etDiag,
											i_udiDiagExt	:= q_etDiagExt,
											i_sMessage		:= Standard.CONCAT('start vel set: ', LREAL_TO_STRING(i_lrVel)), );
		IF xMoveToStoppingStarted THEN											
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
							i_etDiagExt := PDL_ET_DiagExt.WaitUntilStopPositionReached,
							i_sMsg		:= '');
		END_IF											
		q_xMotionInstructionActive	:= TRUE;
		diState := 10;		
	END_IF

	//stop  (i_lrVel = 0)
	IF    (  i_xStart 
		  OR q_xMotionInstructionActive 
		  )
	  AND i_lrVel = 0
	  AND diState = 10
	THEN
		IF i_xStart THEN	
			THIS^.fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
												i_etDiag		:= q_etDiag,
												i_udiDiagExt	:= q_etDiagExt,
												i_sMessage		:= Standard.CONCAT('start with vel: ', LREAL_TO_STRING(i_lrVel)));		
		ELSE
			THIS^.fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
												i_etDiag		:= q_etDiag,
												i_udiDiagExt	:= q_etDiagExt,
												i_sMessage		:= Standard.CONCAT('stop vel set: ', LREAL_TO_STRING(i_lrVel)));
		END_IF
		
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok, 
						i_etDiagExt := PDL_ET_DiagExt.WaitForVelUnequalZero,
						i_sMsg		:= '');

		lrActVel := i_lrVel;
		xMoveToStoppingStarted := NOT i_xStart; 	
		q_xMotionInstructionActive	:= TRUE;							
		xExecuteHalt := TRUE;
		diState := 30;		
	END_IF

	//error
	IF  (	i_ifDrive.etAxisState = MOIN.ET_AxisState.ErrorStop
	  	OR  i_ifDrive.etAxisState = MOIN.ET_AxisState.Disabled
		)
		AND diState > 0 
		AND diState < 100 
	THEN
		diState := 0;
		
		q_xReady					:= FALSE;
		q_xMotionInstructionActive	:= FALSE;
		q_xInVelocity				:= FALSE;
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
	END_IF
		
	//set q_lrPosition
	q_lrPosition	:= i_ifDrive.lrPosition; 
	
	//linear axis only -> set new position when q_lrPosition > i_lrPeriod
	IF NOT xModuloAxis THEN
		SetPos();
	END_IF
END_IF
{endregion}

(*--------------------------------------------------------------------------------------------------------------------------------------------*)
// State machine 
CASE  diState OF
	
(*********************************************************************************************************************)
	0:	//Error or Not Enabled 
		;

(*********************************************************************************************************************)	
	10: //endless movement and positioning to stop pos	
{region "endlessMovementAndPositioning"}
		fbStop( Execute := FALSE );
		fbHalt( Execute := FALSE );
		
		fbMoveAbsolute( );
		fbMoveVelocity( );
	
		SetInVelocity();		
	
		//wait for stop position reached
		IF fbMoveAbsolute.Done THEN					
			fbMoveAbsolute( Execute := FALSE);
			xMoveToStoppingStarted := FALSE;
			
			q_xInVelocity				:= FALSE;
			q_xMotionInstructionActive	:= FALSE;
			
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
							i_etDiagExt := PDL_ET_DiagExt.WaitForStart,
							i_sMsg		:= '');		
		END_IF

		//start movement to stopPosition...
		IF    NOT i_xStart  //...when input i_xStart is set to false
		  AND q_xMotionInstructionActive
		  AND NOT xMoveToStoppingStarted
		  OR  i_lrVel <> lrActVel  //... when velocity changed	
		  AND xMoveToStoppingStarted
		  AND q_xMotionInstructionActive
		THEN
			IF NOT xMoveToStoppingStarted THEN						
				fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
											i_etDiag		:= q_etDiag,
											i_udiDiagExt	:= q_etDiagExt,
											i_sMessage		:= 'stop movement');
			ELSE
				fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.DebugMessage,
											i_etDiag		:= q_etDiag,
											i_udiDiagExt	:= q_etDiagExt,
											i_sMessage		:= Standard.CONCAT('new vel set: ', LREAL_TO_STRING(i_lrVel)) );
			END_IF

			MoveToStopPosition(); //calculate position and call fb
			xMoveToStoppingStarted := TRUE;	
		
		//start Endless movement...
		ELSIF    i_xStart //...when input i_xStart is set to true
			AND (   NOT q_xMotionInstructionActive
				OR  xMoveToStoppingStarted
				)
			OR  i_lrVel <> lrActVel //... when velocity changed
			AND q_xMotionInstructionActive
		THEN
			xMoveToStoppingStarted := FALSE;
			IF lrActVel <> 0 THEN
				fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
											i_etDiag		:= q_etDiag,
											i_udiDiagExt	:= q_etDiagExt,
											i_sMessage		:= Standard.CONCAT('start with vel: ', LREAL_TO_STRING(i_lrVel)) );
			END_IF
			
			MoveVelocity();//call fb
		END_IF
		
			
		//error
		IF fbMoveAbsolute.Error THEN
			q_xMotionInstructionActive	:= FALSE;
			q_xInVelocity				:= FALSE;
		
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
							i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
							i_sMsg		:= CONCAT('MC_MoveAbsolute.ErrorID: ', PLCO.FC_EtResultToString(fbMoveAbsolute.ErrorID) ));	
			diState := 100;
		END_IF

		IF fbMoveVelocity.Error THEN
			q_xMotionInstructionActive	:= FALSE;
			q_xInVelocity				:= FALSE;
		
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
							i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
							i_sMsg		:= CONCAT('MC_MoveVelocity.ErrorID: ', PLCO.FC_EtResultToString(fbMoveVelocity.ErrorID) ));	
			diState := 100;
		END_IF
{endregion}

(*********************************************************************************************************************)
	30:	//stop  (i_lrVel = 0)
{region "stop (i_lrVel = 0)"}	
		fbMoveAbsolute( Execute := FALSE );
		fbMoveVelocity( Execute := FALSE );
		fbStop( Execute := FALSE );
		
		fbHalt( Execute 		:= xExecuteHalt, 
				Deceleration 	:= i_lrDec,
				Jerk			:= lrActJerk);

		q_xInVelocity := 	(  xMoveToStoppingStarted
							OR q_xMotionInstructionActive
							)
						AND NOT fbHalt.Active;

		//stopping done
		IF fbHalt.Done THEN
			xExecuteHalt := FALSE;
			IF xMoveToStoppingStarted THEN
				q_xMotionInstructionActive	:= FALSE;//only reset when stopping was started
			END_IF
		END_IF
												
		//restarted after stopping
		IF 	     i_xStart
			 AND xMoveToStoppingStarted
		THEN
			xMoveToStoppingStarted := FALSE;
			q_xMotionInstructionActive	:= TRUE;

		//vel was 0 and start is set to false			
		ELSIF    NOT i_xStart 
			 AND NOT xMoveToStoppingStarted
		THEN		
			xExecuteHalt := FALSE;			
			q_xInVelocity	:= FALSE;
			fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
										i_etDiag		:= q_etDiag,
										i_udiDiagExt	:= q_etDiagExt,
										i_sMessage		:= 'stop movement');
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
							i_etDiagExt := PDL_ET_DiagExt.WaitForStart,
							i_sMsg		:= '');		
			q_xMotionInstructionActive	:= FALSE;							
			diState := 10;
		END_IF

		//error
		IF fbHalt.Error THEN
			q_xMotionInstructionActive	:= FALSE;
			q_xInVelocity				:= FALSE;
			xExecuteHalt				:= FALSE;
		
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
							i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
							i_sMsg		:= CONCAT('MC_Halt.ErrorID: ', PLCO.FC_EtResultToString(fbHalt.ErrorID) ));	
			diState := 100;
		END_IF
{endregion}

(*********************************************************************************************************************)
	100: //controller stop
{region "controllerStop"}		
		fbMoveAbsolute( Execute := FALSE );
		fbMoveVelocity( Execute := FALSE );
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
			q_xMotionInstructionActive	:= FALSE;
			q_xReady := FALSE;
			fbStop( Execute := FALSE );
			
			IF NOT i_xEnable THEN
				xInterfacesInitialised := FALSE;
				
				q_xMotionInstructionActive	:= FALSE;
				q_xActive					:= FALSE;
			
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
								i_etDiagExt := PDL_ET_DiagExt.Disabled,
								i_sMsg		:= '');
			END_IF
		
			diState := 0;
		END_IF
		
		//error		
		IF fbStop.Error AND fbStop.ErrorId <> PLCO.ET_Result.StoppingInterrupted THEN
			q_xMotionInstructionActive	:= FALSE;
			q_xInVelocity				:= FALSE;
			
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
							i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
							i_sMsg		:= CONCAT('MC_Stop.ErrorID: ', PLCO.FC_EtResultToString(fbStop.ErrorID) ));	
			fbStop( Execute := FALSE );							
		END_IF
{endregion}

END_CASE
(*--------------------------------------------------------------------------------------------------------------------------------------------*)



