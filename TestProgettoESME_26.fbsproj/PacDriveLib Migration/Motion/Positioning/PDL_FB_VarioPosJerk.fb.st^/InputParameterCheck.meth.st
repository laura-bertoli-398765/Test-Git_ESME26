__METADATA__
{
  "v3Meta": {
    "objectGuid": "03bc2fd1-8d13-4ec1-bba8-032671b540d3",
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


//if IF_DriveConfig is not available -> limits are NOT checked 
IF ifDriveConfig <> 0 THEN
	lrMaxAcc := ifDriveConfig.MaxAcc;	
	lrMaxVel := ifDriveConfig.MaxVel;	
END_IF


IF i_lrVel <= 0  OR (i_lrVel > lrMaxVel AND lrMaxVel <> 0) THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
						i_etDiagExt := PDL_ET_DiagExt.VelRange,
						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1 := '0 < i_lrVel <= ',
																i_sString2 := TO_STRING( lrMaxVel),
																i_sString3 := '',
																i_sString4 := ''));
														
ELSIF i_lrAcc <= 0 OR (i_lrAcc > lrMaxAcc AND lrMaxAcc <> 0) THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
						i_etDiagExt := PDL_ET_DiagExt.AccRange,
						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1 := '0.0 < ',
																i_sString2 := 'i_lrAcc',
																i_sString3 := ' <= ',
																i_sString4 := TO_STRING(lrMaxAcc)
																));
														
ELSIF i_lrDec <= 0 OR (i_lrDec > lrMaxAcc AND lrMaxAcc <> 0) THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
						i_etDiagExt := PDL_ET_DiagExt.DecRange,
						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1 := '0.0 < ',
																i_sString2 := 'i_lrDec',
																i_sString3 := ' <= ',
																i_sString4 := TO_STRING(lrMaxAcc)
																));

ELSIF    (i_etPosMode <> PDL_ET_PosMode.Absolute) 
	AND  (i_etPosMode <> PDL_ET_PosMode.Relative) 
	AND  (i_etPosMode <> PDL_ET_PosMode.Endless) 
THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.PosModeRange,
					i_sMsg		:= '');

ELSIF i_lrJerk <= 0.0  THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.JerkRange,
					i_sMsg		:= '0.0 < i_lrJerk ');
ELSE
	InputParameterCheck := TRUE;
END_IF

//Target-Prüfung fehlt noch

