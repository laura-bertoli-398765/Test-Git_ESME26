__METADATA__
{
  "v3Meta": {
    "objectGuid": "f2d2e484-6884-4786-b8dd-c5ea0acc81f5",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
stUserException1.etDiag														:= GD.ET_Diag.ExecutionAborted;
stUserException1.udiDiagExt													:= ET_DiagExt.Exception1FromVis;
stUserException1.sDiagExt													:= FC_EtDiagExtToString(ET_DiagExt.Exception1FromVis);
stUserException1.sMsg														:= 'Test Exception 1 from visualization - TPL.ET_Reaction.AsyncStop';
stUserException1.udiModuleId												:= vpq_stMachineInterface.i_udiModuleId;
stUserException1.sModuleName												:= vpq_stMachineInterface.i_sModuleName;
stUserException1.etSource													:= TPL.ET_ExceptionSource.Vis;
stUserException1.timDelayTime												:= T#0MS;
stUserException1.wHmiAttributes												:= 0;
stUserException1.xAutoQuit													:= FALSE;
stUserException1.stReaction.axReaction[TPL.ET_Reaction.AsyncStop]			:= TRUE;

stUserException2.etDiag														:= GD.ET_Diag.ExecutionAborted;
stUserException2.udiDiagExt													:= ET_DiagExt.Exception2FromVis;
stUserException2.sDiagExt													:= FC_EtDiagExtToString(ET_DiagExt.Exception2FromVis);
stUserException2.sMsg														:= 'Test Exception 2 from visualization - TPL.ET_Reaction.SyncStopEL';
stUserException2.udiModuleId												:= vpq_stMachineInterface.i_udiModuleId;
stUserException2.sModuleName												:= vpq_stMachineInterface.i_sModuleName;
stUserException2.etSource													:= TPL.ET_ExceptionSource.Vis;
stUserException2.timDelayTime												:= T#0MS;
stUserException2.wHmiAttributes												:= 0;
stUserException2.xAutoQuit													:= FALSE;
stUserException2.stReaction.axReaction[TPL.ET_Reaction.SyncStopEL]			:= TRUE;

stUserException3.etDiag														:= GD.ET_Diag.ExecutionAborted;
stUserException3.udiDiagExt													:= ET_DiagExt.Exception3FromVis;
stUserException3.sDiagExt													:= FC_EtDiagExtToString(ET_DiagExt.Exception3FromVis);
stUserException3.sMsg														:= 'Test Exception 3 from visualization - TPL.ET_Reaction.SyncStopEH';
stUserException3.udiModuleId												:= vpq_stMachineInterface.i_udiModuleId;
stUserException3.sModuleName												:= vpq_stMachineInterface.i_sModuleName;
stUserException3.etSource													:= TPL.ET_ExceptionSource.Vis;
stUserException3.timDelayTime												:= T#0MS;
stUserException3.wHmiAttributes												:= 0;
stUserException3.xAutoQuit													:= FALSE;
stUserException3.stReaction.axReaction[TPL.ET_Reaction.SyncStopEH]			:= TRUE;

stUserException4.etDiag														:= GD.ET_Diag.ExecutionAborted;
stUserException4.udiDiagExt													:= ET_DiagExt.Exception4FromVis;
stUserException4.sDiagExt													:= FC_EtDiagExtToString(ET_DiagExt.Exception4FromVis);
stUserException4.sMsg														:= 'Test Exception 4 from visualization - TPL.ET_Reaction.StopEndOfCycle';
stUserException4.udiModuleId												:= vpq_stMachineInterface.i_udiModuleId;
stUserException4.sModuleName												:= vpq_stMachineInterface.i_sModuleName;
stUserException4.etSource													:= TPL.ET_ExceptionSource.Vis;
stUserException4.timDelayTime												:= T#0MS;
stUserException4.wHmiAttributes												:= 0;
stUserException4.xAutoQuit													:= FALSE;
stUserException4.stReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle]		:= TRUE;

stUserException5.etDiag														:= GD.ET_Diag.ExecutionAborted;
stUserException5.udiDiagExt													:= ET_DiagExt.Exception5FromVis;
stUserException5.sDiagExt													:= FC_EtDiagExtToString(ET_DiagExt.Exception5FromVis);
stUserException5.sMsg														:= 'Test Exception 5 from visualization - TPL.ET_Reaction.MainsContactorOff';
stUserException5.udiModuleId												:= vpq_stMachineInterface.i_udiModuleId;
stUserException5.sModuleName												:= vpq_stMachineInterface.i_sModuleName;
stUserException5.etSource													:= TPL.ET_ExceptionSource.Vis;
stUserException5.timDelayTime												:= T#0MS;
stUserException5.wHmiAttributes												:= 0;
stUserException5.xAutoQuit													:= FALSE;
stUserException5.stReaction.axReaction[TPL.ET_Reaction.MainsContactorOff]	:= TRUE;
stUserException5.stReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle]		:= TRUE;
