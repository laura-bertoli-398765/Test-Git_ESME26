__METADATA__
{
  "v3Meta": {
    "objectGuid": "7342418a-0e35-4431-b9ad-ff90b27427f2",
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
METHOD PRIVATE MasterMovedCheck : BOOL
VAR_INPUT
END_VAR
__IMPLEMENTATION__
MasterMovedCheck := FALSE;

//check master position again...
xSuccess :=  GetCamPositionOfSlave( i_xCheckModulo 		:= FALSE,
									q_lrSlavePosition 	=> lrYStart2 ); 

IF NOT xSuccess THEN
	RETURN;
END_IF


//...and compare to first position
IF ABS(lrYStart - lrYStart2) > 1.0 THEN
	q_xReady := FALSE;
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.WarmStartConditionInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.MasterMoved,
					i_sMsg		:= '');		
	q_xInWSWindow := FALSE;
	
	etState := ET_MulticamState.controllerStop;
ELSE	
	//no master movement detected -> success
	MasterMovedCheck := TRUE;

END_IF 
