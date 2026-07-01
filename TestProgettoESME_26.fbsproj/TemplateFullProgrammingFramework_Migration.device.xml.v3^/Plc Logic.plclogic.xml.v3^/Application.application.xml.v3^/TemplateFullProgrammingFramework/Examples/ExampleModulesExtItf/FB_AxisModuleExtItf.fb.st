__METADATA__
{
  "v3Meta": {
    "objectGuid": "834d14cb-0ddf-416f-8e21-afeceb4f4d21",
    "objectTypeGuid": "6f9dac99-8de1-4efc-8465-68ac443b7d08",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__DECLARATION__
FUNCTION_BLOCK FB_AxisModuleExtItf

VAR_INPUT
(* Part of TPL.ST_StandardModuleInterface.i_... *)
	i_xEnable		: BOOL;
	
(* Part of AXM_ST_ModuleInterface.stManual.i_... *)
	i_xJogForw		: BOOL;
	i_xJogBack		: BOOL;
	
(* Part of AXM_ST_ModuleInterface.stMain.i_... *)
	i_xHwLimitPos	: BOOL;
	i_xHwLimitNeg	: BOOL;
END_VAR

VAR_IN_OUT
(* Part of TPL.ST_StandardModuleInterface.iq_... *)	
	iq_diCmd				: DINT;

(* TPL.ST_StandardModuleInterface *)		
	iq_stStandardModuleItf	: TPL.ST_StandardModuleInterface;
	
(* ExceptionHandling and Logging *)	
	iq_stExceptionList		: TPL.ST_ExceptionList;
	iq_stLogDataList		: TPL.ST_LogDataList;
	
(* AXM_ST_ModuleInterface *)
	iq_stAxisModuleItf		: AXM_ST_ModuleInterface;
END_VAR

VAR_OUTPUT
(* Part of TPL.ST_StandardModuleInterface.q_... *)	
	q_xActive		: BOOL;
	q_xReady		: BOOL;
	q_etDiag		: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt		: AXM_ET_DiagExt := AXM_ET_DiagExt.Disabled;
	q_sMsg			: STRING[80] := '';
	q_xCmdActive	: BOOL;
	q_diCmdActive	: DINT;
	q_xCmdDone		: BOOL;
	
(* Part of AXM_ST_ModuleInterface.stMain.q_... *)
	q_xDriveActive	: BOOL;
	q_xHomeOk		: BOOL;
	q_xSynchron		: BOOL;
	q_lrPosition	: LREAL;
	q_lrPositionX	: LREAL;
END_VAR

VAR
	fbAxisModule : AXM_FB_AxisModule;
END_VAR
__IMPLEMENTATION__
(* System generated code, could be modified for your application *)

iq_stStandardModuleItf.i_xEnable	:= i_xEnable;
iq_stStandardModuleItf.iq_diCmd		:= iq_diCmd;

iq_stAxisModuleItf.stMain.i_xHwLimitPos	:= i_xHwLimitPos;
iq_stAxisModuleItf.stMain.i_xHwLimitNeg	:= i_xHwLimitNeg;

iq_stAxisModuleItf.stManual.i_xJogForw	:= i_xJogForw;
iq_stAxisModuleItf.stManual.i_xJogBack	:= i_xJogBack;

(* Module call *)
fbAxisModule(	iq_stStandardModuleItf	:= iq_stStandardModuleItf,
				iq_stExceptionList		:= iq_stExceptionList,
				iq_stLogDataList		:= iq_stLogDataList,
				iq_stAxisModuleItf		:= iq_stAxisModuleItf);
				
iq_diCmd := iq_stStandardModuleItf.iq_diCmd;

q_xActive		:= iq_stStandardModuleItf.q_xActive;
q_xReady		:= iq_stStandardModuleItf.q_xReady;
q_etDiag		:= iq_stStandardModuleItf.q_etDiag;
q_etDiagExt		:= iq_stStandardModuleItf.q_udiDiagExt;
q_sMsg			:= iq_stStandardModuleItf.q_sMsg;
q_xCmdActive	:= iq_stStandardModuleItf.q_xCmdActive;
q_diCmdActive	:= iq_stStandardModuleItf.q_diCmdActive;
q_xCmdDone		:= iq_stStandardModuleItf.q_xCmdDone;

q_xDriveActive	:= iq_stAxisModuleItf.stMain.q_xDriveActive;
q_xHomeOk		:= iq_stAxisModuleItf.stMain.q_xHomeOk;
q_xSynchron		:= iq_stAxisModuleItf.stMain.q_xSynchron;

(* End of system generated code, could be modified for your application *)
