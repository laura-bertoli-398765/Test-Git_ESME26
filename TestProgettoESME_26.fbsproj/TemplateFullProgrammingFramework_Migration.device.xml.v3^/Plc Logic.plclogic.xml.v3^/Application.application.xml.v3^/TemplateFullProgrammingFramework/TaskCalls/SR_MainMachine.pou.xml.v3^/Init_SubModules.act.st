__METADATA__
{
  "v3Meta": {
    "objectGuid": "acd428a2-042b-4845-b945-fa15c802a60e",
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

aaudiSubModuleGroups[c_udiMasterGroup-TPL.GCL.Gc_udiGroupOffset,TPL.ET_Group.Member1]	:= c_udiAlpha;		(* The c_udiAlpha is the first element of the group c_udiMasterGroup *)
aaudiSubModuleGroups[c_udiMasterGroup-TPL.GCL.Gc_udiGroupOffset,TPL.ET_Group.Member2]	:= 0;				(* There is no second element of the group c_udiMasterGroup *)

aaudiSubModuleGroups[c_udiSlaveGroup-TPL.GCL.Gc_udiGroupOffset,TPL.ET_Group.Member1]	:= c_udiBravo;		(* The c_udiBravo is the first element of the group c_udiSlaveGroup *)
aaudiSubModuleGroups[c_udiSlaveGroup-TPL.GCL.Gc_udiGroupOffset,TPL.ET_Group.Member2]	:= c_udiCharly;		(* The c_udiCharly is the second element of the group c_udiSlaveGroup *)


(* Configuration of exception logging *)
G_stLogDataList.wExceptionLogDataFilter	:= UDINT_TO_WORD(TPL.ET_LogDataFilter.ExceptionListDefault);

(* Exception in case of an overflow of the exception list - Set ModuleId and ModuleName *)
G_stExceptionList.stOverflowException.udiModuleId	:= stMachineInterface.i_udiModuleId;
G_stExceptionList.stOverflowException.sModuleName	:= stMachineInterface.i_sModuleName;


(* Example, how to modify the reaction of the overflow exception, by default all reactions are set *)
// FC_ReinitReaction(iq_stException := G_stExceptionList.stOverflowError); //set reaction to no reaction
// G_stExceptionList.stOverflowException.stReaction.axReaction[TPL.ET_Reaction.AsyncStop] := TRUE;
// G_stExceptionList.stOverflowException.stReaction.axReaction[TPL.ET_Reaction.MainsContactorOff] := TRUE; //ensure that the worst possible reactions for your machine are set


(* Set logger save file name and path *)
G_stLoggerInterface.i_sFileName		:= '$$ram0$$/TPL_LOG.XML';					(* './TPL_LOG.XML', ''$$ram0$$/TPL_LOG.CSV', *)
G_stLoggerInterface.i_xEnable		:= TRUE;
G_stLoggerInterface.i_etSortKey		:= TPL.ET_LogDataSortKey.SortByTime;	(*	TPL.ET_LogDataSortKey.SortByCmd
																				TPL.ET_LogDataSortKey.SortById
																				TPL.ET_LogDataSortKey.SortByModuleId
																				TPL.ET_LogDataSortKey.SortByModuleIdAndTime
																				TPL.ET_LogDataSortKey.SortByName
																				TPL.ET_LogDataSortKey.SortByReaction
																				TPL.ET_LogDataSortKey.SortByTime *)

(* End of system generated code, could be modified for your application *)

(* System generated code, do not change without consulting 'Schneider Electric Automation GmbH' - otherwise you risk instability!!!*)
xInitSubModulesException := FALSE;

(*****************************************************************************************************************************************************)
(* Set IDs of SubModules *)	

TPL.FC_SetSubModuleIds(	i_udiMainModuleID			:= stMachineInterface.i_udiModuleId,
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
								iq_stExceptionList	:= G_stExceptionList);

xInitSuccessful := xInitSuccessful AND NOT xInitSubModulesException;
					
etDiag := GD.ET_Diag.Ok;
					
(* End of system generated code, do not change without consulting 'Schneider Electric Automation GmbH' - otherwise you risk instability!!!*)
