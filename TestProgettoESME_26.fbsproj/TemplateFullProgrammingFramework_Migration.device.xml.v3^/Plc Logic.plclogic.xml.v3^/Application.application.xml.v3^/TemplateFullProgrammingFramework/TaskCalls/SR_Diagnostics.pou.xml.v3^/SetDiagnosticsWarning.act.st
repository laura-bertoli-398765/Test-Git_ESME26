__METADATA__
{
  "v3Meta": {
    "objectGuid": "337dd1fe-5ef4-447a-933f-d44ece995104",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* System generated code, do not change without consulting 'Schneider Electric Automation GmbH' - otherwise you risk instability!!!*)
						
(* Signal exception during diagnostics, but as diagnostics should not influence the machine, create only a warning *)
IF(fbDiagnosticsManager.q_etDiag <> GD.ET_Diag.Ok AND fbDiagnosticsManager.q_etDiagExt <> etLastDiagExt) THEN
	
	stWarning.etDiag		:= GD.ET_Diag.DiagActive;
	stWarning.udiDiagExt	:= ET_DiagExt.DiagnosticsWarning;
	stWarning.sDiagExt		:= FC_EtDiagExtToString(ET_DiagExt.DiagnosticsWarning);
	stWarning.udiModuleId	:= SR_MainMachine.c_udiMainModuleId;
	stWarning.sMsg			:= CONCAT(CONCAT('SR_Diagnostics: ', GD.FC_EtDiagToString(fbDiagnosticsManager.q_etDiag)), CONCAT(' ; ', TPL.FC_EtDiagExtToString(fbDiagnosticsManager.q_etDiagExt)));
	stWarning.sModuleName	:= SR_MainMachine.stMachineInterface.i_sModuleName;
	stWarning.etSource		:= TPL.ET_ExceptionSource.Logger;
	
	TPL.FC_SetException(i_xExceptionActive	:= TRUE,
						iq_stException		:= stWarning,
						iq_stExceptionList	:= G_stExceptionList,
						iq_stLogDataList	:= G_stLogDataList);
END_IF

etLastDiagExt := fbDiagnosticsManager.q_etDiagExt;
(* End of system generated code, do not change without consulting 'Schneider Electric Automation GmbH' - otherwise you risk instability!!!*)
