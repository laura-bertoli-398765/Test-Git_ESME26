__METADATA__
{
  "v3Meta": {
    "objectGuid": "20d97015-78cd-457c-9647-de50f37a4bc0",
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
FUNCTION_BLOCK PDL_FB_HomeIn
VAR_INPUT
	i_xEnable         : BOOL;
	i_ifDrive         : MOIN.IF_Axis;
	i_xSensor         : BOOL;
	i_etMode          : PDL_ET_HomeInMode;
	i_lrOffset        : LREAL;
	i_lrMaxTravel     : LREAL;
	i_lrHomePosition  : LREAL;
	i_lrVel           : LREAL;
	i_lrAcc           : LREAL;
	i_lrDec           : LREAL;
	i_lrJerk          : LREAL;
	i_xHwLimitNeg     : BOOL;
	i_xHwLimitPos     : BOOL;
	i_xRotativeSystem : BOOL;
	i_xStart          : BOOL;
END_VAR
VAR_OUTPUT
	q_xActive                  : BOOL;
	q_xReady                   : BOOL;
	q_etDiag                   : GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt                : PDL_ET_DiagExt := PDL_ET_DiagExt.Disabled;
	q_sMsg                     : STRING[80];
	q_xMotionInstructionActive : BOOL;
	q_lrPosition               : LREAL;
	q_xHomeOk                  : BOOL;
END_VAR
VAR
	xSuccess                 : BOOL;
	xInterfacesInitialised   : BOOL;
	xEnableFlag              : BOOL;
	diState                  : DINT;
	lrDistance               : LREAL;
	xLimitPos                : BOOL;
	xLimitNeg                : BOOL;
	xTPPosEdge               : BOOL;
	fbStartEdge              : Standard.R_TRIG;
	fbSensorNegEdge          : Standard.F_TRIG;
	fbSensorPosEdge          : Standard.R_TRIG;
	fbLoggerPoint            : APL.FB_LoggerPoint;
	xLimitChange             : BOOL;
	fbHalt                   : PLCO.MC_Halt;
	fbStop                   : PLCO.MC_Stop;
	fbMoveRelative           : PLCO.MC_MoveRelative;
	fbSetPos                 : PLCO.MC_SetPosition;
	fbPosIN                  : PDL_FB_PosIn;
	ifDriveConfigAccess      : DDI.IF_DriveConfigAccess;
	ifDriveConfig            : DDI.IF_DriveConfig;
	ifDeviceTreeObjectAccess : UFMPLCI.IF_DeviceTreeObjectAccess;
	sDriveName               : STRING(80);
	
END_VAR
__IMPLEMENTATION__
IF i_xEnable AND NOT xEnableFlag THEN
	xEnableFlag := TRUE;
	THIS^.fbLoggerPoint.AddLogEntry(
		i_etLogLevel := APL.ET_LogLevel.UserAction,
		i_etDiag     := q_etDiag,
		i_udiDiagExt := q_etDiagExt,
		i_sMessage   := 'enable function block',
		q_etDiag     =>,
		q_etDiagExt  =>
	);
	diState                    := 0;
	q_xActive                  := TRUE;
	q_xReady                   := FALSE;
	q_xMotionInstructionActive := FALSE;
	q_xHomeOk                  := FALSE;
	SetDiagOutput(i_etDiag := GD.ET_Diag.OK, i_etDiagExt := PDL_ET_DiagExt.Initializing, i_sMsg := '');
	xSuccess := InitInterfaces();
	IF NOT xSuccess THEN
		xInterfacesInitialised := FALSE;
		RETURN;
	ELSE
		xInterfacesInitialised := TRUE;
	END_IF
	
	xSuccess := InputParameterCheck();
	IF NOT xSuccess THEN
		RETURN;
	END_IF
	i_ifDrive.xIsHomed         := FALSE;
	
	fbStartEdge(CLK := i_xStart);
	SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitForStart, i_sMsg := '');
	q_xReady := TRUE;
	diState  := 10;
	
ELSIF NOT i_xEnable AND xEnableFlag THEN
	xEnableFlag := FALSE;
	THIS^.fbLoggerPoint.AddLogEntry(
		i_etLogLevel := APL.ET_LogLevel.UserAction,
		i_etDiag     := q_etDiag,
		i_udiDiagExt := q_etDiagExt,
		i_sMessage   := 'disable function block',
		q_etDiag     =>,
		q_etDiagExt  =>
	);
	q_xReady := FALSE;
	IF xInterfacesInitialised THEN
		SetDiagOutput(i_etDiag := GD.ET_Diag.OK, i_etDiagExt := PDL_ET_DiagExt.WaitUntilDisabled, i_sMsg := '');
		diState := 100;
	ELSE
		q_xActive                  := FALSE;
		q_xMotionInstructionActive := FALSE;
		q_lrPosition               := 0.0;
		q_xHomeOk                  := FALSE;
		SetDiagOutput(i_etDiag := GD.ET_Diag.OK, i_etDiagExt := PDL_ET_DiagExt.Disabled, i_sMsg := '');
		diState := 0;
	END_IF
ELSIF NOT q_xActive THEN
	RETURN;
END_IF

IF xInterfacesInitialised AND q_xActive THEN
	IF i_ifDrive.etAxisState < MOIN.ET_AxisState.Standstill AND diState > 0 AND diState < 100 THEN
		q_xReady                   := FALSE;
		q_xMotionInstructionActive := FALSE;
		SetDiagOutput(
			i_etDiag    := GD.ET_Diag.DriveConditionInvalid,
			i_etDiagExt := PDL_ET_DiagExt.DriveNotReady,
			i_sMsg 		:= STANDARD.CONCAT(sDriveName,': AxisState < Standstill')
		);
		diState := 0;
	END_IF
	q_lrPosition := i_ifDrive.lrPosition;
	fbStartEdge(CLK := i_xStart);
	fbSensorNegEdge(CLK := i_xSensor);
	fbSensorPosEdge(CLK := i_xSensor);
	
	(* Die HW Limits werden je nach Modus ausgewertet - Sie müssen während der Fahrt abgefragt werden *)
	IF i_etMode = PDL_ET_HomeInMode.PosDirectionPosEdgeSensor OR i_etMode = PDL_ET_HomeInMode.PosDirectionNegEdgeSensor THEN (* pos. direction *)
		xLimitPos := i_xHWLimitPos;
		xLimitNeg := i_xHWLimitNeg;
		
		xLimitChange := FALSE;
	ELSE (* neg. direction *)
		xLimitPos := i_xHWLimitNeg;
		xLimitNeg := i_xHWLimitPos;
		
		xLimitChange := TRUE;
	END_IF
END_IF

CASE diState OF
	(*---------------------------------------------------------------------------------------------*)
	0: (* Error or finished *)
		(*---------------------------------------------------------------------------------------------*)
		;
		(*---------------------------------------------------------------------------------------------*)
	10: (* wait for Start *)
		(*---------------------------------------------------------------------------------------------*)
		IF fbStartEdge.Q THEN
			xSuccess := InputParameterCheck();
			IF NOT xSuccess THEN
				q_xReady := FALSE;
				diState  := 0;
				RETURN;
			END_IF
			
			CASE i_etMode OF (* Selection of Mode *)
				PDL_ET_HomeInMode.PosDirectionPosEdgeSensor: (* Mode 0:  pos. Direction until pos. Edge of TP + TPOffset*)
					lrDistance := ABS(i_lrMaxTravel);
					xTPPosEdge := TRUE;
				PDL_ET_HomeInMode.NegDirectionPosEdgeSensor: (* Mode 1:  neg. Direction until pos. Edge of TP + TPOffset*)
					lrDistance := -ABS(i_lrMaxTravel);
					xTPPosEdge := TRUE;
				PDL_ET_HomeInMode.NegDirectionNegEdgeSensor: (* Mode 2:  neg. Direction until neg. Edge of TP + TPOffset*)
					xTPPosEdge := FALSE;
					lrDistance := -ABS(i_lrMaxTravel);
				PDL_ET_HomeInMode.PosDirectionNegEdgeSensor: (* Mode 3:  pos. Direction until neg. Edge of TP + TPOffset*)
					xTPPosEdge := FALSE;
					lrDistance := ABS(i_lrMaxTravel);
				ELSE
					q_xReady := FALSE;
					SetDiagOutput(i_etDiag := GD.ET_Diag.InputParameterInvalid, i_etDiagExt := PDL_ET_DiagExt.UnknownMode, i_sMsg := '');
					diState := 0;
					RETURN;
			END_CASE
			
			q_xMotionInstructionActive := TRUE;
			q_xHomeOk                  := FALSE;
			(*check if Axis stands on Sensor  *)
			IF (i_xSensor = xTPPosEdge AND NOT i_xRotativeSystem) OR xLimitPos THEN
				THIS^.fbMoveRelative(Distance := -lrDistance, Execute := TRUE);
				SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitForNegEdgeOfSensor, i_sMsg := '');
				diState := 20;
			ELSE
				
				fbPosIN(
					i_ifDrive        := i_ifDrive,
					i_xSensor        := i_xSensor,
					i_xPosEdge       := xTPPosEdge,
					i_lrMaxTravel    := lrDistance,
					i_lrOffset       := i_lrOffset,
					i_lrVelocity     := i_lrVel,
					i_lrAcceleration := i_lrAcc,
					i_lrDeceleration := i_lrDec,
					i_lrJerk         := i_lrJerk,
					i_xStart         := TRUE
				);
				
				IF xLimitNeg THEN (* move free from neg. Limit Switch *)
					SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitUntilLimitSwitchFree, i_sMsg := '');
					diState := 35;
				ELSE
					SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitForSensorSignal, i_sMsg := '');
					
					diState := 40;
				END_IF
				
			END_IF
		END_IF
		
		(*---------------------------------------------------------------------------------------------*)
	20: (* vom LimitSwitch frei fahren *)
		(*---------------------------------------------------------------------------------------------*)
		THIS^.fbMoveRelative(Execute := TRUE);
		(* Wait neg. edge of RefSensor *)
		IF (xTPPosEdge AND fbSensorNegEdge.Q) OR (NOT xTPPosEdge AND fbSensorPosEdge.Q) THEN
			
			THIS^.fbMoveRelative(Execute := FALSE);
			THIS^.fbHalt(Execute := TRUE);
			
			IF THIS^.fbHalt.Error THEN
				q_xReady                   := FALSE;
				q_xMotionInstructionActive := FALSE;
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
					i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
					i_sMsg      := CONCAT('MC_Halt.ErrorID: ', PLCO.FC_EtResultToString(THIS^.fbHalt.ErrorID))
				);
				THIS^.fbHalt(Execute := FALSE);
				diState := 0;
			ELSE
				SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitUntilStopped, i_sMsg := '');
				diState := 30;
			END_IF
			
		ELSIF xLimitNeg = TRUE THEN
			q_xReady                   := FALSE;
			q_xMotionInstructionActive := FALSE;
			THIS^.fbHalt(Execute := TRUE, Deceleration := i_lrDec, Jerk := i_lrJerk, BufferMode := PLCO.MC_Buffer_Mode.Aborting);
			
			IF THIS^.fbHalt.Error THEN
				q_xReady                   := FALSE;
				q_xMotionInstructionActive := FALSE;
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
					i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
					i_sMsg      := CONCAT('MC_Halt.ErrorID: ', PLCO.FC_EtResultToString(THIS^.fbHalt.ErrorID))
				);
				THIS^.fbHalt(Execute := FALSE);
				diState := 0;
			ELSE
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.LimitReached,
					i_etDiagExt := SEL(xLimitChange, PDL_ET_DiagExt.HwLimitNegReached, PDL_ET_DiagExt.HwLimitPosReached),
					i_sMsg      := ''
				);
				diState := 50;
			END_IF
			
		ELSIF fbMoveRelative.Done THEN
			q_xMotionInstructionActive := FALSE;
			q_xReady                   := FALSE;
			SetDiagOutput(i_etDiag := GD.ET_Diag.HomingFailed, i_etDiagExt := PDL_ET_DiagExt.SensorNotFound, i_sMsg := 'Sensor not found');
			THIS^.fbMoveRelative(Execute := FALSE);
			diState := 0;
			
		ELSIF fbMoveRelative.Error THEN (* Error *)
			q_xReady                   := FALSE;
			q_xMotionInstructionActive := FALSE;
			
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
				i_sMsg      := CONCAT('MC_MoveRelative.ErrorID: ', PLCO.FC_EtResultToString(THIS^.fbMoveRelative.ErrorID))
			);
			THIS^.fbMoveRelative(Execute := FALSE);
			diState := 0;
		END_IF
		
		(*---------------------------------------------------------------------------------------------*)
	30: (* wait until stopped *)
		(*---------------------------------------------------------------------------------------------*)
		THIS^.fbHalt(Execute := TRUE);
		IF THIS^.fbHalt.Done THEN
			THIS^.fbHalt(Execute := FALSE);
			
			IF xLimitPos THEN
				q_xReady                   := FALSE;
				q_xMotionInstructionActive := FALSE;
				
				//select, which linit switch cause the issue
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.HomingFailed,
					i_etDiagExt := SEL(xLimitChange, PDL_ET_DiagExt.HwLimitPosStillActive, PDL_ET_DiagExt.HwLimitNegStillActive),
					i_sMsg      := ''
				);
				diState := 0;
			ELSE
				fbPosIN(
					i_ifDrive        := i_ifDrive,
					i_xSensor        := i_xSensor,
					i_xPosEdge       := xTPPosEdge,
					i_lrMaxTravel    := lrDistance,
					i_lrOffset       := i_lrOffset,
					i_lrVelocity     := i_lrVel,
					i_lrAcceleration := i_lrAcc,
					i_lrDeceleration := i_lrDec,
					i_lrJerk         := i_lrJerk,
					i_xStart         := TRUE
				);
				
				SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitForSensorSignal, i_sMsg := '');
				
				diState := 40;
			END_IF
		ELSIF fbHalt.Error THEN (* Error *)
			q_xReady                   := FALSE;
			q_xMotionInstructionActive := FALSE;
			
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
				i_sMsg      := CONCAT('MC_Halt.ErrorID: ', PLCO.FC_EtResultToString(THIS^.fbHalt.ErrorID))
			);
			THIS^.fbHalt(Execute := FALSE);
			diState := 0;
		END_IF
		
		(*---------------------------------------------------------------------------------------------*)
	35: (* wait neg. Limit free *)
		(*---------------------------------------------------------------------------------------------*)
		fbPosIN(i_xSensor := i_xSensor, i_xStart := FALSE);
		
		IF NOT xLimitNeg THEN
			SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitForSensorSignal, i_sMsg := '');
			
			diState := 40;
			
		ELSIF xLimitPos THEN (* positive HW LimitSwitch *)
			q_xReady                   := FALSE;
			q_xMotionInstructionActive := FALSE;
			
			THIS^.fbHalt(Execute := TRUE, Deceleration := i_lrDec, Jerk := i_lrJerk, BufferMode := PLCO.MC_Buffer_Mode.Aborting);
			
			IF THIS^.fbHalt.Error THEN
				q_xReady                   := FALSE;
				q_xMotionInstructionActive := FALSE;
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
					i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
					i_sMsg      := CONCAT('MC_Halt.ErrorID: ', PLCO.FC_EtResultToString(THIS^.fbHalt.ErrorID))
				);
				THIS^.fbHalt(Execute := FALSE);
				diState := 0;
			ELSE
				SetDiagOutput(i_etDiag := GD.ET_Diag.LimitReached, i_etDiagExt := PDL_ET_DiagExt.HwLimitPosReached, i_sMsg := '');
				diState := 50;
			END_IF
			
		ELSIF fbPosIN.q_xError THEN
			q_xReady                   := FALSE;
			q_xMotionInstructionActive := FALSE;
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
				i_sMsg      := CONCAT('FB_PosIn: ', PLCO.FC_EtResultToString(fbPosIN.q_diErrorId))
			);
			diState := 0;
			
		ELSIF fbPosIn.q_xSensorNotFound THEN
			q_xReady                   := FALSE;
			q_xMotionInstructionActive := FALSE;
			
			IF i_etMode = PDL_ET_HomeInMode.PosDirectionPosEdgeSensor OR i_etMode = PDL_ET_HomeInMode.PosDirectionNegEdgeSensor THEN
				(* pos. direction *)
				SetDiagOutput(i_etDiag := GD.ET_Diag.HomingFailed, i_etDiagExt := PDL_ET_DiagExt.HwLimitNegStillActive, i_sMsg := '');
			ELSE
				(* neg. direction *)
				SetDiagOutput(i_etDiag := GD.ET_Diag.HomingFailed, i_etDiagExt := PDL_ET_DiagExt.HwLimitPosStillActive, i_sMsg := '');
			END_IF
			diState := 0;
			
			//sensor reached but limit switch is still active
		ELSIF (xLimitPos OR xLimitNeg) AND fbPosIN.q_xInOk THEN
			IF i_etMode = PDL_ET_HomeInMode.PosDirectionPosEdgeSensor OR i_etMode = PDL_ET_HomeInMode.PosDirectionNegEdgeSensor THEN
				SetDiagOutput(i_etDiag := GD.ET_Diag.HomingFailed, i_etDiagExt := PDL_ET_DiagExt.HwLimitNegStillActive, i_sMsg := '');
			ELSE
				SetDiagOutput(i_etDiag := GD.ET_Diag.HomingFailed, i_etDiagExt := PDL_ET_DiagExt.HwLimitPosStillActive, i_sMsg := '');
			END_IF
			
			diState := 0;
		END_IF
		
		(*---------------------------------------------------------------------------------------------*)
	40: (* all Modis *)
		(*---------------------------------------------------------------------------------------------*)
		fbPosIN(i_xSensor := i_xSensor, i_xStart := FALSE);
		
		IF fbPosIN.q_xMoveToHomePosition THEN
			SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitForSensorSignal, i_sMsg := 'Offset movement in progress');
		END_IF
		
		IF xLimitNeg THEN
			q_xReady                   := FALSE;
			q_xMotionInstructionActive := FALSE;
			
			THIS^.fbHalt(Execute := TRUE);
			
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.LimitReached,
				i_etDiagExt := SEL(xLimitChange, PDL_ET_DiagExt.HwLimitNegReached, PDL_ET_DiagExt.HwLimitPosReached),
				i_sMsg      := ''
			);
			
			diState := 50;
			
		ELSIF xLimitPos THEN (* positive HW LimitSwitch *)
			
			THIS^.fbHalt(Execute := TRUE);
			
			IF fbPosIN.q_xMoveToHomePosition = FALSE THEN (* TP was not seen *)
				SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitUntilStopped, i_sMsg := '');
				diState := 60;
			ELSE
				q_xReady                   := FALSE;
				q_xMotionInstructionActive := FALSE;
				SetDiagOutput(i_etDiag := GD.ET_Diag.LimitReached, i_etDiagExt := PDL_ET_DiagExt.HwLimitPosReached, i_sMsg := '');
				diState := 50;
			END_IF
			
		ELSIF fbPosIN.q_xSensorNotFound THEN
			q_xReady                   := FALSE;
			q_xMotionInstructionActive := FALSE;
			SetDiagOutput(i_etDiag := GD.ET_Diag.HomingFailed, i_etDiagExt := PDL_ET_DiagExt.SensorNotFound, i_sMsg := 'Sensor not found');
			diState := 0;
			
		ELSIF fbPosIN.q_xError THEN
			q_xReady                   := FALSE;
			q_xMotionInstructionActive := FALSE;
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
				i_sMsg      := CONCAT('FB_PosIn: ', PLCO.FC_EtResultToString(fbStop.ErrorID))
			);
			diState := 0;
			
		ELSIF fbPosIN.q_xINOk THEN
			q_xHomeOk                  := TRUE;
			i_ifDrive.xIsHomed         := TRUE;
			q_xMotionInstructionActive := FALSE;
			THIS^.fbSetPos(Execute := TRUE, Position := i_lrHomePosition, Relative := FALSE);
			
			IF THIS^.fbSetPos.Error THEN
				q_xReady                   := FALSE;
				q_xMotionInstructionActive := FALSE;
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
					i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
					i_sMsg      := CONCAT('MC_SetPosition: ', PLCO.FC_EtResultToString(THIS^.fbSetPos.ErrorID))
				);
				
				THIS^.fbSetPos(Execute := FALSE);
				diState := 0;
			ELSE
				SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.HomingDone, i_sMsg := '');
				THIS^.fbSetPos(Execute := FALSE);
				diState := 10;
			END_IF
		END_IF
		
		(*---------------------------------------------------------------------------------------------*)
	50: (* wait  until stopped after HW Limit and Error *)
		(*---------------------------------------------------------------------------------------------*)
		THIS^.fbHalt();
		IF THIS^.fbHalt.Done THEN
			THIS^.fbHalt(Execute := FALSE);
			q_xMotionInstructionActive := FALSE;
			diState                    := 0;
			fbLoggerPoint.AddLogEntry(
				i_etLogLevel := APL.ET_LogLevel.StatusMessage,
				i_etDiag     := q_etDiag,
				i_udiDiagExt := q_etDiagExt,
				i_sMessage   := 'Axis stopped',
				q_etDiag     =>,
				q_etDiagExt  =>
			);
			
		ELSIF THIS^.fbHalt.Error THEN
			q_xReady                   := FALSE;
			q_xMotionInstructionActive := FALSE;
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
				i_sMsg      := CONCAT('MC_Halt.ErrorID: ', PLCO.FC_EtResultToString(THIS^.fbHalt.ErrorID))
			);
			THIS^.fbHalt(Execute := FALSE);
			diState := 0;
		END_IF
		
		(*---------------------------------------------------------------------------------------------*)
	60: (* wait until stopped after HW Limit and no Error *)
		(*---------------------------------------------------------------------------------------------*)
		THIS^.fbHalt();
		IF THIS^.fbHalt.Done THEN
			
			THIS^.fbMoveRelative(Execute := TRUE, Distance := -lrDistance);
			
			SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitForNegEdgeOfSensor, i_sMsg := '');
			diState := 20;
		END_IF
		
		(*---------------------------------------------------------------------------------------------*)
	100: (* Wait until stopped after Disable  *)
		(*---------------------------------------------------------------------------------------------*)
		fbMoveRelative(Execute := FALSE);
		fbHalt(Execute := FALSE);
		
		IF
			i_ifDrive.etAxisState <> MOIN.ET_AxisState.Disabled AND
			i_ifDrive.etAxisState <> MOIN.ET_AxisState.ErrorStop AND
			i_ifDrive.etAxisState <> MOIN.ET_AxisState.Standstill AND
			i_ifDrive.etAxisState <> MOIN.ET_AxisState.Stopping
		THEN
			fbStop.Execute      := TRUE;
			fbStop.Deceleration := i_lrDec;
			fbStop.Jerk         := i_lrJerk;
		END_IF
		
		fbStop();
		
		//stopping done
		IF
			i_ifDrive.etAxisState = MOIN.ET_AxisState.Disabled OR
			i_ifDrive.etAxisState = MOIN.ET_AxisState.ErrorStop OR
			i_ifDrive.etAxisState = MOIN.ET_AxisState.Standstill OR
			fbStop.Done
		THEN
			xInterfacesInitialised := FALSE;
			fbStop(Axis := i_ifDrive, Execute := FALSE);
			q_xActive    := FALSE;
			q_xReady     := FALSE;
			q_lrPosition := 0.0;
			SetDiagOutput(i_etDiag := GD.ET_Diag.OK, i_etDiagExt := PDL_ET_DiagExt.Disabled, i_sMsg := '');
			
			diState := 0;
		END_IF
		
		//error		
		IF fbStop.Error AND fbStop.ErrorId <> PLCO.ET_Result.StoppingInterrupted THEN
			q_xMotionInstructionActive := FALSE;
			
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
				i_sMsg      := CONCAT('MC_Stop.ErrorID: ', PLCO.FC_EtResultToString(fbStop.ErrorID))
			);
			fbStop(Execute := FALSE);
		END_IF
		(* Ende Case *)
	ELSE
		q_xReady                   := FALSE;
		q_xMotionInstructionActive := FALSE;
		
		SetDiagOutput(
			i_etDiag := GD.ET_Diag.UnexpectedProgramBehavior, i_etDiagExt := PDL_ET_DiagExt.UnknownState, i_sMsg := DINT_TO_STRING(diState)
		);
		diState := 0;
END_CASE
