__METADATA__
{
  "v3Meta": {
    "objectGuid": "32b9c830-de70-4d9a-b5e3-55a34a810e54",
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
xOutputPrepareActive	:= xActPrepare;
xOutputAutoActive		:= xActAuto;
xOutputManualActive		:= xActManual;
xOutputJogMachineActive	:= xActJogMachine;

IF stMachineInterface.q_udiSubModuleInException <> 0 THEN
	stMachineInterface.q_etDiag		:= GD.ET_Diag.Ok;
	stMachineInterface.q_udiDiagExt	:= ET_DiagExt.SubModuleInException;
	stMachineInterface.q_sDiagExt		:= FC_EtDiagExtToString(i_etDiagExt := ET_DiagExt.SubModuleInException);
	stMachineInterface.q_sMsg			:= '';
ELSE
	IF etDiagModuleController = GD.ET_Diag.Ok THEN
		stMachineInterface.q_etDiag	:= etDiagModuleController;
		stMachineInterface.q_sMsg		:= sMsgModuleController;
		
		CASE etDiagExtModuleController OF
			TPL.ET_DiagExt.DeactivatingSubModules : 
				stMachineInterface.q_udiDiagExt	:= ET_DiagExt.DeactivatingSubModules;
				stMachineInterface.q_sDiagExt		:= FC_EtDiagExtToString(i_etDiagExt := ET_DiagExt.DeactivatingSubModules);
			TPL.ET_DiagExt.Disabled : 
				stMachineInterface.q_udiDiagExt	:= ET_DiagExt.Disabled;
				stMachineInterface.q_sDiagExt		:= FC_EtDiagExtToString(i_etDiagExt := ET_DiagExt.Disabled);
			TPL.ET_DiagExt.ExecuteStep : 
				stMachineInterface.q_udiDiagExt	:= ET_DiagExt.ExecuteStep;
				stMachineInterface.q_sDiagExt		:= FC_EtDiagExtToString(i_etDiagExt := ET_DiagExt.ExecuteStep);
			TPL.ET_DiagExt.Initializing : 
				stMachineInterface.q_udiDiagExt	:= ET_DiagExt.Initializing;
				stMachineInterface.q_sDiagExt		:= FC_EtDiagExtToString(i_etDiagExt := ET_DiagExt.Initializing);
			TPL.ET_DiagExt.WaitAtNegativeStep : 
				stMachineInterface.q_udiDiagExt	:= ET_DiagExt.WaitAtNegativeStep;
				stMachineInterface.q_sDiagExt		:= FC_EtDiagExtToString(i_etDiagExt := ET_DiagExt.WaitAtNegativeStep);
			TPL.ET_DiagExt.WaitCmdsDone : 
				stMachineInterface.q_udiDiagExt	:= ET_DiagExt.WaitCmdsDone;
				stMachineInterface.q_sDiagExt		:= FC_EtDiagExtToString(i_etDiagExt := ET_DiagExt.WaitCmdsDone);
			TPL.ET_DiagExt.WaitForCmd : 
				stMachineInterface.q_udiDiagExt	:= ET_DiagExt.WaitForCmd;
				stMachineInterface.q_sDiagExt		:= FC_EtDiagExtToString(i_etDiagExt := ET_DiagExt.WaitForCmd);
			ELSE
				stMachineInterface.q_etDiag		:= GD. ET_Diag.UnexpectedProgramBehavior;
				stMachineInterface.q_udiDiagExt	:= ET_DiagExt.UnknownStateModuleController;
				stMachineInterface.q_sDiagExt		:= FC_EtDiagExtToString(i_etDiagExt := ET_DiagExt.UnknownStateModuleController);
		END_CASE
	ELSE
		stMachineInterface.q_etDiag		:= GD.ET_Diag.DiagActive;
		stMachineInterface.q_udiDiagExt	:= ET_DiagExt.ModuleControllerException;
		stMachineInterface.q_sDiagExt		:= FC_EtDiagExtToString(i_etDiagExt := ET_DiagExt.ModuleControllerException);
		stMachineInterface.q_sMsg			:= SE_CTBX.FC_MultiConcat(	i_sString1 := GD.FC_EtDiagToString(i_etDiag := etDiagModuleController), 
																			i_sString2 := ' - ',
																			i_sString3 := TPL.FC_EtDiagExtToString(i_etDiagExt := etDiagExtModuleController), 
																			i_sString4 := '');
	END_IF
END_IF
(* End of system generated code, only to be changed by experienced programmers *)
