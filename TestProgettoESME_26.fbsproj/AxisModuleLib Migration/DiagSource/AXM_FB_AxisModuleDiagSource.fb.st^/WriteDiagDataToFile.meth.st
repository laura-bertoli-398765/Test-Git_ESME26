__METADATA__
{
  "v3Meta": {
    "objectGuid": "b4bacf4b-aeee-4610-b300-da7917f365b9",
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
METHOD INTERNAL WriteDiagDataToFile : BOOL
VAR_INPUT
END_VAR
VAR
END_VAR
__IMPLEMENTATION__
TPL.FC_CanContinueWriting(iq_stCanContinueWriting := THIS^.iq_stComStructure.iq_stCanContinueWriting); (* loop as long as we can continue to write *)

WHILE (THIS^.iq_stComStructure.iq_stCanContinueWriting.xCanContinue) DO
	
	CASE THIS^.diCmdExecState OF
		1:
			THIS^.pstTmp := ADR(THIS^.iq_stMachineItf);

			(* start writing *)
			THIS^.fbTreeWriter.TreeStart(	i_sName					:= THIS^.c_sName, 
											i_sTypeName				:= THIS^.c_sTypeName, 
											i_sTitleEnglish			:= 'AxisModule interface', 
											i_sTitleGerman			:= 'AxisModule Schnittstelle', 
											i_uiPrintRank			:= 14, 
											i_sEmptyListTextEnglish	:= 'No data available to show', 
											i_sEmptyListTextGerman	:= 'Keine Daten zum Anzeigen vorhanden',
											q_etDiag				=> THIS^.etDiag,
											q_etDiagExt				=> THIS^.etDiagExtTPL,
											q_sMsg					=> THIS^.sMsg);
									
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF

			THIS^.audiHierarchy[1]	:= 1;
			THIS^.apstHierarchy[1]	:= THIS^.pstTmp;
			THIS^.udiLevelCounter	:= 1; (* start loop at index 1 *)

			THIS^.diCmdExecState := THIS^.diCmdExecState + 1;

        2:
			(* writing node main machine *)
			THIS^.sModuleName := CONCAT(UDINT_TO_STRING(THIS^.pstTmp^.i_udiModuleId), ' : ');
			THIS^.sModuleName := CONCAT(THIS^.sModuleName, THIS^.pstTmp^.i_sModuleName);

			THIS^.fbTreeWriter.NodeStart(	i_sName		:= THIS^.sModuleName,
											q_etDiag	=> THIS^.etDiag,
											q_etDiagExt	=> THIS^.etDiagExtTPL,
											q_sMsg		=> THIS^.sMsg);
									
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF

			IF (THIS^.pstTmp^.iq_stExt.udiNumberOfSubModules <> 0) THEN
				THIS^.diCmdExecState := THIS^.diCmdExecState + 1;
			ELSE
				THIS^.fbTreeWriter.NodeEnd(	q_etDiag	=> THIS^.etDiag,
											q_etDiagExt	=> THIS^.etDiagExtTPL,
											q_sMsg		=> THIS^.sMsg);		
										
				IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
					ExceptionDuringWriting();
					EXIT;
				END_IF
					
				THIS^.diCmdExecState := 4;
			END_IF

		3:
			(* Navigate to next module *)
			(* Try to go down *)
			IF ((THIS^.apstHierarchy[THIS^.udiLevelCounter]^.iq_stExt.udiNumberOfSubModules > 0) AND (THIS^.udiLevelCounter < THIS^.c_udiMaxLevel)) THEN
				(* Go down *)
				THIS^.udiLevelCounter := THIS^.udiLevelCounter + 1;
				THIS^.audiHierarchy[THIS^.udiLevelCounter] := 1;
				(* Set pointer *)
				THIS^.apstHierarchy[THIS^.udiLevelCounter] := THIS^.apstHierarchy[THIS^.udiLevelCounter - 1]^.iq_stExt.dwSubModulesItf
					+ UDINT_TO_DWORD((THIS^.audiHierarchy[THIS^.udiLevelCounter] - 1) * SIZEOF(THIS^.pstTmp^));

			ELSIF (THIS^.apstHierarchy[THIS^.udiLevelCounter - 1] <> 0) THEN
				(* Cannot go down *)
				
				(* Write end-tag of last module *)
				THIS^.fbTreeWriter.NodeEnd(	q_etDiag	=> THIS^.etDiag,
											q_etDiagExt	=> THIS^.etDiagExtTPL,
											q_sMsg		=> THIS^.sMsg);		
										
				IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
					ExceptionDuringWriting();
					EXIT;
				END_IF
				
				(* Check if you can go right *)
				IF (THIS^.apstHierarchy[THIS^.udiLevelCounter - 1]^.iq_stExt.udiNumberOfSubModules > THIS^.audiHierarchy[THIS^.udiLevelCounter]) THEN
					(* Go right *)
					THIS^.audiHierarchy[THIS^.udiLevelCounter] := THIS^.audiHierarchy[THIS^.udiLevelCounter] + 1;
					(* Set pointer *)
					THIS^.apstHierarchy[THIS^.udiLevelCounter] := THIS^.apstHierarchy[THIS^.udiLevelCounter - 1]^.iq_stExt.dwSubModulesItf
						+  UDINT_TO_DWORD((THIS^.audiHierarchy[THIS^.udiLevelCounter] - 1) * SIZEOF(THIS^.pstTmp^));
				ELSE
					(* Check if you can go up *)
					(* Go up until you can go right *)
					THIS^.xLoop := TRUE;
					WHILE (THIS^.xLoop AND (THIS^.udiLevelCounter > 1)) DO
						THIS^.udiLevelCounter := THIS^.udiLevelCounter - 1;
						IF (THIS^.udiLevelCounter > 1) THEN
							THIS^.xLoop := (THIS^.apstHierarchy[THIS^.udiLevelCounter - 1]^.iq_stExt.udiNumberOfSubModules <= THIS^.audiHierarchy[THIS^.udiLevelCounter]);
							IF (THIS^.xLoop) THEN
								(* Write end-tag of last module *)
				  				THIS^.fbTreeWriter.NodeEnd(	q_etDiag	=> THIS^.etDiag,
															q_etDiagExt	=> THIS^.etDiagExtTPL,
															q_sMsg		=> THIS^.sMsg);		
										
								IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
									ExceptionDuringWriting();
									EXIT;
								END_IF
							END_IF
						ELSE
							THIS^.xLoop := FALSE;
						END_IF
					END_WHILE

					(* Write end-tag of last module *)
					THIS^.fbTreeWriter.NodeEnd(	q_etDiag	=> THIS^.etDiag,
												q_etDiagExt	=> THIS^.etDiagExtTPL,
												q_sMsg		=> THIS^.sMsg);		
							
					IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
						ExceptionDuringWriting();
						EXIT;
					END_IF

					IF (THIS^.udiLevelCounter <= 1) THEN
						(* End of tree reached *)
						THIS^.diCmdExecState := 4;
					ELSE
						(* Go right *)
						(* Set pointer *)
						THIS^.audiHierarchy[THIS^.udiLevelCounter] := THIS^.audiHierarchy[THIS^.udiLevelCounter] + 1;
						THIS^.apstHierarchy[THIS^.udiLevelCounter] := THIS^.apstHierarchy[THIS^.udiLevelCounter - 1]^.iq_stExt.dwSubModulesItf
							+  UDINT_TO_DWORD((THIS^.audiHierarchy[THIS^.udiLevelCounter] - 1) * SIZEOF(THIS^.pstTmp^));
					END_IF
				END_IF
			END_IF

			(* Write node of current module *)
			IF (THIS^.diCmdExecState <> 4) THEN
				IF (THIS^.apstHierarchy[THIS^.udiLevelCounter] <> 0) THEN
					(* Set name pointer to character before last semicolon *)
					THIS^.pstChar := ADR(THIS^.apstHierarchy[THIS^.udiLevelCounter]^.i_sModuleName) +  INT_TO_DWORD((LEN(THIS^.apstHierarchy[THIS^.udiLevelCounter]^.i_sModuleName) - 3));
					THIS^.sModuleName := THIS^.pstChar^;
					(* Search for beginning of module name *)
					WHILE (FIND(THIS^.sModuleName, ':') <> 1) DO
						THIS^.pstChar := THIS^.pstChar - 1;
						THIS^.sModuleName := THIS^.pstChar^;
					END_WHILE
					(* Make string nicer *)
					THIS^.sModuleName := CONCAT (' ', THIS^.sModuleName);
					
					THIS^.fbTreeWriter.NodeStart(	i_sName		:= CONCAT(UDINT_TO_STRING(THIS^.apstHierarchy[THIS^.udiLevelCounter]^.i_udiModuleId), THIS^.sModuleName),
													q_etDiag	=> THIS^.etDiag,
													q_etDiagExt	=> THIS^.etDiagExtTPL,
													q_sMsg		=> THIS^.sMsg);
											
					IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
						ExceptionDuringWriting();
						EXIT;
					END_IF

					(* is an axis module? *)
					IF (THIS^.apstHierarchy[THIS^.udiLevelCounter]^.q_dwModuleType =  UDINT_TO_DWORD(TPL.ET_ModuleType.AxisModule)) THEN
						IF (THIS^.apstHierarchy[THIS^.udiLevelCounter]^.q_udiModuleVersion <> 1) THEN
							(* version not supported *)
							THIS^.fbTreeWriter.Parameter(	i_sName		:= 'Exception', 
															i_sValue	:= 'Version of AxisModule not supported',
															q_etDiag	=> THIS^.etDiag,
															q_etDiagExt	=> THIS^.etDiagExtTPL,
															q_sMsg		=> THIS^.sMsg);
													
							IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
								ExceptionDuringWriting();
								EXIT;
							END_IF
						ELSE
							(* print additional interface *)
							THIS^.pstInterface := 0;
							(* get pointer to additional interface *)
							IF (THIS^.udiLevelCounter >= 2) THEN
								IF(THIS^.apstHierarchy[THIS^.udiLevelCounter - 1] <> 0) THEN
									IF (THIS^.apstHierarchy[THIS^.udiLevelCounter - 1]^.iq_stExt.pdwSubModulesAddItf <> 0) THEN
										(* get correct position in list of add interface pointers *)
										THIS^.pdw := THIS^.apstHierarchy[THIS^.udiLevelCounter - 1]^.iq_stExt.pdwSubModulesAddItf
											+ UDINT_TO_DWORD((THIS^.audiHierarchy[THIS^.udiLevelCounter](* number OF submodule *) - 1) * SIZEOF(THIS^.pdw^));
										IF (THIS^.pdw^ <> 0) THEN
											THIS^.pstInterface := THIS^.pdw^;
										END_IF
									END_IF
								END_IF
							END_IF
							
							IF (THIS^.pstInterface = 0) THEN
								THIS^.fbTreeWriter.Parameter(	i_sName		:= 'Exception', 
																i_sValue	:= 'Could not get pointer to additional interface',
																q_etDiag	=> THIS^.etDiag,
																q_etDiagExt	=> THIS^.etDiagExtTPL,
																q_sMsg		=> THIS^.sMsg);
														
								IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
									ExceptionDuringWriting();
									EXIT;
								END_IF
							ELSE
								THIS^.diCmdExecState := 5; (* continue output in different state *)
							END_IF (* addinterface pointer *)
						END_IF (* version *)
					END_IF (* module type *)
				END_IF
			END_IF

		4:
			(* library versions *)
			THIS^.fbTreeWriter.NodeStart(	i_sName		:= 'LibraryVersions',
											q_etDiag	=> THIS^.etDiag,
											q_etDiagExt	=> THIS^.etDiagExtTPL,
											q_sMsg		=> THIS^.sMsg);
									
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			
				THIS^.fbTreeWriter.Parameter(	i_sName		:= 'GlobalDiagnostics', 
												i_sValue	:= GD.Gc_sLibraryVersion,
												q_etDiag	=> THIS^.etDiag,
												q_etDiagExt	=> THIS^.etDiagExtTPL,
												q_sMsg		=> THIS^.sMsg);
										
				IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
					ExceptionDuringWriting();
					EXIT;
				END_IF
				
				THIS^.fbTreeWriter.Parameter(	i_sName		:= 'PLCopenMcPart1', 
												i_sValue	:= 'TODO', //PLCO. PDL_Gc_sLibraryVersion,
												q_etDiag	=> THIS^.etDiag,
												q_etDiagExt	=> THIS^.etDiagExtTPL,
												q_sMsg		=> THIS^.sMsg);
										
				IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
					ExceptionDuringWriting();
					EXIT;
				END_IF

		
			THIS^.fbTreeWriter.NodeEnd(	q_etDiag	=> THIS^.etDiag,
										q_etDiagExt	=> THIS^.etDiagExtTPL,
										q_sMsg		=> THIS^.sMsg);		
					
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF


			THIS^.fbTreeWriter.TreeEnd(	q_etDiag	=> THIS^.etDiag,
										q_etDiagExt	=> THIS^.etDiagExtTPL,
										q_sMsg		=> THIS^.sMsg);	
									
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			(* done *)
			
			(* signal command execution *)
			THIS^.iq_stComStructure.iq_diCmd := 0;
			
			SetDiagOutputs(	i_etDiag	:= GD.ET_Diag.Ok,
							i_etDiagExt	:= AXM_ET_DiagExt.DataSuccessfullyWritten,
							i_sMsg		:= '');		
			
			THIS^.diCmdExecState := 0;
			EXIT; (* exit the while loop *)

		5:
			(* continue output of AxisModule interface *)
			WriteInterfaceStart(q_etDiag	=> THIS^.etDiag,
								q_etDiagExt	=> THIS^.etDiagExtTPL,
								q_sMsg		=> THIS^.sMsg);
			
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF

			THIS^.diCmdExecState := 51;

		51:
			WriteInterfaceMain(	q_etDiag	=> THIS^.etDiag,
								q_etDiagExt	=> THIS^.etDiagExtTPL,
								q_sMsg		=> THIS^.sMsg);
			
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			
			THIS^.diCmdExecState := 52;

		52:
			WriteInterfaceHomeStart(q_etDiag	=> THIS^.etDiag,
									q_etDiagExt	=> THIS^.etDiagExtTPL,
									q_sMsg		=> THIS^.sMsg);
			
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			
			THIS^.diCmdExecState := 53;

		53:
			WriteInterfaceHomeParam(q_etDiag	=> THIS^.etDiag,
									q_etDiagExt	=> THIS^.etDiagExtTPL,
									q_sMsg		=> THIS^.sMsg);
			
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			
			THIS^.diCmdExecState := 54;

		54:
// 			WriteInterfaceHomeTouchProbe(	q_etDiag	=> THIS^.etDiag,
// 											q_etDiagExt	=> THIS^.etDiagExtTPL,
// 											q_sMsg		=> THIS^.sMsg);
// 			
// 			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
// 				ExceptionDuringWriting();
// 				EXIT;
// 			END_IF
			
			THIS^.diCmdExecState := 55;

		55:
// 			WriteInterfaceHomeSensor(	q_etDiag	=> THIS^.etDiag,
// 										q_etDiagExt	=> THIS^.etDiagExtTPL,
// 										q_sMsg		=> THIS^.sMsg);
// 			WriteInterfaceHomeDigitalInput(	q_etDiag	=> THIS^.etDiag,
// 											q_etDiagExt	=> THIS^.etDiagExtTPL,
// 											q_sMsg		=> THIS^.sMsg);
// 			
// 			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
// 				ExceptionDuringWriting();
// 				EXIT;
// 			END_IF
			
			THIS^.diCmdExecState := 56;

		56:
// 			WriteInterfaceHomeLimitSwitch(	q_etDiag	=> THIS^.etDiag,
// 											q_etDiagExt	=> THIS^.etDiagExtTPL,
// 											q_sMsg		=> THIS^.sMsg);
// 			
// 			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
// 				ExceptionDuringWriting();
// 				EXIT;
// 			END_IF
			
			THIS^.diCmdExecState := 57;

		57:
// 			WriteInterfaceHomeTorque(	q_etDiag	=> THIS^.etDiag,
// 										q_etDiagExt	=> THIS^.etDiagExtTPL,
// 										q_sMsg		=> THIS^.sMsg);
// 			
// 			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
// 				ExceptionDuringWriting();
// 				EXIT;
// 			END_IF
			
			THIS^.diCmdExecState := 581;
			
		581:
// 			WriteInterfaceHomeForce(	q_etDiag	=> THIS^.etDiag,
// 										q_etDiagExt	=> THIS^.etDiagExtTPL,
// 										q_sMsg		=> THIS^.sMsg);
// 			
// 			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
// 				ExceptionDuringWriting();
// 				EXIT;
// 			END_IF
			
			THIS^.diCmdExecState := 58;						

		58:
			WriteInterfaceHomeMoveOnPos(q_etDiag	=> THIS^.etDiag,
										q_etDiagExt	=> THIS^.etDiagExtTPL,
										q_sMsg		=> THIS^.sMsg);
			
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			
			THIS^.diCmdExecState := 59;

		59:
			WriteInterfaceHomeSetPos(	q_etDiag	=> THIS^.etDiag,
										q_etDiagExt	=> THIS^.etDiagExtTPL,
										q_sMsg		=> THIS^.sMsg);
			
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			
			THIS^.diCmdExecState := 60;

		60:
// 			WriteInterfaceHomeWritePos(	q_etDiag	=> THIS^.etDiag,
// 										q_etDiagExt	=> THIS^.etDiagExtTPL,
// 										q_sMsg		=> THIS^.sMsg);
// 			
// 			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
// 				ExceptionDuringWriting();
// 				EXIT;
// 			END_IF
			
			THIS^.diCmdExecState := 61;
			
		61:
			WriteInterfaceHomeEnd(	q_etDiag	=> THIS^.etDiag,
									q_etDiagExt	=> THIS^.etDiagExtTPL,
									q_sMsg		=> THIS^.sMsg);
			
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			
			THIS^.diCmdExecState := 62;

		62:
			WriteInterfaceManual(	q_etDiag	=> THIS^.etDiag,
									q_etDiagExt	=> THIS^.etDiagExtTPL,
									q_sMsg		=> THIS^.sMsg);
			
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			
			THIS^.diCmdExecState := 63;

		63:
			WriteInterfaceEndless(	q_etDiag	=> THIS^.etDiag,
									q_etDiagExt	=> THIS^.etDiagExtTPL,
									q_sMsg		=> THIS^.sMsg);
			
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			
			THIS^.diCmdExecState := 64;

		64:
			WriteInterfaceMultiCamStart(q_etDiag	=> THIS^.etDiag,
										q_etDiagExt	=> THIS^.etDiagExtTPL,
										q_sMsg		=> THIS^.sMsg);
			
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			
			THIS^.diCmdExecState := 65;
			
		65:
			WriteInterfaceMultiCamParamIn(	q_etDiag	=> THIS^.etDiag,
											q_etDiagExt	=> THIS^.etDiagExtTPL,
											q_sMsg		=> THIS^.sMsg);
			
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			
			THIS^.diCmdExecState := 66;

		66:
			WriteInterfaceMultiCamMotionParStart(	q_etDiag	=> THIS^.etDiag,
													q_etDiagExt	=> THIS^.etDiagExtTPL,
													q_sMsg		=> THIS^.sMsg);
			
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF

			(* loop over multiple cycles in state 67 and 68 *)
			(* FOR diMotionParCounter := 0 TO Gc_udiMaxNumberOfCamTables DO *)
			THIS^.diMotionParCounter := -1;

			THIS^.diCmdExecState := 67;
			
		67:
			IF (THIS^.i_xPrintCamData) THEN (* allow the user to protect his know-how *)
				IF (THIS^.diMotionParCounter < UDINT_TO_DINT(AXM_GPL.Gc_udiMaxNumberOfCamTables)) THEN (* loop over more than one cycle *)

					THIS^.diMotionParCounter := THIS^.diMotionParCounter + 1;

					WriteInterfaceMultiCamMotionParCyclicStart(	q_etDiag	=> THIS^.etDiag,
																q_etDiagExt	=> THIS^.etDiagExtTPL,
																q_sMsg		=> THIS^.sMsg);
					(* loop over multiple cycles in state 553 *)
					(* FOR diCamPointerCounter := 0 TO MAX_NO_OF_SEG DO *)
					THIS^.diCamPointCounter := 0;
					THIS^.diCmdExecState := 1000; (* switch to loop over CamPoints *)
				ELSE
					THIS^.diCmdExecState := 999;
				END_IF
			ELSE
				THIS^.fbTreeWriter.Parameter(	i_sName		:= 'data omitted', 
												i_sValue	:= 'because i_xPrintCamData is FALSE',
												q_etDiag	=> THIS^.etDiag,
												q_etDiagExt	=> THIS^.etDiagExtTPL,
												q_sMsg		=> THIS^.sMsg);
										
				IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
					ExceptionDuringWriting();
					EXIT;
				END_IF

				diCmdExecState := 999;
			END_IF
	
		1000:
			WriteInterfaceMultiCamMotionParCamPointStart(	q_etDiag	=> THIS^.etDiag,
															q_etDiagExt	=> THIS^.etDiagExtTPL,
															q_sMsg		=> THIS^.sMsg);
			
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			
			THIS^.diCmdExecState := 68;	
		
		68: (* loop over cam points using diCamPointerCounter *)
			IF (THIS^.diCamPointCounter <= 32) THEN
				
				WriteInterfaceMultiCamMotionParCamPoint(q_etDiag	=> THIS^.etDiag,
														q_etDiagExt	=> THIS^.etDiagExtTPL,
														q_sMsg		=> THIS^.sMsg);
														
				IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
					ExceptionDuringWriting();
					EXIT;
				END_IF
														
				THIS^.diCamPointCounter := THIS^.diCamPointCounter + 1;
			ELSE
				WriteInterfaceMultiCamMotionParCamPointEnd(	q_etDiag	=> THIS^.etDiag,
															q_etDiagExt	=> THIS^.etDiagExtTPL,
															q_sMsg		=> THIS^.sMsg);
															
				IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
					ExceptionDuringWriting();
					EXIT;
				END_IF
															
				THIS^.diCmdExecState := 1001;
			END_IF
			
		1001:
				WriteInterfaceMultiCamMotionParCyclicEnd(	q_etDiag	=> THIS^.etDiag,
															q_etDiagExt	=> THIS^.etDiagExtTPL,
															q_sMsg		=> THIS^.sMsg);
															
				IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
					ExceptionDuringWriting();
					EXIT;
				END_IF
															
				THIS^.diCmdExecState := 67;	
		999:
			WriteInterfaceMultiCamMotionParEnd(	q_etDiag	=> THIS^.etDiag,
												q_etDiagExt	=> THIS^.etDiagExtTPL,
												q_sMsg		=> THIS^.sMsg);
			
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			
			THIS^.diCmdExecState := 70;
			
	
		70:
			WriteInterfaceMultiCamExt(	q_etDiag	=> THIS^.etDiag,
										q_etDiagExt	=> THIS^.etDiagExtTPL,
										q_sMsg		=> THIS^.sMsg);
			
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			
			THIS^.diCmdExecState := 71;
			
		71:
			WriteInterfaceMultiCamParamOut(	q_etDiag	=> THIS^.etDiag,
											q_etDiagExt	=> THIS^.etDiagExtTPL,
											q_sMsg		=> THIS^.sMsg);
			
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			
			THIS^.diCmdExecState := 72;
			
		72:
			WriteInterfaceMultiCamParamOutActualCamData(	q_etDiag	=> THIS^.etDiag,
															q_etDiagExt	=> THIS^.etDiagExtTPL,
															q_sMsg		=> THIS^.sMsg);
			
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			
			THIS^.diCmdExecState := 73;

		73:
			WriteInterfaceMultiCamEnd(	q_etDiag	=> THIS^.etDiag,
										q_etDiagExt	=> THIS^.etDiagExtTPL,
										q_sMsg		=> THIS^.sMsg);
			
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			
			THIS^.diCmdExecState := 74;
		
		74:
			WriteInterfacePos(	q_etDiag	=> THIS^.etDiag,
								q_etDiagExt	=> THIS^.etDiagExtTPL,
								q_sMsg		=> THIS^.sMsg);
			
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			
			THIS^.diCmdExecState := 75;
			
		75:
			WriteInterfaceBrake(q_etDiag	=> THIS^.etDiag,
								q_etDiagExt	=> THIS^.etDiagExtTPL,
								q_sMsg		=> THIS^.sMsg);
			
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			
			THIS^.diCmdExecState := 76;		
			
		76:
			WriteInterfaceAdditionalMode(	q_etDiag	=> THIS^.etDiag,
											q_etDiagExt	=> THIS^.etDiagExtTPL,
											q_sMsg		=> THIS^.sMsg);
			
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF
			
			THIS^.diCmdExecState := 77;				

		77:

			WriteInterfaceEnd(	q_etDiag	=> THIS^.etDiag,
								q_etDiagExt	=> THIS^.etDiagExtTPL,
								q_sMsg		=> THIS^.sMsg);
			
			IF THIS^.etDiag <> GD.ET_Diag.Ok THEN
				ExceptionDuringWriting();
				EXIT;
			END_IF

			THIS^.diCmdExecState := 3; (* go to next module *)
			
	END_CASE
	
	(* check again whether we can continue writing *)
	TPL.FC_CanContinueWriting(iq_stCanContinueWriting := THIS^.iq_stComStructure.iq_stCanContinueWriting);
END_WHILE
