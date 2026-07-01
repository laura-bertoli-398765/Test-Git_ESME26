__METADATA__
{
  "v3Meta": {
    "objectGuid": "4e627bd7-4dfd-4506-92b5-b0acf87f94c8",
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
METHOD Insert : BOOL
VAR_INPUT
	i_lrValue		: LREAL;
END_VAR
VAR_OUTPUT
	q_etDiag				: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt				: PDL_ET_DiagExt := PDL_ET_DiagExt.Ok;
END_VAR
VAR
	diIndexOldestValue		: DINT;	
	uiDenominator			: UINT; 
END_VAR
__IMPLEMENTATION__
IF NOT THIS^.xInitialized THEN

	//Fehlermeldung ausgeben und abbrechen
	q_etDiag := GD.ET_Diag.ExecutionAborted;
	q_etDiagExt := PDL_ET_DiagExt.InitMethodNotCalled;

ELSE

	//	calculate index of oldest value, which has to be subtracted from the summation of the last order values
	diIndexOldestValue := THIS^.uiWriteIndex - THIS^.uiOrder_loc;
	IF diIndexOldestValue <= 0 THEN
		diIndexOldestValue := diIndexOldestValue + UINT_TO_DINT(Gc_uiMovingAverageMaxOrder);
	END_IF

	// calculate summation over the last order values
	THIS^.lrSum := THIS^.lrSum + i_lrValue - (THIS^.alrBufferElements[diIndexOldestValue]);
	
	// add new value to list of values (has to be done after detection of oldest value, because the oldest value is overwritten if order is maximum)
	THIS^.alrBufferElements[THIS^.uiWriteIndex] := i_lrValue;
	THIS^.uiWriteIndex := THIS^.uiWriteIndex + 1;

	IF THIS^.uiWriteIndex > Gc_uiMovingAverageMaxOrder THEN
		THIS^.uiWriteIndex := 1;
	END_IF

	// increase fill-level
	THIS^.uiLevel_loc := THIS^.uiLevel_loc + 1;
	IF THIS^.uiLevel > Gc_uiMovingAverageMaxOrder  THEN
		THIS^.uiLevel_loc := Gc_uiMovingAverageMaxOrder;
	END_IF

	// calculate average value
	uiDenominator := MIN(THIS^.uiLevel_loc, THIS^.uiOrder_loc);
	IF uiDenominator = 0 THEN
		uiDenominator := 1;
	END_IF
	THIS^.lrAverage_loc :=  THIS^.lrSum / UINT_TO_LREAL(uiDenominator);

	q_etDiag := GD.ET_Diag.Ok;
	q_etDiagExt := PDL_ET_DiagExt.Ok;
END_IF 
