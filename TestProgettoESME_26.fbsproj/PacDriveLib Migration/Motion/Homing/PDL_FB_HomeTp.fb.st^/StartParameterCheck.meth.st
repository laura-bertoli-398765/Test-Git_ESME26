__METADATA__
{
  "v3Meta": {
    "objectGuid": "e3e968dd-36a0-43b2-be13-2f2c0cd27c72",
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
METHOD PRIVATE StartParameterCheck : BOOL
VAR_INPUT
END_VAR
__IMPLEMENTATION__
StartParameterCheck := FALSE;

IF i_ifDrive = 0 THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg		:= 'i_ifDrive - Invalid Interface');
ELSIF i_ifTouchProbe = 0 THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.TouchProbeInvalid,
					i_sMsg		:= 'i_ifTouchProbe - Invalid Interface');
ELSIF (i_lrMaxTravel <= 0.0) THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.MaxTravelRange,
					i_sMsg		:= 'i_lrMaxTravel <= 0.0');
ELSIF i_lrVel <= 0.0  OR (ABS(i_lrVel) > ifDriveConfig.MaxVel AND ifDriveConfig.MaxVel <> 0) THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.VelRange,
					i_sMsg		:= STANDARD.CONCAT('0.0 < i_lrVel <= ', TO_STRING(ifDriveConfig.MaxVel)) );
ELSIF i_lrAcc <= 0.0 OR (i_lrAcc > ifDriveConfig.MaxAcc AND ifDriveConfig.MaxAcc <> 0) THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.AccRange,
					i_sMsg		:= STANDARD.CONCAT('0.0 < i_lrAcc <= ', TO_STRING(ifDriveConfig.MaxAcc) ));
ELSIF i_lrDec <= 0.0 OR (i_lrDec > ifDriveConfig.MaxAcc AND ifDriveConfig.MaxAcc <> 0)THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DecRange,
					i_sMsg		:= STANDARD.CONCAT('0.0 < i_lrDec <= ', TO_STRING(ifDriveConfig.MaxAcc) ));
ELSIF (i_etMode <> PDL_ET_HomeTpMode.PosDirectionPosEdgeTp) AND
	(i_etMode <> PDL_ET_HomeTpMode.NegDirectionPosEdgeTp) AND
	(i_etMode <> PDL_ET_HomeTpMode.NegDirectionNegEdgeTp) AND
	(i_etMode <> PDL_ET_HomeTpMode.PosDirectionNegEdgeTp) THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
						i_etDiagExt := PDL_ET_DiagExt.UnknownMode,
						i_sMsg		:= '');
ELSE
	lrDistance	:= i_lrMaxTravel;
	
	fbStop.Deceleration 		:= i_lrDec;
	fbStop.Jerk 				:= i_lrJerk;
	
	fbMoveAbsolute.Velocity 	:= i_lrVel;
	fbMoveAbsolute.Deceleration := i_lrDec;
	fbMoveAbsolute.Acceleration := i_lrAcc;
	fbMoveAbsolute.Jerk 		:= i_lrJerk;
	
	fbMoveRelative.Velocity 	:= i_lrVel;
	fbMoveRelative.Deceleration := i_lrDec;
	fbMoveRelative.Acceleration := i_lrAcc;
	fbMoveRelative.Jerk 		:= i_lrJerk;
	
	StartParameterCheck := TRUE;
END_IF
