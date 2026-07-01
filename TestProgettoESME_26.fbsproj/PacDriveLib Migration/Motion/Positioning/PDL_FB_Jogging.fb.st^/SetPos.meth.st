__METADATA__
{
  "v3Meta": {
    "objectGuid": "4f759012-a240-4bed-a03d-0f6c3a3399e2",
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
METHOD PRIVATE SetPos : BOOL  //returns false in case of error
VAR_INPUT
END_VAR
__IMPLEMENTATION__
SetPos := TRUE; //TRUE: Success

IF i_lrPeriod > 0 THEN
	
	//reset fb
	fbSetPos(Execute := FALSE ); 

	//period counter
	lrPosBuffer := i_ifDrive.lrPosition;
	iPeriodeCount := TRUNC_INT(lrPosBuffer / i_lrPeriod);
	IF lrPosBuffer < 0 THEN
		iPeriodeCount := iPeriodeCount - 1;
	END_IF

	//pos > period
	IF lrPosBuffer > i_lrPeriod + 0.001  THEN
		fbSetPos(	Execute		:= TRUE, 
					Position	:= -i_lrPeriod*iPeriodeCount, 
					Relative	:= TRUE);

	//pos < 0
	ELSIF lrPosBuffer  < -0.001 THEN
		fbSetPos(	Execute		:= TRUE, 
					Position	:= i_lrPeriod*ABS(iPeriodeCount), 
					Relative	:= TRUE);
	END_IF
	
	
	//fb error
	IF fbSetPos.Error THEN
		q_xMotionInstructionActive	:= FALSE;
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
						i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
						i_sMsg		:= CONCAT('MC_SetPosition.ErrorId: ', TO_STRING(fbSetPos.ErrorId)));
		SetPos := FALSE;						
		RETURN;
	END_IF
	
END_IF

q_lrPosition := i_ifDrive.lrPosition;


