__METADATA__
{
  "v3Meta": {
    "objectGuid": "0b6a6a29-f70f-4860-b3a4-c88fb07fcb0e",
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


IF    NOT xModuloAxis 
  AND i_lrPeriod <= 0.0  
THEN									
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.PeriodRange,
					i_sMsg		:= '0.0 < i_lrPeriod');
					
ELSIF i_lrStopPosition < 0.0 THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.StopPositionRange,
					i_sMsg		:= '0.0 <= i_lrStopPosition');

ELSIF    xModuloAxis 
	 AND i_lrStopPosition > lrModuloPeriod
THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.StopPositionRange,
					i_sMsg		:= 'i_lrStopPosition > Modulo Period');

ELSIF i_lrAcc <= 0.0 OR (i_lrAcc > lrMaxAcc AND lrMaxAcc <> 0) THEN 
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.AccRange,
					i_sMsg		:= STANDARD.CONCAT('0.0 < i_lrAcc <= ', TO_STRING(lrMaxAcc) ));

ELSIF i_lrDec <= 0.0 OR (i_lrDec > lrMaxAcc AND lrMaxAcc <> 0) THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DecRange,
					i_sMsg		:= STANDARD.CONCAT('0.0 < i_lrDec <= ', TO_STRING(lrMaxAcc) ));

ELSIF ABS(i_lrVel) > lrMaxVel AND lrMaxVel <> 0 THEN 
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.VelRange,
					i_sMsg		:= STANDARD.CONCAT('0.0 < i_lrVel <= ', TO_STRING(lrMaxVel) ));

ELSIF i_lrJerk <= 0.0  THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.JerkRange,
					i_sMsg		:= '0.0 < i_lrJerk');

ELSE
	InputParameterCheck := TRUE;
END_IF
