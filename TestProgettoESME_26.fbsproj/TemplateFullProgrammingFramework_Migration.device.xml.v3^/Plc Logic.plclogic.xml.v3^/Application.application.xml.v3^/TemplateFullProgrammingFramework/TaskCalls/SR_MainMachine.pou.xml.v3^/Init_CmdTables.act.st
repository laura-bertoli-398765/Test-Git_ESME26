__METADATA__
{
  "v3Meta": {
    "objectGuid": "5deb9ccf-f81f-4cb8-888c-a9ea4e5541e0",
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

TPL.FC_FirstStep(udiStepIndex, diStep);
astPrepareTable[udiStepIndex].sTitle					:= 'Prepare AllSubModules';
astPrepareTable[udiStepIndex].udiModuleName				:= TPL.GCL.Gc_udiAllSubModules;
astPrepareTable[udiStepIndex].diStep					:= diStep;
astPrepareTable[udiStepIndex].diCMD						:= ET_Cmd.Prepare;
astPrepareTable[udiStepIndex].timTimeOut				:= T#0MS;
astPrepareTable[udiStepIndex].xEndCMD					:= FALSE;

TPL.FC_LastStep(udiStepIndex, diStep);
astPrepareTable[udiStepIndex].sTitle					:= 'End';
astPrepareTable[udiStepIndex].udiModuleName				:= 0;
astPrepareTable[udiStepIndex].diStep					:= diStep;
astPrepareTable[udiStepIndex].diCMD						:= 0;
astPrepareTable[udiStepIndex].timTimeOut				:= T#0MS;
astPrepareTable[udiStepIndex].xEndCMD					:= TRUE;

TPL.FC_FirstCmdTable(iq_udiTableIndex:= udiTableIndex);
astListofCMDTables[udiTableIndex].diCMD					:= ET_Cmd.Prepare;
astListofCMDTables[udiTableIndex].sTitle				:= 'Prepare';
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Auto  ***)

TPL.FC_FirstStep(udiStepIndex, diStep);
astAutoTable[udiStepIndex].sTitle						:= 'Auto Bravo';
astAutoTable[udiStepIndex].udiModuleName				:= c_udiBravo;
astAutoTable[udiStepIndex].diStep						:= diStep;
astAutoTable[udiStepIndex].diCMD						:= ET_Cmd.Auto;
astAutoTable[udiStepIndex].timTimeOut					:= T#0MS;
astAutoTable[udiStepIndex].xEndCMD						:= FALSE;

// TPL.FC_NextStep(udiStepIndex, diStep);
// astAutoTable[udiStepIndex].sTitle						:= 'Auto Charly';
// astAutoTable[udiStepIndex].udiModuleName				:= c_udiCharly;
// astAutoTable[udiStepIndex].diStep						:= diStep;
// astAutoTable[udiStepIndex].diCMD						:= ET_Cmd.Auto;
// astAutoTable[udiStepIndex].timTimeOut					:= T#0MS;
// astAutoTable[udiStepIndex].xEndCMD						:= FALSE;

TPL.FC_NextStep(udiStepIndex, diStep);
astAutoTable[udiStepIndex].sTitle						:= 'Auto Alpha';
astAutoTable[udiStepIndex].udiModuleName				:= c_udiAlpha;
astAutoTable[udiStepIndex].diStep						:= diStep;
astAutoTable[udiStepIndex].diCMD						:= ET_Cmd.Auto;
astAutoTable[udiStepIndex].timTimeOut					:= T#0MS;
astAutoTable[udiStepIndex].xEndCMD						:= FALSE;

TPL.FC_LastStep(udiStepIndex, diStep);
astAutoTable[udiStepIndex].sTitle						:= 'End';
astAutoTable[udiStepIndex].udiModuleName				:= 0;
astAutoTable[udiStepIndex].diStep						:= diStep;
astAutoTable[udiStepIndex].diCMD						:= 0;
astAutoTable[udiStepIndex].timTimeOut					:= T#0MS;
astAutoTable[udiStepIndex].xEndCMD						:= TRUE;

TPL.FC_NextCmdTable(iq_udiTableIndex:= udiTableIndex);
astListofCMDTables[udiTableIndex].diCMD					:= ET_Cmd.Auto;
astListofCMDTables[udiTableIndex].sTitle				:= 'Auto';
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Manual  ***)

TPL.FC_FirstStep(udiStepIndex, diStep);
astManualTable[udiStepIndex].sTitle						:= 'Stop AllSubModules';
astManualTable[udiStepIndex].udiModuleName				:= TPL.GCL.Gc_udiAllSubModules;
astManualTable[udiStepIndex].diStep						:= diStep;
astManualTable[udiStepIndex].diCMD						:= ET_Cmd.Stop;
astManualTable[udiStepIndex].timTimeOut					:= T#0MS;
astManualTable[udiStepIndex].xEndCMD					:= FALSE;

TPL.FC_NextStep(udiStepIndex, diStep);
astManualTable[udiStepIndex].sTitle						:= 'Manual SlaveGroup';
astManualTable[udiStepIndex].udiModuleName				:= c_udiSlaveGroup;
astManualTable[udiStepIndex].diStep						:= diStep;
astManualTable[udiStepIndex].diCMD						:= ET_Cmd.Manual;
astManualTable[udiStepIndex].timTimeOut					:= T#0MS;
astManualTable[udiStepIndex].xEndCMD					:= FALSE;

TPL.FC_LastStep(udiStepIndex, diStep);
astManualTable[udiStepIndex].sTitle						:= 'End';
astManualTable[udiStepIndex].udiModuleName				:= 0;
astManualTable[udiStepIndex].diStep						:= diStep;
astManualTable[udiStepIndex].diCMD						:= 0;
astManualTable[udiStepIndex].timTimeOut					:= T#0MS;
astManualTable[udiStepIndex].xEndCMD					:= TRUE;

TPL.FC_NextCmdTable(iq_udiTableIndex:= udiTableIndex);
astListofCMDTables[udiTableIndex].diCMD					:= ET_Cmd.Manual;
astListofCMDTables[udiTableIndex].sTitle				:= 'Manual';
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Stop ***)

TPL.FC_FirstStep(udiStepIndex, diStep);
astStopTable[udiStepIndex].sTitle						:= 'Stop AllSubModules';
astStopTable[udiStepIndex].udiModuleName				:= TPL.GCL.Gc_udiAllSubModules;
astStopTable[udiStepIndex].diStep						:= diStep;
astStopTable[udiStepIndex].diCMD						:= ET_Cmd.Stop;
astStopTable[udiStepIndex].timTimeOut					:= T#0MS;
astStopTable[udiStepIndex].xEndCMD						:= FALSE;

TPL.FC_LastStep(udiStepIndex, diStep);
astStopTable[udiStepIndex].sTitle						:= 'End';
astStopTable[udiStepIndex].udiModuleName				:= 0;
astStopTable[udiStepIndex].diStep						:= diStep;
astStopTable[udiStepIndex].diCMD						:= 0;
astStopTable[udiStepIndex].timTimeOut					:= T#0MS;
astStopTable[udiStepIndex].xEndCMD						:= TRUE;

TPL.FC_NextCmdTable(iq_udiTableIndex:= udiTableIndex);
astListofCMDTables[udiTableIndex].diCMD					:= ET_Cmd.Stop;
astListofCMDTables[udiTableIndex].sTitle				:= 'Stop';
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Start ***)

TPL.FC_FirstStep(udiStepIndex, diStep);
astStartTable[udiStepIndex].sTitle						:= 'Start AllSubModules';
astStartTable[udiStepIndex].udiModuleName				:= TPL.GCL.Gc_udiAllSubModules;
astStartTable[udiStepIndex].diStep						:= diStep;
astStartTable[udiStepIndex].diCMD						:= ET_Cmd.Start;
astStartTable[udiStepIndex].timTimeOut					:= T#0MS;
astStartTable[udiStepIndex].xEndCMD						:= FALSE;

TPL.FC_LastStep(udiStepIndex, diStep);
astStartTable[udiStepIndex].sTitle						:= 'End';
astStartTable[udiStepIndex].udiModuleName				:= 0;
astStartTable[udiStepIndex].diStep						:= diStep;
astStartTable[udiStepIndex].diCMD						:= 0;
astStartTable[udiStepIndex].timTimeOut					:= T#0MS;
astStartTable[udiStepIndex].xEndCMD						:= TRUE;

TPL.FC_NextCmdTable(iq_udiTableIndex:= udiTableIndex);
astListofCMDTables[udiTableIndex].diCMD					:= ET_Cmd.Start;
astListofCMDTables[udiTableIndex].sTitle				:= 'Start';
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Abort ***)

TPL.FC_FirstStep(udiStepIndex, diStep);
astAbortTable[udiStepIndex].sTitle						:= 'Abort AllSubModules';
astAbortTable[udiStepIndex].udiModuleName				:= TPL.GCL.Gc_udiAllSubModules;
astAbortTable[udiStepIndex].diStep						:= diStep;
astAbortTable[udiStepIndex].diCMD						:= ET_Cmd.Abort;
astAbortTable[udiStepIndex].timTimeOut					:= T#0MS;
astAbortTable[udiStepIndex].xEndCMD						:= FALSE;

TPL.FC_LastStep(udiStepIndex, diStep);
astAbortTable[udiStepIndex].sTitle						:= 'End';
astAbortTable[udiStepIndex].udiModuleName				:= 0;
astAbortTable[udiStepIndex].diStep						:= diStep;
astAbortTable[udiStepIndex].diCMD						:= 0;
astAbortTable[udiStepIndex].timTimeOut					:= T#0MS;
astAbortTable[udiStepIndex].xEndCMD						:= TRUE;

TPL.FC_NextCmdTable(iq_udiTableIndex:= udiTableIndex);
astListofCMDTables[udiTableIndex].diCMD					:= ET_Cmd.Abort;
astListofCMDTables[udiTableIndex].sTitle				:= 'Abort';
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Hold ***)

TPL.FC_FirstStep(udiStepIndex, diStep);
astHoldTable[udiStepIndex].sTitle						:= 'Hold Alpha';
astHoldTable[udiStepIndex].udiModuleName				:= c_udiAlpha;
astHoldTable[udiStepIndex].diStep						:= diStep;
astHoldTable[udiStepIndex].diCMD						:= ET_Cmd.Hold;
astHoldTable[udiStepIndex].timTimeOut					:= T#0MS;
astHoldTable[udiStepIndex].xEndCMD						:= FALSE;

TPL.FC_NextStep(udiStepIndex, diStep);
astHoldTable[udiStepIndex].sTitle						:= 'Hold Charly';
astHoldTable[udiStepIndex].udiModuleName				:= c_udiCharly;
astHoldTable[udiStepIndex].diStep						:= diStep;
astHoldTable[udiStepIndex].diCMD						:= ET_Cmd.Hold;
astHoldTable[udiStepIndex].timTimeOut					:= T#0MS;
astHoldTable[udiStepIndex].xEndCMD						:= FALSE;

TPL.FC_NextStep(udiStepIndex, diStep);
astHoldTable[udiStepIndex].sTitle						:= 'Hold NodeWithoutMotion';
astHoldTable[udiStepIndex].udiModuleName				:= c_udiNodeWithoutMotion;
astHoldTable[udiStepIndex].diStep						:= diStep;
astHoldTable[udiStepIndex].diCMD						:= ET_Cmd.Hold;
astHoldTable[udiStepIndex].timTimeOut					:= T#0MS;
astHoldTable[udiStepIndex].xEndCMD						:= FALSE;

TPL.FC_LastStep(udiStepIndex, diStep);
astHoldTable[udiStepIndex].sTitle						:= 'End';
astHoldTable[udiStepIndex].udiModuleName				:= 0;
astHoldTable[udiStepIndex].diStep						:= diStep;
astHoldTable[udiStepIndex].diCMD						:= 0;
astHoldTable[udiStepIndex].timTimeOut					:= T#0MS;
astHoldTable[udiStepIndex].xEndCMD						:= TRUE;

TPL.FC_NextCmdTable(iq_udiTableIndex:= udiTableIndex);
astListofCMDTables[udiTableIndex].diCMD					:= ET_Cmd.Hold;
astListofCMDTables[udiTableIndex].sTitle				:= 'Hold';
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Hold for JogMachine***)

TPL.FC_FirstStep(udiStepIndex, diStep);
astHoldJogMachineTable[udiStepIndex].sTitle				:= 'Stop Alpha';
astHoldJogMachineTable[udiStepIndex].udiModuleName		:= c_udiAlpha;
astHoldJogMachineTable[udiStepIndex].diStep				:= diStep;
astHoldJogMachineTable[udiStepIndex].diCMD				:= ET_Cmd.Stop;
astHoldJogMachineTable[udiStepIndex].timTimeOut			:= T#0MS;
astHoldJogMachineTable[udiStepIndex].xEndCMD			:= FALSE;

TPL.FC_NextStep(udiStepIndex, diStep);
astHoldJogMachineTable[udiStepIndex].sTitle				:= 'Hold Charly';
astHoldJogMachineTable[udiStepIndex].udiModuleName		:= c_udiCharly;
astHoldJogMachineTable[udiStepIndex].diStep				:= diStep;
astHoldJogMachineTable[udiStepIndex].diCMD				:= ET_Cmd.Hold;
astHoldJogMachineTable[udiStepIndex].timTimeOut			:= T#0MS;
astHoldJogMachineTable[udiStepIndex].xEndCMD			:= FALSE;

TPL.FC_NextStep(udiStepIndex, diStep);
astHoldJogMachineTable[udiStepIndex].sTitle				:= 'Hold NodeWithoutMotion';
astHoldJogMachineTable[udiStepIndex].udiModuleName		:= c_udiNodeWithoutMotion;
astHoldJogMachineTable[udiStepIndex].diStep				:= diStep;
astHoldJogMachineTable[udiStepIndex].diCMD				:= ET_Cmd.Hold;
astHoldJogMachineTable[udiStepIndex].timTimeOut			:= T#0MS;
astHoldJogMachineTable[udiStepIndex].xEndCMD			:= FALSE;

TPL.FC_LastStep(udiStepIndex, diStep);
astHoldJogMachineTable[udiStepIndex].sTitle				:= 'End';
astHoldJogMachineTable[udiStepIndex].udiModuleName		:= 0;
astHoldJogMachineTable[udiStepIndex].diStep				:= diStep;
astHoldJogMachineTable[udiStepIndex].diCMD				:= 0;
astHoldJogMachineTable[udiStepIndex].timTimeOut			:= T#0MS;
astHoldJogMachineTable[udiStepIndex].xEndCMD			:= TRUE;

TPL.FC_NextCmdTable(iq_udiTableIndex:= udiTableIndex);
astListofCMDTables[udiTableIndex].diCMD					:= ET_Cmd.HoldJM;
astListofCMDTables[udiTableIndex].sTitle				:= 'Hold Jog Machine';
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Brake Release ***)

TPL.FC_FirstStep(udiStepIndex, diStep);
astBrakeReleaseTable[udiStepIndex].sTitle				:= 'BrakeRelease Bravo';
astBrakeReleaseTable[udiStepIndex].udiModuleName		:= c_udiBravo;
astBrakeReleaseTable[udiStepIndex].diStep				:= diStep;
astBrakeReleaseTable[udiStepIndex].diCMD				:= ET_Cmd.BrakeRelease;
astBrakeReleaseTable[udiStepIndex].timTimeOut			:= T#0MS;
astBrakeReleaseTable[udiStepIndex].xEndCMD				:= FALSE;

TPL.FC_LastStep(udiStepIndex, diStep);
astBrakeReleaseTable[udiStepIndex].sTitle				:= 'End';
astBrakeReleaseTable[udiStepIndex].udiModuleName		:= 0;
astBrakeReleaseTable[udiStepIndex].diStep				:= diStep;
astBrakeReleaseTable[udiStepIndex].diCMD				:= 0;
astBrakeReleaseTable[udiStepIndex].timTimeOut			:= T#0MS;
astBrakeReleaseTable[udiStepIndex].xEndCMD				:= TRUE;

TPL.FC_NextCmdTable(iq_udiTableIndex:= udiTableIndex);
astListofCMDTables[udiTableIndex].diCMD					:= ET_Cmd.BrakeRelease;
astListofCMDTables[udiTableIndex].sTitle				:= 'BrakeRelease';
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** JogMachine ***)

TPL.FC_FirstStep(udiStepIndex, diStep);
astJogMachineTable[udiStepIndex].sTitle					:= 'Auto Bravo';
astJogMachineTable[udiStepIndex].udiModuleName			:= c_udiBravo;
astJogMachineTable[udiStepIndex].diStep					:= diStep;
astJogMachineTable[udiStepIndex].diCMD					:= ET_Cmd.Auto;
astJogMachineTable[udiStepIndex].timTimeOut				:= T#0MS;
astJogMachineTable[udiStepIndex].xEndCMD				:= FALSE;

TPL.FC_NextStep(udiStepIndex, diStep);
astJogMachineTable[udiStepIndex].sTitle					:= 'Auto Charly';
astJogMachineTable[udiStepIndex].udiModuleName			:= c_udiCharly;
astJogMachineTable[udiStepIndex].diStep					:= diStep;
astJogMachineTable[udiStepIndex].diCMD					:= ET_Cmd.Auto;
astJogMachineTable[udiStepIndex].timTimeOut				:= T#0MS;
astJogMachineTable[udiStepIndex].xEndCMD				:= FALSE;

TPL.FC_NextStep(udiStepIndex, diStep);
astJogMachineTable[udiStepIndex].sTitle					:= 'Manual Alpha';
astJogMachineTable[udiStepIndex].udiModuleName			:= c_udiAlpha;
astJogMachineTable[udiStepIndex].diStep					:= diStep;
astJogMachineTable[udiStepIndex].diCMD					:= ET_Cmd.Manual;
astJogMachineTable[udiStepIndex].timTimeOut				:= T#0MS;
astJogMachineTable[udiStepIndex].xEndCMD				:= FALSE;

TPL.FC_LastStep(udiStepIndex, diStep);
astJogMachineTable[udiStepIndex].sTitle					:= 'End';
astJogMachineTable[udiStepIndex].udiModuleName			:= 0;
astJogMachineTable[udiStepIndex].diStep					:= diStep;
astJogMachineTable[udiStepIndex].diCMD					:= 0;
astJogMachineTable[udiStepIndex].timTimeOut				:= T#0MS;
astJogMachineTable[udiStepIndex].xEndCMD				:= TRUE;

TPL.FC_NextCmdTable(iq_udiTableIndex:= udiTableIndex);
astListofCMDTables[udiTableIndex].diCMD					:= ET_Cmd.Jogging;
astListofCMDTables[udiTableIndex].sTitle				:= 'Jogging';
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(* End of system generated code, could be modified for your application *)
