__METADATA__
{
  "v3Meta": {
    "objectGuid": "d51b780a-20c3-4739-9a46-4d3e82f77181",
    "objectTypeGuid": "f8a58466-d7f6-439f-bbb8-d4600e41d099",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {
      "_3S.CoDeSys.LanguageModelManager.BuildProperty": "<?xml version=\"1.0\" encoding=\"utf-8\"?><Single xml:space=\"preserve\" Type=\"{24568a24-c491-472c-a21f-ee5d33859fab}\" Method=\"IArchivable\"><Single Name=\"MemoryReserveForOnlineChange\" Type=\"int\">0</Single><Single Name=\"ExcludeFromBuild\" Type=\"bool\">False</Single><Single Name=\"External\" Type=\"bool\">False</Single><Single Name=\"EnableSystemCall\" Type=\"bool\">False</Single><Single Name=\"CompilerDefines\" Type=\"string\"></Single><Single Name=\"LinkAlways\" Type=\"bool\">False</Single><Array Name=\"Undefines\" Type=\"string\" /></Single>"
    },
    "subObjects": {}
  }
}
__DECLARATION__
{attribute 'conditionalshow_all_locals'}
METHOD INTERNAL WriteInterfaceHomeForce : BOOL
VAR_INPUT
END_VAR
VAR_OUTPUT
	q_etDiag		: GD.ET_Diag;
	q_etDiagExt	: TPL.ET_DiagExt;
	q_sMsg			: STRING[80];
END_VAR
__IMPLEMENTATION__
THIS^.fbTreeWriter.NodeStart(	i_sName		:= 'stForce',
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
								
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF	
								
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_lrHomePosition', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stHome.stForce.i_lrHomePosition),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF	
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_lrVel', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stHome.stForce.i_lrVel),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF	
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_lrAcc', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stHome.stForce.i_lrAcc),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF	
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_lrDec', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stHome.stForce.i_lrDec),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF	
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_lrJerk', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stHome.stForce.i_lrJerk),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF	
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_lrOffset', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stHome.stForce.i_lrOffset),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_lrMaxTravel', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stHome.stForce.i_lrMaxTravel),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_lrMaxForce', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stHome.stForce.i_lrMaxForce),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_diForceTime', 
									i_sValue	:= DINT_TO_STRING(THIS^.pstInterface^.stHome.stForce.i_diForceTime),
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
