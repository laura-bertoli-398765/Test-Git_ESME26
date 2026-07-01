__METADATA__
{
  "v3Meta": {
    "objectGuid": "5abf0249-e0dc-454d-9fca-f6d125ad8840",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* Start application code *)
IF(iq_stExampleLeafModuleItf.q_etState = ET_ExampleLeafModuleState.AutoWaitForStart) THEN
	IF(xAutoEnable) THEN
		IF(xStartFlag) THEN
			iq_stExampleLeafModuleItf.q_etState := ET_ExampleLeafModuleState.AutoRunning;
		END_IF
	ELSE
		xAutoActive := FALSE;
	END_IF
END_IF

IF(NOT xStartFlag AND iq_stExampleLeafModuleItf.q_etState = ET_ExampleLeafModuleState.AutoRunning) THEN
	iq_stExampleLeafModuleItf.q_etState := ET_ExampleLeafModuleState.AutoWaitForStart;
END_IF

IF(iq_stExampleLeafModuleItf.q_etState = ET_ExampleLeafModuleState.AutoRunning) THEN
	IF(xAutoEnable) AND iq_stExampleLeafModuleItf.i_ifDrive <> 0 THEN
		iq_stExampleLeafModuleItf.q_xValue := iq_stExampleLeafModuleItf.i_ifDrive.lrPosition >= iq_stExampleLeafModuleItf.i_lrPosMin AND 
												iq_stExampleLeafModuleItf.i_ifDrive.lrPosition <= iq_stExampleLeafModuleItf.i_lrPosMax;
	ELSE
		iq_stExampleLeafModuleItf.q_etState := ET_ExampleLeafModuleState.AutoWaitForStart;
	END_IF
END_IF
(* End application code *)
