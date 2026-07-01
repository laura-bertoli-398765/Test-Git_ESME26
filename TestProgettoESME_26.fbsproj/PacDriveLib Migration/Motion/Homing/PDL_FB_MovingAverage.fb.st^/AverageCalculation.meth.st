__METADATA__
{
  "v3Meta": {
    "objectGuid": "aed23f4b-5877-404c-80c6-f56942048b31",
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
{attribute 'hide'}
METHOD AverageCalculation : BOOL
VAR_INPUT
END_VAR

VAR
	uiReadIndexStart 	: UINT;	
	diReadIndex			: DINT;	
END_VAR
__IMPLEMENTATION__
//internal routine for calculating AverageValue completely

//get Max Number of usable Values
IF THIS^.uiLevel_loc >= Gc_uiMovingAverageMaxOrder THEN
	THIS^.uiValidValues := Gc_uiMovingAverageMaxOrder;
ELSE
	THIS^.uiValidValues := THIS^.uiLevel_loc;
END_IF

//get Number of Values to use according order
IF THIS^.uiValidValues >= THIS^.uiOrder_loc THEN
	THIS^.uiValidValues := THIS^.uiOrder_loc;
ELSE
	THIS^.uiValidValues := THIS^.uiLevel_loc;
	IF THIS^.uiValidValues = 0 THEN
		//do not allow division by zero
		THIS^.uiValidValues := 1;
	END_IF
END_IF

//Calculation
THIS^.lrSum      := 0.0;
uiReadIndexStart := THIS^.uiWriteIndex;

FOR THIS^.uiI := 1 TO THIS^.uiValidValues DO
	
	diReadIndex := UINT_TO_DINT(uiReadIndexStart) - UINT_TO_DINT(THIS^.uiI);
	//Check for positive Index
	IF diReadIndex <= 0 THEN
		diReadIndex := diReadIndex + UINT_TO_DINT(Gc_uiMovingAverageMaxOrder);
	END_IF
	
	THIS^.lrSum := THIS^.lrSum + THIS^.alrBufferElements[diReadIndex];
END_FOR

THIS^.lrAverage_loc := lrSum / UINT_TO_LREAL(uiValidValues);
