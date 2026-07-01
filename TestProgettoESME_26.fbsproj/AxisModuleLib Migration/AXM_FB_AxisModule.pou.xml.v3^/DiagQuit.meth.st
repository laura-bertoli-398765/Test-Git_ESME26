__METADATA__
{
  "v3Meta": {
    "objectGuid": "1ff5c771-87ce-4be6-9765-d80d628ca07e",
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
METHOD INTERNAL DiagQuit
VAR_INPUT
END_VAR
__IMPLEMENTATION__
IF(iq_stStandardModuleItf.i_xDiagQuit AND NOT xDiagQuitFlag) THEN
	(* Rising edge of error quit *)
	xDiagQuitFlag := TRUE;
	xNotAbleToSetException := FALSE;
	iq_stStandardModuleItf.q_xException := FALSE;

	FOR udii := 1 TO TPL.ET_Reaction.MainsContactorOff DO
		stLocalReaction.axReaction[udii] := FALSE;
	END_FOR

	IF(iq_stStandardModuleItf.iq_diCMD < 0) THEN
		iq_stStandardModuleItf.iq_diCMD := 0;
	END_IF
	IF fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.UserAction THEN
		fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
									i_etDiag		:= GD.ET_Diag.Ok,
									i_udiDiagExt	:= AXM_ET_DiagExt.Ok,
									i_sMessage		:= 'Diag Quit',
									q_etDiag		:= ,
									q_etDiagExt		:= );
	END_IF
ELSIF(NOT iq_stStandardModuleItf.i_xDiagQuit AND xDiagQuitFlag) THEN
	xDiagQuitFlag := FALSE;
END_IF
