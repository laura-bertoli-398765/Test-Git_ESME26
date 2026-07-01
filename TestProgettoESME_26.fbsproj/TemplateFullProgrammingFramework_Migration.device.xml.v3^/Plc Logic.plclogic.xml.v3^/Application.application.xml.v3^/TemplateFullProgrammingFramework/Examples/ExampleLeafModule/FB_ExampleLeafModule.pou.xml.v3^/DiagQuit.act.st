__METADATA__
{
  "v3Meta": {
    "objectGuid": "e6351903-8191-48dc-a617-7141648ccee4",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
IF(iq_stStandardModuleItf.i_xDiagQuit AND NOT xDiagQuitFlag) THEN
	(* Rising edge of error quit *)
	xDiagQuitFlag := TRUE;
	xNotAbleToSetException := FALSE;

	FOR udii := 1 TO TPL.ET_Reaction.MainsContactorOff DO
		stLocalReaction.axReaction[udii] := FALSE;
	END_FOR

	iq_stStandardModuleItf.q_etDiag := GD.ET_Diag.Ok;

	IF(iq_stStandardModuleItf.iq_diCMD < 0) THEN
		iq_stStandardModuleItf.iq_diCMD := 0;
	END_IF
	IF fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.UserAction THEN
		fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
									i_etDiag		:= GD.ET_Diag.Ok,
									i_udiDiagExt	:= ET_DiagExtExampleLeafModule.Ok,
									i_sMessage		:= 'Diag Quit',
									q_etDiag		:= ,
									q_etDiagExt		:= );
	END_IF
ELSIF(NOT iq_stStandardModuleItf.i_xDiagQuit AND xDiagQuitFlag) THEN
	xDiagQuitFlag := FALSE;
END_IF
