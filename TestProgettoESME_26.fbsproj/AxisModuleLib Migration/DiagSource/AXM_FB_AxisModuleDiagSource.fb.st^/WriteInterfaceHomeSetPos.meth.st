__METADATA__
{
  "v3Meta": {
    "objectGuid": "ea32da19-dde3-435d-b9bf-4f5619be8b89",
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
METHOD INTERNAL WriteInterfaceHomeSetPos : BOOL
VAR_INPUT
END_VAR
VAR_OUTPUT
	q_etDiag		: GD.ET_Diag;
	q_etDiagExt	: TPL.ET_DiagExt;
	q_sMsg			: STRING[80];
END_VAR
__IMPLEMENTATION__
THIS^.fbTreeWriter.NodeStart(	i_sName		:= 'stSetPos',
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
								
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF	
								
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_lrHomePosition', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stHome.stSetPos.i_lrHomePosition),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF	
	
// 	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_lrEncoderPosition', 
// 									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stHome.stSetPos.i_lrEncoderPosition),
// 									q_etDiag	=> q_etDiag,
// 									q_etDiagExt	=> q_etDiagExt,
// 									q_sMsg		=> q_sMsg);
// 							
// 	IF q_etDiag <> GD.ET_Diag.Ok THEN
// 		RETURN;
// 	END_IF	
// 	
// 	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_lrUserPeriod', 
// 									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stHome.stSetPos.i_lrUserPeriod),
// 									q_etDiag	=> q_etDiag,
// 									q_etDiagExt	=> q_etDiagExt,
// 									q_sMsg		=> q_sMsg);
// 							
// 	IF q_etDiag <> GD.ET_Diag.Ok THEN
// 		RETURN;
// 	END_IF	
// 	
// 	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_lrAbsEncOffset', 
// 									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stHome.stSetPos.i_lrAbsEncOffset),
// 									q_etDiag	=> q_etDiag,
// 									q_etDiagExt	=> q_etDiagExt,
// 									q_sMsg		=> q_sMsg);
// 							
// 	IF q_etDiag <> GD.ET_Diag.Ok THEN
// 		RETURN;
// 	END_IF	
// 	
// 	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_lrRestoreWindow', 
// 									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stHome.stSetPos.i_lrRestoreWindow),
// 									q_etDiag	=> q_etDiag,
// 									q_etDiagExt	=> q_etDiagExt,
// 									q_sMsg		=> q_sMsg);
// 							
// 	IF q_etDiag <> GD.ET_Diag.Ok THEN
// 		RETURN;
// 	END_IF	
// 	
// 	IF (THIS^.pstInterface^.stHome.stSetPos.iq_pstRestorePosRetain <> 0) THEN
// 		
// 		THIS^.fbTreeWriter.NodeStart(	i_sName		:= 'iq_pstRestorePosRetain',
// 										q_etDiag	=> q_etDiag,
// 										q_etDiagExt	=> q_etDiagExt,
// 										q_sMsg		=> q_sMsg);
// 										
// 		IF q_etDiag <> GD.ET_Diag.Ok THEN
// 			RETURN;
// 		END_IF	
// 		
// 			THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrEncPosition', 
// 											i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stHome.stSetPos.iq_pstRestorePosRetain^.lrEncPosition),
// 											q_etDiag	=> q_etDiag,
// 											q_etDiagExt	=> q_etDiagExt,
// 											q_sMsg		=> q_sMsg);
// 									
// 			IF q_etDiag <> GD.ET_Diag.Ok THEN
// 				RETURN;
// 			END_IF
// 			
// 			THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrAxisPosition', 
// 											i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stHome.stSetPos.iq_pstRestorePosRetain^.lrAxisPosition),
// 											q_etDiag	=> q_etDiag,
// 											q_etDiagExt	=> q_etDiagExt,
// 											q_sMsg		=> q_sMsg);
// 									
// 			IF q_etDiag <> GD.ET_Diag.Ok THEN
// 				RETURN;
// 			END_IF
// 			
// 			THIS^.fbTreeWriter.Parameter(	i_sName		:= 'lrCheckSum', 
// 											i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stHome.stSetPos.iq_pstRestorePosRetain^.lrCheckSum),
// 											q_etDiag	=> q_etDiag,
// 											q_etDiagExt	=> q_etDiagExt,
// 											q_sMsg		=> q_sMsg);
// 									
// 			IF q_etDiag <> GD.ET_Diag.Ok THEN
// 				RETURN;
// 			END_IF
// 			
// 		THIS^.fbTreeWriter.NodeEnd(	q_etDiag	=> q_etDiag,
// 									q_etDiagExt	=> q_etDiagExt,
// 									q_sMsg		=> q_sMsg);		
// 				
// 		IF q_etDiag <> GD.ET_Diag.Ok THEN
// 			RETURN;
// 		END_IF	
// 	
// 	ELSE
// 		THIS^.fbTreeWriter.Parameter(	i_sName		:= 'iq_pstRestorePosRetain', 
// 										i_sValue	:= 'not configured',
// 										q_etDiag	=> q_etDiag,
// 										q_etDiagExt	=> q_etDiagExt,
// 										q_sMsg		=> q_sMsg);
// 								
// 		IF q_etDiag <> GD.ET_Diag.Ok THEN
// 			RETURN;
// 		END_IF	
// 	END_IF

THIS^.fbTreeWriter.NodeEnd(	q_etDiag	=> q_etDiag,
							q_etDiagExt	=> q_etDiagExt,
							q_sMsg		=> q_sMsg);		
		
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF	
