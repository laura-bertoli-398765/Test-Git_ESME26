__METADATA__
{
  "v3Meta": {
    "objectGuid": "4aa47ba2-99d8-49fa-95b1-7f556ffac844",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* System generated code, only to be changed by experienced programmers *)
IF c_udiNumberOfSubModules < 1 THEN
	RETURN;
END_IF

(* Change of default reactions only on demand *)
(* Compare SR MainMachine Action Init_Reactions *)

xInitReactionsException := FALSE;

(*****************************************************************************************************************************************************)
(* Init ReactionTranslationMode *)

TPL.FC_InitReactionTranslationMode(	i_udiNumberOfSubModules			:= c_udiNumberOfSubModules,
									i_petReactionTranslationMode	:= ADR(aetReactionTranslationMode),
									q_etDiag						=> etDiag,
									q_etDiagExt						=> etDiagExtTPL);
							
IF etDiag <> GD.ET_Diag.Ok AND NOT xInitReactionsException THEN
	xInitReactionsException := TRUE;
	
	stInitReactionsException.sMsg := SE_CTBX.FC_MultiConcat(i_sString1 := 'InitReactionTranslationMode - ', 
														i_sString2 := GD.FC_EtDiagToString(i_etDiag := etDiag), 
														i_sString3 := ' - ', 
														i_sString4 := TPL.FC_EtDiagExtToString(i_etDiagExt := etDiagExtTPL));
END_IF	

(*****************************************************************************************************************************************************)
(* Init ReactionTranslationTable *)	

TPL.FC_InitReactionTranslationTable(i_udiNumberOfSubModules			:= c_udiNumberOfSubModules,
									i_pstReactionTranslationTable	:= ADR(aastReactionTranslationTable),
									q_etDiag						=> etDiag,
									q_etDiagExt						=> etDiagExtTPL);
									
IF etDiag <> GD.ET_Diag.Ok AND NOT xInitReactionsException THEN
	xInitReactionsException := TRUE;
	
	stInitReactionsException.sMsg := SE_CTBX.FC_MultiConcat(i_sString1 := 'InitReactionTranslationTable - ', 
														i_sString2 := GD.FC_EtDiagToString(i_etDiag := etDiag), 
														i_sString3 := ' - ', 
														i_sString4 := TPL.FC_EtDiagExtToString(i_etDiagExt := etDiagExtTPL));
END_IF		

(*****************************************************************************************************************************************************)
(* Init ReactionTranslationJobs *)	
								
TPL.FC_InitReactionTranslationJobs( i_udiNumberOfSubModules			:= c_udiNumberOfSubModules,
									i_pstReactionTranslationJobs	:= ADR(astReactionTranslationJobs),
									q_etDiag						=> etDiag,
									q_etDiagExt						=> etDiagExtTPL);
						
IF etDiag <> GD.ET_Diag.Ok AND NOT xInitReactionsException THEN
	xInitReactionsException := TRUE;
	
	stInitReactionsException.sMsg := SE_CTBX.FC_MultiConcat(i_sString1 := 'InitReactionTranslationJobs - ', 
														i_sString2 := GD.FC_EtDiagToString(i_etDiag := etDiag), 
														i_sString3 := ' - ', 
														i_sString4 := TPL.FC_EtDiagExtToString(i_etDiagExt := etDiagExtTPL));
END_IF		

(*****************************************************************************************************************************************************)
(* Set exception if any exception occurred *)

fbExceptionHandler.SetException(i_xExceptionActive	:= xInitReactionsException, 
								iq_stException		:= stInitReactionsException, 
								iq_stExceptionList	:= iq_stExceptionList);
					
xInitSuccessful := xInitSuccessful AND NOT xInitReactionsException;

etDiag := GD.ET_Diag.Ok;
(* End of system generated code, only to be changed by experienced programmers *)
