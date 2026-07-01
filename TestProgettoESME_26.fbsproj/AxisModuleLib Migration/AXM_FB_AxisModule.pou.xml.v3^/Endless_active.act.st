__METADATA__
{
  "v3Meta": {
    "objectGuid": "3c0b60bf-17fe-403b-b7bd-421c8472aa89",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
iq_stAxisModuleItf.stMain.q_etOpMode := AXM_ET_OpMode.Endless;

IF (iq_stAxisModuleItf.stMain.stReducedVelocity.i_xEnableReducedVelocity AND 
	NOT iq_stAxisModuleItf.stMain.stReducedVelocity.i_xOnlyLimitCheck) THEN
	
	lrEndlessVel := MIN(iq_stAxisModuleItf.stEndless.i_lrVel, iq_stAxisModuleItf.stMain.stReducedVelocity.i_lrMaxReducedVelocity);
ELSE
	lrEndlessVel := iq_stAxisModuleItf.stEndless.i_lrVel;
END_IF

xEndlessStart := (xStartFlag OR iq_stAxisModuleItf.stMain.i_xStart) AND NOT stModuleReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle];

fbEndless(	i_xEnable			:= xEndlessEnable AND fbDriveEnable.q_xDriveEnabled,
			i_ifDrive			:= iq_stAxisModuleItf.stMain.i_ifDrive,
			i_lrVel				:= lrEndlessVel,
			i_lrAcc				:= iq_stAxisModuleItf.stEndless.i_lrAcc,
			i_lrDec				:= iq_stAxisModuleItf.stEndless.i_lrDec,
			i_lrJerk			:= iq_stAxisModuleItf.stEndless.i_lrJerk,
			i_lrPeriod			:= iq_stAxisModuleItf.stEndless.i_lrPeriod,
			i_lrStopPosition	:= iq_stAxisModuleItf.stEndless.i_lrStopPosition,
			i_xStart			:= xEndlessStart,
			q_etDiag			=> etDiagBuffer,
			q_etDiagExt			=> etDiagExtBufferPDL,
			q_sMsg				=> sDiagMsgBuffer,
			q_xInVelocity		=> iq_stAxisModuleItf.stEndless.q_xInVelocity);

DiagTestEndless(iq_etDiag		:= fbEndless.q_etDiag,
				iq_etDiagExt	:= fbEndless.q_etDiagExt,
				iq_sMsg			:= fbEndless.q_sMsg);

IF fbEndless.q_xReady AND fbEndless.q_etDiagExt = PDL_ET_DiagExt.WaitForStart THEN
	 iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.EndlessWaitForStart;
ELSIF fbEndless.q_xReady THEN
	iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.EndlessRunning;
ELSE
	IF xEndlessEnable THEN
		iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.EndlessInit;
	ELSE
		iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.EndlessExit;
	END_IF
END_IF

IF NOT xEndlessEnable AND NOT fbEndless.q_xActive THEN
	xEndlessActive := FALSE;
END_IF
