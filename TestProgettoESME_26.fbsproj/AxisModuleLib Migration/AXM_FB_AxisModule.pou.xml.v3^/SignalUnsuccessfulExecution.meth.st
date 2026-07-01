__METADATA__
{
  "v3Meta": {
    "objectGuid": "b8bbfd5a-079e-480e-949c-06e91d72ca9c",
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
METHOD INTERNAL SignalUnsuccessfulExecution 
VAR_INPUT
END_VAR
__IMPLEMENTATION__
IF fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.StatusMessage THEN
	fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.StatusMessage,
								i_etDiag		:= GD.ET_Diag.Ok,
								i_udiDiagExt	:= AXM_ET_DiagExt.Ok,
								i_sMessage		:= Standard.CONCAT(Standard.CONCAT(Standard.CONCAT('Command failed: ', AXM_FC_EtCmdToString(i_etCmd := iq_stStandardModuleItf.iq_diCmd)),' number: '),DINT_TO_STRING(iq_stStandardModuleItf.iq_diCmd)),
								q_etDiag		:= ,
								q_etDiagExt		:= );
END_IF

iq_stStandardModuleItf.q_xCmdActive := FALSE;
iq_stStandardModuleItf.q_xCmdDone := FALSE;
IF(iq_stStandardModuleItf.iq_diCmd = iq_stStandardModuleItf.q_diCmdActive) THEN
	iq_stStandardModuleItf.iq_diCmd := -iq_stStandardModuleItf.iq_diCmd;
(* ELSE don't touch iq_diCMD *)
END_IF
