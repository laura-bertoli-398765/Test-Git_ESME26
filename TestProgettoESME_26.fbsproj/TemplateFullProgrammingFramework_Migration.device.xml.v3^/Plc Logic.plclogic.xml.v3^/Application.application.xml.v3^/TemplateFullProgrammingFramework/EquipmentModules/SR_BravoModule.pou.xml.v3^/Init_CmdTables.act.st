__METADATA__
{
  "v3Meta": {
    "objectGuid": "9bddf752-c8e4-40f8-8d40-e0cae711996a",
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
astPrepareTable[udiStepIndex].sTitle					:= 'DriveEnable On AllSubModules';
astPrepareTable[udiStepIndex].udiModuleName				:= TPL.GCL.Gc_udiAllSubModules;
astPrepareTable[udiStepIndex].diStep					:= diStep;
astPrepareTable[udiStepIndex].diCMD						:= AXM_ET_Cmd.DriveEnableOn;
astPrepareTable[udiStepIndex].timTimeOut				:= T#0MS;
astPrepareTable[udiStepIndex].xEndCMD					:= FALSE;

TPL.FC_NextStep(udiStepIndex, diStep);
astPrepareTable[udiStepIndex].sTitle					:= 'Homing Mode AllSubModules';
astPrepareTable[udiStepIndex].udiModuleName				:= TPL.GCL.Gc_udiAllSubModules;
astPrepareTable[udiStepIndex].diStep					:= diStep;
astPrepareTable[udiStepIndex].diCMD						:= AXM_ET_Cmd.Homing;
astPrepareTable[udiStepIndex].timTimeOut				:= T#0MS;
astPrepareTable[udiStepIndex].xEndCMD					:= FALSE;

TPL.FC_NextStep(udiStepIndex, diStep);
astPrepareTable[udiStepIndex].sTitle					:= 'Homing Start AllSubModules';
astPrepareTable[udiStepIndex].udiModuleName				:= TPL.GCL.Gc_udiAllSubModules;
astPrepareTable[udiStepIndex].diStep					:= diStep;
astPrepareTable[udiStepIndex].diCMD						:= AXM_ET_Cmd.Start;
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
astListofCMDTables[udiTableIndex].sTitle				:= 'Prepare';
astListofCMDTables[udiTableIndex].diCMD					:= ET_Cmd.Prepare;
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Auto  ***)

TPL.FC_FirstStep(udiStepIndex, diStep);
astAutoTable[udiStepIndex].sTitle						:= 'DriveEnable On AllSubModules';
astAutoTable[udiStepIndex].udiModuleName				:= TPL.GCL.Gc_udiAllSubModules;
astAutoTable[udiStepIndex].diStep						:= diStep;
astAutoTable[udiStepIndex].diCMD						:= AXM_ET_Cmd.DriveEnableOn;
astAutoTable[udiStepIndex].timTimeOut					:= T#0MS;
astAutoTable[udiStepIndex].xEndCMD						:= FALSE;

TPL.FC_NextStep(udiStepIndex, diStep);
astAutoTable[udiStepIndex].sTitle						:= 'Cam Mode AllSubModules';
astAutoTable[udiStepIndex].udiModuleName				:= TPL.GCL.Gc_udiAllSubModules;
astAutoTable[udiStepIndex].diStep						:= diStep;
astAutoTable[udiStepIndex].diCMD						:= AXM_ET_Cmd.CamWs;
astAutoTable[udiStepIndex].timTimeOut					:= T#0MS;
astAutoTable[udiStepIndex].xEndCMD						:= FALSE;

TPL.FC_NextStep(udiStepIndex, diStep);
astAutoTable[udiStepIndex].sTitle						:= 'Start AllSubModules';
astAutoTable[udiStepIndex].udiModuleName				:= TPL.GCL.Gc_udiAllSubModules;
astAutoTable[udiStepIndex].diStep						:= diStep;
astAutoTable[udiStepIndex].diCMD						:= AXM_ET_Cmd.Start;
astAutoTable[udiStepIndex].timTimeOut					:= T#0MS;
astAutoTable[udiStepIndex].xEndCMD						:= FALSE;

TPL.FC_NextStep(udiStepIndex, diStep);
astAutoTable[udiStepIndex].sTitle						:= 'WarmStart AllSubModules';
astAutoTable[udiStepIndex].udiModuleName				:= TPL.GCL.Gc_udiAllSubModules;
astAutoTable[udiStepIndex].diStep						:= diStep;
astAutoTable[udiStepIndex].diCMD						:= AXM_ET_Cmd.WsStart;
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
astListofCMDTables[udiTableIndex].sTitle				:= 'Auto';
astListofCMDTables[udiTableIndex].diCMD					:= ET_Cmd.Auto;
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Manual  ***)

TPL.FC_FirstStep(udiStepIndex, diStep);
astManualTable[udiStepIndex].sTitle						:= 'DriveEnable On AllSubModules';
astManualTable[udiStepIndex].udiModuleName				:= TPL.GCL.Gc_udiAllSubModules;
astManualTable[udiStepIndex].diStep						:= diStep;
astManualTable[udiStepIndex].diCMD						:= AXM_ET_Cmd.DriveEnableOn;
astManualTable[udiStepIndex].timTimeOut					:= T#0MS;
astManualTable[udiStepIndex].xEndCMD					:= FALSE;

TPL.FC_NextStep(udiStepIndex, diStep);
astManualTable[udiStepIndex].sTitle						:= 'Manual Mode AllSubModules';
astManualTable[udiStepIndex].udiModuleName				:= TPL.GCL.Gc_udiAllSubModules;
astManualTable[udiStepIndex].diStep						:= diStep;
astManualTable[udiStepIndex].diCMD						:= AXM_ET_Cmd.Manual;
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
astListofCMDTables[udiTableIndex].sTitle				:= 'Manual';
astListofCMDTables[udiTableIndex].diCMD					:= ET_Cmd.Manual;
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Stop ***)

TPL.FC_FirstStep(udiStepIndex, diStep);
astStopTable[udiStepIndex].sTitle						:= 'Stop AllSubModules';
astStopTable[udiStepIndex].udiModuleName				:= TPL.GCL.Gc_udiAllSubModules;
astStopTable[udiStepIndex].diStep						:= diStep;
astStopTable[udiStepIndex].diCMD						:= AXM_ET_Cmd.Stop;
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
astListofCMDTables[udiTableIndex].sTitle				:= 'Stop';
astListofCMDTables[udiTableIndex].diCMD					:= ET_Cmd.Stop;
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Start ***)

TPL.FC_FirstStep(udiStepIndex, diStep);
astStartTable[udiStepIndex].sTitle						:= 'Start AllSubModules';
astStartTable[udiStepIndex].udiModuleName				:= TPL.GCL.Gc_udiAllSubModules;
astStartTable[udiStepIndex].diStep						:= diStep;
astStartTable[udiStepIndex].diCMD						:= AXM_ET_Cmd.Start;
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
astListofCMDTables[udiTableIndex].sTitle				:= 'Start';
astListofCMDTables[udiTableIndex].diCMD					:= ET_Cmd.Start;
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Abort ***)

TPL.FC_FirstStep(udiStepIndex, diStep);
astAbortTable[udiStepIndex].sTitle						:= 'Stop AllSubModules';
astAbortTable[udiStepIndex].udiModuleName				:= TPL.GCL.Gc_udiAllSubModules;
astAbortTable[udiStepIndex].diStep						:= diStep;
astAbortTable[udiStepIndex].diCMD						:= AXM_ET_Cmd.Stop;
astAbortTable[udiStepIndex].timTimeOut					:= T#0MS;
astAbortTable[udiStepIndex].xEndCMD						:= FALSE;

TPL.FC_LastStep(udiStepIndex, diStep);
astAbortTable[udiStepIndex].sTitle						:= 	'End';
astAbortTable[udiStepIndex].udiModuleName				:= 	0;
astAbortTable[udiStepIndex].diStep						:= 	diStep;
astAbortTable[udiStepIndex].diCMD						:= 	0;
astAbortTable[udiStepIndex].timTimeOut					:=	T#0MS;
astAbortTable[udiStepIndex].xEndCMD						:= TRUE;

TPL.FC_NextCmdTable(iq_udiTableIndex:= udiTableIndex);
astListofCMDTables[udiTableIndex].sTitle				:= 'Abort';
astListofCMDTables[udiTableIndex].diCMD					:= ET_Cmd.Abort;
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Hold ***)

TPL.FC_FirstStep(udiStepIndex, diStep);
astHoldTable[udiStepIndex].sTitle						:= 'Hold AllSubModules';
astHoldTable[udiStepIndex].udiModuleName				:= TPL.GCL.Gc_udiAllSubModules;
astHoldTable[udiStepIndex].diStep						:= diStep;
astHoldTable[udiStepIndex].diCMD						:= AXM_ET_Cmd.Hold;
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
astListofCMDTables[udiTableIndex].sTitle				:= 'Hold';
astListofCMDTables[udiTableIndex].diCMD					:= ET_Cmd.Hold;
astListofCMDTables[udiTableIndex].udiNumberOfCmdSteps	:= udiStepIndex;

(*********************************************************************************************************************)
(*** Brake Release ***)

TPL.FC_FirstStep(udiStepIndex, diStep);
astBrakeReleaseTable[udiStepIndex].sTitle				:= 'AxisEnable Off AllSubModules';
astBrakeReleaseTable[udiStepIndex].udiModuleName		:= TPL.GCL.Gc_udiAllSubModules;
astBrakeReleaseTable[udiStepIndex].diStep				:= diStep;
astBrakeReleaseTable[udiStepIndex].diCMD				:= AXM_ET_Cmd.DriveEnableOff;
astBrakeReleaseTable[udiStepIndex].timTimeOut			:= T#0MS;
astBrakeReleaseTable[udiStepIndex].xEndCMD				:= FALSE;
(*
TPL.FC_NextStep(udiStepIndex, diStep);
astBrakeReleaseTable[udiStepIndex].sTitle				:= 'BrakeRelease Mode AllSubModules';
astBrakeReleaseTable[udiStepIndex].udiModuleName		:= TPL.GCL.Gc_udiAllSubModules;
astBrakeReleaseTable[udiStepIndex].diStep				:= diStep;
astBrakeReleaseTable[udiStepIndex].diCMD				:= AXM_ET_Cmd.BrakeRelease;
astBrakeReleaseTable[udiStepIndex].timTimeOut			:= T#0MS;
astBrakeReleaseTable[udiStepIndex].xEndCMD				:= FALSE;

TPL.FC_NextStep(udiStepIndex, diStep);
astBrakeReleaseTable[udiStepIndex].sTitle				:= 'Start AllSubModules';
astBrakeReleaseTable[udiStepIndex].udiModuleName		:= TPL.GCL.Gc_udiAllSubModules;
astBrakeReleaseTable[udiStepIndex].diStep				:= diStep;
astBrakeReleaseTable[udiStepIndex].diCMD				:= AXM_ET_Cmd.Start;
astBrakeReleaseTable[udiStepIndex].timTimeOut			:= T#0MS;
astBrakeReleaseTable[udiStepIndex].xEndCMD				:= FALSE;
*)
TPL.FC_LastStep(udiStepIndex, diStep);
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
