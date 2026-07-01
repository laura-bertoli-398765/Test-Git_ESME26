__METADATA__
{
  "v3Meta": {
    "objectGuid": "b1135fad-b84a-4b18-9757-9ad81b424dc4",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
IF vpiq_xTestUserException1 THEN
	TPL.FC_SetException(i_xExceptionActive := vpiq_xTestUserException1,
						iq_stException := stUserException1,
						iq_stExceptionList := G_stExceptionList,
						iq_stLogDataList := G_stLogDataList);
	IF vpiq_xTestUserException1 AND NOT xTestUserException1Old AND (fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.Exception) THEN
		fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.Exception,
									i_etDiag		:= stUserException1.etDiag,
									i_udiDiagExt	:= stUserException1.udiDiagExt,
									i_sMessage		:= stUserException1.sMsg,
									q_etDiag		=> ,
									q_etDiagExt		=> );
	END_IF
	xTestUserException1Old := vpiq_xTestUserException1; 
END_IF	
TPL.FC_SetException(i_xExceptionActive := vpiq_xTestUserException2,
					iq_stException := stUserException2,
					iq_stExceptionList := G_stExceptionList,
					iq_stLogDataList := G_stLogDataList);
IF vpiq_xTestUserException2 AND NOT xTestUserException2Old AND (fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.Exception) THEN
	fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.Exception,
								i_etDiag		:= stUserException2.etDiag,
								i_udiDiagExt	:= stUserException2.udiDiagExt,
								i_sMessage		:= stUserException2.sMsg,
								q_etDiag		=> ,
								q_etDiagExt		=> );
END_IF
xTestUserException2Old := vpiq_xTestUserException2;
	
TPL.FC_SetException(i_xExceptionActive := vpiq_xTestUserException3,
					iq_stException := stUserException3,
					iq_stExceptionList := G_stExceptionList,
					iq_stLogDataList := G_stLogDataList);
IF vpiq_xTestUserException3 AND NOT xTestUserException3Old AND (fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.Exception) THEN
	fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.Exception,
								i_etDiag		:= stUserException3.etDiag,
								i_udiDiagExt	:= stUserException3.udiDiagExt,
								i_sMessage		:= stUserException3.sMsg,
								q_etDiag		=> ,
								q_etDiagExt		=> );
END_IF
xTestUserException3Old := vpiq_xTestUserException3;
	
TPL.FC_SetException(i_xExceptionActive := (vpiq_xTestUserException4 OR vpiq_fbAxisModuleVisController.q_xSimulateExceptionStopEndOfCycle),
					iq_stException := stUserException4,
					iq_stExceptionList := G_stExceptionList,
					iq_stLogDataList := G_stLogDataList);
IF (vpiq_xTestUserException4 OR vpiq_fbAxisModuleVisController.q_xSimulateExceptionStopEndOfCycle) AND NOT xTestUserException4Old AND (fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.Exception) THEN
	fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.Exception,
								i_etDiag		:= stUserException4.etDiag,
								i_udiDiagExt	:= stUserException4.udiDiagExt,
								i_sMessage		:= stUserException4.sMsg,
								q_etDiag		=> ,
								q_etDiagExt		=> );
END_IF
xTestUserException4Old := (vpiq_xTestUserException4 OR vpiq_fbAxisModuleVisController.q_xSimulateExceptionStopEndOfCycle);
	
TPL.FC_SetException(i_xExceptionActive := vpiq_xTestUserException5,
					iq_stException := stUserException5,
					iq_stExceptionList := G_stExceptionList,
					iq_stLogDataList := G_stLogDataList);
IF vpiq_xTestUserException5 AND NOT xTestUserException5Old AND (fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.Exception) THEN
	fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.Exception,
								i_etDiag		:= stUserException5.etDiag,
								i_udiDiagExt	:= stUserException5.udiDiagExt,
								i_sMessage		:= stUserException5.sMsg,
								q_etDiag		=> ,
								q_etDiagExt		=> );
END_IF
xTestUserException5Old := vpiq_xTestUserException5;
