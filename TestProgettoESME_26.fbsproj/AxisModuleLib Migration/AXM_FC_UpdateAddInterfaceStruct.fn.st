__METADATA__
{
  "v3Meta": {
    "objectGuid": "89ae1092-4374-4ad6-a6d5-60cad88e3ca6",
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
/// FC version: 1.0.0.0
/// Example Project version: 26.0.11.0 (Automatically generated, do not change!)

FUNCTION PUBLIC AXM_FC_UpdateAddInterfaceStruct : BOOL
VAR_INPUT
	i_pdwSubModuleAddInterfaces : POINTER TO TPL.TYPE_ADDRESS; // change from DWORD to TYPE_ADDRESS;
	i_udiSubModuleConstant		: UDINT;
END_VAR
VAR_IN_OUT
	iq_stAxisModuleItf	: AXM_ST_ModuleInterface;
END_VAR
VAR_OUTPUT
	q_etDiag			: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt			: AXM_ET_DiagExt := AXM_ET_DiagExt.Ok;
	q_sMsg				: STRING[80];
END_VAR
VAR
	pdwArrayPos			: POINTER TO TPL.TYPE_ADDRESS; // change from DWORD to TYPE_ADDRESS;
END_VAR
__IMPLEMENTATION__
(********************************************************************************************************
revision history:
=========================================================================================================
version	|	date		| author				| comment
=========================================================================================================
1.0.0.0	|	2025-03-18	| Schneider Electric	| - initial release
---------------------------------------------------------------------------------------------------------
1.x.y.z	|	20xx-xx-xx	| your name				| - What has been modified?
=========================================================================================================
********************************************************************************************************)

IF i_pdwSubModuleAddInterfaces = 0 THEN
	q_etDiag	:= GD.ET_Diag.InputParameterInvalid;
	q_etDiagExt	:= AXM_ET_DiagExt.SubModuleAddInterfacesInvalidPointer;
	q_sMsg		:= '';
ELSIF i_udiSubModuleConstant < 1 THEN
	q_etDiag	:= GD.ET_Diag.InputParameterInvalid;
	q_etDiagExt := AXM_ET_DiagExt.SubModuleConstantRange;
	q_sMsg		:= '1 <= i_udiSubModuleConstant';
ELSE
	pdwArrayPos := i_pdwSubModuleAddInterfaces + (i_udiSubModuleConstant-1) * SIZEOF(pdwArrayPos^);
	pdwArrayPos^ := ADR(iq_stAxisModuleItf);
END_IF
