__METADATA__
{
  "v3Meta": {
    "objectGuid": "95a41eea-732b-4df9-b4b6-dec268632541",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
iq_stAxisModuleItf.stMain.q_etOpMode := AXM_ET_OpMode.Additional;

xAdditionalStart := (xStartFlag OR iq_stAxisModuleItf.stMain.i_xStart) AND NOT stModuleReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle];

iq_stAxisModuleItf.stAdditional.q_xEnable := xAdditionalEnable AND fbDriveEnable.q_xDriveEnabled;
iq_stAxisModuleItf.stAdditional.q_xStart := xAdditionalStart;
iq_stAxisModuleItf.stAdditional.q_xWsSelect := xWsSelect;
iq_stAxisModuleItf.stAdditional.q_xWsStart := xWsStartFlag;

IF iq_stAxisModuleItf.stAdditional.i_etDiag <> GD.ET_Diag.Ok THEN
	stExceptionModuleReaction2.etDiag := GD.ET_Diag.DiagActive;
	stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.AdditionalModeException;
	stExceptionModuleReaction2.sMsg := SE_CTBX.FC_MultiConcat(	i_sString1 := GD.FC_EtDiagToString(i_etDiag := iq_stAxisModuleItf.stAdditional.i_etDiag),
															i_sString2 := ' ',
															i_sString3 := iq_stAxisModuleItf.stAdditional.i_sDiagExt,
															i_sString4 := SE_CTBX.FC_MultiConcat(	i_sString1 := '(',
																								i_sString2 := UDINT_TO_STRING(iq_stAxisModuleItf.stAdditional.i_udiDiagExt),
																								i_sString3 := ') ',
																								i_sString4 := iq_stAxisModuleItf.stAdditional.i_sMsg));
	ReportException(iq_stException := stExceptionModuleReaction2);
END_IF

xAdditionalActive := iq_stAxisModuleItf.stAdditional.i_xActive;

IF iq_stAxisModuleItf.stAdditional.i_xReady AND NOT iq_stAxisModuleItf.stAdditional.q_xStart THEN
	iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.AdditionalWaitForStart;
ELSIF iq_stAxisModuleItf.stAdditional.i_xReady AND iq_stAxisModuleItf.stAdditional.q_xStart THEN
	iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.AdditionalRunning;
ELSE
	IF xAdditionalEnable THEN
		iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.AdditionalInit;
	ELSE
		iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.AdditionalExit;
	END_IF
END_IF
