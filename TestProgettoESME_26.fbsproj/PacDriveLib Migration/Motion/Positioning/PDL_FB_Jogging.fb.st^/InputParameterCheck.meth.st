__METADATA__
{
  "v3Meta": {
    "objectGuid": "6a0f46f9-e427-4042-95b6-40fcebdaeb2e",
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
	xCheckDistance 		: BOOL := TRUE;
	xCheckPeriod 		: BOOL := TRUE;
END_VAR
VAR
	lrMaxAcc	: LREAL := 0;
END_VAR
__IMPLEMENTATION__
InputParameterCheck := FALSE;

//if IF_DriveConfig is not available -> limits are NOT checked 
IF ifDriveConfig <> 0 THEN
	lrMaxAcc := ifDriveConfig.MaxAcc;	
END_IF


IF i_lrAcc <= 0.0 OR (i_lrAcc > lrMaxAcc AND lrMaxAcc <> 0) THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.AccRange,
					i_sMsg		:= STANDARD.CONCAT('0.0 < i_lrAcc <= ', TO_STRING(lrMaxAcc)) );
	RETURN;

ELSIF i_lrDec <= 0.0 OR (i_lrDec > lrMaxAcc AND lrMaxAcc <> 0) THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DecRange,
					i_sMsg		:= STANDARD.CONCAT('0.0 < i_lrDec <= ', TO_STRING(lrMaxAcc)) );
	RETURN;
ELSIF i_lrJerk <= 0.0 THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.JerkRange,
					i_sMsg		:= '0.0 < i_lrJerk');
	RETURN;
	
	
ELSIF i_lrMaxDistance < 0 AND xCheckDistance THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.MaxDistanceRange,
					i_sMsg		:= '0 <= i_lrMaxDistance');	
	RETURN;
					
ELSIF i_lrPeriod < 0 AND xCheckPeriod THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.PeriodRange,
					i_sMsg		:= '0 <= i_lrPeriod');	
	RETURN;

END_IF

InputParameterCheck := TRUE;
