__METADATA__
{
  "v3Meta": {
    "objectGuid": "b40bfdc4-ca55-4612-a0d7-150a9c69cd58",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* This step is active until the machine is being enabled *)

(* System generated code, do not change without consulting 'Schneider Electric Automation GmbH' - otherwise you risk instability!!! *)
iq_stStandardModuleItf.q_xActive			:= FALSE;
iq_stStandardModuleItf.q_xReady			:= FALSE;

iq_stStandardModuleItf.q_etDiag			:= GD.ET_Diag.Ok;
iq_stStandardModuleItf.q_udiDiagExt		:= ET_DiagExt.Disabled;
iq_stStandardModuleItf.q_sDiagExt			:= FC_EtDiagExtToString(i_etDiagExt := iq_stStandardModuleItf.q_udiDiagExt);
iq_stStandardModuleItf.q_sMsg				:= '';

iq_stStandardModuleItf.q_dwModuleType		:= TPL.ET_ModuleType.NodeModule;
iq_stStandardModuleItf.q_sModuleTypeName	:= 'NodeModule';
iq_stStandardModuleItf.q_udiModuleVersion	:= 1;	
(* End of system generated code, do not change without consulting 'Schneider Electric Automation GmbH' - otherwise you risk instability!!! *)

(* System generated code, to be changed by experienced programmers *)
IF iq_stStandardModuleItf.iq_diCMD <> 0 AND NOT iq_stStandardModuleItf.i_xEnable THEN
	iq_stStandardModuleItf.iq_diCMD := 0;
END_IF
(* End of system generated code, to be changed by experienced programmers *)

(* Application specific code *)
(* ToDo: Add your application specific code here *)
;
(* End of application specific code *)
