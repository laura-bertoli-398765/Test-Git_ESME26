__METADATA__
{
  "v3Meta": {
    "objectGuid": "eea500c5-647f-47e3-97f3-b2f491db17ac",
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
	i_xCheckWsParam			: BOOL;
	i_xCheckStartPosParam	: BOOL;
	i_xCheckStopPosParam	: BOOL;
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


IF  ABS(i_lrWsVel) > lrMaxVel AND lrMaxVel <> 0  AND i_xCheckWsParam THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
						i_etDiagExt := PDL_ET_DiagExt.VelRange,
						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1 := 'i_lrWsVel',
																i_sString2 := ' <= ',
																i_sString3 := TO_STRING(lrMaxVel),
																i_sString4 := '') );

ELSIF (i_lrWsAcc <= 0 OR (i_lrWsAcc > lrMaxAcc AND lrMaxAcc <> 0)) AND i_xCheckWsParam THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
						i_etDiagExt := PDL_ET_DiagExt.AccRange,
						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1 := '0.0 < ',
																i_sString2 := 'i_lrWsAcc',
																i_sString3 := ' <= ',
																i_sString4 := TO_STRING(lrMaxAcc) ));
														
ELSIF (i_lrWsJerk <= 0.0 ) AND i_xCheckWsParam THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
						i_etDiagExt := PDL_ET_DiagExt.JerkRange,
						i_sMsg		:= '0.0 < i_lrWsJerk ');
													
ELSIF iq_stExt.xStartPositionSelect AND  (ABS(iq_stExt.lrStartVelocity) > lrMaxVel AND lrMaxVel <> 0) AND i_xCheckStartPosParam THEN
 		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
 						i_etDiagExt := PDL_ET_DiagExt.VelRange,
 						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1 := 'iq_stExt.lrStartVelocity',
																i_sString2 := ' <= ',
																i_sString3 := TO_STRING(lrMaxVel),
																i_sString4 := '')); 	

ELSIF iq_stExt.xStartPositionSelect AND (iq_stExt.lrStartAcceleration <= 0 OR (iq_stExt.lrStartAcceleration > lrMaxAcc AND lrMaxAcc <> 0) ) AND i_xCheckStartPosParam THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
						i_etDiagExt := PDL_ET_DiagExt.AccRange,
						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1 := '0.0 < ',
																i_sString2 := 'iq_stExt.lrStartAcceleration',
																i_sString3 := ' <= ',
																i_sString4 := TO_STRING(lrMaxAcc) ));
														
ELSIF iq_stExt.xStartPositionSelect AND (iq_stExt.lrStartDeceleration <= 0 OR (iq_stExt.lrStartDeceleration > lrMaxAcc AND lrMaxAcc <> 0) ) AND i_xCheckStartPosParam THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
						i_etDiagExt := PDL_ET_DiagExt.DecRange,
						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1 := '0.0 < ',
																i_sString2 := 'iq_stExt.lrStartDeceleration',
																i_sString3 := ' <= ',
																i_sString4 := TO_STRING(lrMaxAcc) ));
														
ELSIF iq_stExt.xStartPositionSelect AND (iq_stExt.lrStartJerk <= 0.0 ) AND i_xCheckStartPosParam THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
						i_etDiagExt := PDL_ET_DiagExt.JerkRange,
						i_sMsg		:= '0.0 < iq_stExt.lrStartJerk');
								
ELSIF iq_stExt.xStopPositionSelect AND (ABS(iq_stExt.lrStopVelocity) > lrMaxVel AND lrMaxVel <> 0) AND i_xCheckStopPosParam THEN
 		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
 						i_etDiagExt := PDL_ET_DiagExt.VelRange,
 						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1 := 'iq_stExt.lrStopVelocity',
																i_sString2 := ' <= ',
																i_sString3 := TO_STRING(lrMaxVel),
																i_sString4 := '')); 	

ELSIF iq_stExt.xStopPositionSelect AND (iq_stExt.lrStopAcceleration <= 0 OR (iq_stExt.lrStopAcceleration > lrMaxAcc AND lrMaxAcc <> 0) ) AND i_xCheckStopPosParam THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
						i_etDiagExt := PDL_ET_DiagExt.AccRange,
						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1 := '0.0 < ',
																i_sString2 := 'iq_stExt.lrStopAcceleration',
																i_sString3 := ' <= ',
																i_sString4 := TO_STRING(lrMaxAcc) ));
														
ELSIF iq_stExt.xStopPositionSelect AND (iq_stExt.lrStopDeceleration <= 0 OR (iq_stExt.lrStopDeceleration > lrMaxAcc AND lrMaxAcc <> 0)) AND i_xCheckStopPosParam THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
						i_etDiagExt := PDL_ET_DiagExt.DecRange,
						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1 := '0.0 < ',
																i_sString2 := 'iq_stExt.lrStopDeceleration',
																i_sString3 := ' <= ',
																i_sString4 := TO_STRING(lrMaxAcc) ));
														
ELSIF iq_stExt.xStopPositionSelect AND (iq_stExt.lrStopJerk <= 0.0 ) AND i_xCheckStopPosParam THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
						i_etDiagExt := PDL_ET_DiagExt.JerkRange,
						i_sMsg		:= '0.0 < iq_stExt.lrStopJerk');		
						
ELSE
	InputParameterCheck := TRUE;
END_IF

