__METADATA__
{
  "v3Meta": {
    "objectGuid": "e49fa851-5256-4ece-bfbc-c49aa56bcb5d",
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

METHOD INTERNAL WriteInterfaceMultiCamParamOutActualCamData : BOOL
VAR_INPUT
END_VAR
VAR_OUTPUT
	q_etDiag		: GD.ET_Diag;
	q_etDiagExt	: TPL.ET_DiagExt;
	q_sMsg			: STRING[80];
END_VAR
__IMPLEMENTATION__
THIS^.fbTreeWriter.NodeStart(	i_sName		:= 'q_stActualCamData',
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
								
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF	

	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'diProfileId', 
									i_sValue	:= DINT_TO_STRING(THIS^.pstInterface^.stMultiCam.q_stActualCamData.diProfileId),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrXOffset', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.q_stActualCamData.lrXOffset),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrYOffset', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.q_stActualCamData.lrYOffset),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrXFactor', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.q_stActualCamData.lrXFactor),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrYFactor', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.q_stActualCamData.lrYFactor),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'diUserTableId', 
									i_sValue	:= DINT_TO_STRING(THIS^.pstInterface^.stMultiCam.q_stActualCamData.diUserTableId),
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
