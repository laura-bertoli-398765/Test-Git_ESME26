__METADATA__
{
  "v3Meta": {
    "objectGuid": "dad504b0-fcdd-4d6d-bd70-758191436065",
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
METHOD PRIVATE MoveVelocity : BOOL
VAR_INPUT
END_VAR

__IMPLEMENTATION__

IF NOT InputParameterCheck() THEN
		
	q_xInVelocity				:= FALSE;
	q_xMotionInstructionActive	:= FALSE;
	q_xReady					:= FALSE;

	diState := 100;
ELSE
	q_xMotionInstructionActive := TRUE;

	//check if velocity changes direction
	IF (lrActVel*i_lrVel) >= 0 THEN
		lrAccel	:= i_lrACC;
		lrDecel	:= i_lrDEC;	
	ELSE //if yes take acceleration also for deceleration phase
		lrAccel	:= i_lrACC;
		lrDecel	:= i_lrACC;	
	END_IF
	lrActVel  := i_lrVel;
	lrActJerk := i_lrJerk;

	//set direction
	IF lrActVel < 0 THEN
		fbMoveVelocity.Direction := MOIN.ET_Direction.NegativeDirection;
	ELSE
		fbMoveVelocity.Direction := MOIN.ET_Direction.PositiveDirection;
	END_IF
	
	//reset fbs
	fbMoveAbsolute( Execute := FALSE);
	fbMoveVelocity( Execute := FALSE );
	
	//call fb with new values
	fbMoveVelocity(	Execute			:= TRUE, 
					Velocity		:= ABS(lrActVel), 
					Acceleration	:= lrAccel, 
					Deceleration	:= lrDecel, 
					Jerk			:= lrActJerk);


	//set output msg
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok, 
					i_etDiagExt := PDL_ET_DiagExt.EndlessPositioning,
					i_sMsg		:= Standard.CONCAT('Velocity: ', LREAL_TO_STRING(lrActVel)));		

END_IF
