__METADATA__
{
  "v3Meta": {
    "objectGuid": "e5dd1cdc-5ee5-46d9-a02c-cd1dfda45dfe",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
iq_stAxisModuleItf.stMain.q_etOpMode := AXM_ET_OpMode.Manual;

xManJogForw :=
	(iq_stAxisModuleItf.stManual.i_xJogForw AND
		NOT iq_stAxisModuleItf.stMain.i_xHwLimitPos AND
		NOT stModuleReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle]);
xManJogBack :=
	(iq_stAxisModuleItf.stManual.i_xJogBack AND
		NOT iq_stAxisModuleItf.stMain.i_xHwLimitNeg AND
		NOT stModuleReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle]);
		
IF (iq_stAxisModuleItf.stMain.stReducedVelocity.i_xEnableReducedVelocity AND NOT iq_stAxisModuleItf.stMain.stReducedVelocity.i_xOnlyLimitCheck) THEN
	
	lrManVel := MIN(iq_stAxisModuleItf.stManual.i_lrVel, iq_stAxisModuleItf.stMain.stReducedVelocity.i_lrMaxReducedVelocity);
ELSE
	lrManVel := iq_stAxisModuleItf.stManual.i_lrVel;
END_IF

fbJogging(
	i_xEnable                  := xManEnable AND fbDriveEnable.q_xDriveEnabled,
	i_ifDrive                  := iq_stAxisModuleItf.stMain.i_ifDrive,
	i_xJogForw                 := xManJogForw,
	i_xJogBack                 := xManJogBack,
	i_lrPeriod                 := iq_stAxisModuleItf.stManual.i_lrPeriod,
	i_xEndless                 := iq_stAxisModuleItf.stManual.i_xEndless,
	i_lrMaxDistance            := iq_stAxisModuleItf.stManual.i_lrMaxDistance,
	i_lrVel                    := lrManVel,
	i_lrAcc                    := iq_stAxisModuleItf.stManual.i_lrAcc,
	i_lrDec                    := iq_stAxisModuleItf.stManual.i_lrDec,
	i_lrJerk                   := iq_stAxisModuleItf.stManual.i_lrJerk,
	q_xActive                  =>,
	q_xReady                   =>,
	q_etDiag                   => etDiagBuffer,
	q_etDiagExt                => etDiagExtBufferPDL,
	q_sMsg                     => sDiagMsgBuffer,
	q_xMotionInstructionActive =>,
	q_lrPosition               =>,
	q_xStepFinished            =>
);

DiagTestJogging(iq_etDiag := fbJogging.q_etDiag, iq_etDiagExt := fbJogging.q_etDiagExt, iq_sMsg := fbJogging.q_sMsg);

IF fbJogging.q_xReady THEN
	iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.ManualRunning;
ELSE
	IF xManEnable THEN
		iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.ManualInit;
	ELSE
		iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.ManualExit;
	END_IF
END_IF

IF NOT xManEnable AND NOT fbJogging.q_xActive THEN
	xManActive := FALSE;
END_IF
