__METADATA__
{
  "v3Meta": {
    "objectGuid": "5d575959-8856-4e1f-b222-a58bb189d100",
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
METHOD Private HomeLSDiagTranslation : BOOL
VAR
END_VAR
__IMPLEMENTATION__
IF THIS^.xFbEnable AND THIS^.fbHomeLS.q_etDiag <> GD.ET_Diag.Ok THEN

	CASE THIS^.fbHomeLS.q_etDiagExt OF

		PDL_ET_DiagExt.DriveNotReady,
		PDL_ET_DiagExt.SensorNotFound,
		PDL_ET_DiagExt.AccRange,
		PDL_ET_DiagExt.DecRange,
		PDL_ET_DiagExt.DriveInvalid,
		PDL_ET_DiagExt.JerkRange,
		PDL_ET_DiagExt.LowVelRange,
		PDL_ET_DiagExt.MaxTravelRange,
		PDL_ET_DiagExt.VelRange,
		PDL_ET_DiagExt.HwLimitNegReached,
		PDL_ET_DiagExt.HwLimitPosReached,
		PDL_ET_DiagExt.SercosNotInPhaseFour,
		PDL_ET_DiagExt.UnexpectedFeedback,
		PDL_ET_DiagExt.UnknownState:

			THIS^.sTempMsg 	:= SE_CTBX.FC_MultiConcat(  i_sString1 := 'Mode HomeLS: ',
														i_sString2 := THIS^.fbHomeLS.q_sMsg,
														i_sString3 := '',
														i_sString4 := ''); 
			SetDiagOutput(	i_etDiag	:= THIS^.fbHomeLS.q_etDiag, 
							i_etDiagExt := THIS^.fbHomeLS.q_etDiagExt,
							i_sMsg		:= THIS^.sTempMsg);
	ELSE
		sTempMsg 	:= SE_CTBX.FC_MultiConcat(  i_sString1 := 'Mode HomeLS, PDL_FB_HomeLimitSwitch: ' ,
												i_sString2 := PDL_FC_EtDiagExtToString(i_etDiagExt := THIS^.fbHomeLS.q_etDiagExt),
												i_sString3 := THIS^.fbHomeLS.q_sMsg,
												i_sString4 := ''); 
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
						i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
						i_sMsg		:= THIS^.sTempMsg);
	END_CASE

END_IF
