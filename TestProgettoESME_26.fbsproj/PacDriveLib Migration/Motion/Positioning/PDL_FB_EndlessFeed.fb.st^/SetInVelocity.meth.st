__METADATA__
{
  "v3Meta": {
    "objectGuid": "2b85cde4-eaba-453d-bf1a-e087f0c985b3",
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
METHOD PRIVATE SetInVelocity : BOOL
VAR_INPUT
END_VAR
VAR
	lrMaxVelDeviation			: LREAL;
	lrCurrVelDeviation			: LREAL;
END_VAR
__IMPLEMENTATION__

// Check, if we have already reached the required velocity
IF (ABS(lrActVel) > 0) THEN
	
	lrMaxVelDeviation	:= 0.01 * ABS(i_ifDrive.lrVelocity);
	lrCurrVelDeviation	:= ABS( lrActVel - i_ifDrive.lrVelocity); 
	IF (lrCurrVelDeviation <= lrMaxVelDeviation )THEN
		q_xInVelocity	:= TRUE;
	ELSE
		q_xInVelocity	:= FALSE;
	END_IF
ELSE
	q_xInVelocity := q_xMotionInstructionActive;
END_IF




