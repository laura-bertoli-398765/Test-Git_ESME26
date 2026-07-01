__METADATA__
{
  "v3Meta": {
    "objectGuid": "83fcff65-30e3-45b1-8025-89da43a052bf",
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
FUNCTION_BLOCK FB_ExampleLeafModuleController

VAR_INPUT
	i_xEnable				: BOOL;
END_VAR

VAR_IN_OUT
	iq_stStandardModuleItf	: TPL.ST_StandardModuleInterface;
	iq_stStandardMotionItf	: TPL.ST_StandardMotionInterface;
	iq_stExceptionList		: TPL.ST_ExceptionList;
	iq_stLogDataList		: TPL.ST_LogDataList;
END_VAR

VAR_OUTPUT
	q_xActive				: BOOL;
	q_xReady				: BOOL;
	q_etDiag				: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt				: ET_DiagExtExampleLeafModule := ET_DiagExtExampleLeafModule.Disabled;
	q_sMsg					: STRING[80] := '';
END_VAR

VAR
	xEnableFlag				: BOOL;
	udiTmp					: UDINT;
END_VAR
__IMPLEMENTATION__
IF i_xEnable AND NOT xEnableFlag THEN
	xEnableFlag	:= TRUE;
	
	q_xActive	:= TRUE;

	q_etDiag	:= GD.ET_Diag.Ok;
	q_etDiagExt := ET_DiagExtExampleLeafModule.Initializing;
	q_sMsg		:= '';
	
	IF ((iq_stStandardModuleItf.iq_stExt.udiNumberOfSubModules <> 0) AND 
	   ((iq_stStandardModuleItf.iq_stExt.pdwSubModulesAddItf = 0) OR (iq_stStandardModuleItf.iq_stExt.dwSubModulesItf = 0))) THEN
	   
		q_etDiag	:= GD.ET_Diag.ExecutionAborted;
		q_etDiagExt	:= ET_DiagExtExampleLeafModule.MissingExtInit;
		q_sMsg		:= 'Missing call of FC_UpdateExampleLeafModuleAddInterfaceStruct';

		RETURN;
	END_IF
	
	udiTmp := ET_ExceptionSource.ExampleLeafModule;
	
	q_xReady := TPL.FC_CheckSubModuleList(	i_dwModuleType		:= UDINT_TO_DWORD(ET_ModuleType.ExampleLeafModule),
											i_udiModuleId		:= iq_stStandardModuleItf.i_udiModuleId,
											i_sModuleName		:= iq_stStandardModuleItf.i_sModuleName,
											i_etSource			:= udiTmp (* Hack around compiler restrictions *),
											iq_stExt			:= iq_stStandardModuleItf.iq_stExt,
											iq_stExceptionList	:= iq_stExceptionList,
											iq_stLogDataList	:= iq_stLogDataList);
											
	IF NOT q_xReady THEN
		xEnableFlag := FALSE;
	END_IF

ELSIF NOT i_xEnable AND xEnableFlag THEN
	xEnableFlag	:= FALSE;
	
	(* No actions required, this simple module does not support jogging or any other things the XXXModuleController would have to handle *)
	q_xReady 	:= FALSE;
	q_xActive	:= FALSE;
	
	q_etDiag	:= GD.ET_Diag.Ok;
	q_etDiagExt	:= ET_DiagExtExampleLeafModule.Disabled;
	q_sMsg		:= '';
END_IF



IF q_xActive AND q_xReady THEN
	(* No actions required, this simple module does not support jogging or any other things the XXXModuleController would have to handle *)
	q_etDiag	:= GD.ET_Diag.Ok;
	q_etDiagExt := ET_DiagExtExampleLeafModule.Working;
	q_sMsg		:= '';
END_IF
