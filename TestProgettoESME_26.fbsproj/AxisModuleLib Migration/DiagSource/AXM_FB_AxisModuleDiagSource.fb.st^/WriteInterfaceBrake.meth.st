__METADATA__
{
  "v3Meta": {
    "objectGuid": "bd56ca31-a528-4b4e-8ae2-a923a0c5a276",
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
METHOD INTERNAL WriteInterfaceBrake : BOOL
VAR_INPUT
END_VAR
VAR_OUTPUT
	q_etDiag		: GD.ET_Diag;
	q_etDiagExt	: TPL.ET_DiagExt;
	q_sMsg			: STRING[80];
END_VAR
__IMPLEMENTATION__
THIS^.fbTreeWriter.NodeStart(	i_sName		:= 'stBrake',
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
								
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'q_xBrakeReleased', 
									i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stBrake.q_xBrakeReleased),
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
