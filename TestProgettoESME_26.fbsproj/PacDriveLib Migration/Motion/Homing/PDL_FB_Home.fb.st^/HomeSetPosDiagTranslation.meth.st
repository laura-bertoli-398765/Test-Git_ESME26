__METADATA__
{
  "v3Meta": {
    "objectGuid": "a40b4d3d-99ce-4ec4-92cc-0034eedcaf51",
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
METHOD Private HomeSetPosDiagTranslation : BOOL
VAR
END_VAR
__IMPLEMENTATION__
IF THIS^.xFbEnable AND THIS^.fbSetpos.q_etDiag <> GD.ET_Diag.Ok THEN

	CASE THIS^.fbSetpos.q_etDiagExt OF
		PDL_ET_DiagExt.DriveEncoderInvalid,
		PDL_ET_DiagExt.RestoreInterrupted,
		PDL_ET_DiagExt.SercosNotInPhaseFour,
		PDL_ET_DiagExt.AbsEncOffsetRange,
		PDL_ET_DiagExt.CheckSumInvalid,
		PDL_ET_DiagExt.DataNVRamInvalid,
		PDL_ET_DiagExt.DriveInvalid,
		PDL_ET_DiagExt.LencInvalid,
		PDL_ET_DiagExt.PointerRestorePosRetainInvalid,
		PDL_ET_DiagExt.UserPeriodRange,
		PDL_ET_DiagExt.OutOfRestoreWindow,
		PDL_ET_DiagExt.UnexpectedFeedback,
		PDL_ET_DiagExt.UnknownMode,
		PDL_ET_DiagExt.UnknownState:
			THIS^.sTempMsg 	:= SE_CTBX.FC_MultiConcat(  i_sString1 := 'Mode HomeSetPos: ',
														i_sString2 := THIS^.fbSetpos.q_sMsg,
														i_sString3 := '',
														i_sString4 := ''); 
			SetDiagOutput(	i_etDiag	:= THIS^.fbSetpos.q_etDiag, 
							i_etDiagExt := THIS^.fbSetpos.q_etDiagExt,
							i_sMsg		:= THIS^.sTempMsg);
	ELSE
		sTempMsg 	:= SE_CTBX.FC_MultiConcat(  i_sString1 := 'Mode HomeSetPos, PDL_FB_HomeSetPos: ' ,
												i_sString2 := PDL_FC_EtDiagExtToString(i_etDiagExt := THIS^.fbSetpos.q_etDiagExt),
												i_sString3 := THIS^.fbSetpos.q_sMsg,
												i_sString4 := ''); 
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
						i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
						i_sMsg		:= THIS^.sTempMsg);
	END_CASE

END_IF
