__METADATA__
{
  "v3Meta": {
    "objectGuid": "d5271a6d-a6e9-4aab-aa5b-8f45a48dc59c",
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

(*
	TPL.ET_Reaction.AsyncStop
	TPL.ET_Reaction.SyncStopEL
	TPL.ET_Reaction.SyncStopEH
	TPL.ET_Reaction.StopEndOfCycle
	TPL.ET_Reaction.MainsContactorOff
*)

(*------------------------------------------------------------------------------------------*)
(* Init System Exceptions *)
(*------------------------------------------------------------------------------------------*)

stSystemException1.etDiag														:= GD.ET_Diag.Ok; (* Replaced on usage *)
stSystemException1.udiDiagExt													:= ET_DiagExt.Ok; (* Replaced on usage *)
stSystemException1.sDiagExt														:= FC_EtDiagExtToString(ET_DiagExt.Ok); (* Replaced on usage *)
stSystemException1.sMsg															:= ''; (* Replaced on usage *)
stSystemException1.udiModuleId													:= stMachineInterface.i_udiModuleId;
stSystemException1.sModuleName													:= stMachineInterface.i_sModuleName;
stSystemException1.etSource														:= TPL.ET_ExceptionSource.Main;
stSystemException1.timDelayTime													:= T#0MS;
stSystemException1.wHmiAttributes												:= 0;
stSystemException1.xAutoQuit													:= FALSE;
stSystemException1.stReaction.axReaction[TPL.ET_Reaction.AsyncStop]				:= TRUE;

stSystemException2.etDiag														:= GD.ET_Diag.Ok; (* Replaced on usage *)
stSystemException2.udiDiagExt													:= ET_DiagExt.Ok; (* Replaced on usage *)
stSystemException2.sDiagExt														:= FC_EtDiagExtToString(ET_DiagExt.Ok); (* Replaced on usage *)
stSystemException2.sMsg															:= ''; (* Replaced on usage *)
stSystemException2.udiModuleId													:= stMachineInterface.i_udiModuleId;
stSystemException2.sModuleName													:= stMachineInterface.i_sModuleName;
stSystemException2.etSource														:= TPL.ET_ExceptionSource.Main;
stSystemException2.timDelayTime													:= T#0MS;
stSystemException2.wHmiAttributes												:= 0;
stSystemException2.xAutoQuit													:= FALSE;
stSystemException2.stReaction.axReaction[TPL.ET_Reaction.SyncStopEL]			:= TRUE;

stSystemException3.etDiag														:= GD.ET_Diag.Ok; (* Replaced on usage *)
stSystemException3.udiDiagExt													:= ET_DiagExt.Ok; (* Replaced on usage *)
stSystemException3.sDiagExt														:= FC_EtDiagExtToString(ET_DiagExt.Ok); (* Replaced on usage *)
stSystemException3.sMsg															:= ''; (* Replaced on usage *)
stSystemException3.udiModuleId													:= stMachineInterface.i_udiModuleId;
stSystemException3.sModuleName													:= stMachineInterface.i_sModuleName;
stSystemException3.etSource														:= TPL.ET_ExceptionSource.Main;
stSystemException3.timDelayTime													:= T#0MS;
stSystemException3.wHmiAttributes												:= 0;
stSystemException3.xAutoQuit													:= FALSE;
stSystemException3.stReaction.axReaction[TPL.ET_Reaction.SyncStopEH]			:= TRUE;

stEmergencyStopException.etDiag													:= GD.ET_Diag.ExecutionAborted;
stEmergencyStopException.udiDiagExt												:= ET_DiagExt.MainSystemEmergencyStop;
stEmergencyStopException.sDiagExt												:= FC_EtDiagExtToString(ET_DiagExt.MainSystemEmergencyStop);
stEmergencyStopException.sMsg													:= 'Emergency Stop';
stEmergencyStopException.udiModuleId											:= stMachineInterface.i_udiModuleId;
stEmergencyStopException.sModuleName											:= stMachineInterface.i_sModuleName;
stEmergencyStopException.etSource												:= TPL.ET_ExceptionSource.Main;
stEmergencyStopException.timDelayTime											:= T#0MS;
stEmergencyStopException.wHmiAttributes											:= 0;
stEmergencyStopException.xAutoQuit												:= FALSE;
stEmergencyStopException.stReaction.axReaction[TPL.ET_Reaction.SyncStopEL]		:= TRUE;

stContactorControlException.etDiag												:= GD.ET_Diag.Ok; (* Replaced on usage *)
stContactorControlException.udiDiagExt											:= ET_DiagExt.Ok; (* Replaced on usage *)
stContactorControlException.sDiagExt											:= FC_EtDiagExtToString(ET_DiagExt.Ok); (* Replaced on usage *)
stContactorControlException.sMsg												:= ''; (* Replaced on usage *)
stContactorControlException.udiModuleId											:= stMachineInterface.i_udiModuleId;
stContactorControlException.sModuleName											:= stMachineInterface.i_sModuleName;
stContactorControlException.etSource											:= TPL.ET_ExceptionSource.Main;
stContactorControlException.timDelayTime										:= T#0MS;
stContactorControlException.wHmiAttributes										:= 0;
stContactorControlException.xAutoQuit											:= FALSE;
stContactorControlException.stReaction.axReaction[TPL.ET_Reaction.AsyncStop]	:= TRUE;

stUpdateStructsException.etDiag													:= GD.ET_Diag.UnexpectedProgramBehavior;
stUpdateStructsException.udiDiagExt												:= ET_DiagExt.UpdateStructsException;
stUpdateStructsException.sDiagExt												:= FC_EtDiagExtToString(i_etDiagExt := stUpdateStructsException.udiDiagExt);
stUpdateStructsException.sMsg													:= '';	(* Replaced on usage *)
stUpdateStructsException.udiModuleId											:= stMachineInterface.i_udiModuleId;
stUpdateStructsException.sModuleName											:= stMachineInterface.i_sModuleName;
stUpdateStructsException.stReaction.axReaction[TPL.ET_Reaction.AsyncStop]		:= TRUE;
stUpdateStructsException.etSource												:= TPL.ET_ExceptionSource.Main;
stUpdateStructsException.timDelayTime											:= T#0MS;
stUpdateStructsException.wHmiAttributes											:= 0;
stUpdateStructsException.xAutoQuit												:= FALSE;

stInitReactionsException.etDiag													:= GD.ET_Diag.UnexpectedProgramBehavior;
stInitReactionsException.udiDiagExt												:= ET_DiagExt.InitReactionsException;
stInitReactionsException.sDiagExt												:= FC_EtDiagExtToString(i_etDiagExt := stInitReactionsException.udiDiagExt);
stInitReactionsException.sMsg													:= '';	(* Replaced on usage *)
stInitReactionsException.udiModuleId											:= stMachineInterface.i_udiModuleId;
stInitReactionsException.sModuleName											:= stMachineInterface.i_sModuleName;
stInitReactionsException.stReaction.axReaction[TPL.ET_Reaction.AsyncStop]		:= TRUE;
stInitReactionsException.etSource												:= TPL.ET_ExceptionSource.Main;
stInitReactionsException.timDelayTime											:= T#0MS;
stInitReactionsException.wHmiAttributes											:= 0;
stInitReactionsException.xAutoQuit												:= FALSE;

stInitSubModulesException.etDiag												:= GD.ET_Diag.UnexpectedProgramBehavior;
stInitSubModulesException.udiDiagExt											:= ET_DiagExt.InitSubModulesException;
stInitSubModulesException.sDiagExt												:= FC_EtDiagExtToString(i_etDiagExt := stInitSubModulesException.udiDiagExt);
stInitSubModulesException.sMsg													:= '';	(* Replaced on usage *)
stInitSubModulesException.udiModuleId											:= stMachineInterface.i_udiModuleId;
stInitSubModulesException.sModuleName											:= stMachineInterface.i_sModuleName;
stInitSubModulesException.stReaction.axReaction[TPL.ET_Reaction.AsyncStop]		:= TRUE;
stInitSubModulesException.etSource												:= TPL.ET_ExceptionSource.Main;
stInitSubModulesException.timDelayTime											:= T#0MS;
stInitSubModulesException.wHmiAttributes										:= 0;
stInitSubModulesException.xAutoQuit												:= FALSE;

(*------------------------------------------------------------------------------------------*)
(* Init User Exceptions *)
(*------------------------------------------------------------------------------------------*)	

stUserException1.etDiag															:= GD.ET_Diag.ExecutionAborted; (* Replaced on usage *)
stUserException1.udiDiagExt														:= ET_DiagExtUser.Exception1FromMain; (* Replaced on usage *)
stUserException1.sDiagExt														:= FC_EtDiagExtUserToString(i_etDiagExt := stUserException1.udiDiagExt); (* Replaced on usage *)
stUserException1.sMsg															:= 'User Exception 1'; (* To be replaced if used *)
stUserException1.udiModuleId													:= stMachineInterface.i_udiModuleId;
stUserException1.sModuleName													:= stMachineInterface.i_sModuleName;
stUserException1.etSource														:= TPL.ET_ExceptionSource.User;
stUserException1.timDelayTime													:= T#0MS;
stUserException1.wHmiAttributes													:= 0;
stUserException1.xAutoQuit														:= FALSE;
stUserException1.stReaction.axReaction[TPL.ET_Reaction.AsyncStop]				:= TRUE;

stUserException2.etDiag															:= GD.ET_Diag.ExecutionAborted; (* Replaced on usage *)
stUserException2.udiDiagExt														:= ET_DiagExtUser.Exception2FromMain; (* Replaced on usage *)
stUserException2.sDiagExt														:= FC_EtDiagExtUserToString(i_etDiagExt := stUserException2.udiDiagExt); (* Replaced on usage *)
stUserException2.sMsg															:= 'User Exception 2'; (* To be replaced if used *)
stUserException2.udiModuleId													:= stMachineInterface.i_udiModuleId;
stUserException2.sModuleName													:= stMachineInterface.i_sModuleName;
stUserException2.etSource														:= TPL.ET_ExceptionSource.User;
stUserException2.timDelayTime													:= T#0MS;
stUserException2.wHmiAttributes													:= 0;
stUserException2.xAutoQuit														:= FALSE;
stUserException2.stReaction.axReaction[TPL.ET_Reaction.SyncStopEL]				:= TRUE;

stUserException3.etDiag															:= GD.ET_Diag.ExecutionAborted; (* Replaced on usage *)
stUserException3.udiDiagExt														:= ET_DiagExtUser.Exception3FromMain; (* Replaced on usage *)
stUserException3.sDiagExt														:= FC_EtDiagExtUserToString(i_etDiagExt := stUserException3.udiDiagExt); (* Replaced on usage *)
stUserException3.sMsg															:= 'User Exception 3'; (* To be replaced if used *)
stUserException3.udiModuleId													:= stMachineInterface.i_udiModuleId;
stUserException3.sModuleName													:= stMachineInterface.i_sModuleName;
stUserException3.etSource														:= TPL.ET_ExceptionSource.User;
stUserException3.timDelayTime													:= T#0MS;
stUserException3.wHmiAttributes													:= 0;
stUserException3.xAutoQuit														:= TRUE;
stUserException3.stReaction.axReaction[TPL.ET_Reaction.SyncStopEH]				:= TRUE;

stUserException4.etDiag															:= GD.ET_Diag.ExecutionAborted; (* Replaced on usage *)
stUserException4.udiDiagExt														:= ET_DiagExtUser.Exception4FromMain; (* Replaced on usage *)
stUserException4.sDiagExt														:= FC_EtDiagExtUserToString(i_etDiagExt := stUserException4.udiDiagExt); (* Replaced on usage *)
stUserException4.sMsg															:= 'User Exception 4'; (* To be replaced if used *)	
stUserException4.udiModuleId													:= stMachineInterface.i_udiModuleId;
stUserException4.sModuleName													:= stMachineInterface.i_sModuleName;
stUserException4.etSource														:= TPL.ET_ExceptionSource.User;
stUserException4.timDelayTime													:= T#0MS;
stUserException4.wHmiAttributes													:= 0;
stUserException4.xAutoQuit														:= FALSE;
stUserException4.stReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle]			:= TRUE;

stUserException5.etDiag															:= GD.ET_Diag.ExecutionAborted; (* Replaced on usage *)
stUserException5.udiDiagExt														:= ET_DiagExtUser.Exception5FromMain; (* Replaced on usage *)
stUserException5.sDiagExt														:= FC_EtDiagExtUserToString(i_etDiagExt := stUserException5.udiDiagExt); (* Replaced on usage *)
stUserException5.sMsg															:= 'User Exception 5'; (* To be replaced if used *)		
stUserException5.udiModuleId													:= stMachineInterface.i_udiModuleId;
stUserException5.sModuleName													:= stMachineInterface.i_sModuleName;
stUserException5.etSource														:= TPL.ET_ExceptionSource.User;
stUserException5.timDelayTime													:= T#0MS;
stUserException5.wHmiAttributes													:= 0;
stUserException5.xAutoQuit														:= FALSE;
stUserException5.stReaction.axReaction[TPL.ET_Reaction.MainsContactorOff]		:= TRUE;
stUserException5.stReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle]			:= TRUE;

(* End of system generated code, could be modified for your application *)
