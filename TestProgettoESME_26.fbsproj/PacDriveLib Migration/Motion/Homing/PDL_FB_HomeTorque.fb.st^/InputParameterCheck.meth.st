__METADATA__
{
  "v3Meta": {
    "objectGuid": "6b6389c5-14ec-47be-b9c6-4b28f98129d6",
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

METHOD PRIVATE InputParameterCheck : BOOL
VAR_INPUT
END_VAR
__IMPLEMENTATION__
InputParameterCheck := FALSE;



IF (i_lrMaxTravel <= 0.0) THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.MaxTravelRange,
					i_sMsg		:= '0.0 < i_lrMaxTravel');
	RETURN;

ELSIF i_lrVel <= 0.0 OR (ABS(i_lrVel) > ifDriveConfig.MaxVel AND ifDriveConfig.MaxVel <> 0) THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.VelRange,
					i_sMsg		:= STANDARD.CONCAT('0.0 < i_lrVel <= ', TO_STRING(ifDriveConfig.MaxVel)) );
	RETURN;

ELSIF i_lrAcc <= 0.0 OR (i_lrAcc > ifDriveConfig.MaxAcc AND ifDriveConfig.MaxAcc <> 0) THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.AccRange,
					i_sMsg		:= STANDARD.CONCAT('0.0 < i_lrAcc <= ', TO_STRING(ifDriveConfig.MaxAcc) ));
	RETURN;

ELSIF i_lrDec <= 0.0 OR (i_lrDec > ifDriveConfig.MaxAcc AND ifDriveConfig.MaxAcc <> 0)THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DecRange,
					i_sMsg		:= STANDARD.CONCAT('0.0 < i_lrDec <= ', TO_STRING(ifDriveConfig.MaxAcc) ));
	RETURN;
	
ELSIF i_lrJerk <= 0.0 THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.JerkRange,
					i_sMsg		:= '0.0 < i_lrJerk');
	RETURN;
END_IF

THIS^.fbStop.Deceleration := i_lrDec;
THIS^.fbStop.Jerk		  := i_lrJerk;


InputParameterCheck := TRUE;
