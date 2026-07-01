__METADATA__
{
  "v3Meta": {
    "objectGuid": "1d297d7a-351d-4413-92a7-7626813427e9",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* System generated code, could be modified for your application *)

(* Module Group declaration *)

(* aaudiSubModuleGroups[c_udiAlphaGroup1-TPL.GCL.Gc_udiGroupOffset,TPL.ET_Group.Member1]	:= c_udiMaster; *)	(* The c_diMaster is the first element of the group c_diAlphaGroup1 *)
(* aaudiSubModuleGroups[c_udiAlphaGroup1-TPL.GCL.Gc_udiGroupOffset,TPL.ET_Group.Member2]	:= 0;			*)	(* There is no second element of the group c_diAlphaGroup1 *)

(* aaudiSubModuleGroups[c_udiAlphaGroup2-TPL.GCL.Gc_udiGroupOffset,TPL.ET_Group.Member1]	:= 0;			*)	(* There is no first element of the group c_diAlphaGroup2 *)
(* aaudiSubModuleGroups[c_udiAlphaGroup2-TPL.GCL.Gc_udiGroupOffset,TPL.ET_Group.Member2]	:= 0;			*)	(* There is no second element of the group c_diAlphaGroup2 *)

(* End of system generated code, could be modified for your application *)


(* System generated code, do not change without consulting 'Schneider Electric Automation GmbH' - otherwise you risk instability!!!*)
xInitSubModulesException := FALSE;

(*****************************************************************************************************************************************************)
(* Set IDs of SubModules *)	

TPL.FC_SetSubModuleIds(	i_udiMainModuleId			:= iq_stStandardModuleItf.i_udiModuleId,
						i_pstSubModulesItf			:= ADR(astSubModuleInterface),
						i_udiNumberOfSubModules		:= c_udiNumberOfSubModules,
						q_etDiag					=> etDiag,
						q_etDiagExt					=> etDiagExtTPL);
					
IF etDiag <> GD.ET_Diag.Ok AND NOT xInitSubModulesException THEN
	xInitSubModulesException := TRUE;
	
	stInitSubModulesException.sMsg := SE_CTBX.FC_MultiConcat(	i_sString1 := 'SetSubModuleIds - ', 
															i_sString2 := GD.FC_EtDiagToString(i_etDiag := etDiag), 
															i_sString3 := ' - ', 
															i_sString4 := TPL.FC_EtDiagExtToString(i_etDiagExt := etDiagExtTPL));
END_IF	

(*****************************************************************************************************************************************************)
(* Set exception if any exception occurred *)

fbExceptionHandler.SetException(i_xExceptionActive	:= xInitSubModulesException, 
								iq_stException		:= stInitSubModulesException, 
								iq_stExceptionList	:= iq_stExceptionList);

xInitSuccessful := xInitSuccessful AND NOT xInitSubModulesException;
					
etDiag := GD.ET_Diag.Ok;
(* End of system generated code, do not change without consulting 'Schneider Electric Automation GmbH' - otherwise you risk instability!!!*)
