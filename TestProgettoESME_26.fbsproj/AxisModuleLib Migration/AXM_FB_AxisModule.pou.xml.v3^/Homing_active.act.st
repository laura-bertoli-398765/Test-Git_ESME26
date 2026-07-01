__METADATA__
{
  "v3Meta": {
    "objectGuid": "efbee110-d1de-4db7-a717-9c786137436a",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
iq_stAxisModuleItf.stMain.q_etOpMode := AXM_ET_OpMode.Homing;
xRefStart := (xStartFlag OR iq_stAxisModuleItf.stMain.i_xStart) AND NOT stModuleReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle];

fbHome.stReducedVelocity := iq_stAxisModuleItf.stMain.stReducedVelocity;
CASE iq_stAxisModuleItf.stHome.i_etMode OF
	PDL_ET_HomeMode.PosDirectionPosEdgeTp,
	PDL_ET_HomeMode.NegDirectionPosEdgeTp,
	PDL_ET_HomeMode.NegDirectionNegEdgeTp,
	PDL_ET_HomeMode.PosDirectionNegEdgeTp:
		fbHome.stTouchProbe := iq_stAxisModuleItf.stHome.stTouchProbe;
	
	PDL_ET_HomeMode.PosDirectionPosEdgeSensor,
	PDL_ET_HomeMode.NegDirectionPosEdgeSensor,
	PDL_ET_HomeMode.NegDirectionNegEdgeSensor,
	PDL_ET_HomeMode.PosDirectionNegEdgeSensor:
		fbHome.stSensor := iq_stAxisModuleItf.stHome.stSensor;

	PDL_ET_HomeMode.PosDirectionPosEdgeHWLimitPos,
	PDL_ET_HomeMode.NegDirectionPosEdgeHWLimitNeg,
	PDL_ET_HomeMode.NegDirectionNegEdgeHWLimitNeg,
	PDL_ET_HomeMode.PosDirectionNegEdgeHWLimitPos:
		fbHome.stLimitSwitch := iq_stAxisModuleItf.stHome.stLimitSwitch;

	PDL_ET_HomeMode.PosDirectionMaxTorque,
	PDL_ET_HomeMode.NegDirectionMaxTorque:
		fbHome.stTorque := iq_stAxisModuleItf.stHome.stTorque;
		
	PDL_ET_HomeMode.PosDirectionMaxForce,
	PDL_ET_HomeMode.NegDirectionMaxForce:
		fbHome.stForce:= iq_stAxisModuleItf.stHome.stForce;	

	PDL_ET_HomeMode.MoveOnPosAbs:
		fbHome.stMoveOnPos := iq_stAxisModuleItf.stHome.stMoveonPos;

	PDL_ET_HomeMode.SetPosAxisPosition,
	PDL_ET_HomeMode.SetPosLogEncoderPosition,
	PDL_ET_HomeMode.SetPosAxisAndLogEncoderPosition,
	PDL_ET_HomeMode.RestorePosFromAxisEncoder,
	PDL_ET_HomeMode.RestorePosFromRetain:
		stFbHomeSetPosProperty.i_lrAbsEncOffset			:= iq_stAxisModuleItf.stHome.stSetPos.i_lrAbsEncOffset;
		stFbHomeSetPosProperty.i_lrEncoderPosition		:= iq_stAxisModuleItf.stHome.stSetPos.i_lrEncoderPosition;
		stFbHomeSetPosProperty.i_lrHomePosition			:= iq_stAxisModuleItf.stHome.stSetPos.i_lrHomePosition;
		stFbHomeSetPosProperty.i_lrRestoreWindow		:= iq_stAxisModuleItf.stHome.stSetPos.i_lrRestoreWindow;
		stFbHomeSetPosProperty.i_lrUserPeriod			:= iq_stAxisModuleItf.stHome.stSetPos.i_lrUserPeriod;
		stFbHomeSetPosProperty.iq_pstRestorePosRetain	:= iq_stAxisModuleItf.stHome.stSetPos.iq_pstRestorePosRetain;
		stFbHomeSetPosProperty.iq_lencAxis				:= iq_stAxisModuleItf.stMain.iq_lencEncoder;
		fbHome.stSetPos := stFbHomeSetPosProperty;
	
	PDL_ET_HomeMode.WriteAxisEncoder:
		fbHome.stWritePos := iq_stAxisModuleItf.stHome.stWritePos;
END_CASE

fbHome(	i_xEnable				:= xRefEnable AND (	   fbDriveEnable.q_xDriveEnabled
													OR fbHome.q_xDisableDrive
													OR xRefAxisEnableOld			(* xRefAxisEnableOld makes shure i_xEnable keeps true during reaktivation of axis after encoter writing *)
													OR iq_stAxisModuleItf.stHome.stSetPos.i_xKeepPowerDisabled), 
		i_etMode				:= iq_stAxisModuleItf.stHome.i_etMode,
		i_ifDrive	 			:= iq_stAxisModuleItf.stMain.i_ifDrive,
		i_xHwLimitNeg			:= iq_stAxisModuleItf.stMain.i_xHwLimitNeg,
		i_xHwLimitPos			:= iq_stAxisModuleItf.stMain.i_xHwLimitPos,
		i_xStart				:= xRefStart,
		q_xActive				=> ,
		q_xReady				=> ,
		q_etDiag				=> etDiagBuffer,
		q_etDiagExt				=> etDiagExtBufferPDL,
		q_sMsg					=> sDiagMsgBuffer,
		q_xDisableDrive			=> ,
		q_xMotionInstructionActive	=> ,
		q_lrPosition			=> ,
		q_lrEncoderPosition		=> ,
		q_xHomeOk				=> );

DiagTestHoming(	iq_etDiag		:= fbHome.q_etDiag,
				iq_etDiagExt	:= fbHome.q_etDiagExt,
				iq_sMsg			:= fbHome.q_sMsg);
				
IF fbHome.i_xEnable THEN
	xRefAxisEnableOld := TRUE;
END_IF
				
IF fbHome.q_xHomeOk AND NOT xResetHomeOkActive THEN
	iq_stAxisModuleItf.stMain.q_xHomeOk := TRUE;
END_IF

IF fbHome.q_xReady AND NOT fbHome.i_xStart AND NOT fbHome.q_xHomeOk THEN
	iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.HomingWaitForStart;
ELSIF fbHome.q_xReady AND fbHome.i_xStart AND NOT fbHome.q_xHomeOk THEN
	iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.HomingExecuting;
ELSIF fbHome.q_xReady AND fbHome.q_xHomeOk AND NOT fbHome.q_xMotionInstructionActive THEN
	iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.HomingDone;
	xStartFlag := FALSE;
ELSE
	IF xRefEnable THEN
		iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.HomingInit;
	ELSE
		iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.HomingExit;
	END_IF
END_IF

IF NOT xRefEnable AND NOT fbHome.q_xActive THEN 
	xRefActive := FALSE;
	xResetHomeOkActive := FALSE;
END_IF

IF xRefStart AND NOT xRefStartOld 
		AND iq_stAxisModuleItf.stMain.i_ifDrive.etAxisState >= MOIN.ET_AxisState.Standstill
 		AND	iq_stAxisModuleItf.stMain.i_ifDrive.etAxisState <= MOIN.ET_AxisState.Stopping
		AND (  iq_stAxisModuleItf.stHome.i_etMode = PDL_ET_HomeMode.RestorePosFromAxisEncoder 
			OR iq_stAxisModuleItf.stHome.i_etMode = PDL_ET_HomeMode.RestorePosFromRetain
			OR iq_stAxisModuleItf.stHome.i_etMode = PDL_ET_HomeMode.SetPosAxisAndLogEncoderPosition
			OR iq_stAxisModuleItf.stHome.i_etMode = PDL_ET_HomeMode.SetPosAxisPosition
			OR iq_stAxisModuleItf.stHome.i_etMode = PDL_ET_HomeMode.SetPosLogEncoderPosition )THEN

	ReadTrackingDeviation(	q_sLrealConversion => sLrealConversion);

	fbLoggerPoint.AddLogEntry (
			i_etLogLevel 	:= APL.ET_LogLevel.StatusMessage,
			i_etDiag		:= GD.ET_Diag.Ok,
			i_udiDiagExt	:= 0,
			i_sMessage		:= Standard.CONCAT('SetPos-Homing:  Axis-State >= Standstill; TrackingDeviation: ',sLrealConversion)
		);
END_IF
xRefStartOld := xRefStart;
