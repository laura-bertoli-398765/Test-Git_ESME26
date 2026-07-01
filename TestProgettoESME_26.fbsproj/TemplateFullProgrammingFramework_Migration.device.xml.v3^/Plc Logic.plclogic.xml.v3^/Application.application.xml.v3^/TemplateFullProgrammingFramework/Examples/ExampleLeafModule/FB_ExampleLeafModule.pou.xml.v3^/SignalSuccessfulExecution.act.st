__METADATA__
{
  "v3Meta": {
    "objectGuid": "1819f248-a243-4b83-91e7-b94758afaf5c",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
IF fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.StatusMessage THEN
	fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.StatusMessage,
								i_etDiag		:= GD.ET_Diag.Ok,
								i_udiDiagExt	:= ET_DiagExtExampleLeafModule.Ok,
								i_sMessage		:= Standard.CONCAT(Standard.CONCAT(Standard.CONCAT('Command done: ', FC_etExampleLeafModuleCmdToString(i_diCmd := iq_stStandardModuleItf.iq_diCmd)),' number: '),DINT_TO_STRING(iq_stStandardModuleItf.iq_diCmd)),
								q_etDiag		:= ,
								q_etDiagExt		:= );
END_IF

iq_stStandardModuleItf.q_xCMDActive := FALSE;
iq_stStandardModuleItf.q_xCMDDone := TRUE;
IF(iq_stStandardModuleItf.iq_diCMD = iq_stStandardModuleItf.q_diCMDActive) THEN
	iq_stStandardModuleItf.iq_diCMD := 0;
(* ELSE don't touch iq_diCMD *)
END_IF
