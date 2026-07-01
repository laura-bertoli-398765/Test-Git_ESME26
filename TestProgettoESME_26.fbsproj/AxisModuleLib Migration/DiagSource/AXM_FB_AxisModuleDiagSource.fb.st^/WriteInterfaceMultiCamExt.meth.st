__METADATA__
{
  "v3Meta": {
    "objectGuid": "2440431e-d2bb-46a6-8906-9137cd17388f",
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
{attribute 'conditionalshow_all_locals'}
METHOD INTERNAL WriteInterfaceMultiCamExt : BOOL
VAR_INPUT
END_VAR
VAR_OUTPUT
	q_etDiag		: GD.ET_Diag;
	q_etDiagExt	: TPL.ET_DiagExt;
	q_sMsg			: STRING[80];
END_VAR
__IMPLEMENTATION__
THIS^.fbTreeWriter.NodeStart(	i_sName		:= 'iq_stExt',
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
								
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF	

	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'xNoModuloMasterAtStart', 
									i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_stExt.xNoModuloMasterAtStart),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'xNoModuloSlaveAtStart', 
									i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_stExt.xNoModuloSlaveAtStart),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'xNoCyclicCams', 
									i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_stExt.xNoCyclicCams),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'xFirstCamNoXLimMin', 
									i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_stExt.xFirstCamNoXLimMin),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'xStopPositionSelect', 
									i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_stExt.xStopPositionSelect),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrStopPosition', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_stExt.lrStopPosition),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrStopVelocity', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_stExt.lrStopVelocity),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrStopAcceleration', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_stExt.lrStopAcceleration),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrStopDeceleration', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_stExt.lrStopDeceleration),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrStopJerk', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_stExt.lrStopJerk),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'xStartPositionSelect', 
									i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_stExt.xStartPositionSelect),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrStartPosition', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_stExt.lrStartPosition),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrStartVelocity', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_stExt.lrStartVelocity),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrStartAcceleration', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_stExt.lrStartAcceleration),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrStartDeceleration', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_stExt.lrStartDeceleration),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrStartJerk', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_stExt.lrStartJerk),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'xYEqualCheck', 
									i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_stExt.xYEqualCheck),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrYEqualCheckAccuracy', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_stExt.lrYEqualCheckAccuracy),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'xNewCamDirectAccept', 
									i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_stExt.xNewCamDirectAccept),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'xDisableLowEnd', 
									i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_stExt.xDisableLowEnd),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'xDisableHighEnd', 
									i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_stExt.xDisableHighEnd),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrCsMasterPosition', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_stExt.lrCsMasterPosition),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'xInWindowCheckWithoutLimits', 
									i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_stExt.xInWindowCheckWithoutLimits),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'etInWindowMode', 
									i_sValue	:= AXM_FC_EtMultiCamWsModeToString(THIS^.pstInterface^.stMultiCam.iq_stExt.etInWindowMode),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrXStart', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_stExt.lrXStart),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrXIncr', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_stExt.lrXIncr),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrAccuracy', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_stExt.lrAccuracy),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
THIS^.fbTreeWriter.NodeEnd(	q_etDiag	=> q_etDiag,
							q_etDiagExt	=> q_etDiagExt,
							q_sMsg		=> q_sMsg);	
								
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF	
