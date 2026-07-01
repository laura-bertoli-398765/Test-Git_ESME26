__METADATA__
{
  "v3Meta": {
    "objectGuid": "a0611d26-332c-4111-9c1d-278c823dacad",
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
METHOD INTERNAL WriteInterfaceMultiCamMotionParCamPoint : BOOL
VAR_INPUT
END_VAR
VAR_OUTPUT
	q_etDiag		: GD.ET_Diag;
	q_etDiagExt	: TPL.ET_DiagExt;
	q_sMsg			: STRING[80];
END_VAR
__IMPLEMENTATION__
THIS^.fbTreeWriter.NodeStart(	i_sName		:= Standard.CONCAT('astCamPoint[', Standard.CONCAT(DINT_TO_STRING(THIS^.diCamPointCounter), ']')),
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
								
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF	
								
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrX', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_astMotionPar[THIS^.diMotionParCounter].astCamPoint[THIS^.diCamPointCounter].lrX),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrY', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_astMotionPar[THIS^.diMotionParCounter].astCamPoint[THIS^.diCamPointCounter].lrY),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'etCamType', 
									i_sValue	:= AXM_FC_EtCamTypeToString(THIS^.pstInterface^.stMultiCam.iq_astMotionPar[THIS^.diMotionParCounter].astCamPoint[THIS^.diCamPointCounter].etCamType),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrM', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_astMotionPar[THIS^.diMotionParCounter].astCamPoint[THIS^.diCamPointCounter].lrM),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrK', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_astMotionPar[THIS^.diMotionParCounter].astCamPoint[THIS^.diCamPointCounter].lrK),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrYUser', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_astMotionPar[THIS^.diMotionParCounter].astCamPoint[THIS^.diCamPointCounter].lrYUser),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'diProfileId', 
									i_sValue	:= DINT_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_astMotionPar[THIS^.diMotionParCounter].astCamPoint[THIS^.diCamPointCounter].diProfileId),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrYUserOffset', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_astMotionPar[THIS^.diMotionParCounter].astCamPoint[THIS^.diCamPointCounter].lrYUserOffset),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrLambda', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_astMotionPar[THIS^.diMotionParCounter].astCamPoint[THIS^.diCamPointCounter].lrLambda),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrC', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMultiCam.iq_astMotionPar[THIS^.diMotionParCounter].astCamPoint[THIS^.diCamPointCounter].lrC),
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
