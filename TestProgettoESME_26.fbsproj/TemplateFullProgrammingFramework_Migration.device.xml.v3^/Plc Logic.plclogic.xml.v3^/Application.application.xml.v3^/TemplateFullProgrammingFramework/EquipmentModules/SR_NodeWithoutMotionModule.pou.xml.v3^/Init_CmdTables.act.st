__METADATA__
{
  "v3Meta": {
    "objectGuid": "07c0eb84-5bd6-49a3-b1a4-642d4ace3d46",
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

(*********************************************************************************************************************)
(*** Prepare  ***)

TPL.FC_FirstLastStepEmptyTable(udiStepIndex, diStep);
astPrepareTable[udiStepIndex].sTitle					:= 'End';
astPrepareTable[udiStepIndex].udiModuleName				:= 0;
astPrepareTable[udiStepIndex].diStep					:= diStep;
astPrepareTable[udiStepIndex].diCMD						:= 0;
astPrepareTable[udiStepIndex].timTimeOut				:= T#0MS;
astPrepareTable[udiStepIndex].xEndCMD					:= TRUE;

TPL.FC_FirstCmdTable(iq_udiTableIndex:= udiTableIndex);
astListofCMDTables[udiTableIndex].sTitle				:= 'Prepare';
astListofCMDTables[udiTableIndex].diCMD					:= ET_Cmd.Prepare;
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Auto  ***)

TPL.FC_FirstLastStepEmptyTable(udiStepIndex, diStep);
astAutoTable[udiStepIndex].sTitle						:= 'End';
astAutoTable[udiStepIndex].udiModuleName				:= 0;
astAutoTable[udiStepIndex].diStep						:= diStep;
astAutoTable[udiStepIndex].diCMD						:= 0;
astAutoTable[udiStepIndex].timTimeOut					:= T#0MS;
astAutoTable[udiStepIndex].xEndCMD						:= TRUE;

TPL.FC_NextCmdTable(iq_udiTableIndex:= udiTableIndex);
astListofCMDTables[udiTableIndex].sTitle				:= 'Auto';
astListofCMDTables[udiTableIndex].diCMD					:= ET_Cmd.Auto;
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Manual  ***)

TPL.FC_FirstLastStepEmptyTable(udiStepIndex, diStep);
astManualTable[udiStepIndex].sTitle						:= 'End';
astManualTable[udiStepIndex].udiModuleName				:= 0;
astManualTable[udiStepIndex].diStep						:= diStep;
astManualTable[udiStepIndex].diCMD						:= 0;
astManualTable[udiStepIndex].timTimeOut					:= T#0MS;
astManualTable[udiStepIndex].xEndCMD					:= TRUE;

TPL.FC_NextCmdTable(iq_udiTableIndex:= udiTableIndex);
astListofCMDTables[udiTableIndex].sTitle				:= 'Manual';
astListofCMDTables[udiTableIndex].diCMD					:= ET_Cmd.Manual;
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Stop ***)

TPL.FC_FirstLastStepEmptyTable(udiStepIndex, diStep);
astStopTable[udiStepIndex].sTitle						:= 'End';
astStopTable[udiStepIndex].udiModuleName				:= 0;
astStopTable[udiStepIndex].diStep						:= diStep;
astStopTable[udiStepIndex].diCMD						:= 0;
astStopTable[udiStepIndex].timTimeOut					:= T#0MS;
astStopTable[udiStepIndex].xEndCMD						:= TRUE;

TPL.FC_NextCmdTable(iq_udiTableIndex:= udiTableIndex);
astListofCMDTables[udiTableIndex].sTitle				:= 'Stop';
astListofCMDTables[udiTableIndex].diCMD					:= ET_Cmd.Stop;
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Start ***)

TPL.FC_FirstLastStepEmptyTable(udiStepIndex, diStep);
astStartTable[udiStepIndex].sTitle						:= 'End';
astStartTable[udiStepIndex].udiModuleName				:= 0;
astStartTable[udiStepIndex].diStep						:= diStep;
astStartTable[udiStepIndex].diCMD						:= 0;
astStartTable[udiStepIndex].timTimeOut					:= T#0MS;
astStartTable[udiStepIndex].xEndCMD						:= TRUE;

TPL.FC_NextCmdTable(iq_udiTableIndex:= udiTableIndex);
astListofCMDTables[udiTableIndex].sTitle				:= 'Start';
astListofCMDTables[udiTableIndex].diCMD					:= ET_Cmd.Start;
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Abort ***)

TPL.FC_FirstLastStepEmptyTable(udiStepIndex, diStep);
astAbortTable[udiStepIndex].sTitle						:= 'End';
astAbortTable[udiStepIndex].udiModuleName				:= 0;
astAbortTable[udiStepIndex].diStep						:= diStep;
astAbortTable[udiStepIndex].diCMD						:= 0;
astAbortTable[udiStepIndex].timTimeOut					:= T#0MS;
astAbortTable[udiStepIndex].xEndCMD						:= TRUE;

TPL.FC_NextCmdTable(iq_udiTableIndex:= udiTableIndex);
astListofCMDTables[udiTableIndex].sTitle				:= 'Abort';
astListofCMDTables[udiTableIndex].diCMD					:= ET_Cmd.Abort;
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Hold ***)

TPL.FC_FirstLastStepEmptyTable(udiStepIndex, diStep);
astHoldTable[udiStepIndex].sTitle						:= 'End';
astHoldTable[udiStepIndex].udiModuleName				:= 0;
astHoldTable[udiStepIndex].diStep						:= diStep;
astHoldTable[udiStepIndex].diCMD						:= 0;
astHoldTable[udiStepIndex].timTimeOut					:= T#0MS;
astHoldTable[udiStepIndex].xEndCMD						:= TRUE;

TPL.FC_NextCmdTable(iq_udiTableIndex:= udiTableIndex);
astListofCMDTables[udiTableIndex].sTitle				:= 'Hold';
astListofCMDTables[udiTableIndex].diCMD					:= ET_Cmd.Hold;
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Brake Release ***)

TPL.FC_FirstLastStepEmptyTable(udiStepIndex, diStep);
astBrakeReleaseTable[udiStepIndex].sTitle				:= 'End';
astBrakeReleaseTable[udiStepIndex].udiModuleName		:= 0;
astBrakeReleaseTable[udiStepIndex].diStep				:= diStep;
astBrakeReleaseTable[udiStepIndex].diCMD				:= 0;
astBrakeReleaseTable[udiStepIndex].timTimeOut			:= T#0MS;
astBrakeReleaseTable[udiStepIndex].xEndCMD				:= TRUE;

TPL.FC_NextCmdTable(iq_udiTableIndex:= udiTableIndex);
astListofCMDTables[udiTableIndex].sTitle				:= 'Brake Release';
astListofCMDTables[udiTableIndex].diCMD					:= ET_Cmd.BrakeRelease;
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(* End of system generated code, could be modified for your application *)
