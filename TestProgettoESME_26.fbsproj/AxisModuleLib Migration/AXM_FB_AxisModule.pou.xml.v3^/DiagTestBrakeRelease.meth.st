__METADATA__
{
  "v3Meta": {
    "objectGuid": "f1490a96-d668-4bd5-a5ff-9ee83f87459e",
    "objectTypeGuid": "f8a58466-d7f6-439f-bbb8-d4600e41d099",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__DECLARATION__
{attribute 'conditionalshow_all_locals'}
METHOD INTERNAL DiagTestBrakeRelease
VAR_IN_OUT
	iq_etDiag		: GD.ET_Diag;
	iq_etDiagExt	: PDL_ET_DiagExt;
	iq_sMsg			: STRING[80];
END_VAR
__IMPLEMENTATION__
IF (iq_etDiag <> GD.ET_Diag.Ok) THEN
	CASE iq_etDiagExt OF

	PDL_ET_DiagExt.DriveInvalid: (* if Drive has no brake *)
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.DriveInvalid;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);
		
	PDL_ET_DiagExt.DriveNotReady:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.DriveConditionInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.DriveNotReady;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);
		
	ELSE
		stExceptionUnexpected.udiDiagExt := AXM_ET_DiagExt.UnexpectedFeedback;
		stExceptionUnexpected.sMsg := SE_CTBX.FC_MultiConcat(	i_sString1 := 'FB_BrakeRelease ',
															i_sString2 := PDL_FC_EtDiagExtToString(i_etDiagExt := iq_etDiagExt),
															i_sString3 := ' ',
															i_sString4 := iq_sMsg);
		ReportException(iq_stException := stExceptionUnexpected);
	END_CASE
END_IF
