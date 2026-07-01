__METADATA__
{
  "v3Meta": {
    "objectGuid": "5e4d4a6e-01ed-4d13-acca-b77fa975fa45",
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
			THIS^.fbTreeWriter.TreeStart(	i_sName					:= THIS^.c_sName, 
											i_sTypeName				:= THIS^.c_sTypeName, 
											i_sTitleEnglish			:= 'Example data as tree', 
											i_sTitleGerman			:= 'Beispieldaten als Baum', 
											i_uiPrintRank			:= 14, 
											i_sEmptyListTextEnglish	:= 'No data available to show', 
											i_sEmptyListTextGerman	:= 'Keine Daten zum Anzeigen vorhanden',
											q_etDiag				=> THIS^.etDiag,
											q_etDiagExt				=> THIS^.etDiagExtTPL);
									
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF

			FOR THIS^.uiLevelCounter := 1 TO THIS^.c_uiMaxLevel DO
				THIS^.auiNodeCounter[uiLevelCounter] := 1;
			END_FOR

			THIS^.uiNodeId := 1;

			THIS^.lrSumNodes := ((1 - EXPT(THIS^.uiMaxNodePerLevel, THIS^.c_uiMaxLevel + 1)) / (1 - THIS^.uiMaxNodePerLevel));

			THIS^.uiLevelCounter := 1; (* start loop at index 1 *)

			THIS^.diCmdExecState := THIS^.diCmdExecState + 1;
		2:
			IF (THIS^.auiNodeCounter[THIS^.uiLevelCounter] <= THIS^.uiMaxNodePerLevel) THEN
				(* don't need to go up again, can create more nodes on this level *)

				(* create another subnode and go down *)
				(* create another node *)
				THIS^.uiNodeId := 0;
				THIS^.auiNodeCounter[THIS^.uiLevelCounter] := THIS^.auiNodeCounter[THIS^.uiLevelCounter] + 1;
				
				FOR THIS^.uiTmp := 1 TO THIS^.uiLevelCounter DO
					THIS^.uiNodeId := THIS^.uiNodeId * 100 + (THIS^.auiNodeCounter[THIS^.uiTmp] - 1);
				END_FOR
				
				THIS^.fbTreeWriter.NodeStart(	i_sName		:= CONCAT('Knoten_', UINT_TO_STRING(uiNodeId)),
												q_etDiag	=> THIS^.etDiag,
												q_etDiagExt	=> THIS^.etDiagExtTPL);
										
				IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
					ExceptionDuringWriting();
					EXIT;
				END_IF
				
					THIS^.fbTreeWriter.Parameter(	i_sName		:= 'something', 
													i_sValue	:= LREAL_TO_STRING(UINT_TO_LREAL(uiLevelCounter * auiNodeCounter[uiLevelCounter]) / UINT_TO_LREAL(uiNodeId)),
													q_etDiag	=> THIS^.etDiag,
													q_etDiagExt	=> THIS^.etDiagExtTPL);
											
					IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
						ExceptionDuringWriting();
						EXIT;
					END_IF

				THIS^.uiLevelCounter := THIS^.uiLevelCounter + 1;

				IF (THIS^.uiLevelCounter > THIS^.c_uiMaxLevel) THEN
					(* go up again *)
					THIS^.fbTreeWriter.NodeEnd(	q_etDiag	=> THIS^.etDiag,
												q_etDiagExt	=> THIS^.etDiagExtTPL);	
											
					IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
						ExceptionDuringWriting();
						EXIT;
					END_IF

					THIS^.uiLevelCounter := THIS^.uiLevelCounter - 1;
				END_IF
			ELSE
				(* go up again *)
				THIS^.fbTreeWriter.NodeEnd(	q_etDiag	=> THIS^.etDiag,
											q_etDiagExt	=> THIS^.etDiagExtTPL);	
										
				IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
					ExceptionDuringWriting();
					EXIT;
				END_IF

				THIS^.auiNodeCounter[THIS^.uiLevelCounter] := 1; (* reset node counter of level *)

				THIS^.uiLevelCounter := THIS^.uiLevelCounter - 1;
				IF (THIS^.uiLevelCounter <= 1) THEN
					(* loop over all nodes and levels done *)
					THIS^.diCmdExecState := THIS^.diCmdExecState + 1;
				END_IF
			END_IF

			THIS^.iq_stComStructure.q_lrProgress := UINT_TO_LREAL(THIS^.auiNodeCounter[1]) * LREAL#100.0 / MAX(THIS^.lrSumNodes,0.0001);

		3:
			THIS^.fbTreeWriter.TreeEnd(	q_etDiag	=> THIS^.etDiag,
										q_etDiagExt	=> THIS^.etDiagExtTPL);	
									
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
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
	END_CASE
	
	(* check again whether we can continue writing *)
	TPL.FC_CanContinueWriting(iq_stCanContinueWriting := THIS^.iq_stComStructure.iq_stCanContinueWriting);
END_WHILE
