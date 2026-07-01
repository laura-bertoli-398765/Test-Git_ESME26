__METADATA__
{
  "v3Meta": {
    "objectGuid": "a0bd202a-5491-4976-86f4-6b20b2717580",
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
VAR
	lrMaxAcc	: LREAL := 0;
	lrMaxVel	: LREAL := 0;
END_VAR
__IMPLEMENTATION__
InputParameterCheck := FALSE;

lrMaxAcc := ifDriveConfig.MaxAcc;
lrMaxVel := ifDriveConfig.MaxVel;

IF (i_lrMaxTravel <= 0.0) THEN
	SetDiagOutput(i_etDiag := GD.ET_Diag.InputParameterInvalid, i_etDiagExt := PDL_ET_DiagExt.MaxTravelRange, i_sMsg := '0.0 < i_lrMaxTravel');
	RETURN;
	
ELSIF i_lrVel <= 0.0 OR (i_lrVel > lrMaxVel AND lrMaxVel <> 0) THEN
	SetDiagOutput(
		i_etDiag    := GD.ET_Diag.InputParameterInvalid,
		i_etDiagExt := PDL_ET_DiagExt.VelRange,
		i_sMsg      := STANDARD.CONCAT('0.0 < i_lrVel <= ', TO_STRING(lrMaxVel))
	);
	RETURN;
	
ELSIF (i_lrAcc <= 0.0 OR i_lrAcc > lrMaxAcc AND lrMaxAcc <> 0) THEN
	SetDiagOutput(
		i_etDiag    := GD.ET_Diag.InputParameterInvalid,
		i_etDiagExt := PDL_ET_DiagExt.AccRange,
		i_sMsg      := STANDARD.CONCAT('0.0 < i_lrAcc <= ', TO_STRING(lrMaxAcc))
	);
	RETURN;
	
ELSIF (i_lrDec <= 0.0 OR i_lrDec > lrMaxAcc AND lrMaxAcc <> 0) THEN
	SetDiagOutput(
		i_etDiag    := GD.ET_Diag.InputParameterInvalid,
		i_etDiagExt := PDL_ET_DiagExt.DecRange,
		i_sMsg      := STANDARD.CONCAT('0.0 < i_lrDec <= ', TO_STRING(lrMaxAcc))
	);
	RETURN;
	
ELSIF i_lrJerk <= 0.0 THEN
	SetDiagOutput(i_etDiag := GD.ET_Diag.InputParameterInvalid, i_etDiagExt := PDL_ET_DiagExt.JerkRange, i_sMsg := '0.0 < i_lrJerk');
	RETURN;
END_IF

THIS^.fbMoveRelative.Velocity     := i_lrVel;
THIS^.fbMoveRelative.Acceleration := i_lrAcc;
THIS^.fbMoveRelative.Deceleration := i_lrDec;
THIS^.fbMoveRelative.Jerk         := i_lrJerk;
THIS^.fbMoveRelative.BufferMode   := PLCO.MC_Buffer_Mode.Aborting;

THIS^.fbHalt.Jerk         := i_lrJerk;
THIS^.fbHalt.Deceleration := i_lrDec;
THIS^.fbHalt.BufferMode   := PLCO.MC_Buffer_Mode.Aborting;

THIS^.fbStop.Jerk         := i_lrJerk;
THIS^.fbStop.Deceleration := i_lrDec;

InputParameterCheck := TRUE;
