__METADATA__
{
  "v3Meta": {
    "objectGuid": "9296cd82-e001-4ba8-9776-db12e2063d74",
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
METHOD PRIVATE AsyncExtDiagTranslation : BOOL
VAR_INPUT
	i_etResult : SE_Async.ET_Result;
END_VAR
__IMPLEMENTATION__

CASE i_etResult OF
	SE_Async.ET_Result.MaxNumOfReusableObjectsExceeded: ; // No error message. Try again to Start in next cycle

		
	SE_Async.ET_Result.AsyncAddWasNotSuccessful:
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
						i_etDiagExt := PDL_ET_DiagExt.AsyncAddWasNotSuccessful,
						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1 := '#', 
														i_sString2 := DINT_TO_STRING(diState), 
														i_sString3 := ' G_ifAsync.Start: ', 
														i_sString4 := PDL_FC_EtDiagExtToString(etDiagExt)));

	SE_Async.ET_Result.InterfaceCastFailed:
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
						i_etDiagExt := PDL_ET_DiagExt.InterfaceCastFailed,
						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1 := '#', 
														i_sString2 := DINT_TO_STRING(diState), 
														i_sString3 := ' G_ifAsync.Start: ', 
														i_sString4 := PDL_FC_EtDiagExtToString(etDiagExt)));
		
	SE_Async.ET_Result.SemaphoreCreateFailed:
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
						i_etDiagExt := PDL_ET_DiagExt.SemaphoreMeCreateFailed,
						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1 := '#', 
														i_sString2 := DINT_TO_STRING(diState), 
														i_sString3 := ' G_ifAsync.Start: ', 
														i_sString4 := PDL_FC_EtDiagExtToString(etDiagExt)));

	SE_Async.ET_Result.AsyncInvalid:
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
						i_etDiagExt := PDL_ET_DiagExt.AsyncInvalid,
						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1 := '#', 
														i_sString2 := DINT_TO_STRING(diState), 
														i_sString3 := ' G_ifAsync.Start: ', 
														i_sString4 := PDL_FC_EtDiagExtToString(etDiagExt)));
		
	SE_Async.ET_Result.NoAsyncTasksCreated:
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.ExecutionAborted, 
						i_etDiagExt := PDL_ET_DiagExt.NoAsyncTasksCreated,
						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1 := '#', 
														i_sString2 := DINT_TO_STRING(diState), 
														i_sString3 := ' G_ifAsync.Start: ', 
														i_sString4 := PDL_FC_EtDiagExtToString(etDiagExt)));
		
	SE_Async.ET_Result.AsyncInitNotFinished:
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.ExecutionAborted, 
						i_etDiagExt := PDL_ET_DiagExt.AsyncInitNotFinished,
						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1 := '#', 
														i_sString2 := DINT_TO_STRING(diState), 
														i_sString3 := ' G_ifAsync.Start: ', 
														i_sString4 := PDL_FC_EtDiagExtToString(etDiagExt)));
		
	SE_Async.ET_Result.ColdResetOfControllerNecessary:
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.ExecutionAborted, 
						i_etDiagExt := PDL_ET_DiagExt.ColdResetOfControllerNecessary,
						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1 := '#', 
														i_sString2 := DINT_TO_STRING(diState), 
														i_sString3 := ' G_ifAsync.Start: ', 
														i_sString4 := PDL_FC_EtDiagExtToString(etDiagExt)));
		
	ELSE
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
						i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
						i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1 := '#', 
														i_sString2 := DINT_TO_STRING(diState), 
														i_sString3 := ' G_ifAsync.Start: ', 
														i_sString4 := PDL_FC_EtDiagExtToString(etDiagExt)));
END_CASE	
