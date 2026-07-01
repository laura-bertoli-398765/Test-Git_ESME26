__METADATA__
{
  "v3Meta": {
    "objectGuid": "0957d204-aa54-4e74-9ffb-addd439f412e",
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
FUNCTION_BLOCK PDL_FB_HomeTp
VAR_INPUT
	i_xEnable         : BOOL;
	i_ifDrive         : MOIN.IF_Axis;
	i_ifTouchProbe    : PLCO.MC_Trigger_Ref;
	i_etMode          : PDL_ET_HomeTpMode;
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
	xEnableFlag   : BOOL;
	diState       : DINT;
	fbLoggerPoint : APL.FB_LoggerPoint;
	
	xLimitGivenDirection       : BOOL;
	xLimitGivenDirectionOld    : BOOL;
	xLimitOpposideDirection    : BOOL;
	xLimitOpposideDirectionOld : BOOL;
	lrDistance                 : LREAL;
	xMotionJobStarted          : BOOL;
	ifDeviceTreeObjectAccess   : UFMPLCI.IF_DeviceTreeObjectAccess;
	sDriveName                 : STRING(80);
	ifScalingAccess            : DMFI.IF_ScalingAccess;
	ifScaling                  : DMFI.IF_Scaling;
	ifDrive2Access             : DDI.IF_Drive2Access;
	ifDrive2                   : DDI.IF_Drive2;
	ifDriveAccess              : DMFI.IF_DriveAccess;
	ifDrive                    : DMFI.IF_Drive;
	ifDriveConfigAccess        : DDI.IF_DriveConfigAccess;
	ifDriveConfig              : DDI.IF_DriveConfig;
	ifTouprobeData             : IODI.IF_TouchprobeData;
	ifTouprobeDataAccess       : IODI.IF_TouchprobeDataAccess;
	fbTouchProbe               : PLCO.MC_TouchProbe;
	fbAbortTouchprobe          : PLCO.MC_AbortTrigger;
	fbStop                     : PLCO.MC_Stop;
	fbHalt                     : PLCO.MC_Halt;
	fbMoveAbsolute             : PLCO.MC_MoveAbsolute;
	fbMoveRelative             : PLCO.MC_MoveRelative;
	fbSetPos                   : PLCO.MC_SetPosition;
	
END_VAR
__IMPLEMENTATION__
IF i_xEnable AND NOT xEnableFlag AND (diState = 0) THEN
	// detect positive flank on i_xEnable if FB is disabled
	xEnableFlag := TRUE;
	fbLoggerPoint.AddLogEntry(
		i_etLogLevel := APL.ET_LogLevel.UserAction, i_etDiag := q_etDiag, i_udiDiagExt := q_etDiagExt, i_sMessage := 'enable function block'
	);
	q_xActive                  := TRUE;
	q_xReady                   := FALSE;
	q_xMotionInstructionActive := FALSE;
	q_xHomeOk                  := FALSE;
	IF THIS^.EnableParameterCheck() THEN
		i_ifDrive.xIsHomed         := FALSE;
		fbStop(Execute := FALSE);
		fbSetPos(Execute := FALSE);
		fbAbortTouchprobe(Execute := FALSE);
		fbTouchProbe(Execute := FALSE);
		fbMoveAbsolute(Execute := FALSE);
		fbMoveRelative(Execute := FALSE);
		fbAbortTouchprobe.Axis := i_ifDrive;
		fbAbortTouchprobe.ifTrigger := i_ifTouchProbe;
		fbAbortTouchprobe(Execute := TRUE);
		IF fbAbortTouchprobe.Error THEN
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
				i_sMsg      := CONCAT('MC_AbortTrigger: ', PLCO.FC_EtResultToString(fbAbortTouchprobe.ErrorId))
			);
		ELSE
			q_xReady := TRUE;
			SetDiagOutput(i_etDiag := GD.ET_Diag.OK, i_etDiagExt := PDL_ET_DiagExt.WaitForStart, i_sMsg := '');
			diState := 5;
		END_IF
	END_IF
ELSIF NOT i_xEnable AND xEnableFlag THEN
	// detect negative flank on i_xEnable if FB is active
	fbHalt(Execute := FALSE);
	fbSetPos(Execute := FALSE);
	fbAbortTouchprobe(Execute := FALSE);
	fbTouchProbe(Execute := FALSE);
	fbMoveAbsolute(Execute := FALSE);
	fbMoveRelative(Execute := FALSE);
	xEnableFlag := FALSE;
	q_xReady    := FALSE;
	fbLoggerPoint.AddLogEntry(
		i_etLogLevel := APL.ET_LogLevel.UserAction, i_etDiag := q_etDiag, i_udiDiagExt := q_etDiagExt, i_sMessage := 'disable function block'
	);
	IF (diState <= 10) THEN
		// job not started yet -> disable immediately
		q_xActive    := FALSE;
		q_lrPosition := 0.0;
		q_xHomeOk    := FALSE;
		
		THIS^.SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.Disabled, i_sMsg := '');
		diState := 0;
	ELSE
		// stop process before disable
		fbStop(Execute := TRUE);
		THIS^.SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitUntilDisabled, i_sMsg := '');
		diState := 100;
	END_IF
END_IF

IF q_xActive AND (i_ifDrive <> 0) THEN
	IF i_ifDrive.etAxisState < MOIN.ET_AxisState.Standstill AND diState > 0 AND diState < 100 THEN
		q_xMotionInstructionActive := FALSE;
		SetDiagOutput(
			i_etDiag    := GD.ET_Diag.DriveConditionInvalid,
			i_etDiagExt := PDL_ET_DiagExt.DriveNotReady,
			i_sMsg 		:= STANDARD.CONCAT(sDriveName,': AxisState < Standstill')
		);
		diState := 0;
	ELSIF i_ifDrive.etAxisState > MOIN.ET_AxisState.Stopping THEN
		xMotionJobStarted := TRUE; // latch a started job in order to make shure job has stared if for job finish is checked. This can be necessary if FB is called twice in a cycle as it is done in tests.
	END_IF
	q_lrPosition := i_ifDrive.RefPosition;
	(* The HW limits are evaluated depending on the mode – they must be queried during motion. *)
	IF i_etMode = PDL_ET_HomeTpMode.PosDirectionPosEdgeTp OR i_etMode = PDL_ET_HomeTpMode.PosDirectionNegEdgeTp THEN (* pos. direction *)
		xLimitGivenDirection    := i_xHWLimitPos;
		xLimitOpposideDirection := i_xHWLimitNeg;
	ELSE (* neg. direction *)
		xLimitGivenDirection    := i_xHWLimitNeg;
		xLimitOpposideDirection := i_xHWLimitPos;
	END_IF
END_IF

// statemachine of FB
CASE diState OF
	0: // FB is disabled or in error
		; // do nothing (error quit is done by negative flank of i_xEnable)

	5: 		fbAbortTouchprobe(Execute := TRUE);
			IF fbAbortTouchprobe.Done THEN
				fbAbortTouchprobe(Execute := FALSE);
				diState := 10;
			ELSIF fbAbortTouchprobe.Error THEN
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
					i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
					i_sMsg      := CONCAT('MC_AbortTrigger: ', PLCO.FC_EtResultToString(fbAbortTouchprobe.ErrorId))
				);
				diState := 0;
			END_IF


	10: // wait for start
		IF i_xStart THEN
			fbLoggerPoint.AddLogEntry(
				i_etLogLevel := APL.ET_LogLevel.UserAction, i_etDiag := q_etDiag, i_udiDiagExt := q_etDiagExt, i_sMessage := 'start function block'
			);
			q_xHomeOk := FALSE;
			IF NOT THIS^.StartParameterCheck() THEN
				// error during start (error message is already set during StartParameterCheck() )
				diState := 0;
			ELSE
				// store information of limit switches if search started on opposide limit switch in order to prevent error message from check of limit switches till run free from switch
				xLimitGivenDirectionOld    := xLimitGivenDirection;
				xLimitOpposideDirectionOld := xLimitOpposideDirection;
				// check all possible start conditions
				IF
					xLimitGivenDirection OR
					(NOT i_xRotativeSystem AND
						ifTouprobeData.Value AND
						(i_etMode = PDL_ET_HomeTpMode.PosDirectionPosEdgeTp OR i_etMode = PDL_ET_HomeTpMode.NegDirectionPosEdgeTp)) OR
					(NOT i_xRotativeSystem AND
						NOT ifTouprobeData.Value AND
						(i_etMode = PDL_ET_HomeTpMode.PosDirectionNegEdgeTp OR i_etMode = PDL_ET_HomeTpMode.NegDirectionNegEdgeTp))
				THEN
					// Standing on TP or not possible to drive in set direction -> search TP in different direction
					SetTpEdge(i_xOppositeFlank := TRUE);
					StartPositioningAndTPEdge(i_xOppositeDirection := TRUE);
					IF q_etDiag <> GD.ET_Diag.Ok THEN
						// exception during command, diag message already set in SearchTpInDifferentDirection()
						q_xMotionInstructionActive := FALSE;
						diState                    := 0;
					ELSE
						SetDiagOutput(i_etDiag := GD.ET_Diag.OK, i_etDiagExt := PDL_ET_DiagExt.WaitForNegEdgeOfTouchProbe, i_sMsg := '');
						diState := 40;
					END_IF
				ELSE
					// regular search of TP
					xLimitOpposideDirectionOld := xLimitOpposideDirection;
					SetTpEdge(i_xOppositeFlank := FALSE);
					StartPositioningAndTPEdge(i_xOppositeDirection := FALSE);
					IF q_etDiag <> GD.ET_Diag.Ok THEN
						// exception during command, diag message already set in SearchTpInDifferentDirection()
						q_xMotionInstructionActive := FALSE;
						diState                    := 0;
					ELSE
						IF xLimitOpposideDirection THEN
							SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitUntilLimitSwitchFree, i_sMsg := '');
						ELSE
							SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitForTouchProbeSignal, i_sMsg := '');
						END_IF
						diState := 20;
					END_IF
				END_IF
			END_IF
		END_IF
	20: // search TP in given direction
		fbMoveRelative(Execute := TRUE);
		IF ifTouprobeData.CaptureOk THEN
			fbMoveRelative(Execute := FALSE);
			fbLoggerPoint.AddLogEntry(
				i_etLogLevel := APL.ET_LogLevel.ExternalEvent,
				i_etDiag     := q_etDiag,
				i_udiDiagExt := q_etDiagExt,
				i_sMessage   := 'Touch probe found in given direction'
			);
			xMotionJobStarted  := FALSE;
			i_ifDrive.xIsHomed := TRUE;
			fbMoveAbsolute(Execute := TRUE, Position := ifTouprobeData.CaptureValue + i_lrOffset);
			
			IF fbMoveAbsolute.Error THEN
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
					i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
					i_sMsg      := CONCAT('MC_MoveAbsolute.ErrorID: ', PLCO.FC_EtResultToString(THIS^.fbMoveAbsolute.ErrorID))
				);
				fbMoveAbsolute(Execute := FALSE);
				diState := 0;
			ELSE
				q_xMotionInstructionActive := TRUE;
				// additional information after TP until offset is reached
				SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitForSensorSignal, i_sMsg := 'Offset movement in progress');
				
				diState := 60;
			END_IF
		ELSIF xLimitOpposideDirection AND NOT xLimitOpposideDirectionOld THEN
			fbStop(Execute := TRUE);
			fbMoveRelative(Execute := FALSE);
			IF i_etMode = PDL_ET_HomeTpMode.PosDirectionPosEdgeTp OR i_etMode = PDL_ET_HomeTpMode.PosDirectionNegEdgeTp THEN (* pos. direction *)
				SetDiagOutput(i_etDiag := GD.ET_Diag.LimitReached, i_etDiagExt := PDL_ET_DiagExt.HwLimitNegReached, i_sMsg := '');
			ELSE (* neg. direction *)
				SetDiagOutput(i_etDiag := GD.ET_Diag.LimitReached, i_etDiagExt := PDL_ET_DiagExt.HwLimitPosReached, i_sMsg := '');
			END_IF
			diState := 100;
		ELSIF xLimitGivenDirection AND NOT xLimitGivenDirectionOld THEN (* positive HW LimitSwitch *)
			fbMoveRelative(Execute := FALSE);
			fbLoggerPoint.AddLogEntry(
				i_etLogLevel := APL.ET_LogLevel.ExternalEvent,
				i_etDiag     := q_etDiag,
				i_udiDiagExt := q_etDiagExt,
				i_sMessage   := 'Limit switch in given direction seen'
			);
			fbHalt(Execute := TRUE);
			fbAbortTouchprobe(Execute := TRUE, Axis := i_ifDrive);
			IF fbAbortTouchprobe.Error THEN
				q_xMotionInstructionActive := FALSE;
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
					i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
					i_sMsg      := CONCAT('MC_AbortTrigger: ', PLCO.FC_EtResultToString(fbAbortTouchprobe.ErrorId))
				);
				fbAbortTouchprobe(Execute := FALSE);
				diState := 0;
			ELSE
				SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitUntilStopped, i_sMsg := '');
				diState := 30;
			END_IF
		ELSIF THIS^.fbMoveRelative.Done AND xMotionJobStarted THEN // positioning job for search of TP finisched
			THIS^.fbMoveRelative(Execute := FALSE);
			q_xMotionInstructionActive := FALSE;
			IF q_etDiagExt = PDL_ET_DiagExt.WaitUntilLimitSwitchFree THEN
				// give special exception message if the search started on limit switch and the limit switch was never set to false
				IF (i_etMode = PDL_ET_HomeTpMode.PosDirectionNegEdgeTp OR i_etMode = PDL_ET_HomeTpMode.PosDirectionPosEdgeTp) THEN
					SetDiagOutput(i_etDiag := GD.ET_Diag.HomingFailed, i_etDiagExt := PDL_ET_DiagExt.HwLimitNegStillActive, i_sMsg := '');
				ELSE
					SetDiagOutput(i_etDiag := GD.ET_Diag.HomingFailed, i_etDiagExt := PDL_ET_DiagExt.HwLimitPosStillActive, i_sMsg := '');
				END_IF
			ELSE
				SetDiagOutput(i_etDiag := GD.ET_Diag.HomingFailed, i_etDiagExt := PDL_ET_DiagExt.TouchProbeNotFound, i_sMsg := '');
			END_IF
			diState := 0;
		ELSIF NOT xLimitOpposideDirection AND xLimitOpposideDirectionOld THEN
			// signal user that the limit switch is left, which was active at start
			SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitForTouchProbeSignal, i_sMsg := '');
		ELSIF fbMoveRelative.Error THEN
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
				i_sMsg      := CONCAT('MC_MoveRelative.ErrorID: ', PLCO.FC_EtResultToString(THIS^.fbMoveRelative.ErrorID))
			);
			THIS^.fbMoveRelative(Execute := FALSE);
			diState := 0;
		END_IF
		xLimitGivenDirectionOld    := xLimitGivenDirection;
		xLimitOpposideDirectionOld := xLimitOpposideDirection;
	30: // wait until stopped after HW Limit reached during search in given direction
		fbAbortTouchprobe(Execute := TRUE);
		IF i_ifDrive.etAxisState <= MOIN.ET_AxisState.Standstill AND fbAbortTouchprobe.Done THEN
			fbAbortTouchprobe(Execute := FALSE);
			q_xMotionInstructionActive := FALSE;
			xLimitGivenDirection       := xLimitGivenDirectionOld;
			xLimitOpposideDirection    := xLimitOpposideDirectionOld;
			fbHalt(Execute := FALSE);
			SetTpEdge(i_xOppositeFlank := TRUE);
			StartPositioningAndTPEdge(i_xOppositeDirection := TRUE);
			IF q_etDiag <> GD.ET_Diag.Ok THEN
				// exception during command, diag message already set in SearchTpInDifferentDirection()
				q_xMotionInstructionActive := FALSE;
				diState                    := 0;
			ELSE
				SetDiagOutput(i_etDiag := GD.ET_Diag.OK, i_etDiagExt := PDL_ET_DiagExt.WaitForNegEdgeOfTouchProbe, i_sMsg := '');
				diState := 40;
			END_IF
		ELSIF fbAbortTouchprobe.Error THEN
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
					i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
					i_sMsg      := CONCAT('MC_AbortTrigger: ', PLCO.FC_EtResultToString(fbAbortTouchprobe.ErrorId))
				);
				fbAbortTouchprobe(Execute := FALSE);
				diState := 0;
		END_IF
	40: // search TP in opposite direction
		fbMoveRelative(Execute := TRUE);
		IF ifTouprobeData.CaptureOK = TRUE THEN
			fbLoggerPoint.AddLogEntry(
				i_etLogLevel := APL.ET_LogLevel.ExternalEvent,
				i_etDiag     := q_etDiag,
				i_udiDiagExt := q_etDiagExt,
				i_sMessage   := 'Touch probe found in opposite direction'
			);
			fbMoveRelative(Execute := FALSE);
			fbHalt(Execute := TRUE);
			SetDiagOutput(i_etDiag := GD.ET_Diag.OK, i_etDiagExt := PDL_ET_DiagExt.WaitUntilStopped, i_sMsg := '');
			diState := 50;
			
		ELSIF xLimitOpposideDirection AND NOT xLimitOpposideDirectionOld THEN // limit in opposite direction reached -> no more ways to searche TP
			fbMoveRelative(Execute := FALSE);
			fbStop(Execute := TRUE);
			IF i_etMode = PDL_ET_HomeTpMode.PosDirectionPosEdgeTp OR i_etMode = PDL_ET_HomeTpMode.PosDirectionNegEdgeTp THEN
				SetDiagOutput(i_etDiag := GD.ET_Diag.LimitReached, i_etDiagExt := PDL_ET_DiagExt.HwLimitNegReached, i_sMsg := '');
			ELSE (* neg. direction *)
				SetDiagOutput(i_etDiag := GD.ET_Diag.LimitReached, i_etDiagExt := PDL_ET_DiagExt.HwLimitPosReached, i_sMsg := '');
			END_IF
			diState := 100;
			
		ELSIF fbMoveRelative.Done AND xMotionJobStarted THEN // positioning has finished without finding TP or LimitSwitch
			q_xMotionInstructionActive := FALSE;
			SetDiagOutput(i_etDiag := GD.ET_Diag.HomingFailed, i_etDiagExt := PDL_ET_DiagExt.TouchProbeNotFound, i_sMsg := '');
			diState := 0;
		ELSIF fbMoveRelative.Error THEN
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
				i_sMsg      := CONCAT('MC_MoveRelative.ErrorID: ', PLCO.FC_EtResultToString(THIS^.fbMoveRelative.ErrorID))
			);
			THIS^.fbMoveRelative(Execute := FALSE);
			diState := 0;
		END_IF
		xLimitOpposideDirectionOld := xLimitOpposideDirection; // reset flag if not on sensor in order to detect error if sensor gets true again
		xLimitGivenDirectionOld    := xLimitGivenDirection;
	50: // whait Until Drive has stopped after finding TP in opposite direction
		fbHalt(Execute := TRUE);
		IF fbHalt.Done THEN
			fbHalt(Execute := FALSE);
			IF xLimitGivenDirection THEN
				q_xMotionInstructionActive := FALSE;
				IF i_etMode = PDL_ET_HomeTpMode.PosDirectionPosEdgeTp OR i_etMode = PDL_ET_HomeTpMode.PosDirectionNegEdgeTp THEN (* pos. direction *)
					SetDiagOutput(i_etDiag := GD.ET_Diag.LimitReached, i_etDiagExt := PDL_ET_DiagExt.HwLimitPosReached, i_sMsg := '');
				ELSE (* neg. direction *)
					SetDiagOutput(i_etDiag := GD.ET_Diag.LimitReached, i_etDiagExt := PDL_ET_DiagExt.HwLimitNegReached, i_sMsg := '');
				END_IF
				diState := 0;
			ELSE
				xLimitGivenDirectionOld    := xLimitGivenDirection;
				xLimitOpposideDirectionOld := xLimitOpposideDirection;
				SetTpEdge(i_xOppositeFlank := FALSE);
				StartPositioningAndTPEdge(i_xOppositeDirection := FALSE);
				IF q_etDiag <> GD.ET_Diag.Ok THEN
					// exception during command, diag message already set in StartPositioningAndTPEdge()
					q_xMotionInstructionActive := FALSE;
					diState                    := 0;
				ELSE
					SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitForTouchProbeSignal, i_sMsg := '');
					diState := 20;
				END_IF
			END_IF
		ELSIF fbHalt.Error THEN
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
				i_sMsg      := CONCAT('MC_Halt.ErrorID: ', PLCO.FC_EtResultToString(THIS^.fbHalt.ErrorID))
			);
			THIS^.fbHalt(Execute := FALSE);
			diState := 0;
		END_IF
	60: // wait till positioning done after seen TP
		fbMoveAbsolute(Execute := TRUE);
		IF fbMoveAbsolute.Done THEN // pos finished
			fbMoveAbsolute(Execute := FALSE);
			q_xMotionInstructionActive := FALSE;
			fbSetPos(Execute := TRUE, Relative := FALSE, Position := i_lrHomePosition);
			IF fbSetPos.Error THEN
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
					i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
					i_sMsg      := CONCAT('MC_Setpos: ', PLCO.FC_EtResultToString(fbSetPos.ErrorId))
				);
				fbSetPos(Execute := FALSE);
				diState := 0;
			ELSE
				fbSetPos(Execute := FALSE);
				q_xHomeOk := TRUE;
				SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.HomingDone, i_sMsg := '');
				IF NOT i_xStart THEN
					diState := 10;
				ELSE
					diState := 70;
				END_IF
			END_IF
		ELSIF fbMoveAbsolute.Error THEN
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
				i_sMsg      := CONCAT('MC_MoveAbsolute.ErrorID: ', PLCO.FC_EtResultToString(THIS^.fbMoveAbsolute.ErrorID))
			);
			THIS^.fbMoveAbsolute(Execute := FALSE);
			q_xMotionInstructionActive := FALSE;
			diState                    := 0;
		END_IF
	70: // wait till i_xStart FALSE to prevent immediate restart
		IF NOT i_xStart THEN
			fbLoggerPoint.AddLogEntry(
				i_etLogLevel := APL.ET_LogLevel.DebugMessage, i_etDiag := q_etDiag, i_udiDiagExt := q_etDiagExt, i_sMessage := 'i_xStart reset'
			);
			// diagnosis output keeps ET_Diag.Ok and PDL_ET_DiagExt.HomingDone as it is set in state 60
			diState := 10;
		END_IF
	100: // wait  until stopped after HW Limit and Error 
		fbStop(Execute := TRUE);
		IF
			i_ifDrive.etAxisState = MOIN.ET_AxisState.Disabled OR
			i_ifDrive.etAxisState = MOIN.ET_AxisState.ErrorStop OR
			i_ifDrive.etAxisState = MOIN.ET_AxisState.Standstill OR
			fbStop.Done
		THEN
			q_xMotionInstructionActive := FALSE;
			fbStop(Execute := FALSE);
			fbLoggerPoint.AddLogEntry(
				i_etLogLevel := APL.ET_LogLevel.DebugMessage, i_etDiag := q_etDiag, i_udiDiagExt := q_etDiagExt, i_sMessage := 'Axis stopped'
			);
			
			IF NOT xEnableFlag THEN
				q_xActive    := FALSE;
				q_lrPosition := 0.0;
				q_xHomeOk    := FALSE;
				SetDiagOutput(i_etDiag := GD.ET_Diag.OK, i_etDiagExt := PDL_ET_DiagExt.Disabled, i_sMsg := '');
			END_IF
			
			diState := 0;
		END_IF
		
		IF fbStop.Error AND fbStop.ErrorId <> PLCO.ET_Result.StoppingInterrupted THEN
			q_xMotionInstructionActive := FALSE;
			q_xReady                   := FALSE;
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
				i_sMsg      := CONCAT('MC_Stop.ErrorID:', PLCO.FC_EtResultToString(fbStop.ErrorId))
			);
			fbStop(Execute := FALSE);
			diState := 0;
		END_IF
	ELSE
		q_xReady := FALSE;
		THIS^.SetDiagOutput(
			i_etDiag := GD.ET_Diag.UnexpectedProgramBehavior, i_etDiagExt := PDL_ET_DiagExt.UnknownState, i_sMsg := DINT_TO_STRING(diState)
		);
		diState := 0;
END_CASE
