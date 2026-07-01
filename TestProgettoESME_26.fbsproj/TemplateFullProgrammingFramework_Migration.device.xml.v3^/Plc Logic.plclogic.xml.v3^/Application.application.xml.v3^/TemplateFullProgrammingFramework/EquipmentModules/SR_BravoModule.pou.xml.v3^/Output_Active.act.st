__METADATA__
{
  "v3Meta": {
    "objectGuid": "71008e6c-9762-44bc-bc92-823e2ec69ec8",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* System generated code, only to be changed by experienced programmers *)
IF iq_stStandardModuleItf.q_udiSubModuleInException <> 0 THEN
	iq_stStandardModuleItf.q_etDiag		:= GD.ET_Diag.Ok;
	iq_stStandardModuleItf.q_udiDiagExt	:= ET_DiagExt.SubModuleInException;
	iq_stStandardModuleItf.q_sDiagExt		:= FC_EtDiagExtToString(i_etDiagExt := ET_DiagExt.SubModuleInException);
	iq_stStandardModuleItf.q_sMsg			:= '';
ELSE
	IF etDiagModuleController = GD.ET_Diag.Ok THEN
		iq_stStandardModuleItf.q_etDiag	:= etDiagModuleController;
		iq_stStandardModuleItf.q_sMsg		:= sMsgModuleController;
		
		CASE etDiagExtModuleController OF
			TPL.ET_DiagExt.DeactivatingSubModules : 
				iq_stStandardModuleItf.q_udiDiagExt	:= ET_DiagExt.DeactivatingSubModules;
				iq_stStandardModuleItf.q_sDiagExt		:= FC_EtDiagExtToString(i_etDiagExt := ET_DiagExt.DeactivatingSubModules);
			TPL.ET_DiagExt.Disabled : 
				iq_stStandardModuleItf.q_udiDiagExt	:= ET_DiagExt.Disabled;
				iq_stStandardModuleItf.q_sDiagExt		:= FC_EtDiagExtToString(i_etDiagExt := ET_DiagExt.Disabled);
			TPL.ET_DiagExt.ExecuteStep : 
				iq_stStandardModuleItf.q_udiDiagExt	:= ET_DiagExt.ExecuteStep;
				iq_stStandardModuleItf.q_sDiagExt		:= FC_EtDiagExtToString(i_etDiagExt := ET_DiagExt.ExecuteStep);
			TPL.ET_DiagExt.Initializing : 
				iq_stStandardModuleItf.q_udiDiagExt	:= ET_DiagExt.Initializing;
				iq_stStandardModuleItf.q_sDiagExt		:= FC_EtDiagExtToString(i_etDiagExt := ET_DiagExt.Initializing);
			TPL.ET_DiagExt.WaitAtNegativeStep : 
				iq_stStandardModuleItf.q_udiDiagExt	:= ET_DiagExt.WaitAtNegativeStep;
				iq_stStandardModuleItf.q_sDiagExt		:= FC_EtDiagExtToString(i_etDiagExt := ET_DiagExt.WaitAtNegativeStep);
			TPL.ET_DiagExt.WaitCmdsDone : 
				iq_stStandardModuleItf.q_udiDiagExt	:= ET_DiagExt.WaitCmdsDone;
				iq_stStandardModuleItf.q_sDiagExt		:= FC_EtDiagExtToString(i_etDiagExt := ET_DiagExt.WaitCmdsDone);
			TPL.ET_DiagExt.WaitForCmd : 
				iq_stStandardModuleItf.q_udiDiagExt	:= ET_DiagExt.WaitForCmd;
				iq_stStandardModuleItf.q_sDiagExt		:= FC_EtDiagExtToString(i_etDiagExt := ET_DiagExt.WaitForCmd);
			ELSE
				iq_stStandardModuleItf.q_etDiag		:= GD. ET_Diag.UnexpectedProgramBehavior;
				iq_stStandardModuleItf.q_udiDiagExt	:= ET_DiagExt.UnknownStateModuleController;
				iq_stStandardModuleItf.q_sDiagExt		:= FC_EtDiagExtToString(i_etDiagExt := ET_DiagExt.UnknownStateModuleController);
		END_CASE
	ELSE
		iq_stStandardModuleItf.q_etDiag		:= GD.ET_Diag.DiagActive;
		iq_stStandardModuleItf.q_udiDiagExt	:= ET_DiagExt.ModuleControllerException;
		iq_stStandardModuleItf.q_sDiagExt		:= FC_EtDiagExtToString(i_etDiagExt := ET_DiagExt.ModuleControllerException);
		iq_stStandardModuleItf.q_sMsg			:= SE_CTBX.FC_MultiConcat(	i_sString1 := GD.FC_EtDiagToString(i_etDiag := etDiagModuleController), 
																			i_sString2 := ' - ',
																			i_sString3 := TPL.FC_EtDiagExtToString(i_etDiagExt := etDiagExtModuleController), 
																			i_sString4 := '');
	END_IF
END_IF

(* End of system generated code, only to be changed by experienced programmers *)
