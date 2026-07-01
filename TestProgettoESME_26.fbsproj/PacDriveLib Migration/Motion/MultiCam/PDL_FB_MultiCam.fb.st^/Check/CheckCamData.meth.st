__METADATA__
{
  "v3Meta": {
    "objectGuid": "8ec37836-ec03-4e09-aee7-7448164a39e5",
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
METHOD CheckCamData : BOOL
VAR_INPUT
END_VAR
__IMPLEMENTATION__
//return TRUE: data is valid
CheckCamData := TRUE;



//check cam data
IF iq_stMultiCamData.diNumberOfCamPoints <= 0 OR iq_stMultiCamData.diNumberOfCamPoints > UPPER_BOUND(iq_stMultiCamData.astCamPoint, 1) THEN
	
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.NumberOfCamPointsRange,
					i_sMsg		:= SE_CTBX.FC_MultiConcat(	i_sString1 := '0 < ST_MultiCam.diNumberOfCamPoints <= ', 
															i_sString2 := DINT_TO_STRING( UPPER_BOUND(iq_stMultiCamData.astCamPoint, 1) ), 
															i_sString3 := ' , Current: ', 
															i_sString4 := DINT_TO_STRING(iq_stMultiCamData.diNumberOfCamPoints) )
					);
					
	q_xSynActive		:= FALSE;
	q_xXLowEnd			:= FALSE;
	q_xXHighEnd			:= FALSE;
	iq_xNewCam			:= FALSE;
	iq_xInstantNewCam	:= FALSE;
	
	etState := ET_MulticamState.controllerStop;

	CheckCamData := FALSE;
	
END_IF
