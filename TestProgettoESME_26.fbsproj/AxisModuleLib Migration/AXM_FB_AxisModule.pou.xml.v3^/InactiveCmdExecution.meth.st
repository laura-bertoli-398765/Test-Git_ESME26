__METADATA__
{
  "v3Meta": {
    "objectGuid": "94016789-cc0a-4705-b2e4-8efd7706cb84",
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
METHOD INTERNAL InactiveCmdExecution
VAR_INPUT
END_VAR
__IMPLEMENTATION__
(* Command execution if module is not active (q_xActive = FALSE) or currently deactivating (i_xEnable = FALSE, q_xActive is still TRUE) *)
IF iq_stStandardModuleItf.iq_diCmd <> 0 THEN
	IF(NOT iq_stStandardModuleItf.i_xEnable) THEN
		iq_stStandardModuleItf.iq_diCmd := 0; (* All commands are signaled executed if module is disabled *)
(*ELSE*)
	ELSIF(iq_stStandardModuleItf.iq_diCmd > 0) THEN (* New command *)
		(* Command execution during enable but module is not ready for commands yet ==> error *)
		//xExceptionCmdImpossibleState := TRUE;
		stExceptionCmdImpossibleState.udiDiagExt := AXM_ET_DiagExt.CmdImpossibleState;
		stExceptionCmdImpossibleState.sDiagExt := AXM_FC_EtDiagExtToString(i_etDiagExt := AXM_ET_DiagExt.CmdImpossibleState);
		stExceptionCmdImpossibleState.sMsg := SE_CTBX.FC_MultiConcat(	i_sString1 := 'Cmd impossible: ',
																	i_sString2 := AXM_FC_EtCmdToString(i_etCmd := ABS(iq_stStandardModuleItf.iq_diCMD)),
																	i_sString3 := '; State: ',
																	i_sString4 := AXM_FC_EtStateToString(i_etState := iq_stAxisModuleItf.stMain.q_etState));
		ReportException(iq_stException := stExceptionCmdImpossibleState);
		iq_stStandardModuleItf.iq_diCmd:= - ABS(iq_stStandardModuleItf.iq_diCmd);
	END_IF
END_IF
iq_stStandardModuleItf.q_xCmdActive := FALSE;
iq_stStandardModuleItf.q_xCmdDone := FALSE;
iq_stStandardModuleItf.q_diCmdActive := 0;
