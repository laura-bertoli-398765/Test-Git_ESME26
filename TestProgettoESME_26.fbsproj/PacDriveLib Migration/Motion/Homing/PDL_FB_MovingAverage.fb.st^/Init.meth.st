__METADATA__
{
  "v3Meta": {
    "objectGuid": "0f45f304-b247-4a3f-b276-0857f7508301",
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
METHOD Init : BOOL
VAR_INPUT
	i_uiOrder		: UINT;
END_VAR

VAR_OUTPUT
	q_etDiag			: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt			: PDL_ET_DiagExt := PDL_ET_DiagExt.Ok;
	
END_VAR
__IMPLEMENTATION__
	THIS^.lrAverage_loc := 0.0;
	
IF i_uiOrder > 0  AND i_uiOrder <= Gc_uiMovingAverageMaxOrder THEN

	THIS^.uiOrder_loc := i_uiOrder;
	
	THIS^.uiLevel_loc := 0;
	
	FOR THIS^.uiI := 1 TO Gc_uiMovingAverageMaxOrder DO
		THIS^.alrBufferElements[THIS^.uiI]:= 0;
	END_FOR

	THIS^.uiWriteIndex := 1;
	THIS^.lrSum:= 0.0;		
	THIS^.xInitialized := TRUE;
	
	q_etDiag :=  GD.ET_Diag.Ok;
	q_etDiagExt := PDL_ET_DiagExt.Ok;

ELSE

	q_etDiag :=  GD.ET_Diag.InputParameterInvalid;
	q_etDiagExt := PDL_ET_DiagExt.OrderRange;
	
	THIS^.xInitialized := FALSE;
	
END_IF
