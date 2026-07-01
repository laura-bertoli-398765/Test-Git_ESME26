__METADATA__
{
  "v3Meta": {
    "objectGuid": "9af98f9a-7888-47e4-8e57-baeef8787e82",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* System generated code, do not change without consulting 'Schneider Electric Automation GmbH' - otherwise you risk instability!!! *)
IF ifControllerDiagnostic <> 0 THEN
	diDiagCode := ifControllerDiagnostic.DiagCode; 
	IF diDiagCode <> diDiagCode_old THEN
		diDiagCode_old	:= diDiagCode;
		stDiagSource	:= ifControllerDiagnostic.DiagSource;
		IF NOT __QUERYINTERFACE(stDiagSource.Device, ifDriveType ) THEN
			diDiagClass		:= ifControllerDiagnostic.DiagClass;
			sDiagMsg		:= ifControllerDiagnostic.DiagMsg;
			sInstanceName	:= 'UnknownDevice';
			sDiagMsgExt := '';
			sDiagMsgExt := ifControllerDiagnostic.DiagExtMsg;

			diDiagClass := ifControllerDiagnostic.DiagClass;
			IF diDiagClass = 4 THEN
				stSystemException1.etDiag		:= GD.ET_Diag.DiagActive;
				stSystemException1.udiDiagExt	:= ET_DiagExt.SystemFatalException;								
				stSystemException1.sDiagExt		:= FC_EtDiagExtToString(stSystemException1.udiDiagExt);	
				stSystemException1.sMsg			:= SE_CTBX.FC_MultiConcat(	i_sString1 := STANDARD.CONCAT(sInstanceName, ' '),
																		i_sString2 := STANDARD.CONCAT(DINT_TO_STRING(diDiagCode), ' '), 
																		i_sString3 := STANDARD.CONCAT(sDiagMsg, ' '), 
																		i_sString4 := sDiagMsgExt);
				stSystemException1.udiExceptionNumber := TPL.FC_GenerateExceptionNumber( i_etSource := TPL.ET_ExceptionSource.System, i_udiDiagExt := DINT_TO_UDINT(diDiagCode) );
				fbExceptionHandler.SetException(i_xExceptionActive	:= TRUE,
												iq_stException		:= stSystemException1,
												iq_stExceptionList	:= G_stExceptionList);
				
			ELSIF diDiagClass = 3 THEN
				stSystemException2.etDiag		:= GD.ET_Diag.DiagActive;
				stSystemException2.udiDiagExt	:= ET_DiagExt.SystemException;				
				stSystemException2.sDiagExt		:= FC_EtDiagExtToString(stSystemException2.udiDiagExt);	
				stSystemException2.sMsg			:= SE_CTBX.FC_MultiConcat(	i_sString1 := STANDARD.CONCAT(sInstanceName, ' '),
																		i_sString2 := STANDARD.CONCAT(DINT_TO_STRING(diDiagCode), ' '), 
																		i_sString3 := STANDARD.CONCAT(sDiagMsg, ' '), 
																		i_sString4 := sDiagMsgExt);
				stSystemException2.udiExceptionNumber := TPL.FC_GenerateExceptionNumber( i_etSource := TPL.ET_ExceptionSource.System, i_udiDiagExt := DINT_TO_UDINT(diDiagCode) );
				fbExceptionHandler.SetException(i_xExceptionActive	:= TRUE,
												iq_stException		:= stSystemException2,
												iq_stExceptionList	:= G_stExceptionList);
				
			ELSIF (diDiagClass = 2 OR diDiagClass = 1) THEN
				stSystemException3.etDiag		:= GD.ET_Diag.DiagActive;
				stSystemException3.udiDiagExt	:= ET_DiagExt.SystemWarning;
				stSystemException3.sDiagExt		:= FC_EtDiagExtToString(stSystemException3.udiDiagExt);	
				stSystemException3.sMsg			:= SE_CTBX.FC_MultiConcat(	i_sString1 := STANDARD.CONCAT(sInstanceName, ' '),
																		i_sString2 := STANDARD.CONCAT(DINT_TO_STRING(diDiagCode), ' '), 
																		i_sString3 := STANDARD.CONCAT(sDiagMsg, ' '), 
																		i_sString4 := sDiagMsgExt);
				stSystemException3.udiExceptionNumber := TPL.FC_GenerateExceptionNumber( i_etSource := TPL.ET_ExceptionSource.System, i_udiDiagExt := DINT_TO_UDINT(diDiagCode) );
				fbExceptionHandler.SetException(i_xExceptionActive	:= TRUE,
												iq_stException		:= stSystemException3,
												iq_stExceptionList	:= G_stExceptionList);
			END_IF
		END_IF
	END_IF
END_IF

IF NOT xInputEmergency THEN	(* Extend logic for hardware *)

	fbExceptionHandler.SetException(i_xExceptionActive	:= TRUE,
									iq_stException		:= stEmergencyStopException,
									iq_stExceptionList	:= G_stExceptionList);
END_IF

IF etContactorControlDiag <> GD.ET_Diag.Ok THEN

	stContactorControlException.etDiag		:= etContactorControlDiag;
	stContactorControlException.udiDiagExt	:= etContactorControlDiagExt;
	stContactorControlException.sDiagExt	:= TPL.FC_EtDiagExtToString(etContactorControlDiagExt);
	stContactorControlException.sMsg		:= sContactorControlMsg;
	
	fbExceptionHandler.SetException(i_xExceptionActive	:= TRUE,
									iq_stException		:= stContactorControlException,
									iq_stExceptionList	:= G_stExceptionList);
END_IF

(* End of system generated code, do not change without consulting 'Schneider Electric Automation GmbH' - otherwise you risk instability!!! *)
