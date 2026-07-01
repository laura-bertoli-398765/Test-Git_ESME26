__METADATA__
{
  "v3Meta": {
    "objectGuid": "f780d373-eae4-43d7-a829-9e722571d65d",
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

METHOD INTERNAL WriteInterfaceMultiCamParamIn : BOOL
VAR_INPUT
END_VAR
VAR_OUTPUT
	q_etDiag		: GD.ET_Diag;
	q_etDiagExt	: TPL.ET_DiagExt;
	q_sMsg			: STRING[80];
END_VAR
__IMPLEMENTATION__
THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_etCsModeSlave', 
								i_sValue	:= AXM_FC_EtMultiCamCsModeSlaveToString(THIS^.pstInterface^.stMultiCam.i_etCsModeSlave),
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
						
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF	

THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_etCsModeMaster', 
								i_sValue	:= AXM_FC_EtMultiCamCsModeMasterToString(THIS^.pstInterface^.stMultiCam.i_etCsModeMaster),
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
						
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF	

THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_etWsMode', 
								i_sValue	:= AXM_FC_EtMultiCamWsModeToString(THIS^.pstInterface^.stMultiCam.i_etWsMode),
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
						
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF	

THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_lrWsWindow', 
								i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.i_lrWsWindow),
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
						
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF	

THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_lrWsVel', 
								i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.i_lrWsVel),
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
						
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF	

THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_lrWsAcc', 
								i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.i_lrWsAcc),
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
						
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF	

THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_lrWsJerk', 
								i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.i_lrWsJerk),
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
						
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF	

THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_xCheckEncoderPeriod', 
								i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMultiCam.i_xCheckEncoderPeriod),
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
						
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF	

THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_xSetEncoderPosition', 
								i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMultiCam.i_xSetEncoderPosition),
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
						
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF

THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_lrSetEncoderOffset', 
								i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.i_lrSetEncoderOffset),
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
						
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF	

THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_diTXend', 
								i_sValue	:= DINT_TO_STRING(THIS^.pstInterface^.stMultiCam.i_diTXend),
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
						
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF	

THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_lrInstantXLimMax', 
								i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.i_lrInstantXLimMax),
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
						
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF	

THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_xEnableTabHandler', 
								i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMultiCam.i_xEnableTabHandler),
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
						
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF	

THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_udiTableSelectNr', 
								i_sValue	:= UDINT_TO_STRING(THIS^.pstInterface^.stMultiCam.i_udiTableSelectNr),
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
						
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF	
