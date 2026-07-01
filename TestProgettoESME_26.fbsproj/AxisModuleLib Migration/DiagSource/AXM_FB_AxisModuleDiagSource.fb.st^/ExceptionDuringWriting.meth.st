__METADATA__
{
  "v3Meta": {
    "objectGuid": "19bfc1da-3ddf-47a9-a872-85af3b10c98b",
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
METHOD INTERNAL ExceptionDuringWriting : BOOL
VAR_INPUT
END_VAR
__IMPLEMENTATION__
(* exception during writing *)
CASE THIS^.etDiagExtTPL OF
	TPL.ET_DiagExt.TreeStartAlreadySuccessfullyCalled,		
	TPL.ET_DiagExt.FileIdNotSet,							
	TPL.ET_DiagExt.FileIdInvalid,												
	TPL.ET_DiagExt.FileNotOpen,													
	TPL.ET_DiagExt.UnexpectedFeedback,											
	TPL.ET_DiagExt.TreeStartNotCalled,						
	TPL.ET_DiagExt.TreeStartNotSuccessfullyCalled,			
	TPL.ET_DiagExt.NoMoreNodeOpen,											
	TPL.ET_DiagExt.CallTreeStartFirst,						
	TPL.ET_DiagExt.NodesStillOpen:							
	                                                        
		SetDiagOutputs(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior,
						i_etDiagExt	:= AXM_ET_DiagExt.UnexpectedFeedback,
						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1	:= 'FB_TreeWriter: ', 
																i_sString2	:= GD.FC_EtDiagToString(THIS^.etDiag), 
																i_sString3	:= ' - ', 
																i_sString4	:= TPL.FC_EtDiagExtToString(THIS^.etDiagExtTPL) 
															 )
					  ); 								
	ELSE
		SetDiagOutputs(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior,
						i_etDiagExt	:= AXM_ET_DiagExt.UnexpectedFeedback,
						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1	:= 'FB_TreeWriter: ', 
																i_sString2	:= GD.FC_EtDiagToString(THIS^.etDiag), 
																i_sString3	:= ' - ', 
																i_sString4	:= TPL.FC_EtDiagExtToString(THIS^.etDiagExtTPL) 
															  )
					   ); 						
END_CASE
		
CancelWriting();
