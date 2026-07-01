__METADATA__
{
  "v3Meta": {
    "objectGuid": "30bfc610-6151-43e5-88b1-85d38d3fc0ea",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
iq_stAxisModuleItf.stMain.q_etOpMode := AXM_ET_OpMode.NoOp;
IF fbDriveEnable.q_xDriveEnabled THEN
	iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.NoOpDriveEnabled;
ELSE
	iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.NoOpDriveDisabled;
END_IF
