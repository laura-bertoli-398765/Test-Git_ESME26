__METADATA__
{
  "v3Meta": {
    "objectGuid": "6ee586d5-424f-4d54-8345-e8a58771cf03",
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
METHOD PRIVATE MoveToStopPosition : BOOL
VAR
	lrStopPosCycles      : LREAL;
	lrNormalizedStopPos  : LREAL;
	lrBrakePosCycles     : LREAL;
	lrNormalizedBrakePos : LREAL;
END_VAR

__IMPLEMENTATION__

IF NOT InputParameterCheck() THEN
		
	q_xInVelocity				:= FALSE;
	q_xMotionInstructionActive	:= FALSE;
	q_xReady					:= FALSE;

	diState := 100;
ELSE
	q_xMotionInstructionActive := TRUE;
	
	// if velocity was set to zero together with i_xStart = FALSE take velocity of last seen command.
	IF i_lrVel <> 0 THEN 
		lrActVel	:= i_lrVel;
	END_IF
	lrActJerk	:= i_lrJerk;
	lrAccel	:= i_lrACC;
	lrDecel	:= i_lrDEC;

	//calc new stop position
	IF NOT xMoveToStoppingStarted THEN
	
		//modulo axis
		IF xModuloAxis THEN
			lrStopPosition := i_lrStopPosition;
			
		//linear axis -> lrStopPosition has to be calculated
		ELSE
			IF lrActVel >= 0 THEN
				etResultCalcStopping := MOIN.FC_CalculateMoveVelocity( 	i_etDirection 				:= MOIN.ET_Direction.PositiveDirection, //not considered when TargetVelocity = 0   
																		i_lrStartVelocity			:= i_ifDrive.lrVelocity + i_ifDrive.lrAcceleration*0.01,//tolerance to avoid overshoot
																		i_lrStartAcceleration		:= i_ifDrive.lrAcceleration,
																		i_lrMovementAcceleration 	:= lrAccel,
																		i_lrMovementDeceleration	:= lrDecel,
																		i_lrJerk 					:= lrActJerk,
																		i_lrStartPosition			:= 0.0, //inside a distance is calculated, StartPosition is added  
																		i_lrTargetVelocity			:= 0.0,
																		q_stTrajectory				=> stStoppingDistance,
																		q_xError					=> xErrorCalcStopping
																		);
				IF xErrorCalcStopping THEN																
					q_xActive					:= FALSE;	
					q_xMotionInstructionActive	:= FALSE;		
					q_lrPosition				:= 0.0;	
					
					SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
									i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
									i_sMsg		:= CONCAT('FC_CalculateMoveVelocity.ET_Result: ', MOIN.FC_EtResultToString(etResultCalcStopping) ));					
					diState := 100;
					RETURN;	
				ELSE				
					lrStoppingDistance := ABS(stStoppingDistance.astPoints[stStoppingDistance.uiNumberOfPhases].lrPosition);
				END_IF

				
				IF i_lrPeriod > 0 THEN
					lrPeriodeCount := DINT_TO_LREAL(TRUNC((q_lrPosition + lrStoppingDistance) / i_lrPeriod)); 
					IF q_lrPosition + lrStoppingDistance - lrPeriodeCount * i_lrPeriod > i_lrStopPosition THEN
						lrPeriodeCount := lrPeriodeCount + 1;
					END_IF
					lrStopPosition := i_lrStopPosition + lrPeriodeCount * i_lrPeriod;
				ELSE
					lrStopPosition := i_lrStopPosition;
				END_IF
			
			ELSE
				etResultCalcStopping := MOIN.FC_CalculateMoveVelocity( 	i_etDirection 				:= MOIN.ET_Direction.NegativeDirection,  //not considered when TargetVelocity = 0 
																		i_lrStartVelocity			:= i_ifDrive.lrVelocity + i_ifDrive.lrAcceleration*0.01,//tolerance to avoid overshoot
																		i_lrStartAcceleration		:= i_ifDrive.lrAcceleration,
																		i_lrMovementAcceleration 	:= lrAccel,
																		i_lrMovementDeceleration	:= lrDecel,
																		i_lrJerk 					:= lrActJerk,
																		i_lrStartPosition			:= 0,
																		i_lrTargetVelocity			:= 0.0,
																		q_stTrajectory				=> stStoppingDistance,
																		q_xError					=> xErrorCalcStopping
																		);
				IF xErrorCalcStopping THEN																
					q_xActive					:= FALSE;	
					q_xMotionInstructionActive	:= FALSE;		
					q_lrPosition				:= 0.0;	
					
					SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
									i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
									i_sMsg		:= CONCAT('FC_CalculateMoveVelocity.ET_Result: ', MOIN.FC_EtResultToString(etResultCalcStopping) ));					
					diState := 100;
					RETURN;	
				ELSE				
					lrStoppingDistance := ABS(stStoppingDistance.astPoints[stStoppingDistance.uiNumberOfPhases].lrPosition);
				END_IF
				
				IF i_lrPeriod > 0 THEN
					lrStopPosCycles      := TO_LREAL(TRUNC(i_lrStopPosition / i_lrPeriod));
					lrNormalizedStopPos  := i_lrStopPosition - lrStopPosCycles * i_lrPeriod;
					lrBrakePosCycles     := ABS(TO_LREAL(TRUNC((q_lrPosition - lrStoppingDistance - i_lrPeriod) / i_lrPeriod))); // slided one period to negative, because first negative period would be zero (as "first" positive period)
					lrNormalizedBrakePos := q_lrPosition - lrStoppingDistance + lrBrakePosCycles * i_lrPeriod;
					IF lrStopPosCycles >= 1.0 OR lrNormalizedBrakePos > lrNormalizedStopPos THEN
						// can stop in cycle or is forced to move to next cycle with too big i_lrStopPosition anyway
						lrStopPosition := lrNormalizedStopPos - (lrStopPosCycles + lrBrakePosCycles) * i_lrPeriod;
					ELSE
						// add additional move to next cycle to prevent overswing
						lrStopPosition := lrNormalizedStopPos - (lrStopPosCycles + lrBrakePosCycles + 1.0) * i_lrPeriod;
					END_IF
				ELSE
					lrStopPosition := i_lrStopPosition;
				END_IF
			END_IF
		END_IF
	END_IF
	
	//reset fbs
	fbMoveVelocity( Execute := FALSE);
	fbMoveAbsolute( Execute := FALSE);
	
	//call fb with new values
	fbMoveAbsolute(	Execute			:= TRUE, 
					Position		:= lrStopPosition, 
					Velocity		:= ABS(lrActVel), 
					Acceleration	:= lrAccel, 
					Deceleration	:= lrDecel, 
					Jerk			:= lrActJerk, 
					Direction		:= fbMoveVelocity.Direction);		

	//set output msg
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok, 
					i_etDiagExt := PDL_ET_DiagExt.WaitUntilStopPositionReached,
					i_sMsg		:= '');			
	
END_IF


