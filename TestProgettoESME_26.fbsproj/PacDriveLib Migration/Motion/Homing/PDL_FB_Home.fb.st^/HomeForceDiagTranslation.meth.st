__METADATA__
{
  "v3Meta": {
    "objectGuid": "169ec9f3-f970-4883-8ccf-567d467b0028",
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
METHOD PRIVATE HomeForceDiagTranslation : BOOL
VAR
END_VAR
__IMPLEMENTATION__
IF THIS^.xFbEnable AND THIS^.fbHomeForce.q_etDiag <> GD.ET_Diag.Ok THEN

	CASE THIS^.fbHomeForce.q_etDiagExt OF

		PDL_ET_DiagExt.ControllerInvalid,
		PDL_ET_DiagExt.DriveNotReady,
		PDL_ET_DiagExt.MaxForceNotFound,
		PDL_ET_DiagExt.AccRange,
		PDL_ET_DiagExt.DecRange,
		PDL_ET_DiagExt.DriveInvalid,
		PDL_ET_DiagExt.JerkRange,
		PDL_ET_DiagExt.MaxForceRange,
		PDL_ET_DiagExt.MaxTravelRange,
		PDL_ET_DiagExt.VelRange,
		PDL_ET_DiagExt.SercosNotInPhaseFour,
		PDL_ET_DiagExt.UnexpectedFeedback,
		PDL_ET_DiagExt.UnknownState:

			THIS^.sTempMsg 	:= SE_CTBX.FC_MultiConcat(  i_sString1 := 'Mode HomeForce: ',
												i_sString2 := THIS^.fbHomeForce.q_sMsg,
												i_sString3 := '',
												i_sString4 := ''); 
			SetDiagOutput(	i_etDiag	:= THIS^.fbHomeForce.q_etDiag, 
							i_etDiagExt := THIS^.fbHomeForce.q_etDiagExt,
							i_sMsg		:= THIS^.sTempMsg);
	ELSE
		sTempMsg 	:= SE_CTBX.FC_MultiConcat(  i_sString1 := 'Mode HomeForce, PDL_FB_HomeForce: ' ,
										i_sString2 := PDL_FC_EtDiagExtToString(i_etDiagExt := THIS^.fbHomeForce.q_etDiagExt),
										i_sString3 := THIS^.fbHomeForce.q_sMsg,
										i_sString4 := ''); 
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
						i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
						i_sMsg		:= THIS^.sTempMsg);
	END_CASE

END_IF
