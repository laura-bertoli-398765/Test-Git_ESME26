__METADATA__
{
  "v3Meta": {
    "objectGuid": "abf33e8c-5bd5-4f08-834d-cda8f72d5d2b",
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
FUNCTION FC_SercosWriteIDN : DINT
VAR_INPUT
	i_uiTopoAddr : UINT;
	i_etSercosParameterType : ET_SercosParameterType;
	i_uiIDN : UINT;
	i_etWriteIDNType : ET_SercosWriteIDNType;
	i_dwValue : DWORD;
END_VAR
VAR
	dwIDN : DWORD;
	dwValue : DWORD;	
END_VAR
__IMPLEMENTATION__
dwValue := i_dwValue;

IF i_etSercosParameterType = ET_SercosParameterType.S_Parameter THEN
	dwIDN := i_uiIDN;
ELSE
	dwIDN := 16#8000 + i_uiIDN;
END_IF

FC_SercosWriteIDN := SMM6xx.FC_SercosWriteServiceDataByTopAddr(
	i_wTopoAddr := i_uiTopoAddr,
	i_dwIDN := dwIDN,
	i_wType := TO_UINT(i_etWriteIDNType),
	i_lwPointerToData := TO_LWORD(ADR(dwValue)),
	i_wMaxDataLen := 2);
