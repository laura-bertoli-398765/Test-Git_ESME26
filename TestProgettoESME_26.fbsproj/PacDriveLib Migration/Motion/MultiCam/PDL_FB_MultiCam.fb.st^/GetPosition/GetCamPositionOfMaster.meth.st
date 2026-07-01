__METADATA__
{
  "v3Meta": {
    "objectGuid": "d969ad34-f3f2-480d-bec5-563bbe1379cd",
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
METHOD PRIVATE GetCamPositionOfMaster : BOOL
VAR_INPUT
END_VAR


VAR
	etMoinResult				: MOIN.ET_Result;
END_VAR	
__IMPLEMENTATION__
GetCamPositionOfMaster := TRUE;



etMoinResult :=  MOIN.FC_GetMasterPositionFromGivenSlavePositionForMultiCam(
							i_lrSlavePosition		:= i_ifDrive.lrPosition, 
							i_lrMasterScaling		:= 1, 
							i_lrSlaveScaling		:= 1, 
							i_stCamTableID			:= stActiveMultiCamData, 
							i_lrStartPosition		:= iq_stExt.lrXStart, 
							i_lrAccuracy			:= iq_stExt.lrAccuracy, 
							i_lrIncrementalStepSize	:= iq_stExt.lrXIncr, 
							q_lrMasterPosition		=> q_lrPositionX );

IF etMoinResult <> MOIN.ET_Result.Ok THEN

	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
					i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
					i_sMsg		:= CONCAT('FC_GetMasterPositionFromGivenSlavePositionForMultiCam: ', TO_STRING(etMoinResult)));
	etState := ET_MulticamState.idle_error;
	GetCamPositionOfMaster := FALSE;
	RETURN;
END_IF			
