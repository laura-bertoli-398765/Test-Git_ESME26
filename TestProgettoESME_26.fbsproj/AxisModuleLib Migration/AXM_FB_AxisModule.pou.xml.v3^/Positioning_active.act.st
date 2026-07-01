__METADATA__
{
  "v3Meta": {
    "objectGuid": "2ecf66ce-f923-48fb-8d77-3fe74e91c2a1",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
iq_stAxisModuleItf.stMain.q_etOpMode := AXM_ET_OpMode.Positioning;

IF (iq_stAxisModuleItf.stMain.stReducedVelocity.i_xEnableReducedVelocity AND 
	NOT iq_stAxisModuleItf.stMain.stReducedVelocity.i_xOnlyLimitCheck) THEN
	
	lrPosVel := MIN(iq_stAxisModuleItf.stPos.i_lrVel, iq_stAxisModuleItf.stMain.stReducedVelocity.i_lrMaxReducedVelocity);
ELSE
	lrPosVel := iq_stAxisModuleItf.stPos.i_lrVel;
END_IF

lrPosVel := iq_stAxisModuleItf.stPos.i_lrVel;

IF iq_stAxisModuleItf.stPos.i_xStop THEN
	xStartFlag := FALSE;
END_IF
xPosStart := (xStartFlag OR iq_stAxisModuleItf.stMain.i_xStart) AND NOT stModuleReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle];

fbVarioPos(
	i_xEnable                  := xPosEnable AND fbDriveEnable.q_xDriveEnabled,
	i_ifDrive                  := iq_stAxisModuleItf.stMain.i_ifDrive,
	i_xStart                   := xPosStart,
	i_xStop                    := iq_stAxisModuleItf.stPos.i_xStop,
	i_lrTarget                 := iq_stAxisModuleItf.stPos.i_lrTarget,
	i_lrVel                    := lrPosVel,
	i_lrAcc                    := iq_stAxisModuleItf.stPos.i_lrAcc,
	i_lrDec                    := iq_stAxisModuleItf.stPos.i_lrDec,
	i_lrJerk                   := iq_stAxisModuleItf.stPos.i_lrJerk,
	i_etPosMode                := iq_stAxisModuleItf.stPos.i_etPosMode,
	q_xActive                  => xPosActive,
	q_xReady                   =>,
	q_etDiag                   => etDiagBuffer,
	q_etDiagExt                => etDiagExtBufferPDL,
	q_sMsg                     => sDiagMsgBuffer,
	q_xMotionInstructionActive =>,
	q_lrPosition               =>,
	q_xInPosition              => iq_stAxisModuleItf.stPos.q_xInPosition);

DiagTestPositioning(
	iq_etDiag    := fbVarioPos.q_etDiag,
	iq_etDiagExt := fbVarioPos.q_etDiagExt,
	iq_sMsg      := fbVarioPos.q_sMsg);

IF fbVarioPos.q_xReady AND NOT fbVarioPos.q_xMotionInstructionActive THEN
	iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.PositioningWaitForStart;
ELSIF fbVarioPos.q_xReady AND fbVarioPos.q_xMotionInstructionActive THEN
	iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.PositioningRunning;
ELSE
	IF xPosEnable THEN
		iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.PositioningInit;
	ELSE
		iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.PositioningExit;
	END_IF
END_IF

(* make shure next start command is effective *)
IF fbVarioPos.q_xMotionInstructionActive AND xMotionActiveOld THEN
	xStartFlag := FALSE;
END_IF
xMotionActiveOld := fbVarioPos.q_xMotionInstructionActive;

IF NOT xPosEnable AND NOT fbVarioPos.q_xActive THEN
	xPosActive := FALSE;
END_IF
