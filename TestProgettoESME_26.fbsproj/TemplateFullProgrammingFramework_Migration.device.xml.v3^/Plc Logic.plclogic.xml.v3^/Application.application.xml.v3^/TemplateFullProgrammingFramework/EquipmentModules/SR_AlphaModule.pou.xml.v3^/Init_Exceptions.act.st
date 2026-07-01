__METADATA__
{
  "v3Meta": {
    "objectGuid": "66c3aa4c-d1dd-4553-8c41-347743c7d766",
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
stUpdateStructsException.etDiag												:= GD.ET_Diag.UnexpectedProgramBehavior;
stUpdateStructsException.udiDiagExt											:= ET_DiagExt.UpdateStructsException;
stUpdateStructsException.sDiagExt											:= FC_EtDiagExtToString(i_etDiagExt := stUpdateStructsException.udiDiagExt);
stUpdateStructsException.sMsg												:= '';	(* Replaced on usage *)
stUpdateStructsException.udiModuleId										:= iq_stStandardModuleItf.i_udiModuleId;
stUpdateStructsException.sModuleName										:= iq_stStandardModuleItf.i_sModuleName;
stUpdateStructsException.stReaction.axReaction[TPL.ET_Reaction.AsyncStop]	:= TRUE;
stUpdateStructsException.etSource											:= TPL.ET_ExceptionSource.NodeModule;
stUpdateStructsException.timDelayTime										:= T#0MS;
stUpdateStructsException.wHmiAttributes										:= 0;
stUpdateStructsException.xAutoQuit											:= FALSE;

stInitReactionsException.etDiag												:= GD.ET_Diag.UnexpectedProgramBehavior;
stInitReactionsException.udiDiagExt											:= ET_DiagExt.InitReactionsException;
stInitReactionsException.sDiagExt											:= FC_EtDiagExtToString(i_etDiagExt := stInitReactionsException.udiDiagExt);
stInitReactionsException.sMsg												:= '';	(* Replaced on usage *)
stInitReactionsException.udiModuleId										:= iq_stStandardModuleItf.i_udiModuleId;
stInitReactionsException.sModuleName										:= iq_stStandardModuleItf.i_sModuleName;
stInitReactionsException.stReaction.axReaction[TPL.ET_Reaction.AsyncStop]	:= TRUE;
stInitReactionsException.etSource											:= TPL.ET_ExceptionSource.NodeModule;
stInitReactionsException.timDelayTime										:= T#0MS;
stInitReactionsException.wHmiAttributes										:= 0;
stInitReactionsException.xAutoQuit											:= FALSE;

stInitSubModulesException.etDiag											:= GD.ET_Diag.UnexpectedProgramBehavior;
stInitSubModulesException.udiDiagExt										:= ET_DiagExt.InitSubModulesException;
stInitSubModulesException.sDiagExt											:= FC_EtDiagExtToString(i_etDiagExt := stInitSubModulesException.udiDiagExt);
stInitSubModulesException.sMsg												:= '';	(* Replaced on usage *)
stInitSubModulesException.udiModuleId										:= iq_stStandardModuleItf.i_udiModuleId;
stInitSubModulesException.sModuleName										:= iq_stStandardModuleItf.i_sModuleName;
stInitSubModulesException.stReaction.axReaction[TPL.ET_Reaction.AsyncStop]	:= TRUE;
stInitSubModulesException.etSource											:= TPL.ET_ExceptionSource.NodeModule;
stInitSubModulesException.timDelayTime										:= T#0MS;
stInitSubModulesException.wHmiAttributes									:= 0;
stInitSubModulesException.xAutoQuit											:= FALSE;

stIsDriveVirtualException.etDiag											:= GD.ET_Diag.InputParameterInvalid;
stIsDriveVirtualException.udiDiagExt										:= ET_DiagExt.DriveInvalid;
stIsDriveVirtualException.sDiagExt											:= FC_EtDiagExtToString(i_etDiagExt := stIsDriveVirtualException.udiDiagExt);
stIsDriveVirtualException.sMsg												:= '';	(* Replaced on usage *)
stIsDriveVirtualException.udiModuleId										:= iq_stStandardModuleItf.i_udiModuleId;
stIsDriveVirtualException.sModuleName										:= iq_stStandardModuleItf.i_sModuleName;
stIsDriveVirtualException.stReaction.axReaction[TPL.ET_Reaction.AsyncStop]	:= TRUE;
stIsDriveVirtualException.etSource											:= TPL.ET_ExceptionSource.NodeModule;
stIsDriveVirtualException.timDelayTime										:= T#0MS;
stIsDriveVirtualException.wHmiAttributes									:= 0;
stIsDriveVirtualException.xAutoQuit											:= FALSE;

(*------------------------------------------------------------------------------------------*)
(* Init User Exceptions *)

	// TPL.ET_Reaction.AsyncStop
	// TPL.ET_Reaction.SyncStopEL
	// TPL.ET_Reaction.SyncStopEH
	// TPL.ET_Reaction.StopEndOfCycle
	// TPL.ET_Reaction.MainsContactorOff

(*------------------------------------------------------------------------------------------*)
stUserException1.etDiag													:= GD.ET_Diag.ExecutionAborted;
stUserException1.udiDiagExt												:= ET_DiagExtUser.Exception1FromEquipmentModule;
stUserException1.sDiagExt												:= FC_EtDiagExtUserToString(i_etDiagExt := stUserException1.udiDiagExt);
stUserException1.sMsg													:= 'User Exception 1';
stUserException1.udiModuleId											:= iq_stStandardModuleItf.i_udiModuleId;
stUserException1.sModuleName											:= iq_stStandardModuleItf.i_sModuleName;
stUserException1.stReaction.axReaction[TPL.GCL.Gc_udiUserReactionOffset+2]	:= TRUE;
stUserException1.etSource												:= TPL.ET_ExceptionSource.User;
stUserException1.timDelayTime											:= T#0MS;
stUserException1.wHmiAttributes											:= 0;
stUserException1.xAutoQuit												:= FALSE;

stUserException2.etDiag													:= GD.ET_Diag.ExecutionAborted;
stUserException2.udiDiagExt												:= ET_DiagExtUser.Exception2FromEquipmentModule;
stUserException2.sDiagExt												:= FC_EtDiagExtUserToString(i_etDiagExt := stUserException2.udiDiagExt);
stUserException2.sMsg													:= 'User Exception 2';
stUserException2.udiModuleId											:= iq_stStandardModuleItf.i_udiModuleId;
stUserException2.sModuleName											:= iq_stStandardModuleItf.i_sModuleName;
stUserException2.stReaction.axReaction[TPL.GCL.Gc_udiUserReactionOffset+2]	:= TRUE;
stUserException2.etSource												:= TPL.ET_ExceptionSource.User;
stUserException2.timDelayTime											:= T#0MS;
stUserException2.wHmiAttributes											:= 0;
stUserException2.xAutoQuit												:= FALSE;

(* End of system generated code, could be modified for your application *)
