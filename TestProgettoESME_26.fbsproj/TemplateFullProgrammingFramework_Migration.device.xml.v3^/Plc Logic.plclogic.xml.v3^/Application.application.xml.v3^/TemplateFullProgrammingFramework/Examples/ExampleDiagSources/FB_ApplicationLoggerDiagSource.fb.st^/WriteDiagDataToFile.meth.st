__METADATA__
{
  "v3Meta": {
    "objectGuid": "7b77e33f-e4f7-4bbe-9a78-ddf5c25d8975",
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
METHOD WriteDiagDataToFile
VAR_INPUT
END_VAR
__IMPLEMENTATION__
TPL.FC_CanContinueWriting(iq_stCanContinueWriting := THIS^.iq_stComStructure.iq_stCanContinueWriting); (* loop as long as we can continue to write *)

WHILE (THIS^.iq_stComStructure.iq_stCanContinueWriting.xCanContinue) DO
	
	CASE THIS^.diCmdExecState OF
		1:	(* start writing *)
			THIS^.fbTreeWriter.TreeStart(	i_sName					:= THIS^.c_sName, 
											i_sTypeName				:= THIS^.c_sTypeName, 
											i_sTitleEnglish			:= 'ApplicationLogger', 
											i_sTitleGerman			:= 'ApplicationLogger', 
											i_uiPrintRank			:= 14, 
											i_sEmptyListTextEnglish	:= 'No data available to show', 
											i_sEmptyListTextGerman	:= 'Keine Daten zum Anzeigen vorhanden',
											q_etDiag				=> THIS^.etDiagBuffer,
											q_etDiagExt				=> THIS^.etDiagExtBufferTPL,
											q_sMsg					=> THIS^.sMsgBuffer);
			IF THIS^.etDiagBuffer <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			THIS^.diCmdExecState := 50;

		50:	(* Start LogEntryList *)
			THIS^.fbTreeWriter.NodeStart(	i_sName		:= 'LogEntry list',
											q_etDiag	=> etDiagBuffer,
											q_etDiagExt	=> etDiagExtBufferTPL,
											q_sMsg		=> sMsgBuffer);
			IF THIS^.etDiagBuffer <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			THIS^.udiLogEntryCount := 1;
			THIS^.udiLogEntryCountMax := 50;
			THIS^.udiLogEntryId := THIS^.fbAppLogHandler.udiFirstLogEntryId;
			THIS^.diCmdExecState := 51;
			
		51: (* write LogEntrys *)
			WHILE (THIS^.udiLogEntryCount < THIS^.udiLogEntryCountMax) AND (THIS^.udiLogEntryCount <= THIS^.fbAppLogHandler.udiNumberOfLogEntries) DO
				THIS^.fbTreeWriter.NodeStart(	i_sName		:= UDINT_TO_STRING(THIS^.udiLogEntryId),
												q_etDiag	=> etDiagBuffer,
												q_etDiagExt	=> etDiagExtBufferTPL,
												q_sMsg		=> sMsgBuffer);
				IF THIS^.etDiagBuffer <> GD.ET_Diag.Ok THEN
					ExceptionDuringWriting();
					RETURN;
				END_IF					

					THIS^.fbAppLogHandler.GetLogEntry(	i_udiId			:= THIS^.udiLogEntryId,
														q_stLogEntry	=> THIS^.stLogEntry,
														q_etDiag		=> THIS^.etDiagBuffer,
														q_etDiagExt		=> THIS^.etDiagExtBufferAPL);
					IF (THIS^.etDiagBuffer <> GD.ET_Diag.Ok) THEN
						ExceptionDuringWriting();
						RETURN;
					END_IF
				
					THIS^.fbTreeWriter.Parameter(	i_sName		:= 'udiId', 
													i_sValue	:= UDINT_TO_STRING(THIS^.stLogEntry.udiId),
													q_etDiag	=> etDiagBuffer,
													q_etDiagExt	=> etDiagExtBufferTPL,
													q_sMsg		=> sMsgBuffer);
					IF etDiagBuffer <> GD.ET_Diag.Ok THEN
						ExceptionDuringWriting();
						RETURN;
					END_IF

					THIS^.fbTreeWriter.Parameter(	i_sName		:= 'udiLoggerPointId', 
													i_sValue	:= UDINT_TO_STRING(THIS^.stLogEntry.udiLoggerPointId),
													q_etDiag	=> etDiagBuffer,
													q_etDiagExt	=> etDiagExtBufferTPL,
													q_sMsg		=> sMsgBuffer);
					IF etDiagBuffer <> GD.ET_Diag.Ok THEN
						ExceptionDuringWriting();
						RETURN;
					END_IF
					THIS^.fbTreeWriter.Parameter(	i_sName		:= 'sMessage', 
													i_sValue	:= THIS^.stLogEntry.sMessage,
													q_etDiag	=> etDiagBuffer,
													q_etDiagExt	=> etDiagExtBufferTPL,
													q_sMsg		=> sMsgBuffer);
					IF etDiagBuffer <> GD.ET_Diag.Ok THEN
						ExceptionDuringWriting();
						RETURN;
					END_IF
					THIS^.fbTreeWriter.Parameter(	i_sName		:= 'etDiag', 
													i_sValue	:= GD.FC_EtDiagToString(i_etDiag := THIS^.stLogEntry.etDiag),
													q_etDiag	=> etDiagBuffer,
													q_etDiagExt	=> etDiagExtBufferTPL,
													q_sMsg		=> sMsgBuffer);
					IF etDiagBuffer <> GD.ET_Diag.Ok THEN
						ExceptionDuringWriting();
						RETURN;
					END_IF
					THIS^.fbTreeWriter.Parameter(	i_sName		:= 'udiDiagExt', 
													i_sValue	:= UDINT_TO_STRING(THIS^.stLogEntry.udiDiagExt),
													q_etDiag	=> etDiagBuffer,
													q_etDiagExt	=> etDiagExtBufferTPL,
													q_sMsg		=> sMsgBuffer);
					IF etDiagBuffer <> GD.ET_Diag.Ok THEN
						ExceptionDuringWriting();
						RETURN;
					END_IF
					THIS^.fbTreeWriter.Parameter(	i_sName		:= 'dtDate', 
													i_sValue	:= DATE_TO_STRING(THIS^.stLogEntry.dtDate),
													q_etDiag	=> etDiagBuffer,
													q_etDiagExt	=> etDiagExtBufferTPL,
													q_sMsg		=> sMsgBuffer);
					IF etDiagBuffer <> GD.ET_Diag.Ok THEN
						ExceptionDuringWriting();
						RETURN;
					END_IF
					THIS^.fbTreeWriter.Parameter(	i_sName		:= 'todTime', 
													i_sValue	:= TOD_TO_STRING(THIS^.stLogEntry.todTime),
													q_etDiag	=> etDiagBuffer,
													q_etDiagExt	=> etDiagExtBufferTPL,
													q_sMsg		=> sMsgBuffer);
					IF etDiagBuffer <> GD.ET_Diag.Ok THEN
						ExceptionDuringWriting();
						RETURN;
					END_IF
					THIS^.fbTreeWriter.Parameter(	i_sName		:= 'etLogLevel', 
													i_sValue	:= APL.FC_EtLogLevelToString(i_etLogLevel := THIS^.stLogEntry.etLogLevel),
													q_etDiag	=> etDiagBuffer,
													q_etDiagExt	=> etDiagExtBufferTPL,
													q_sMsg		=> sMsgBuffer);
					IF etDiagBuffer <> GD.ET_Diag.Ok THEN
						ExceptionDuringWriting();
						RETURN;
					END_IF
					
				THIS^.fbTreeWriter.NodeEnd(	q_etDiag	=> etDiagBuffer,
											q_etDiagExt	=> etDiagExtBufferTPL,
											q_sMsg		=> sMsgBuffer);	
				IF THIS^.etDiagBuffer <> GD.ET_Diag.Ok THEN
					ExceptionDuringWriting();
					RETURN;
				END_IF	
			
				THIS^.udiLogEntryCount := THIS^.udiLogEntryCount +1;
				THIS^.udiLogEntryId := THIS^.udiLogEntryId +1;
			END_WHILE
			THIS^.udiLogEntryCountMax := THIS^.udiLogEntryCountMax + 50;
			IF (THIS^.udiLogEntryCount > THIS^.fbAppLogHandler.udiNumberOfLogEntries) THEN
				THIS^.fbTreeWriter.NodeEnd(	q_etDiag	=> etDiagBuffer,
											q_etDiagExt	=> etDiagExtBufferTPL,
											q_sMsg		=> sMsgBuffer);	
				IF THIS^.etDiagBuffer <> GD.ET_Diag.Ok THEN
					ExceptionDuringWriting();
					EXIT;
				END_IF
				THIS^.diCmdExecState := 60;
			END_IF
		
		60: (* Start LoggerPoint list *)
			THIS^.fbTreeWriter.NodeStart(	i_sName		:= 'LoggerPoint list',
											q_etDiag	=> etDiagBuffer,
											q_etDiagExt	=> etDiagExtBufferTPL,
											q_sMsg		=> sMsgBuffer);
			IF THIS^.etDiagBuffer <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			THIS^.udiLoggerPointCount := 1;
			THIS^.udiLoggerPointCountMax := 50;
			THIS^.diCmdExecState := 61;	
			
		61: (* write LoggerPoint list *)
			WHILE (THIS^.udiLoggerPointCount < THIS^.udiLoggerPointCountMax) AND (THIS^.udiLoggerPointCount <= THIS^.fbAppLogHandler.udiNumberOfLoggerPoints) DO
				THIS^.fbTreeWriter.NodeStart(	i_sName		:= UDINT_TO_STRING(THIS^.udiLoggerPointCount),
												q_etDiag	=> etDiagBuffer,
												q_etDiagExt	=> etDiagExtBufferTPL,
												q_sMsg		=> sMsgBuffer);
				IF THIS^.etDiagBuffer <> GD.ET_Diag.Ok THEN
					ExceptionDuringWriting();
					RETURN;
				END_IF					

					THIS^.fbAppLogHandler.GetLoggerPoint(	i_udiId			:= THIS^.udiLoggerPointCount,
															q_ifLoggerPoint	=> THIS^.ifLoggerPoint,
															q_etDiag		=> THIS^.etDiagBuffer,
															q_etDiagExt		=> THIS^.etDiagExtBufferAPL);
					IF (THIS^.etDiagBuffer <> GD.ET_Diag.Ok) THEN
						ExceptionDuringWriting();
						RETURN;
					END_IF
				
					THIS^.fbTreeWriter.Parameter(	i_sName		:= 'udiId', 
													i_sValue	:= UDINT_TO_STRING(THIS^.ifLoggerPoint.udiId),
													q_etDiag	=> etDiagBuffer,
													q_etDiagExt	=> etDiagExtBufferTPL,
													q_sMsg		=> sMsgBuffer);
					IF etDiagBuffer <> GD.ET_Diag.Ok THEN
						ExceptionDuringWriting();
						RETURN;
					END_IF			
					THIS^.fbTreeWriter.Parameter(	i_sName		:= 'udiParentId', 
													i_sValue	:= UDINT_TO_STRING(THIS^.ifLoggerPoint.udiParentId),
													q_etDiag	=> etDiagBuffer,
													q_etDiagExt	=> etDiagExtBufferTPL,
													q_sMsg		=> sMsgBuffer);
					IF etDiagBuffer <> GD.ET_Diag.Ok THEN
						ExceptionDuringWriting();
						RETURN;
					END_IF
					THIS^.fbTreeWriter.Parameter(	i_sName		:= 'sName', 
													i_sValue	:= THIS^.ifLoggerPoint.sName,
													q_etDiag	=> etDiagBuffer,
													q_etDiagExt	=> etDiagExtBufferTPL,
													q_sMsg		=> sMsgBuffer);
					IF etDiagBuffer <> GD.ET_Diag.Ok THEN
						ExceptionDuringWriting();
						RETURN;
					END_IF			
					THIS^.fbTreeWriter.Parameter(	i_sName		:= 'sType', 
													i_sValue	:= THIS^.ifLoggerPoint.sType,
													q_etDiag	=> etDiagBuffer,
													q_etDiagExt	=> etDiagExtBufferTPL,
													q_sMsg		=> sMsgBuffer);
					IF etDiagBuffer <> GD.ET_Diag.Ok THEN
						ExceptionDuringWriting();
						RETURN;
					END_IF
					THIS^.fbTreeWriter.Parameter(	i_sName		:= 'sSource', 
													i_sValue	:= THIS^.ifLoggerPoint.sSource,
													q_etDiag	=> etDiagBuffer,
													q_etDiagExt	=> etDiagExtBufferTPL,
													q_sMsg		=> sMsgBuffer);
					IF etDiagBuffer <> GD.ET_Diag.Ok THEN
						ExceptionDuringWriting();
						RETURN;
					END_IF
					THIS^.fbTreeWriter.Parameter(	i_sName		:= 'etLogLevel', 
													i_sValue	:= APL.FC_EtLogLevelToString(i_etLogLevel := THIS^.ifLoggerPoint.etLogLevel),
													q_etDiag	=> etDiagBuffer,
													q_etDiagExt	=> etDiagExtBufferTPL,
													q_sMsg		=> sMsgBuffer);
					IF etDiagBuffer <> GD.ET_Diag.Ok THEN
						ExceptionDuringWriting();
						RETURN;
					END_IF
			
				THIS^.fbTreeWriter.NodeEnd(	q_etDiag	=> etDiagBuffer,
											q_etDiagExt	=> etDiagExtBufferTPL,
											q_sMsg		=> sMsgBuffer);	
				IF THIS^.etDiagBuffer <> GD.ET_Diag.Ok THEN
					ExceptionDuringWriting();
					RETURN;
				END_IF	
			
				THIS^.udiLoggerPointCount := THIS^.udiLoggerPointCount +1;
			END_WHILE
			THIS^.udiLoggerPointCountMax := THIS^.udiLoggerPointCountMax + 50;
			IF (THIS^.udiLoggerPointCount > THIS^.fbAppLogHandler.udiNumberOfLoggerPoints) THEN
				THIS^.fbTreeWriter.NodeEnd(	q_etDiag	=> etDiagBuffer,
											q_etDiagExt	=> etDiagExtBufferTPL,
											q_sMsg		=> sMsgBuffer);	
				IF THIS^.etDiagBuffer <> GD.ET_Diag.Ok THEN
					ExceptionDuringWriting();
					EXIT;
				END_IF
				THIS^.diCmdExecState := 70;
			END_IF			
		
		70:
			(* library versions *)
			THIS^.fbTreeWriter.NodeStart(	i_sName		:= 'LibraryVersions',
											q_etDiag	=> THIS^.etDiagBuffer,
											q_etDiagExt	=> THIS^.etDiagExtBufferTPL,
											q_sMsg		=> THIS^.sMsgBuffer);				
			IF THIS^.etDiagBuffer <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			
				THIS^.fbTreeWriter.Parameter(	i_sName		:= 'ApplicationLogger', 
												i_sValue	:= APL.Gc_sLibraryVersion,
												q_etDiag	=> THIS^.etDiagBuffer,
												q_etDiagExt	=> THIS^.etDiagExtBufferTPL,
												q_sMsg		=> THIS^.sMsgBuffer);
				IF THIS^.etDiagBuffer <> GD.ET_Diag.Ok THEN
					ExceptionDuringWriting();
					EXIT;
				END_IF
			
				THIS^.fbTreeWriter.Parameter(	i_sName		:= 'GlobalDiagnostics', 
												i_sValue	:= GD.Gc_sLibraryVersion,
												q_etDiag	=> THIS^.etDiagBuffer,
												q_etDiagExt	=> THIS^.etDiagExtBufferTPL,
												q_sMsg		=> THIS^.sMsgBuffer);
				IF THIS^.etDiagBuffer <> GD.ET_Diag.Ok THEN
					ExceptionDuringWriting();
					EXIT;
				END_IF
				
			THIS^.fbTreeWriter.NodeEnd(	q_etDiag	=> THIS^.etDiagBuffer,
										q_etDiagExt	=> THIS^.etDiagExtBufferTPL,
										q_sMsg		=> THIS^.sMsgBuffer);		
			IF THIS^.etDiagBuffer <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF

			THIS^.fbTreeWriter.TreeEnd(	q_etDiag	=> THIS^.etDiagBuffer,
										q_etDiagExt	=> THIS^.etDiagExtBufferTPL,
										q_sMsg		=> THIS^.sMsgBuffer);	
			IF THIS^.etDiagBuffer <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			(* done *)
			
			(* signal command execution *)
			THIS^.iq_stComStructure.iq_diCmd := 0;
			
			SetDiagOutputs(	i_etDiag	:= GD.ET_Diag.Ok,
							i_etDiagExt	:= ET_DiagExt.DataSuccessfullyWritten,
							i_sMsg		:= '');		
			
			THIS^.diCmdExecState := 0;
			EXIT; (* exit the while loop *)
		ELSE
			ExceptionDuringWriting();
			EXIT;
	END_CASE
END_WHILE
