__METADATA__
{
  "v3Meta": {
    "objectGuid": "2fe414c2-dac7-4544-8d43-f8783aa40dc3",
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
PROGRAM SR_CharlyModuleExtItf
VAR_INPUT
(* Part of TPL.ST_StandardModuleInterface.i_... *)
	i_xEnable						: BOOL;
	
(* Master of AlphaModule *)
	i_ifMaster						: PLCO.Axis_Ref;
END_VAR

VAR_IN_OUT
(* Part of TPL.ST_StandardModuleInterface.iq_... *)
	iq_diCmd						: DINT;
	iq_diStartStep					: DINT;

(* TPL.ST_StandardModuleInterface *)	
	iq_stStandardModuleItf			: TPL.ST_StandardModuleInterface;
	
(* TPL.ST_StandardMotionInterface *)		
	iq_stStandardMotionItf			: TPL.ST_StandardMotionInterface;
	
(* ExceptionHandling and Logging *)	
	iq_stExceptionList				: TPL.ST_ExceptionList;
	iq_stLogDataList				: TPL.ST_LogDataList;
END_VAR

VAR_OUTPUT
(* Part of TPL.ST_StandardModuleInterface.q_... *)
	q_xActive						: BOOL;
	q_xReady						: BOOL;
	q_etDiag						: GD.ET_Diag; 
	q_etDiagExt						: ET_DiagExt;
	q_sMsg							: STRING[80];	
	q_xCmdActive					: BOOL;
	q_diCmdActive					: DINT;
	q_xCmdDone						: BOOL;
	q_udiActiveSubModule			: UDINT;
	q_udiSubModuleInException		: UDINT;
END_VAR
__IMPLEMENTATION__
(* System generated code, could be modified for your application *)

iq_stStandardModuleItf.i_xEnable		:= i_xEnable;
iq_stStandardModuleItf.iq_diCmd			:= iq_diCmd;
iq_stStandardModuleItf.iq_diStartStep	:= iq_diStartStep;

(* Module call *)
SR_CharlyModule(i_ifMaster				:= i_ifMaster, 
				iq_stStandardModuleItf	:= iq_stStandardModuleItf, 
				iq_stStandardMotionItf	:= iq_stStandardMotionItf, 
				iq_stExceptionList		:= iq_stExceptionList, 
				iq_stLogDataList		:= iq_stLogDataList);
				
iq_diCmd		:= iq_stStandardModuleItf.iq_diCmd;
iq_diStartStep	:= iq_stStandardModuleItf.iq_diStartStep;

q_xActive						:= iq_stStandardModuleItf.q_xActive;
q_xReady						:= iq_stStandardModuleItf.q_xReady;
q_etDiag						:= iq_stStandardModuleItf.q_etDiag; 
q_etDiagExt						:= iq_stStandardModuleItf.q_udiDiagExt;
q_sMsg							:= iq_stStandardModuleItf.q_sMsg;	
q_xCmdActive					:= iq_stStandardModuleItf.q_xCmdActive;
q_diCmdActive					:= iq_stStandardModuleItf.q_diCmdActive;
q_xCmdDone						:= iq_stStandardModuleItf.q_xCmdDone;
q_udiActiveSubModule			:= iq_stStandardModuleItf.q_udiActiveSubModule;
q_udiSubModuleInException		:= iq_stStandardModuleItf.q_udiSubModuleInException;

(* End of system generated code, could be modified for your application *)
