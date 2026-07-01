__METADATA__
{
  "v3Meta": {
    "objectGuid": "0816b530-0171-4b5d-9fb0-5a45cfdb845f",
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
FUNCTION_BLOCK PDL_FB_Home
VAR_INPUT
	i_xEnable     : BOOL;
	i_etMode      : PDL_ET_HomeMode := PDL_ET_HomeMode.SetPosAxisAndLogEncoderPosition;
	i_ifDrive     : Moin.IF_Axis;
	i_xHwLimitNeg : BOOL;
	i_xHwLimitPos : BOOL;
	i_xStart      : BOOL;
END_VAR
VAR_OUTPUT
	q_xActive                  : BOOL;
	q_xReady                   : BOOL;
	q_etDiag                   : GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt                : PDL_ET_DiagExt := PDL_ET_DiagExt.Disabled;
	q_sMsg                     : STRING[80];
	q_xDisableDrive            : BOOL  := FALSE;
	q_xMotionInstructionActive : BOOL;
	q_lrPosition               : LREAL := 0.0;
	q_lrEncoderPosition        : LREAL := 0.0;
	q_xHomeOk                  : BOOL;
END_VAR
VAR
	stSensor_loc           : PDL_ST_HomeIn;
	stLimitSwitch_loc      : PDL_ST_HomeLimitSwitch;
	stMoveOnPos_loc        : PDL_ST_HomeMoveOnPos;
	stSetPos_loc           : PDL_ST_HomeSetPos;
	stTorque_loc           : PDL_ST_HomeTorque;
	stForce_loc            : PDL_ST_HomeForce;
	stTouchProbe_loc       : PDL_ST_HomeTp;
	stWritePos_loc         : PDL_ST_HomeWritePos;
	stReducedVelocity_loc  : PDL_ST_ReducedVelocity;
	xEnableFlag            : BOOL;
	etHomeState            : PDL_ET_HomeState;
	etHomeOpMode           : PDL_ET_HomeOpMode;
	xStartFlag             : BOOL;
	xStartHomeIn           : BOOL;
	fbHomeTP               : PDL_FB_HomeTp;
	fbHomeIn               : PDL_FB_HomeIn;
	fbHomeLS               : PDL_FB_HomeLimitSwitch;
	fbHomeTorque           : PDL_FB_HomeTorque;
	fbHomeForce            : PDL_FB_HomeForce;
	fbVarioPosJerk         : PDL_FB_VarioPosJerk;
	fbHomeAbs              : PDL_FB_HomeAbs;
	fbSetpos               : PDL_FB_HomeSetpos;
	etHomeTpMode           : PDL_ET_HomeTpMode;
	etHomeInMode           : PDL_ET_HomeInMode;
	etHomeLimitSwitchMode  : PDL_ET_HomeLimitSwitchMode;
	etHomeTorqueMode       : PDL_ET_HomeTorqueMode;
	etHomeForceMode        : PDL_ET_HomeForceMode;
	etHomeSetPosMode       : PDL_ET_HomeSetPosMode;
	xSuccess               : BOOL;
	xFbEnable              : BOOL;
	xFbActive              : BOOL;
	lrUsedVelocity         : LREAL;
	lrLowVelocity          : LREAL;
	etDiagBuffer           : GD.ET_Diag;
	sTempMsg               : STRING[80] := '';
	xFbHomeOk              : BOOL;
	lrPositionOpmMoveOnPos : LREAL;
	xDetectSetPosHomeOnPos : BOOL;
	fbLoggerPoint          : APL.FB_LoggerPoint;
	xControllerStop        : BOOL;
	fbTrigStop              : Standard.R_TRIG;
	fbSetPosIntern         : PLCO.MC_SetPosition;
	ifGetParentDevice      : DTSI.IF_GetParentDevice;
	ifDeviceAccess         : DTSI.IF_DeviceAccess;
	ifDriveAccess          : DMFI.IF_DriveAccess;
	ifDrive                : DMFI.IF_Drive;
	
	xInitReducedVel : BOOL;
END_VAR
__IMPLEMENTATION__
(* ------------------------------------------------------------------------------------------------------------------------------------------------------*)
(* Wait for Enable *)
(* ------------------------------------------------------------------------------------------------------------------------------------------------------*)
IF i_xEnable AND NOT xEnableflag THEN (*  Input action by rising edge of enable *)
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
	q_xDisableDrive            := FALSE;
	q_xMotionInstructionActive := FALSE;
	
	xFbEnable  := FALSE;
	xStartFlag := FALSE;
	q_xReady   := TRUE;
	SetDiagOutput(i_etDiag := GD.ET_Diag.OK, i_etDiagExt := PDL_ET_DiagExt.WaitForStart, i_sMsg := '');
	etHomeState := PDL_ET_HomeState.WaitForStart;
	
ELSIF NOT i_xEnable AND xEnableflag THEN (* Input action by falling edge of enable *)
	xEnableFlag := FALSE;
	THIS^.fbLoggerPoint.AddLogEntry(
		i_etLogLevel := APL.ET_LogLevel.UserAction,
		i_etDiag     := q_etDiag,
		i_udiDiagExt := q_etDiagExt,
		i_sMessage   := 'disable function block',
		q_etDiag     =>,
		q_etDiagExt  =>
	);
	q_xReady  := FALSE;
	xFbEnable := FALSE;
	SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitUntilDisabled, i_sMsg := '');
	etHomeState := PDL_ET_HomeState.WaitUntilDisabled; (* Wait until disabled *)
END_IF

IF NOT i_xStart AND xStartFlag THEN (* allways accept the falling edge in i_xStart *)
	xStartFlag := FALSE; (* make no difference for the fbs called inside, because their start ist fixed to TRUE *)
END_IF

(* Continuous Checks at Enable *)
IF i_xEnable THEN
	(* Check HW-Limits in Pos-Mode because FB_VarioPosJerk has no HW-Limit-Inputs *)
	IF
		(etHomeOpMode = PDL_ET_HomeOpMode.Torque OR etHomeOpMode = PDL_ET_HomeOpMode.Force OR etHomeOpMode = PDL_ET_HomeOpMode.MoveOnPos) AND
		(i_xHwLimitNeg OR i_xHwLimitPos)
	THEN
		IF i_xHwLimitNeg THEN
			SetDiagOutput(i_etDiag := GD.ET_Diag.LimitReached, i_etDiagExt := PDL_ET_DiagExt.HwLimitNegReached, i_sMsg := '');
		ELSIF i_xHwLimitPos THEN
			SetDiagOutput(i_etDiag := GD.ET_Diag.LimitReached, i_etDiagExt := PDL_ET_DiagExt.HwLimitPosReached, i_sMsg := '');
		END_IF
	END_IF
	(* Check ReducedVelocity *)
	IF stReducedVelocity_loc.i_xEnableReducedVelocity THEN
		IF NOT xInitReducedVel THEN
			xInitReducedVel := TRUE;
			(* Check Interfaces *)
			xSuccess := __QUERYINTERFACE(i_ifDrive, ifGetParentDevice);
			IF NOT xSuccess OR ifGetParentDevice = 0 THEN
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.InputParameterInvalid,
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg      := 'i_ifDrive - IF_GetParentDevice not implemented.'
				);
			END_IF
			ifDeviceAccess := ifGetParentDevice.GetParentDevice();
			
			xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifDriveAccess);
			IF (NOT xSuccess OR ifDriveAccess = 0) THEN
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.InputParameterInvalid,
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg      := 'i_ifDrive - IF_Drive not implemented.'
				);
			END_IF
			ifDrive := ifDriveAccess.Drive;
		END_IF
		
		IF stReducedVelocity_loc.i_lrMaxReducedVelocity <= 0 THEN
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.InputParameterInvalid,
				i_etDiagExt := PDL_ET_DiagExt.ReducedVelocityRange,
				i_sMsg      := 'lrMaxReducedVelocity <= 0'
			);
		END_IF
		IF stReducedVelocity_loc.i_lrReducedVelocityCheckFactor < 1.0 THEN
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.InputParameterInvalid,
				i_etDiagExt := PDL_ET_DiagExt.ReducedVelocityFactorRange,
				i_sMsg      := 'i_lrReducedVelocityCheckFactor < 1'
			);
		END_IF
		IF ifDrive <> 0 THEN
			IF
				ABS(ifDrive.ActualPosition) > ABS(stReducedVelocity_loc.i_lrMaxReducedVelocity * stReducedVelocity_loc.i_lrReducedVelocityCheckFactor)
			THEN
				SetDiagOutput(i_etDiag := GD.ET_Diag.LimitReached, i_etDiagExt := PDL_ET_DiagExt.ReducedVelocityLimit, i_sMsg := '');
			END_IF
		END_IF
	ELSE
		xInitReducedVel := FALSE;
	END_IF
END_IF

(*Statemachine*)
//etHomeState is also changed in SetDiagOutput and Diag-Translations at END of HomingOpModes-Blocks in FB_Home AS-Structure
CASE etHomeState OF
	(* ------------------------------------------------------------------------------------------------------------------------------------------------------*)
	PDL_ET_HomeState.ExceptionOrIdle: (* Idle or Error *)
		(* ------------------------------------------------------------------------------------------------------------------------------------------------------*)
		;
		
		(* ------------------------------------------------------------------------------------------------------------------------------------------------------*)
	PDL_ET_HomeState.WaitForStart: (* Wait for Start *)
		(* ------------------------------------------------------------------------------------------------------------------------------------------------------*)
		IF i_xStart AND NOT xStartFlag THEN
			xStartFlag := TRUE;
			THIS^.fbLoggerPoint.AddLogEntry(
				i_etLogLevel := APL.ET_LogLevel.UserAction,
				i_etDiag     := q_etDiag,
				i_udiDiagExt := q_etDiagExt,
				i_sMessage   := 'start function block',
				q_etDiag     =>,
				q_etDiagExt  =>
			);
			q_xHomeOK := FALSE;
			sTempMsg  := '';
			IF
				i_etMode = PDL_ET_HomeMode.PosDirectionPosEdgeTp OR
				i_etMode = PDL_ET_HomeMode.NegDirectionPosEdgeTp OR
				i_etMode = PDL_ET_HomeMode.NegDirectionNegEdgeTp OR
				i_etMode = PDL_ET_HomeMode.PosDirectionNegEdgeTp
			THEN (* HomeTP *)
				
				etHomeOpMode := PDL_ET_HomeOpMode.TouchProbe;
				CASE i_etMode OF
					PDL_ET_HomeMode.PosDirectionPosEdgeTp:
						etHomeTpMode := PDL_ET_HomeTpMode.PosDirectionPosEdgeTp;
					PDL_ET_HomeMode.NegDirectionPosEdgeTp:
						etHomeTpMode := PDL_ET_HomeTpMode.NegDirectionPosEdgeTp;
					PDL_ET_HomeMode.NegDirectionNegEdgeTp:
						etHomeTpMode := PDL_ET_HomeTpMode.NegDirectionNegEdgeTp;
					PDL_ET_HomeMode.PosDirectionNegEdgeTp:
						etHomeTpMode := PDL_ET_HomeTpMode.PosDirectionNegEdgeTp;
				END_CASE
				xFbEnable := TRUE;
				sTempMsg  := 'HomeTP';
				DriveAndLencCheck();
				THIS^.fbHomeTP.RegisterLoggerPoint(i_ifParent := THIS^.fbLoggerPoint, i_sName := 'HomeTp', q_etDiag =>, q_etDiagExt => );
				(* HomeIN *)
			ELSIF
				i_etMode = PDL_ET_HomeMode.PosDirectionPosEdgeSensor OR
				i_etMode = PDL_ET_HomeMode.NegDirectionPosEdgeSensor OR
				i_etMode = PDL_ET_HomeMode.NegDirectionNegEdgeSensor OR
				i_etMode = PDL_ET_HomeMode.PosDirectionNegEdgeSensor
			THEN
				
				etHomeOpMode := PDL_ET_HomeOpMode.Sensor;
				CASE i_etMode OF
					PDL_ET_HomeMode.PosDirectionPosEdgeSensor:
						etHomeInMode := PDL_ET_HomeInMode.PosDirectionPosEdgeSensor;
					PDL_ET_HomeMode.NegDirectionPosEdgeSensor:
						etHomeInMode := PDL_ET_HomeInMode.NegDirectionPosEdgeSensor;
					PDL_ET_HomeMode.NegDirectionNegEdgeSensor:
						etHomeInMode := PDL_ET_HomeInMode.NegDirectionNegEdgeSensor;
					PDL_ET_HomeMode.PosDirectionNegEdgeSensor:
						etHomeInMode := PDL_ET_HomeInMode.PosDirectionNegEdgeSensor;
				END_CASE
				xStartHomeIn := FALSE;
				xFbEnable    := TRUE;
				sTempMsg     := 'HomeIn';
				DriveAndLencCheck();
				THIS^.fbHomeIn.RegisterLoggerPoint(i_ifParent := THIS^.fbLoggerPoint, i_sName := 'HomeIn', q_etDiag =>, q_etDiagExt => );
				(* HomeLS *)
			ELSIF
				i_etMode = PDL_ET_HomeMode.PosDirectionPosEdgeHWLimitPos OR
				i_etMode = PDL_ET_HomeMode.NegDirectionPosEdgeHWLimitNeg OR
				i_etMode = PDL_ET_HomeMode.NegDirectionNegEdgeHWLimitNeg OR
				i_etMode = PDL_ET_HomeMode.PosDirectionNegEdgeHWLimitPos
			THEN
				
				etHomeOpMode := PDL_ET_HomeOpMode.LimitSwitch;
				CASE i_etMode OF
					PDL_ET_HomeMode.PosDirectionPosEdgeHWLimitPos:
						etHomeLimitSwitchMode := PDL_ET_HomeLimitSwitchMode.PosDirectionPosEdgeHWLimitPos;
					PDL_ET_HomeMode.NegDirectionPosEdgeHWLimitNeg:
						etHomeLimitSwitchMode := PDL_ET_HomeLimitSwitchMode.NegDirectionPosEdgeHWLimitNeg;
					PDL_ET_HomeMode.NegDirectionNegEdgeHWLimitNeg:
						etHomeLimitSwitchMode := PDL_ET_HomeLimitSwitchMode.NegDirectionNegEdgeHWLimitNeg;
					PDL_ET_HomeMode.PosDirectionNegEdgeHWLimitPos:
						etHomeLimitSwitchMode := PDL_ET_HomeLimitSwitchMode.PosDirectionNegEdgeHWLimitPos;
				END_CASE
				xFbEnable := TRUE;
				sTempMsg  := 'HomeLS';
				DriveAndLencCheck();
				THIS^.fbHomeLS.RegisterLoggerPoint(i_ifParent := THIS^.fbLoggerPoint, i_sName := 'HomeLimitSwitch', q_etDiag =>, q_etDiagExt => );
				(* HomeTorque *)
			ELSIF i_etMode = PDL_ET_HomeMode.PosDirectionMaxTorque OR i_etMode = PDL_ET_HomeMode.NegDirectionMaxTorque THEN
				
				etHomeOpMode := PDL_ET_HomeOpMode.Torque;
				CASE i_etMode OF
					PDL_ET_HomeMode.PosDirectionMaxTorque:
						etHomeTorqueMode := PDL_ET_HomeTorqueMode.PosDirectionMaxTorque;
					PDL_ET_HomeMode.NegDirectionMaxTorque:
						etHomeTorqueMode := PDL_ET_HomeTorqueMode.NegDirectionMaxTorque;
				END_CASE
				xFbEnable := TRUE;
				sTempMsg  := 'HomeTorque';
				DriveAndLencCheck();
				THIS^.fbHomeTorque.RegisterLoggerPoint(i_ifParent := THIS^.fbLoggerPoint, i_sName := 'HomeTorque', q_etDiag =>, q_etDiagExt => );
				
			ELSIF i_etMode = PDL_ET_HomeMode.PosDirectionMaxForce OR i_etMode = PDL_ET_HomeMode.NegDirectionMaxForce THEN
				
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.InputParameterInvalid,
					i_etDiagExt := PDL_ET_DiagExt.UnknownMode,
					i_sMsg      := concat('HomeMode not yet supported', TO_STRING(i_etMode))
				);
				RETURN;

			ELSIF i_etMode = PDL_ET_HomeMode.MoveOnPosAbs THEN (* Home move on Pos *)
				
				etHomeOpMode := PDL_ET_HomeOpMode.MoveOnPos;
				IF stMoveOnPos_loc.i_lrPeriod > 0 AND stMoveOnPos_loc.i_xRotativeSystem THEN
					lrPositionOpmMoveOnPos :=
						MATH.fmod(lrX := (stMoveOnPos_loc.i_lrTarget - i_ifDrive.lrPosition), lrM := stMoveOnPos_loc.i_lrPeriod);
					IF lrPositionOpmMoveOnPos > stMoveOnPos_loc.i_lrPeriod / 2 THEN
						lrPositionOpmMoveOnPos := lrPositionOpmMoveOnPos - stMoveOnPos_loc.i_lrPeriod;
					END_IF
					IF lrPositionOpmMoveOnPos < -stMoveOnPos_loc.i_lrPeriod / 2 THEN
						lrPositionOpmMoveOnPos := lrPositionOpmMoveOnPos + stMoveOnPos_loc.i_lrPeriod;
					END_IF
				ELSE
					lrPositionOpmMoveOnPos := stMoveOnPos_loc.i_lrTarget;
				END_IF
				
				xControllerStop := FALSE;
				
				fbVarioPosJerk(i_ifDrive := i_ifDrive, i_xEnable := FALSE, i_xStart := FALSE, i_xStop := FALSE);
				xFbEnable := TRUE;
				sTempMsg  := 'MoveOnPosAbs';
				DriveAndLencCheck();
				THIS^.fbVarioPosJerk.RegisterLoggerPoint(i_ifParent := THIS^.fbLoggerPoint, i_sName := 'MoveOnPosAbs', q_etDiag =>, q_etDiagExt => );
				
			ELSIF i_etMode = PDL_ET_HomeMode.WriteAxisEncoder THEN (* HomeAbs *)
				
				etHomeOpMode := PDL_ET_HomeOpMode.WritePos;
				xFbEnable    := TRUE;
				sTempMsg     := 'WritePos';
				DriveAndLencCheck(); (* HomeSetPos *)
				THIS^.fbHomeAbs.RegisterLoggerPoint(i_ifParent := THIS^.fbLoggerPoint, i_sName := 'HomeAbs', q_etDiag =>, q_etDiagExt => );
				
			ELSIF
				i_etMode = PDL_ET_HomeMode.SetPosAxisPosition OR
				i_etMode = PDL_ET_HomeMode.SetPosLogEncoderPosition OR
				i_etMode = PDL_ET_HomeMode.SetPosAxisAndLogEncoderPosition OR
				i_etMode = PDL_ET_HomeMode.RestorePosFromAxisEncoder OR
				i_etMode = PDL_ET_HomeMode.RestorePosFromRetain
			THEN
				
				etHomeOpMode := PDL_ET_HomeOpMode.SetPos;
				CASE i_etMode OF
					PDL_ET_HomeMode.SetPosAxisPosition:
						etHomeSetPosMode := PDL_ET_HomeSetPosMode.SetPosAxisPosition;
					PDL_ET_HomeMode.SetPosLogEncoderPosition:
						etHomeSetPosMode := PDL_ET_HomeSetPosMode.SetPosLogEncoderPosition;
					PDL_ET_HomeMode.SetPosAxisAndLogEncoderPosition:
						etHomeSetPosMode := PDL_ET_HomeSetPosMode.SetPosAxisAndLogEncoderPosition;
					PDL_ET_HomeMode.RestorePosFromAxisEncoder:
						etHomeSetPosMode := PDL_ET_HomeSetPosMode.RestorePosFromAxisEncoder;
					PDL_ET_HomeMode.RestorePosFromRetain:
						etHomeSetPosMode := PDL_ET_HomeSetPosMode.RestorePosFromRetain;
				END_CASE
				xFbEnable := TRUE;
				sTempMsg  := 'HomeSetPos';
				DriveAndLencCheck();
				THIS^.fbSetpos.RegisterLoggerPoint(i_ifParent := THIS^.fbLoggerPoint, i_sName := 'HomeSetPos', q_etDiag =>, q_etDiagExt => );
				
			ELSE
				etHomeOpMode := PDL_ET_HomeOpMode.NoOp;
				SetDiagOutput(
					i_etDiag := GD.ET_Diag.InputParameterInvalid, i_etDiagExt := PDL_ET_DiagExt.UnknownMode, i_sMsg := UDINT_TO_STRING(i_etMode)
				);
			END_IF
			
			IF etHomeOpMode <> PDL_ET_HomeOpMode.NoOp THEN
				SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitUntilHomingDone, i_sMsg := sTempMsg);
			END_IF
			etHomeState := PDL_ET_HomeState.WaitUntilFbActive;
		END_IF
		
		(* ------------------------------------------------------------------------------------------------------------------------------------------------------*)
	PDL_ET_HomeState.WaitUntilFbActive: (* Wait HomeFB active *)
		(* ------------------------------------------------------------------------------------------------------------------------------------------------------*)
		THIS^.CallFb();
		IF THIS^.xFbActive THEN
			fbLoggerPoint.AddLogEntry(
				i_etLogLevel := APL.ET_LogLevel.DebugMessage,
				i_etDiag     := q_etDiag,
				i_udiDiagExt := q_etDiagExt,
				i_sMessage   := 'Start homing',
				q_etDiag     =>,
				q_etDiagExt  =>
			);
			etHomeState := PDL_ET_HomeState.WaitUntilHomeOk;
		END_IF
		
		(* ------------------------------------------------------------------------------------------------------------------------------------------------------*)
	PDL_ET_HomeState.WaitUntilHomeOk: (* Wait HomeOk , Check DiagExt-Codes while Execution; If Number 30 changed, see ...TranslateDiag-Methods*)
		(* ------------------------------------------------------------------------------------------------------------------------------------------------------*)
		xStartHomeIn := TRUE;
		THIS^.CallFb();
		IF (THIS^.etDiagBuffer = GD.ET_Diag.Ok) AND THIS^.xFbHomeOk THEN
			q_xHomeOK := TRUE;
			xFbEnable := FALSE;
			SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.HomingDone, i_sMsg := sTempMsg);
			etHomeState := PDL_ET_HomeState.WaitUntilFbDisabled;
		END_IF
		
		(* ------------------------------------------------------------------------------------------------------------------------------------------------------*)
	PDL_ET_HomeState.WaitUntilFbDisabled: (* Wait for FB disabled*)
		(* ------------------------------------------------------------------------------------------------------------------------------------------------------*)
		THIS^.CallFb();
		IF NOT xFbActive THEN
			q_xMotionInstructionActive := FALSE;
			etHomeOpMode               := PDL_ET_HomeOpMode.NoOp;
			fbLoggerPoint.AddLogEntry(
				i_etLogLevel := APL.ET_LogLevel.StatusMessage,
				i_etDiag     := q_etDiag,
				i_udiDiagExt := q_etDiagExt,
				i_sMessage   := 'ready for start',
				q_etDiag     =>,
				q_etDiagExt  =>
			);
			etHomeState := PDL_ET_HomeState.WaitForStart;
		END_IF
		
		(* ------------------------------------------------------------------------------------------------------------------------------------------------------*)
	PDL_ET_HomeState.WaitUntilDisabled: (* Wait for FB disabled*)
		(* ------------------------------------------------------------------------------------------------------------------------------------------------------*)
		THIS^.CallFb();
		IF NOT xFbActive THEN
			q_xActive                  := FALSE;
			q_xDisableDrive            := FALSE;
			q_xMotionInstructionActive := FALSE;
			q_lrPosition               := 0.0;
			q_lrEncoderPosition        := 0.0;
			q_xHomeOK                  := FALSE;
			SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.Disabled, i_sMsg := '');
			etHomeState := PDL_ET_HomeState.ExceptionOrIdle;
		END_IF
		(* ------------------------------------------------------------------------------------------------------------------------------------------------------*)
END_CASE

IF i_xEnable THEN
	(* q_xMotionInstructionActive Set or Reset *)
	IF fbHomeIn.q_xActive THEN
		q_xMotionInstructionActive := fbHomeIn.q_xMotionInstructionActive;
	ELSIF fbHomeTP.q_xActive THEN
		q_xMotionInstructionActive := fbHomeTP.q_xMotionInstructionActive;
	ELSIF fbHomeLS.q_xActive THEN
		q_xMotionInstructionActive := fbHomeLS.q_xMotionInstructionActive;
	ELSIF fbHomeTorque.q_xActive THEN
		q_xMotionInstructionActive := fbHomeTorque.q_xMotionInstructionActive;
	ELSIF fbHomeForce.q_xActive THEN
		q_xMotionInstructionActive := fbHomeForce.q_xMotionInstructionActive;
	ELSIF fbVarioPosJerk.q_xActive THEN
		q_xMotionInstructionActive := fbVarioPosJerk.q_xMotionInstructionActive;
	ELSIF fbHomeAbs.q_xActive THEN
		q_xMotionInstructionActive := fbHomeAbs.q_xActive; // set to q_xActive, because previous version of FB has set output depending on q_xActive
	ELSIF fbSetpos.q_xActive THEN
		q_xMotionInstructionActive := fbSetpos.q_xActive; // set to q_xActive, because previous version of FB has set output depending on q_xActive
	ELSE
		q_xMotionInstructionActive := FALSE;
	END_IF
END_IF

// set outputs
//q_lrPosition
IF fbHomeIn.q_xActive THEN
	q_lrPosition := fbHomeIn.q_lrPosition;
ELSIF fbHomeTP.q_xActive THEN
	q_lrPosition := fbHomeTP.q_lrPosition;
ELSIF fbHomeLS.q_xActive THEN
	q_lrPosition := fbHomeLS.q_lrPosition;
ELSIF fbHomeTorque.q_xActive THEN
	q_lrPosition := fbHomeTorque.q_lrPosition;
ELSIF fbVarioPosJerk.q_xActive OR xDetectSetPosHomeOnPos THEN
	q_lrPosition           := lrPositionOpmMoveOnPos;
	xDetectSetPosHomeOnPos := FALSE;
ELSIF fbHomeAbs.q_xActive THEN
	q_lrPosition := fbHomeAbs.q_lrPosition;
ELSIF fbSetPos.q_xActive THEN
	q_lrPosition := fbSetPos.q_lrPosition;
ELSIF i_ifDrive <> 0 AND i_xEnable THEN
	q_lrPosition := i_ifDrive.lrPosition;
END_IF
// q_lrEncoderPosition
IF fbSetPos.i_xEnable AND fbSetPos.q_xActive THEN
	q_lrEncoderPosition := fbSetPos.q_lrEncoderPosition;
ELSIF THIS^.stSetPos_loc.iq_lencAxis <> 0 THEN
	q_lrEncoderPosition := THIS^.stSetPos_loc.iq_lencAxis.lrPosition;
ELSE
	q_lrEncoderPosition := 0.0;
END_IF
