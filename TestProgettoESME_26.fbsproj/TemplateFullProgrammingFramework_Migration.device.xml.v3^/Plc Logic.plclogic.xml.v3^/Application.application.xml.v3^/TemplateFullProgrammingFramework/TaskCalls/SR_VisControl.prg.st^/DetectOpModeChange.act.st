__METADATA__
{
  "v3Meta": {
    "objectGuid": "af75665b-e72a-4cd6-9097-bdac04a67c13",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
IF (vpiq_fbAxisModuleVisController.i_pstCurrentStandardItf <> 0) THEN
	IF (v_diLastOpMode <> vpiq_fbAxisModuleVisController.i_pstCurrentStandardItf^.q_diCmdActive) THEN
		v_diLastOpMode := vpiq_fbAxisModuleVisController.i_pstCurrentStandardItf^.q_diCmdActive;
		CASE (v_diLastOpMode) OF
			AXM_ET_Cmd.Homing:
				v_xHomeModeActive := TRUE;
				v_xManualModeActive := FALSE;
				v_xMultiCamCSActive := FALSE;
				v_xMultiCamWSActive := FALSE;
				v_xEndlessActive := FALSE;
				v_xEndlessILSActive := FALSE;
				v_xPositioningActive := FALSE;
				v_xBrakeActive := FALSE;
				v_xAdditionalCSActive := FALSE;
				v_xAdditionalWSActive := FALSE;		
			AXM_ET_Cmd.Manual:
				v_xHomeModeActive := FALSE;
				v_xManualModeActive := TRUE;
				v_xMultiCamCSActive := FALSE;
				v_xMultiCamWSActive := FALSE;
				v_xEndlessActive := FALSE;
				v_xEndlessILSActive := FALSE;
				v_xPositioningActive := FALSE;
				v_xBrakeActive := FALSE;
				v_xAdditionalCSActive := FALSE;
				v_xAdditionalWSActive := FALSE;
			
			AXM_ET_Cmd.CamCs:
				v_xHomeModeActive := FALSE;
				v_xManualModeActive := FALSE;
				v_xMultiCamCSActive := TRUE;
				v_xMultiCamWSActive := FALSE;
				v_xEndlessActive := FALSE;
				v_xEndlessILSActive := FALSE;
				v_xPositioningActive := FALSE;
				v_xBrakeActive := FALSE;
				v_xAdditionalCSActive := FALSE;
				v_xAdditionalWSActive := FALSE;
			
			AXM_ET_Cmd.CamWs:
				v_xHomeModeActive := FALSE;
				v_xManualModeActive := FALSE;
				v_xMultiCamCSActive := FALSE;
				v_xMultiCamWSActive := TRUE;
				v_xEndlessActive := FALSE;
				v_xEndlessILSActive := FALSE;
				v_xPositioningActive := FALSE;
				v_xBrakeActive := FALSE;
				v_xAdditionalCSActive := FALSE;
				v_xAdditionalWSActive := FALSE;
				
			AXM_ET_Cmd.Endless:
				v_xHomeModeActive := FALSE;
				v_xManualModeActive := FALSE;
				v_xMultiCamCSActive := FALSE;
				v_xMultiCamWSActive := FALSE;
				v_xEndlessActive := TRUE;
				v_xEndlessILSActive := FALSE;
				v_xPositioningActive := FALSE;
				v_xBrakeActive := FALSE;
				v_xAdditionalCSActive := FALSE;
				v_xAdditionalWSActive := FALSE;
			
			AXM_ET_Cmd.Positioning:
				v_xHomeModeActive := FALSE;
				v_xManualModeActive := FALSE;
				v_xMultiCamCSActive := FALSE;
				v_xMultiCamWSActive := FALSE;
				v_xEndlessActive := FALSE;
				v_xEndlessILSActive := FALSE;
				v_xPositioningActive := TRUE;
				v_xBrakeActive := FALSE;
				v_xAdditionalCSActive := FALSE;
				v_xAdditionalWSActive := FALSE;
			
			AXM_ET_Cmd.AdditionalCs:
				v_xHomeModeActive := FALSE;
				v_xManualModeActive := FALSE;
				v_xMultiCamCSActive := FALSE;
				v_xMultiCamWSActive := FALSE;
				v_xEndlessActive := FALSE;
				v_xEndlessILSActive := FALSE;
				v_xPositioningActive := FALSE;
				v_xBrakeActive := FALSE;
				v_xAdditionalCSActive := TRUE;
				v_xAdditionalWSActive := FALSE;
			
			AXM_ET_Cmd.AdditionalWs:
				v_xHomeModeActive := FALSE;
				v_xManualModeActive := FALSE;
				v_xMultiCamCSActive := FALSE;
				v_xMultiCamWSActive := FALSE;
				v_xEndlessActive := FALSE;
				v_xEndlessILSActive := FALSE;
				v_xPositioningActive := FALSE;
				v_xBrakeActive := FALSE;
				v_xAdditionalCSActive := FALSE;
				v_xAdditionalWSActive := TRUE;
				
			AXM_ET_Cmd.BrakeRelease:
				v_xHomeModeActive := FALSE;
				v_xManualModeActive := FALSE;
				v_xMultiCamCSActive := FALSE;
				v_xMultiCamWSActive := FALSE;
				v_xEndlessActive := FALSE;
				v_xEndlessILSActive := FALSE;
				v_xPositioningActive := FALSE;
				v_xBrakeActive := TRUE;
				v_xAdditionalCSActive := FALSE;
				v_xAdditionalWSActive := FALSE;
		END_CASE
	END_IF
END_IF
