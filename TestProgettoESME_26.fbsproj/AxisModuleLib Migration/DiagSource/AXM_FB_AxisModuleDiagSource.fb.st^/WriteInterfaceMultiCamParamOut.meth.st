__METADATA__
{
  "v3Meta": {
    "objectGuid": "709df46f-69e9-402c-89c8-c631d6836da0",
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

METHOD INTERNAL WriteInterfaceMultiCamParamOut : BOOL
VAR_INPUT
END_VAR
VAR_OUTPUT
	q_etDiag		: GD.ET_Diag;
	q_etDiagExt	: TPL.ET_DiagExt;
	q_sMsg			: STRING[80];
END_VAR
__IMPLEMENTATION__
THIS^.fbTreeWriter.Parameter(	i_sName		:= 'iq_xNewCam', 
								i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_xNewCam),
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
						
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF

THIS^.fbTreeWriter.Parameter(	i_sName		:= 'iq_xInstantNewCam', 
								i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_xInstantNewCam),
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
						
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF

THIS^.fbTreeWriter.Parameter(	i_sName		:= 'iq_xChangeMaster', 
								i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_xChangeMaster),
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
						
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF

THIS^.fbTreeWriter.Parameter(	i_sName		:= 'q_xXLowEnd', 
								i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMultiCam.q_xXLowEnd),
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
						
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF

THIS^.fbTreeWriter.Parameter(	i_sName		:= 'q_xXHighEnd', 
								i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMultiCam.q_xXHighEnd),
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
						
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF

THIS^.fbTreeWriter.Parameter(	i_sName		:= 'q_xInWsWindow', 
								i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMultiCam.q_xInWsWindow),
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
						
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF

THIS^.fbTreeWriter.Parameter(	i_sName		:= 'q_lrCalculatedCamPosition', 
								i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.q_lrCalculatedCamPosition),
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
						
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF

THIS^.fbTreeWriter.Parameter(	i_sName		:= 'q_diActTable', 
								i_sValue	:= DINT_TO_STRING(THIS^.pstInterface^.stMultiCam.q_diActTable),
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
						
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF
