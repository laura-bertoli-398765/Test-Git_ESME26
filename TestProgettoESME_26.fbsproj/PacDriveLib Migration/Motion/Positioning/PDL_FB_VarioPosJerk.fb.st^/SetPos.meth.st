__METADATA__
{
  "v3Meta": {
    "objectGuid": "ff11356a-ed2a-4bb3-b3c4-fd24507d8505",
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

IF i_etPosMode = PDL_ET_PosMode.Endless THEN
	
	fbSetPos( 	Axis		:= i_ifDrive, 
				Execute		:= FALSE); 		

	fbSetPos( 	Axis		:= i_ifDrive, 
				Execute		:= TRUE, 
				Position 	:= 0, 
				Relative  	:= FALSE
				);
				
	IF   fbSetPos.Error 
	  OR NOT fbSetPos.Done
	THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
						i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
						i_sMsg		:= CONCAT('MC_SetPosition.ErrorID: ', TO_STRING(fbSetPos.ErrorID) ));
						
		fbSetPos( 	Axis		:= i_ifDrive, 
					Execute		:= FALSE); 
		diState := 0;	
		RETURN;
	END_IF

END_IF	
