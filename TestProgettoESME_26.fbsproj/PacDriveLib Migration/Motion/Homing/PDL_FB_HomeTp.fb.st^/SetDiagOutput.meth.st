__METADATA__
{
  "v3Meta": {
    "objectGuid": "a9689d4d-82ec-4fae-8235-2944391a5b4c",
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
METHOD PRIVATE SetDiagOutput
VAR_INPUT
	i_etDiag	: GD.ET_Diag;
	i_etDiagExt	: PDL_ET_DiagExt;
	i_sMsg		: STRING[80];
END_VAR
VAR
END_VAR
__IMPLEMENTATION__
// check whether the new state can overwrite the current state
IF q_etDiag = GD.ET_Diag.OK OR i_etDiagExt = PDL_ET_DiagExt.Disabled THEN
	// set outputs
	q_etDiag 	:= i_etDiag;
	q_etDiagExt := i_etDiagExt;
	q_sMsg 		:= i_sMsg;
	IF (i_etDiag <> GD.ET_Diag.Ok) THEN
		q_xReady := FALSE;
	END_IF

	// set application logger entry
	IF(i_etDiag = GD.ET_Diag.Ok) AND (THIS^.fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.StatusMessage) THEN
		THIS^.fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.StatusMessage,
											i_etDiag		:= q_etDiag,
											i_udiDiagExt	:= q_etDiagExt,
											i_sMessage		:= SE_CTBX.FC_MultiConcat(	i_sString1	:= Standard.CONCAT('ET_Diag: ', GD.FC_EtDiagToString(q_etDiag)),
																						i_sString2	:= Standard.CONCAT(' PDL_ET_DiagExt: ', PDL_FC_EtDiagExtToString(q_etDiagExt)),
																						i_sString3	:= Standard.CONCAT(' sMsg: ', q_sMsg),
																						i_sString4	:= ''),
											q_etDiag		:= ,	// ignore result
											q_etDiagExt		:= );	// ignore result
	ELSIF(i_etDiag = GD.ET_Diag.UnexpectedProgramBehavior) AND (THIS^.fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.CriticalException) THEN
		THIS^.fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.CriticalException,
											i_etDiag		:= q_etDiag,
											i_udiDiagExt	:= q_etDiagExt,
											i_sMessage		:= SE_CTBX.FC_MultiConcat(	i_sString1	:= Standard.CONCAT('ET_Diag: ', GD.FC_EtDiagToString(q_etDiag)),
																						i_sString2	:= Standard.CONCAT(' PDL_ET_DiagExt: ', PDL_FC_EtDiagExtToString(q_etDiagExt)),
																						i_sString3	:= Standard.CONCAT(' sMsg: ', q_sMsg),
																						i_sString4	:= ''),
											q_etDiag		:= ,	// ignore result
											q_etDiagExt		:= );	// ignore result
	ELSE
		THIS^.fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.Exception,
											i_etDiag		:= q_etDiag,
											i_udiDiagExt	:= q_etDiagExt,
											i_sMessage		:= SE_CTBX.FC_MultiConcat(	i_sString1	:= Standard.CONCAT('ET_Diag: ', GD.FC_EtDiagToString(q_etDiag)),
																						i_sString2	:= Standard.CONCAT(' PDL_ET_DiagExt: ', PDL_FC_EtDiagExtToString(q_etDiagExt)),
																						i_sString3	:= Standard.CONCAT(' sMsg: ', q_sMsg),
																						i_sString4	:= ''),
											q_etDiag		:= ,	// ignore result
											q_etDiagExt		:= );	// ignore result
	END_IF
END_IF
