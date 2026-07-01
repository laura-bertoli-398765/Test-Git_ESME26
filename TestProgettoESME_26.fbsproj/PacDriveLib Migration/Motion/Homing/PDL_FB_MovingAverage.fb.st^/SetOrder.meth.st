__METADATA__
{
  "v3Meta": {
    "objectGuid": "24c91569-891a-4a89-8cc5-e8a7ef5e050e",
    "objectTypeGuid": "f8a58466-d7f6-439f-bbb8-d4600e41d099",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__DECLARATION__
METHOD SetOrder : BOOL
VAR_INPUT
	i_uiOrder	: UINT;
END_VAR

VAR_OUTPUT
	q_etDiag			: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt			: PDL_ET_DiagExt := PDL_ET_DiagExt.Ok;
END_VAR
__IMPLEMENTATION__
IF i_uiOrder > 0 AND i_uiOrder <= Gc_uiMovingAverageMaxOrder THEN

	uiOrder_loc := i_uiOrder; 

	AverageCalculation();
	
ELSE
	
	q_etDiag :=  GD.ET_Diag.InputParameterInvalid;
	q_etDiagExt := PDL_ET_DiagExt.OrderRange;
	
END_IF
