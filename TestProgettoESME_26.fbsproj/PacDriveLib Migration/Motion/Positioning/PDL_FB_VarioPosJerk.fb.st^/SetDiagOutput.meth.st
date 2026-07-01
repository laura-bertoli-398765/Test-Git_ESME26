__METADATA__
{
  "v3Meta": {
    "objectGuid": "71058f1d-4437-42f0-b23f-8537050a78bb",
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
METHOD PRIVATE SetDiagOutput : BOOL
VAR_INPUT
	i_etDiag	: GD.ET_Diag;
	i_etDiagExt	: PDL_ET_DiagExt;
	i_sMsg		: STRING[80];
END_VAR
VAR
END_VAR
__IMPLEMENTATION__
IF i_etDiag <> GD.ET_Diag.Ok THEN
	q_xReady := FALSE;
END_IF
IF q_etDiag = GD.ET_Diag.OK OR i_etDiagExt = PDL_ET_DiagExt.Disabled THEN
	q_etDiag := i_etDiag;
	q_etDiagExt := i_etDiagExt;
	q_sMsg := i_sMsg;

	IF(i_etDiag = GD.ET_Diag.Ok) AND (fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.StatusMessage) THEN
		fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.StatusMessage,
									i_etDiag		:= q_etDiag,
									i_udiDiagExt	:= q_etDiagExt,
									i_sMessage		:= SE_CTBX.FC_MultiConcat(	i_sString1	:= Standard.CONCAT('ET_Diag: ', GD.FC_EtDiagToString(q_etDiag)),
																				i_sString2	:= Standard.CONCAT(' ET_DiagExt: ', PDL_FC_EtDiagExtToString(q_etDiagExt)),
																				i_sString3	:= Standard.CONCAT(' sMsg: ', q_sMsg),
																				i_sString4	:= '')
											);
	ELSIF(i_etDiag = GD.ET_Diag.UnexpectedProgramBehavior) AND (fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.CriticalException) THEN
		fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.CriticalException,
									i_etDiag		:= q_etDiag,
									i_udiDiagExt	:= q_etDiagExt,
									i_sMessage		:= SE_CTBX.FC_MultiConcat(	i_sString1	:= Standard.CONCAT('ET_Diag: ', GD.FC_EtDiagToString(q_etDiag)),
																				i_sString2	:= Standard.CONCAT(' ET_DiagExt: ', PDL_FC_EtDiagExtToString(q_etDiagExt)),
																				i_sString3	:= Standard.CONCAT(' sMsg: ', q_sMsg),
																				i_sString4	:= '')
											);
	ELSIF(i_etDiag <> GD.ET_Diag.Ok) AND (fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.Exception) THEN
		fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.Exception,
									i_etDiag		:= q_etDiag,
									i_udiDiagExt	:= q_etDiagExt,
									i_sMessage		:= SE_CTBX.FC_MultiConcat(	i_sString1	:= Standard.CONCAT('ET_Diag: ', GD.FC_EtDiagToString(q_etDiag)),
																				i_sString2	:= Standard.CONCAT(' ET_DiagExt: ', PDL_FC_EtDiagExtToString(q_etDiagExt)),
																				i_sString3	:= Standard.CONCAT(' sMsg: ', q_sMsg),
																				i_sString4	:= '')
									);
	END_IF
END_IF
