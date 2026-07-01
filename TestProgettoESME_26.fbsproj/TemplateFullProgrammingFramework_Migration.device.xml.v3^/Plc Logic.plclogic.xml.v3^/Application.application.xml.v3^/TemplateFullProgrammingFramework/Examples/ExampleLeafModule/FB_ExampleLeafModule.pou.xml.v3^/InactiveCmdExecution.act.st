__METADATA__
{
  "v3Meta": {
    "objectGuid": "d2a78170-20a4-4788-9bad-203e4f39fa80",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* Command execution if module is not active (q_xActive = FALSE) or currently deactivating (i_xEnable = FALSE, q_xActive is still TRUE) *)
IF iq_stStandardModuleItf.iq_diCmd <> 0 THEN
	IF(NOT iq_stStandardModuleItf.i_xEnable) THEN
		iq_stStandardModuleItf.iq_diCmd := 0; (* All commands are signaled executed if module is disabled *)
(*ELSE*)
	ELSIF(iq_stStandardModuleItf.iq_diCmd > 0) THEN (* New command *)
		(* Command execution during enable but module is not ready for commands yet ==> error *)
		//xExceptionCmdImpossibleState := TRUE;

		stExceptionCmdImpossibleState.sMsg := SE_CTBX.FC_MultiConcat(	i_sString1 := 'Cmd impossible: ',
																	i_sString2 := FC_EtExampleLeafModuleCmdToString(i_diCmd := ABS(iq_stStandardModuleItf.iq_diCmd)),
																	i_sString3 := '; State: ',
																	i_sString4 := FC_EtExampleLeafModuleStateToString(i_etState := iq_stExampleLeafModuleItf.q_etState));
		ReportException(iq_stException := stExceptionCmdImpossibleState);
		iq_stStandardModuleItf.iq_diCmd:= - ABS(iq_stStandardModuleItf.iq_diCmd);
	END_IF
END_IF
iq_stStandardModuleItf.q_xCmdActive := FALSE;
iq_stStandardModuleItf.q_xCmdDone := FALSE;
iq_stStandardModuleItf.q_diCmdActive := 0;
