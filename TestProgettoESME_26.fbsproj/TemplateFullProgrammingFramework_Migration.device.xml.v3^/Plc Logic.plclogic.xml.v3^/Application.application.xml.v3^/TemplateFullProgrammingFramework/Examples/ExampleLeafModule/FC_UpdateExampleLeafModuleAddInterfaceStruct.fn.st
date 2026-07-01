__METADATA__
{
  "v3Meta": {
    "objectGuid": "fb01998f-f77f-4f7f-9afc-f7ba25527d07",
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
FUNCTION FC_UpdateExampleLeafModuleAddInterfaceStruct : BOOL

VAR_INPUT
	i_pdwSubModuleAddInterfaces		: POINTER TO TPL.TYPE_ADDRESS; // change from DWORD to ADDRESS;
	i_udiSubModuleConstant			: UDINT;
END_VAR

VAR_OUTPUT
	q_etDiag						: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt						: ET_DiagExtExampleLeafModule := ET_DiagExtExampleLeafModule.Ok;
	q_sMsg							: STRING[80] := '';
END_VAR

VAR_IN_OUT
	iq_stExampleLeafModuleInterface	: ST_ExampleLeafModuleInterface;
END_VAR

VAR
	pdwArrayPos						: POINTER TO TPL.TYPE_ADDRESS; // change from DWORD to ADDRESS;
END_VAR
__IMPLEMENTATION__
IF i_pdwSubModuleAddInterfaces = 0 THEN
	q_etDiag	:= GD.ET_Diag.InputParameterInvalid;
	q_etDiagExt	:= ET_DiagExtExampleLeafModule.SubModuleAddInterfacesInvalidPointer;
	q_sMsg		:= '';
ELSIF i_udiSubModuleConstant < 1 THEN
	q_etDiag	:= GD.ET_Diag.InputParameterInvalid;
	q_etDiagExt := ET_DiagExtExampleLeafModule.SubModuleConstantRange;
	q_sMsg		:= '1 <= i_udiSubModuleConstant';
ELSE
	pdwArrayPos := i_pdwSubModuleAddInterfaces + UDINT_TO_DWORD((i_udiSubModuleConstant-1) * SIZEOF(pdwArrayPos^));
	pdwArrayPos^ := ADR(iq_stExampleLeafModuleInterface);
END_IF
