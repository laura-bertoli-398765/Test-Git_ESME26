__METADATA__
{
  "v3Meta": {
    "objectGuid": "62f6a697-2c31-4fa4-aead-e7013a7e303d",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
iq_stAxisModuleItf.stMain.q_etOpMode := AXM_ET_OpMode.BrakeRelease;

fbBrake(	i_xEnable			:= xBrakeEnable AND NOT fbDriveEnable.q_xDriveEnabled,
			i_xRelease			:= (xStartFlag OR iq_stAxisModuleItf.stMain.i_xStart),
			i_ifDrive			:= iq_stAxisModuleItf.stMain.i_ifDrive,
			q_xActive			=> ,
			q_xReady			=> ,
			q_xReleased			=> iq_stAxisModuleItf.stBrake.q_xBrakeReleased,
			q_etDiag			=> etDiagBuffer,
			q_etDiagExt			=> etDiagExtBufferPDL,
			q_sMsg				=> sDiagMsgBuffer);

DiagTestBrakeRelease(	iq_etDiag		:= fbBrake.q_etDiag,
						iq_etDiagExt	:= fbBrake.q_etDiagExt,
						iq_sMsg			:= fbBrake.q_sMsg);

IF fbBrake.q_xReady AND fbBrake.q_xReleased THEN
	iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.BrakeReleased;
ELSIF fbBrake.q_xReady AND NOT fbBrake.q_xReleased THEN
	iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.BrakeClosed;
ELSE
	IF xBrakeEnable THEN
		iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.BrakeReleaseInit;
	ELSE
		iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.BrakeReleaseExit;
	END_IF
END_IF

IF NOT xBrakeEnable AND NOT fbBrake.q_xActive THEN
	xBrakeActive := FALSE;
END_IF
