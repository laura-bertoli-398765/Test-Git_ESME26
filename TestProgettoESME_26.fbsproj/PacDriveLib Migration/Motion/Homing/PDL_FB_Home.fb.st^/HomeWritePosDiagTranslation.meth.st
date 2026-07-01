__METADATA__
{
  "v3Meta": {
    "objectGuid": "54b8bf8a-7609-4502-9ee6-1b10453f7fed",
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
METHOD Private HomeWritePosDiagTranslation : BOOL
VAR
END_VAR
__IMPLEMENTATION__
IF THIS^.xFbEnable AND THIS^.fbHomeAbs.q_etDiag <> GD.ET_Diag.Ok THEN

	CASE THIS^.fbHomeAbs.q_etDiagExt OF

		PDL_ET_DiagExt.SercosInterfaceInvalid,
		PDL_ET_DiagExt.DriveEncoderInvalid,
		PDL_ET_DiagExt.DriveIsMoving,
		PDL_ET_DiagExt.DriveNotDisabled,
		PDL_ET_DiagExt.NoAccessToEEPROM,
		PDL_ET_DiagExt.ProgrammingInProgress,
		PDL_ET_DiagExt.ProgrammingInvalidEEPROM,
		PDL_ET_DiagExt.AbsEncOffsetRange,
		PDL_ET_DiagExt.DriveInvalid,
		PDL_ET_DiagExt.UserPeriodRange,
		PDL_ET_DiagExt.SercosNotInPhaseFour,
		PDL_ET_DiagExt.EncoderWriteTimeOut,
		PDL_ET_DiagExt.UnexpectedFeedback,
		PDL_ET_DiagExt.UnknownState:

			THIS^.sTempMsg 	:= SE_CTBX.FC_MultiConcat(  i_sString1 := 'Mode HomeWritePos: ',
												i_sString2 := THIS^.fbHomeAbs.q_sMsg,
												i_sString3 := '',
												i_sString4 := ''); 
			SetDiagOutput(	i_etDiag	:= THIS^.fbHomeAbs.q_etDiag, 
							i_etDiagExt := THIS^.fbHomeAbs.q_etDiagExt,
							i_sMsg		:= THIS^.sTempMsg);
	ELSE
		sTempMsg 	:= SE_CTBX.FC_MultiConcat(  i_sString1 := 'Mode HomeWritePos, PDL_FB_HomeAbs: ' ,
										i_sString2 := PDL_FC_EtDiagExtToString(i_etDiagExt := THIS^.fbHomeAbs.q_etDiagExt),
										i_sString3 := THIS^.fbHomeAbs.q_sMsg,
										i_sString4 := ''); 
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
						i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
						i_sMsg		:= THIS^.sTempMsg);
	END_CASE

END_IF
