__METADATA__
{
  "v3Meta": {
    "objectGuid": "b7978909-da71-4bff-8a99-d135c3712486",
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
METHOD PRIVATE SetPos : BOOL
VAR_INPUT
END_VAR
__IMPLEMENTATION__

IF i_lrPeriod > 0 THEN
	
	//reset fb
	fbSetPos(	Axis := i_ifDrive, Execute := FALSE ); 

	IF (q_lrPosition > 2 * i_lrPeriod) OR q_lrPosition  < -i_lrPeriod THEN
		lrPeriodeCount := TRUNC_INT(q_lrPosition / i_lrPeriod);
		IF q_lrPosition < 0 THEN
			lrPeriodeCount := (lrPeriodeCount - 1);
		END_IF
			
		IF lrPeriodeCount <> 0 THEN
			q_lrPosition:= q_lrPosition - lrPeriodeCount * i_lrPeriod;


			fbSetPos(	Axis		:= i_ifDrive, 
						Execute		:= TRUE, 
						Position	:= -lrPeriodeCount * i_lrPeriod, 
						Relative	:= TRUE);

			IF fbSetPos.Error THEN
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
								i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
								i_sMsg		:= CONCAT('MC_SetPosition.ErrorId: ', TO_STRING(fbSetPos.ErrorId)));
				RETURN;
			END_IF
							
			lrStopPosition := lrStopPosition - lrPeriodeCount * i_lrPeriod;
		END_IF

	ELSIF q_lrPosition > i_lrPeriod + 0.001  THEN
		lrInchPos		:= lrInchPos - i_lrPeriod;
		q_lrPosition	:= q_lrPosition - i_lrPeriod;

		fbSetPos(	Axis		:= i_ifDrive, 
					Execute		:= TRUE, 
					Position	:= -i_lrPeriod, 
					Relative	:= TRUE);

		IF fbSetPos.Error THEN
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
							i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
							i_sMsg		:= CONCAT('MC_SetPosition.ErrorId: ', TO_STRING(fbSetPos.ErrorId)));
			RETURN;
		END_IF

														
		lrStopPosition := lrStopPosition - i_lrPeriod;

	ELSIF q_lrPosition  < -0.001 THEN
		lrInchPos		:= lrInchPos + i_lrPeriod;
		q_lrPosition	:= q_lrPosition + i_lrPeriod;


		fbSetPos(	Axis		:= i_ifDrive, 
					Execute		:= TRUE, 
					Position	:= i_lrPeriod, 
					Relative	:= TRUE);
					
		IF fbSetPos.Error THEN
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
							i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
							i_sMsg		:= CONCAT('MC_SetPosition.ErrorId: ', TO_STRING(fbSetPos.ErrorId)));
			RETURN;
		END_IF

									
		lrStopPosition := lrStopPosition + i_lrPeriod;
	END_IF
END_IF
