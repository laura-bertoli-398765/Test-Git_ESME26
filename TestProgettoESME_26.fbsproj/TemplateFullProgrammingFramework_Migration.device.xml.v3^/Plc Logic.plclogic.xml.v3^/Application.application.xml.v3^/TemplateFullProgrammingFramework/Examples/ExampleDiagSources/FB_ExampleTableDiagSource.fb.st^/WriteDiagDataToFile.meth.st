__METADATA__
{
  "v3Meta": {
    "objectGuid": "e6f513e1-1ab7-42f9-854b-cd07137f1d52",
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
{attribute 'hide'}
METHOD WriteDiagDataToFile : BOOL
VAR_INPUT
END_VAR
__IMPLEMENTATION__
TPL.FC_CanContinueWriting(iq_stCanContinueWriting := THIS^.iq_stComStructure.iq_stCanContinueWriting); (* loop as long as we can continue to write *)

WHILE (THIS^.iq_stComStructure.iq_stCanContinueWriting.xCanContinue) DO
	
	CASE THIS^.diCmdExecState OF
		1:
			(* start writing *)
			THIS^.fbTableWriter.HeaderStart(	i_sName					:= THIS^.c_sName, 
												i_sTypeName				:= THIS^.c_sTypeName, 
												i_sTitleEnglish			:= 'Example Data as Table', 
												i_sTitleGerman			:= 'Beispieldaten als Tabelle', 
												i_uiPrintRank			:= 14, 
												i_sEmptyListTextEnglish	:= 'No data available to show', 
												i_sEmptyListTextGerman	:= 'Keine Daten zum Anzeigen vorhanden',
												q_etDiag				=> THIS^.etDiag,
												q_etDiagExt				=> THIS^.etDiagExtTPL);
										
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			
			THIS^.udiCName := THIS^.fbTableWriter.HeaderAddColumn(	i_sName			:= 'Name',
																	i_sTextEnglish	:= 'Name',
																	i_sTextGerman	:= 'Name',
																	i_uiWidth		:= 120,
																	q_etDiag		=> THIS^.etDiag,
																	q_etDiagExt		=> THIS^.etDiagExtTPL);
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF

			THIS^.udiCValue := THIS^.fbTableWriter.HeaderAddColumn(	i_sName			:= 'Value',
																	i_sTextEnglish	:= 'Value',
																	i_sTextGerman	:= 'Wert',
																	i_uiWidth		:= 120,
																	q_etDiag		=> THIS^.etDiag,
																	q_etDiagExt		=> THIS^.etDiagExtTPL);
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF

			THIS^.udiCC3 := THIS^.fbTableWriter.HeaderAddColumn(i_sName			:= 'Column3',
																i_sTextEnglish	:= 'Column3',
																i_sTextGerman	:= 'Spalte3',
																i_uiWidth		:= 120,
																q_etDiag		=> THIS^.etDiag,
																q_etDiagExt		=> THIS^.etDiagExtTPL);
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF

			IF THIS^.udiCC3 <= 0 OR THIS^.udiCValue <= 0 OR THIS^.udiCName <= 0 THEN

				THIS^.etDiag		:= GD.ET_Diag.ExecutionAborted;
				THIS^.etDiagExtTPL	:= TPL.ET_DiagExt.HeaderColumnIdInvalid;

				ExceptionDuringWriting();
				EXIT;
			END_IF

			THIS^.fbTableWriter.HeaderFinish(	q_etDiag	=> THIS^.etDiag,
												q_etDiagExt	=> THIS^.etDiagExtTPL);
										
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF

			THIS^.udiRowCounter := 1; (* start loop at index 1 *)

			THIS^.diCmdExecState := THIS^.diCmdExecState + 1;
			
		2:	(* loop over all rows *)

			IF (THIS^.udiRowCounter <= THIS^.c_udiMaxNumRows) THEN
				
				(* write row *)
				THIS^.fbTableWriter.RowStart(	q_etDiag	=> THIS^.etDiag,
												q_etDiagExt	=> THIS^.etDiagExtTPL);
										
				IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
					ExceptionDuringWriting();
					EXIT;
				END_IF
				
				(* write values *)
				THIS^.fbTableWriter.RowValue(	i_udiColumnNumber	:= THIS^.udiCName, 
												i_sValue			:= CONCAT('name_',UDINT_TO_STRING(udiRowCounter)),
												q_etDiag			=> THIS^.etDiag,
												q_etDiagExt			=> THIS^.etDiagExtTPL);
										
				IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
					ExceptionDuringWriting();
					EXIT;
				END_IF

				THIS^.fbTableWriter.RowValue(	i_udiColumnNumber	:= THIS^.udiCValue, 
												i_sValue			:= LREAL_TO_STRING((8000.0 - UDINT_TO_LREAL(udiRowCounter))/5),
												q_etDiag			=> THIS^.etDiag,
												q_etDiagExt			=> THIS^.etDiagExtTPL);
										
				IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
					ExceptionDuringWriting();
					EXIT;
				END_IF

				THIS^.fbTableWriter.RowValue(	i_udiColumnNumber	:= THIS^.udiCC3, 
												i_sValue			:= UDINT_TO_STRING(udiRowCounter + 88),
												q_etDiag			=> THIS^.etDiag,
												q_etDiagExt			=> THIS^.etDiagExtTPL);
										
				IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
					ExceptionDuringWriting();
					EXIT;
				END_IF
				
				THIS^.fbTableWriter.RowEnd(	q_etDiag	=> THIS^.etDiag,
											q_etDiagExt	=> THIS^.etDiagExtTPL);
										
				IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
					ExceptionDuringWriting();
					EXIT;
				END_IF
			END_IF

			THIS^.iq_stComStructure.q_lrProgress := UDINT_TO_LREAL(THIS^.udiRowCounter) * LREAL#100.0 / MAX(UDINT_TO_LREAL(THIS^.c_udiMaxNumRows), LREAL#0.0001);

			THIS^.udiRowCounter := THIS^.udiRowCounter + 1;
			IF (THIS^.udiRowCounter > THIS^.c_udiMaxNumRows) THEN
				(* loop over all rows done *)
				THIS^.diCmdExecState := THIS^.diCmdExecState + 1;
			END_IF
		3:
			THIS^.fbTableWriter.TableEnd(	q_etDiag	=> THIS^.etDiag,
											q_etDiagExt	=> THIS^.etDiagExtTPL);
									
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			
			(* done *)
			THIS^.iq_stComStructure.iq_diCmd := 0;

			SetDiagOutputs(	i_etDiag	:= GD.ET_Diag.Ok,
							i_etDiagExt	:= ET_DiagExt.DataSuccessfullyWritten,
							i_sMsg		:= '');					
	
			THIS^.diCmdExecState := 0;
			EXIT; (* exit the while loop *)
	END_CASE
	
	(* check again whether we can continue writing *)
	TPL.FC_CanContinueWriting(iq_stCanContinueWriting := THIS^.iq_stComStructure.iq_stCanContinueWriting);
END_WHILE
