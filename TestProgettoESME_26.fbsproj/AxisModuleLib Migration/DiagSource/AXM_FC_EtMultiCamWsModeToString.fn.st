__METADATA__
{
  "v3Meta": {
    "objectGuid": "3068e4be-c43f-4505-a3d2-4cbfee584bba",
    "objectTypeGuid": "6f9dac99-8de1-4efc-8465-68ac443b7d08",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__DECLARATION__
FUNCTION AXM_FC_EtMultiCamWsModeToString : STRING[80]
VAR_INPUT
	i_etWsMode	: PDL_ET_MultiCamWsMode;
END_VAR
VAR
END_VAR
__IMPLEMENTATION__
CASE i_etWsMode OF
	PDL_ET_MultiCamWsMode.StoredCamMoveAlwaysNoPositionCheck:
		AXM_FC_EtMultiCamWsModeToString := 'StoredCamMoveAlwaysNoPositionCheck';
		
	PDL_ET_MultiCamWsMode.StoredCamMoveToCamPositonInWsWindow:
		AXM_FC_EtMultiCamWsModeToString := 'StoredCamMoveToCamPositonInWsWindow';
		
	PDL_ET_MultiCamWsMode.StoredCamMoveForwardToCamPositon:
		AXM_FC_EtMultiCamWsModeToString := 'StoredCamMoveForwardToCamPositon';
		
	PDL_ET_MultiCamWsMode.StoredCamMoveBackwardToCamPosition:
		AXM_FC_EtMultiCamWsModeToString := 'StoredCamMoveBackwardToCamPosition';
		
	PDL_ET_MultiCamWsMode.StoredCamShowCamPosition:
		AXM_FC_EtMultiCamWsModeToString := 'StoredCamShowCamPosition';
		
	PDL_ET_MultiCamWsMode.StoredCamSetMasterPositionToRelatedSlavePosition:
		AXM_FC_EtMultiCamWsModeToString := 'StoredCamSetMasterPositionToRelatedSlavePosition';
		
	PDL_ET_MultiCamWsMode.NewCamMoveAlwaysNoPositionCheck:
		AXM_FC_EtMultiCamWsModeToString := 'NewCamMoveAlwaysNoPositionCheck';
		
	PDL_ET_MultiCamWsMode.NewCamMoveToCamPositonInWsWindow:
		AXM_FC_EtMultiCamWsModeToString := 'NewCamMoveToCamPositonInWsWindow';
		
	PDL_ET_MultiCamWsMode.NewCamMoveForwardToCamPositon:
		AXM_FC_EtMultiCamWsModeToString := 'NewCamMoveForwardToCamPositon';
		
	PDL_ET_MultiCamWsMode.NewCamMoveBackwardToCamPosition:
		AXM_FC_EtMultiCamWsModeToString := 'NewCamMoveBackwardToCamPosition';
		
	PDL_ET_MultiCamWsMode.NewCamShowCamPosition:
		AXM_FC_EtMultiCamWsModeToString := 'NewCamShowCamPosition';
		
	PDL_ET_MultiCamWsMode.NewCamSetMasterPositionToRelatedSlavePosition:
		AXM_FC_EtMultiCamWsModeToString := 'NewCamSetMasterPositionToRelatedSlavePosition';
		

	ELSE
		AXM_FC_EtMultiCamWsModeToString := Standard.CONCAT('Unknown WsMode ', INT_TO_STRING(i_etWsMode));
END_CASE
