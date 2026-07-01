__METADATA__
{
  "v3Meta": {
    "objectGuid": "a3dfbc02-f005-4c32-8c1c-5fba9b6b731b",
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
METHOD INTERNAL ExceptionDuringWriting : BOOL
VAR_INPUT
END_VAR
__IMPLEMENTATION__
(* exception during writing *)
CASE THIS^.etDiagExtBufferTPL OF
	TPL.ET_DiagExt.TreeStartAlreadySuccessfullyCalled,		// FB_TreeWriter.TreeStart	
	TPL.ET_DiagExt.FileIdNotSet,							// FB_TreeWriter.TreeStart							
	TPL.ET_DiagExt.FileIdInvalid,							// FB_TreeWriter.TreeStart & FB_TreeWriter.NodeStart & FB_TreeWriter.Parameter & FB_TreeWriter.NodeEnd & FB_TreeWriter.TreeEnd								
	TPL.ET_DiagExt.FileNotOpen,								// FB_TreeWriter.TreeStart & FB_TreeWriter.NodeStart & FB_TreeWriter.Parameter & FB_TreeWriter.NodeEnd & FB_TreeWriter.TreeEnd								
	TPL.ET_DiagExt.UnexpectedFeedback,						// FB_TreeWriter.TreeStart & FB_TreeWriter.NodeStart & FB_TreeWriter.Parameter & FB_TreeWriter.NodeEnd & FB_TreeWriter.TreeEnd								
	TPL.ET_DiagExt.TreeStartNotCalled,						// FB_TreeWriter.NodeStart								
	TPL.ET_DiagExt.TreeStartNotSuccessfullyCalled,			// FB_TreeWriter.NodeStart								
	TPL.ET_DiagExt.NoMoreNodeOpen,							// FB_TreeWriter.Parameter & FB_TreeWriter.NodeEnd						
	TPL.ET_DiagExt.CallTreeStartFirst,						// FB_TreeWriter.TreeEnd								
	TPL.ET_DiagExt.NodesStillOpen:							// FB_TreeWriter.TreeEnd	
	
		SetDiagOutputs(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior,
						i_etDiagExt	:= ET_DiagExt.UnexpectedFeedback,
						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1	:= 'FB_TreeWriter: ', 
															i_sString2	:= GD.FC_EtDiagToString(THIS^.etDiagBuffer), 
															i_sString3	:= ' - ', 
															i_sString4	:= TPL.FC_EtDiagExtToString(THIS^.etDiagExtBufferTPL))); 								
	ELSE
		SetDiagOutputs(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior,
						i_etDiagExt	:= ET_DiagExt.UnexpectedFeedback,
						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1	:= 'FB_TreeWriter: ', 
															i_sString2	:= GD.FC_EtDiagToString(THIS^.etDiagBuffer), 
															i_sString3	:= ' - ', 
															i_sString4	:= TPL.FC_EtDiagExtToString(THIS^.etDiagExtBufferTPL)));
																		
END_CASE
		
CancelWriting();
