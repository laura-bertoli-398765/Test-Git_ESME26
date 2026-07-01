__METADATA__
{
  "v3Meta": {
    "objectGuid": "812a6077-c1de-437c-8376-8c07c7305126",
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
{attribute 'hide'}
METHOD ExceptionDuringWriting : BOOL
VAR_INPUT
END_VAR
__IMPLEMENTATION__
(* exception during writing *)
CASE THIS^.etDiagExtTPL OF
	TPL.ET_DiagExt.HeaderStartAlreadySuccessfullyCalled,	// FB_TableWriter.HeaderStart	
	TPL.ET_DiagExt.FileIdNotSet,							// FB_TableWriter.HeaderStart							
	TPL.ET_DiagExt.FileIdInvalid,							// FB_TableWriter.HeaderStart & FB_TableWriter.HeaderAddColumn & FB_TableWriter.HeaderFinish & FB_TableWriter.RowStart & FB_TableWriter.RowValue & FB_TableWriter.TableEnd							
	TPL.ET_DiagExt.FileNotOpen,								// FB_TableWriter.HeaderStart & FB_TableWriter.HeaderAddColumn & FB_TableWriter.HeaderFinish & FB_TableWriter.RowStart & FB_TableWriter.RowValue & FB_TableWriter.TableEnd								
	TPL.ET_DiagExt.UnexpectedFeedback,						// FB_TableWriter.HeaderStart & FB_TableWriter.HeaderAddColumn & FB_TableWriter.HeaderFinish & FB_TableWriter.RowStart & FB_TableWriter.RowValue & FB_TableWriter.TableEnd								
	TPL.ET_DiagExt.HeaderStartNotCalled,					// FB_TableWriter.HeaderAddColumn								
	TPL.ET_DiagExt.HeaderStartNotSuccessfullyCalled,		// FB_TableWriter.HeaderAddColumn								
	TPL.ET_DiagExt.MaxNumberOfColumnsExceeded,				// FB_TableWriter.HeaderAddColumn						
	TPL.ET_DiagExt.NameInvalid,								// FB_TableWriter.HeaderAddColumn								
	TPL.ET_DiagExt.NoColumnsDefined,						// FB_TableWriter.HeaderFinish	
	TPL.ET_DiagExt.DefineHeaderFirst,						// FB_TableWriter.RowStart
	TPL.ET_DiagExt.RowStartedCallRowEndFirst,				// FB_TableWriter.RowStart
	TPL.ET_DiagExt.CallRowStartFirst,						// FB_TableWriter.RowValue
	TPL.ET_DiagExt.ColumnNumberRange,						// FB_TableWriter.RowValue
	TPL.ET_DiagExt.RowsStillOpen,							// FB_TableWriter.TableEnd
	TPL.ET_DiagExt.HeaderColumnIdInvalid:
	
		SetDiagOutputs(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior,
						i_etDiagExt	:= ET_DiagExt.UnexpectedFeedback,
						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1	:= 'FB_TableWriter: ', 
															i_sString2	:= GD.FC_EtDiagToString(THIS^.etDiag), 
															i_sString3	:= ' - ', 
															i_sString4	:= TPL.FC_EtDiagExtToString(THIS^.etDiagExtTPL))); 								
	ELSE
		SetDiagOutputs(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior,
						i_etDiagExt	:= ET_DiagExt.UnexpectedFeedback,
						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1	:= 'FB_TableWriter: ', 
															i_sString2	:= GD.FC_EtDiagToString(THIS^.etDiag), 
															i_sString3	:= ' - ', 
															i_sString4	:= TPL.FC_EtDiagExtToString(THIS^.etDiagExtTPL) )); 						
END_CASE
		
CancelWriting();
