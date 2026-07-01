__METADATA__
{
  "v3Meta": {
    "objectGuid": "46a0f5db-c6e3-408b-9530-f2fcb0d53885",
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
FUNCTION PDL_FC_EtDiagExtToString : STRING[80]
VAR_INPUT
	i_etDiagExt : PDL_ET_DiagExt;
END_VAR
VAR_OUTPUT
	q_etDiag			: GD.ET_Diag := GD.ET_Diag.OK;
	q_etDiagExt			: PDL_ET_DiagExt := PDL_ET_DiagExt.OK;
END_VAR
VAR
END_VAR
__IMPLEMENTATION__
PDL_FC_EtDiagExtToString := TO_STRING(i_etDiagExt);
