__METADATA__
{
  "v3Meta": {
    "objectGuid": "36f65405-50f1-4e3f-8e76-9cf64a801f11",
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
METHOD INTERNAL DiagTestMultiCam
VAR_IN_OUT
	iq_etDiag		: GD.ET_Diag;
	iq_etDiagExt	: PDL_ET_DiagExt;
	iq_sMsg			: STRING[80];
END_VAR
__IMPLEMENTATION__
IF (iq_etDiag <> GD.ET_Diag.Ok) THEN
	CASE iq_etDiagExt OF
	PDL_ET_DiagExt.AccRange:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.AccRange;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);

	PDL_ET_DiagExt.BoundaryConditionInvalid:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.BoundaryConditionInvalid;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);

	PDL_ET_DiagExt.DecRange:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.DecRange;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);
		
	PDL_ET_DiagExt.JerkRange:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.JerkRange;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);
		
	PDL_ET_DiagExt.NumberOfCamPointsRange:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.NumberOfCamPointsRange;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);
		
	PDL_ET_DiagExt.RangeK:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.RangeK;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);
		
	PDL_ET_DiagExt.RangeM:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.RangeM;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);
		
	PDL_ET_DiagExt.UnknownCamType:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.UnknownCamType;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);
		
	PDL_ET_DiagExt.UnknownCsModeMaster:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.UnknownCsModeMaster;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);
		
	PDL_ET_DiagExt.UnknownCsModeSlave:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.UnknownCsModeSlave;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);
		
	PDL_ET_DiagExt.UnknownWsMode:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.UnknownWsMode;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);
		
	PDL_ET_DiagExt.VelRange:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.VelRange;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);
		
	PDL_ET_DiagExt.XFactorTooSmall:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.XFactorTooLow;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);
		
	PDL_ET_DiagExt.YEqualCheckFailed:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.YEqualCheckFailed;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);
		
	PDL_ET_DiagExt.DrivePositionOutOfWsWindow:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.WarmStartConditionInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.DrivePositionOutOfWsWindow;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);
		
	PDL_ET_DiagExt.MasterMoved:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.WarmStartConditionInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.MasterMoved;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);
		
	PDL_ET_DiagExt.UserCamHasBeenDeleted:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.WarmStartConditionInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.UserCamHasBeenDeleted;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);
		
	ELSE
		stExceptionUnexpected.udiDiagExt := AXM_ET_DiagExt.UnexpectedFeedback;
		stExceptionUnexpected.sMsg := SE_CTBX.FC_MultiConcat(	i_sString1 := 'FB_MultiCam ',
															i_sString2 := PDL_FC_EtDiagExtToString(i_etDiagExt := iq_etDiagExt),
															i_sString3 := ' ',
															i_sString4 := iq_sMsg);
		ReportException(iq_stException := stExceptionUnexpected);
	END_CASE
END_IF
