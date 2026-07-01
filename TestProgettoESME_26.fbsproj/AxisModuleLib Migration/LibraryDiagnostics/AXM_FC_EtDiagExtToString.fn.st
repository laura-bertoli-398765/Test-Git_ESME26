__METADATA__
{
  "v3Meta": {
    "objectGuid": "95fffc69-1878-46c7-b0f8-97c4fe5ae5a3",
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
FUNCTION AXM_FC_EtDiagExtToString : STRING[80]
VAR_INPUT
	i_etDiagExt : AXM_ET_DiagExt;
END_VAR
VAR_OUTPUT
	q_etDiag	: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt	: AXM_ET_DiagExt := AXM_ET_DiagExt.Ok;
END_VAR
VAR
END_VAR
__IMPLEMENTATION__
AXM_FC_EtDiagExtToString := TO_STRING(i_etDiagExt);
IF TO_UDINT(AXM_FC_EtDiagExtToString) <> 0 THEN // if the string is not a number the result is 0
	AXM_FC_EtDiagExtToString := Standard.CONCAT('Unknown DiagExt: ', TO_STRING(i_etDiagExt));
	q_etDiag := GD.ET_Diag.InputParameterInvalid;
	q_etDiagExt := AXM_ET_DiagExt.DiagExtRange; 
END_IF
