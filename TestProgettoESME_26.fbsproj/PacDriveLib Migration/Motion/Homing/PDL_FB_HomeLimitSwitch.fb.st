__METADATA__
{
  "v3Meta": {
    "objectGuid": "2138c314-551f-4434-ad2b-29061f94ba14",
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
FUNCTION_BLOCK PDL_FB_HomeLimitSwitch
VAR_INPUT
	i_xEnable        : BOOL;
	i_ifDrive        : MOIN.IF_Axis;
	i_etMode         : PDL_ET_HomeLimitSwitchMode;
	i_lrOffset       : LREAL;
	i_lrMaxTravel    : LREAL;
	i_lrHomePosition : LREAL;
	i_lrVel          : LREAL;
	i_lrLowVel       : LREAL;
	i_lrAcc          : LREAL;
	i_lrDec          : LREAL;
	i_lrJerk         : LREAL;
	i_xHwLimitNeg    : BOOL;
	i_xHwLimitPos    : BOOL;
	i_xStart         : BOOL;
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
	xSuccess               : BOOL;
	xInterfacesInitialised : BOOL;
	xEnableFlag            : BOOL;
	diState                : DINT;
	fbStop                 : PLCO.MC_Stop;
	fbMoveAbsolute         : PLCO.MC_MoveAbsolute;
	fbMoveRelative         : PLCO.MC_MoveRelative;
	fbSetPos               : PLCO.MC_SetPosition;
	lrDistance             : LREAL;
	xLimitPos              : BOOL;
	xLimitNeg              : BOOL;
	xStartFlag             : BOOL;
	fbLoggerPoint          : APL.FB_LoggerPoint;
	
	ifDriveConfigAccess	   : DDI.IF_DriveConfigAccess;
	ifDriveConfig		   : DDI.IF_DriveConfig;	
	ifDeviceTreeObjectAccess      : UFMPLCI.IF_DeviceTreeObjectAccess;
	sDriveName                    : STRING(80);
END_VAR
VAR CONSTANT
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
	q_xActive                  := TRUE;
	q_xReady                   := FALSE;
	q_xHomeOk                  := FALSE;
	q_xMotionInstructionActive := FALSE;
	SetDiagOutput(
		i_etDiag    := GD.ET_Diag.OK,
		i_etDiagExt := PDL_ET_DiagExt.Initializing,
		i_sMsg      := ''
	);
	
	xInterfacesInitialised := InitInterfaces();
	IF NOT xInterfacesInitialised THEN
		RETURN;
	END_IF
	
	xSuccess := InputParameterCheck();
	IF NOT xSuccess THEN
		RETURN;
	END_IF
	
	THIS^.fbSetPos(
		Execute  := TRUE,
		Position := 0.0,
		Relative := FALSE
	);
	
	IF THIS^.fbSetPos.Error THEN
		q_xReady                   := FALSE;
		q_xMotionInstructionActive := FALSE;
		SetDiagOutput(
			i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
			i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
			i_sMsg      :=
				CONCAT(
					'MC_SetPosition: ',
					PLCO.FC_EtResultToString(THIS^.fbSetPos.ErrorID)
				)
		);
		
		THIS^.fbSetPos(Execute := FALSE);
		RETURN;
	END_IF
	
	THIS^.fbSetPos(Execute := FALSE);
	i_ifDrive.xIsHomed := FALSE;
	xStartFlag         := FALSE;
	q_xReady           := TRUE;
	SetDiagOutput(
		i_etDiag    := GD.ET_Diag.OK,
		i_etDiagExt := PDL_ET_DiagExt.WaitForStart,
		i_sMsg      := ''
	);
	diState := 10;
	
ELSIF NOT I_xEnable AND xEnableFlag THEN
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
		SetDiagOutput(
			i_etDiag    := GD.ET_Diag.OK,
			i_etDiagExt := PDL_ET_DiagExt.WaitUntilDisabled,
			i_sMsg      := ''
		);
		diState := 100;
	ELSE
		q_xActive                  := FALSE;
		q_xMotionInstructionActive := FALSE;
		q_lrPosition               := 0.0;
		q_xHomeOk                  := FALSE;
		SetDiagOutput(
			i_etDiag    := GD.ET_Diag.OK,
			i_etDiagExt := PDL_ET_DiagExt.Disabled,
			i_sMsg      := ''
		);
		diState := 0;
	END_IF
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
	(* The HW limits are evaluated depending on the mode – they must be queried while moving. *)
	IF i_etMode = PDL_ET_HomeLimitSwitchMode.PosDirectionPosEdgeHWLimitPos OR i_etMode = PDL_ET_HomeLimitSwitchMode.PosDirectionNegEdgeHWLimitPos THEN (* pos. direction *)
		xLimitPos := i_xHWLimitPos;
		xLimitNeg := i_xHWLimitNeg;
	ELSE (* neg. direction *)
		xLimitPos := i_xHWLimitNeg;
		xLimitNeg := i_xHWLimitPos;
	END_IF
	IF i_etMode = PDL_ET_HomeLimitSwitchMode.PosDirectionNegEdgeHWLimitPos OR i_etMode = PDL_ET_HomeLimitSwitchMode.NegDirectionNegEdgeHWLimitNeg THEN (* Öffner *)
		xLimitPos := NOT xLimitPos;
		xLimitNeg := NOT xLimitNeg;
	END_IF
END_IF

CASE diState OF
	
	0: (* Error or ready *)
		;
	10: (* Wait for Start *)
		IF i_xStart AND NOT xStartFlag THEN
			xStartFlag := TRUE;
			THIS^.fbLoggerPoint.AddLogEntry(
				i_etLogLevel := APL.ET_LogLevel.UserAction,
				i_etDiag     := q_etDiag,
				i_udiDiagExt := q_etDiagExt,
				i_sMessage   := 'start homing',
				q_etDiag     =>,
				q_etDiagExt  =>
			);
			xSuccess := InputParameterCheck();
			IF NOT xSuccess THEN
				q_xReady := FALSE;
				diState  := 0;
				RETURN;
			END_IF
			q_xHomeOk                  := FALSE;
			q_xMotionInstructionActive := TRUE;
			
			CASE i_etMode OF
				PDL_ET_HomeLimitSwitchMode.PosDirectionPosEdgeHWLimitPos: (* Mode 0:  pos. Direction until pos. Edge of HomeSignal + Offset*)
					lrDistance := ABS(i_lrMaxTravel);
				PDL_ET_HomeLimitSwitchMode.NegDirectionPosEdgeHWLimitNeg: (* Mode 1:  neg. Direction until pos. Edge of HomeSignal + Offset*)
					lrDistance := -ABS(i_lrMaxTravel);
				PDL_ET_HomeLimitSwitchMode.NegDirectionNegEdgeHWLimitNeg: (* Mode 2:  pos. Direction until neg. Edge of HomeSignal + Offset*)
					lrDistance := -ABS(i_lrMaxTravel);
				PDL_ET_HomeLimitSwitchMode.PosDirectionNegEdgeHWLimitPos: (* Mode 3:  neg. Direction until neg. Edge of HomeSignal + Offset*)
					lrDistance := ABS(i_lrMaxTravel);
				ELSE
					q_xReady := FALSE;
					SetDiagOutput(
						i_etDiag    := GD.ET_Diag.InputParameterInvalid,
						i_etDiagExt := PDL_ET_DiagExt.UnknownMode,
						i_sMsg      := ''
					);
					diState := 0;
					RETURN;
			END_CASE
			
			IF xLimitPos AND NOT xLimitNeg THEN (* Axis stands on LS *)
				THIS^.fbMoveRelative(
					Execute  := TRUE,
					Distance := -lrDistance,
					Velocity := i_lrVel
				);
				
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.OK,
					i_etDiagExt := PDL_ET_DiagExt.WaitUntilLimitSwitchFree,
					i_sMsg      := ''
				);
				diState := 30;
				
			ELSIF xLimitPos AND xLimitNeg THEN (* Axis stands on LS pos and neg *)
				q_xMotionInstructionActive := FALSE;
				diState                    := 0;
				IF
					i_etMode = PDL_ET_HomeLimitSwitchMode.PosDirectionPosEdgeHWLimitPos OR
					i_etMode = PDL_ET_HomeLimitSwitchMode.PosDirectionNegEdgeHWLimitPos
				THEN (* pos. direction *)
					q_xReady := FALSE;
					SetDiagOutput(
						i_etDiag    := GD.ET_Diag.LimitReached,
						i_etDiagExt := PDL_ET_DiagExt.HwLimitNegReached,
						i_sMsg      := ''
					);
				ELSE
					q_xReady := FALSE;
					
					SetDiagOutput(
						i_etDiag    := GD.ET_Diag.LimitReached,
						i_etDiagExt := PDL_ET_DiagExt.HwLimitPosReached,
						i_sMsg      := ''
					);
				END_IF
			ELSE (* LS is free *)
				THIS^.fbMoveRelative(
					Execute  := TRUE,
					Distance := lrDistance,
					Velocity := i_lrVel
				);
				
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.Ok,
					i_etDiagExt := PDL_ET_DiagExt.WaitForLimitSwitchVel,
					i_sMsg      := ''
				);
				diState := 20;
			END_IF
			
		ELSIF NOT i_xStart AND xStartFlag THEN
			xStartFlag := FALSE;
		END_IF
	20: (* go for Limitswitch *)
		THIS^.fbMoveRelative(Execute := TRUE);
		
		IF THIS^.fbMoveRelative.Error THEN
			q_xReady                   := FALSE;
			q_xMotionInstructionActive := FALSE;
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
				i_sMsg      := CONCAT('MC_MoveRelative.ErrorID: ',PLCO.FC_EtResultToString(THIS^.fbMoveRelative.ErrorID))
			);
			THIS^.fbMoveRelative(Execute := FALSE);
			diState := 0;
			
		ELSIF xLimitPos THEN
			THIS^.fbMoveRelative(Execute := FALSE);
			THIS^.fbMoveRelative(
				Execute  := TRUE,
				Distance := -lrDistance,
				Velocity := i_lrLowVel
			);
			
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.Ok,
				i_etDiagExt := PDL_ET_DiagExt.WaitUntilLimitSwitchFree,
				i_sMsg      := ''
			);
			diState := 30;
			
		ELSIF THIS^.fbMoveRelative.Done THEN (* MaxDistance reached  *)
			q_xReady                   := FALSE;
			q_xMotionInstructionActive := FALSE;
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.HomingFailed,
				i_etDiagExt := PDL_ET_DiagExt.SensorNotFound,
				i_sMsg      := ''
			);
			THIS^.fbMoveRelative(Execute := FALSE);
			diState := 0;
		END_IF
	30: (* Wait for LimitSwitch free *)
		THIS^.fbMoveRelative(Execute := TRUE);
		
		IF NOT xLimitPos THEN (* Limitswitch is free *)
			THIS^.fbMoveRelative(Execute := FALSE);
			THIS^.fbMoveRelative(
				Execute  := TRUE,
				Distance := lrDistance,
				Velocity := i_lrLowVel
			);
			
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.Ok,
				i_etDiagExt := PDL_ET_DiagExt.WaitForLimitSwitchLowVel,
				i_sMsg      := ''
			);
			diState := 40;
			
		ELSIF THIS^.fbMoveRelative.Error THEN
			q_xReady                   := FALSE;
			q_xMotionInstructionActive := FALSE;
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
				i_sMsg      := CONCAT('MC_MoveRelative.ErrorID: ',PLCO.FC_EtResultToString(THIS^.fbMoveRelative.ErrorID))
			);
			THIS^.fbMoveRelative(Execute := FALSE);
			diState := 0;
			
		ELSIF THIS^.fbMoveRelative.Done THEN (* MaxDistance reached  *)
			q_xReady                   := FALSE;
			q_xMotionInstructionActive := FALSE;
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.HomingFailed,
				i_etDiagExt := PDL_ET_DiagExt.SensorNotFound,
				i_sMsg      := ''
			);
			THIS^.fbMoveRelative(Execute := FALSE);
			diState := 0;
			
		ELSIF xLimitNeg THEN (* Wrong LS *)
			
			THIS^.fbMoveRelative(Execute := FALSE);
			THIS^.fbStop(Execute := TRUE);
			
			diState := 60;
			IF
				i_etMode = PDL_ET_HomeLimitSwitchMode.PosDirectionPosEdgeHWLimitPos OR
				i_etMode = PDL_ET_HomeLimitSwitchMode.PosDirectionNegEdgeHWLimitPos
			THEN (* pos. direction *)
				q_xReady := FALSE;
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.LimitReached,
					i_etDiagExt := PDL_ET_DiagExt.HwLimitNegReached,
					i_sMsg      := ''
				);
			ELSE
				q_xReady := FALSE;
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.LimitReached,
					i_etDiagExt := PDL_ET_DiagExt.HwLimitPosReached,
					i_sMsg      := ''
				);
			END_IF
		END_IF
	40: (* go for Limitswitch *)
		THIS^.fbMoveRelative(Execute := TRUE);
		
		IF THIS^.fbMoveRelative.Error THEN
			q_xReady                   := FALSE;
			q_xMotionInstructionActive := FALSE;
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
				i_sMsg      := CONCAT('MC_MoveRelative.ErrorID: ',PLCO.FC_EtResultToString(THIS^.fbMoveRelative.ErrorID))
			);
			THIS^.fbMoveRelative(Execute := FALSE);
			diState := 0;
			
		ELSIF xLimitPos THEN
			
			THIS^.fbMoveRelative(Execute := FALSE);
			i_ifDrive.xIsHomed := TRUE;
			THIS^.fbMoveAbsolute(
				Execute  := TRUE,
				Position := q_lrPosition + i_lrOffset
			);
			
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.Ok,
				i_etDiagExt := PDL_ET_DiagExt.WaitUntilOffsetReached,
				i_sMsg      := ''
			);
			diState := 50;
			
		ELSIF THIS^.fbMoveRelative.Done THEN (* MaxDistance reached  *)
			q_xReady                   := FALSE;
			q_xMotionInstructionActive := FALSE;
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.HomingFailed,
				i_etDiagExt := PDL_ET_DiagExt.SensorNotFound,
				i_sMsg      := ''
			);
			THIS^.fbMoveRelative(Execute := FALSE);
			diState := 0;
		END_IF
	50: (* Wait for Offset reached *)
		THIS^.fbMoveAbsolute(Execute := TRUE);
		
		IF THIS^.fbMoveAbsolute.Error THEN
			q_xReady                   := FALSE;
			q_xMotionInstructionActive := FALSE;
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
				i_sMsg      := CONCAT('MC_MoveAbsolute.ErrorID: ',PLCO.FC_EtResultToString(THIS^.fbMoveAbsolute.ErrorID))
			);
			THIS^.fbMoveAbsolute(Execute := FALSE);
			i_ifDrive.xIsHomed := FALSE;
			diState := 0;
			
		ELSIF THIS^.fbMoveAbsolute.Done THEN
			THIS^.fbMoveAbsolute(Execute := FALSE);
			q_xHomeOk                  := TRUE;
			q_xMotionInstructionActive := FALSE;
			THIS^.fbSetPos(
				Execute  := TRUE,
				Position := i_lrHomePosition,
				Relative := FALSE
			);
			
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
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.Ok,
					i_etDiagExt := PDL_ET_DiagExt.HomingDone,
					i_sMsg      := ''
				);
				diState := 10;
				THIS^.fbSetPos(Execute := FALSE);
			END_IF
		END_IF
		
	60: (* wait until stopped *)
		THIS^.fbStop(Execute := TRUE);
		IF THIS^.fbStop.Done THEN
			q_xMotionInstructionActive := FALSE;
			diState                    := 0;
		ELSIF THIS^.fbStop.Error THEN
			q_xReady                   := FALSE;
			q_xMotionInstructionActive := FALSE;
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
				i_sMsg      := CONCAT('MC_Stop.ErrorID: ',PLCO.FC_EtResultToString(THIS^.fbStop.ErrorID))
			);
			THIS^.fbStop(Execute := FALSE);
			diState := 0;
		END_IF
	100: (* Wait until stopped  *)
		THIS^.fbMoveAbsolute(Execute := FALSE);
		THIS^.fbMoveRelative(Execute := FALSE);
		
		IF
			i_ifDrive.etAxisState <> MOIN.ET_AxisState.Disabled AND
			i_ifDrive.etAxisState <> MOIN.ET_AxisState.ErrorStop AND
			i_ifDrive.etAxisState <> MOIN.ET_AxisState.Standstill AND
			i_ifDrive.etAxisState <> MOIN.ET_AxisState.Stopping
		THEN
			THIS^.fbStop.Execute := TRUE;
		END_IF
		
		THIS^.fbStop();
		
		//stopping done
		IF
			i_ifDrive.etAxisState = MOIN.ET_AxisState.Disabled OR
			i_ifDrive.etAxisState = MOIN.ET_AxisState.ErrorStop OR
			i_ifDrive.etAxisState = MOIN.ET_AxisState.Standstill OR
			fbStop.Done
		THEN
			xInterfacesInitialised := FALSE;
			fbStop(Execute := FALSE);
			q_xActive    := FALSE;
			q_xReady     := FALSE;
			q_lrPosition := 0.0;
			q_xHomeOk    := FALSE;
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.OK,
				i_etDiagExt := PDL_ET_DiagExt.Disabled,
				i_sMsg      := ''
			);
			
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
			i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
			i_etDiagExt := PDL_ET_DiagExt.UnknownState,
			i_sMsg      := DINT_TO_STRING(diState)
		);
		diState := 0;
END_CASE
