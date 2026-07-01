__METADATA__
{
  "v3Meta": {
    "objectGuid": "a5c3a94c-3ebd-4da7-9869-962562374214",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* Begin of area for vis control fbs of different module types *)
(* SetCurrentModule(); has to be called after each special vis-controller, because it could have requested to change the current module via diSetAsCurrentModule *)

vpiq_fbAxisModuleVisController(	i_xEnable				:= vpq_xDoEnable, 
								i_pstMachineStandardItf	:= ADR(SR_MainMachine.stMachineInterface),
								i_pstCurrentStandardItf	:= pstCurrent, 
								i_dwCurrentAddItf		:= dwCurrentAddInterface, 
								i_xUpdateData			:= xUpdateForOtherFBs,
								i_udiCurrentJogTarget	:= G_udiManualModuleSelect, 
								iq_stExceptionList		:= G_stExceptionList,
								iq_stLogDataList		:= G_stLogDataList,
								q_xActive				=> , 
								q_xReady				=> , 
								q_etDiag				=> , 
								q_etDiagExt				=> , 
								q_sMsg					=> , 
								q_udiSetAsCurrentModule	=> udiSetAsCurrentModule,
								q_udiSetAsJogTarget		=> udiSetAsJogTarget);
SetCurrentModule();

(* Example *)
vpiq_fbExampleLeafModuleVisController(	i_xEnable				:= vpq_xDoEnable, 
										i_pstMachineStandardItf	:= ADR(SR_MainMachine.stMachineInterface), 
										i_pstCurrentStandardItf	:= pstCurrent, 
										i_dwCurrentAddItf		:= dwCurrentAddInterface, 
										i_xUpdateData			:= xUpdateForOtherFBs, 
										i_udiCurrentJogTarget	:= G_udiManualModuleSelect, 
										iq_stExceptionList		:= G_stExceptionList,
										iq_stLogDataList		:= G_stLogDataList, 
										q_xActive				=> , 
										q_xReady				=> , 
										q_etDiag				=> , 
										q_etDiagExt				=> , 
										q_sMsg					=> , 
										q_udiSetAsCurrentModule	=> udiSetAsCurrentModule, 
										q_udiSetAsJogTarget		=> udiSetAsJogTarget);
SetCurrentModule();


(* RoboticModule *)
(*vpiq_fbRoboticModuleVisController(	i_xEnable				:= vpq_xDoEnable, 
									i_pstMachineStandardItf	:= ADR(SR_MainMachine.stMachineInterface),
									i_pstCurrentStandardItf	:= pstCurrent, 
									i_dwCurrentAddItf		:= dwCurrentAddInterface, 
									i_xUpdateData			:= xUpdateForOtherFBs,
									i_udiCurrentJogTarget	:= G_udiManualModuleSelect, 
									iq_stExceptionList		:= G_stExceptionList,
									iq_stLogDataList		:= G_stLogDataList,
									q_xActive				=> , 
									q_xReady				=> , 
									q_etDiag				=> , 
									q_etDiagExt				=> , 
									q_sMsg					=> , 
									q_udiSetAsCurrentModule	=> udiSetAsCurrentModule,
									q_udiSetAsJogTarget		=> udiSetAsJogTarget);
SetCurrentModule();*)
