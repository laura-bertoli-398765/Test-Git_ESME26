__METADATA__
{
  "v3Meta": {
    "objectGuid": "80f18ecd-3668-4137-8a16-6b8538471a00",
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
IF(xStartFlag AND (iq_stExampleLeafModuleItf.q_etState = ET_ExampleLeafModuleState.HomingWaitForStart OR iq_stExampleLeafModuleItf.q_etState = ET_ExampleLeafModuleState.HomingDone)) THEN
	xHomingException := FALSE;
	iq_stExampleLeafModuleItf.q_etState := ET_ExampleLeafModuleState.HomingExecuting;
END_IF

IF(iq_stExampleLeafModuleItf.q_etState = ET_ExampleLeafModuleState.HomingExecuting) THEN
	(* Emulating an action in the process that takes some time *)
	udiDoSomethingCounter := udiDoSomethingCounter + 1;
	IF(udiDoSomethingCounter > c_udiDoSomeThingLevel) THEN
		(* Homing done *)
		iq_stExampleLeafModuleItf.q_xValue := TRUE;

		(* Sometimes creates an error *)
		IF(iq_stExampleLeafModuleItf.i_xEnableRandomExceptionTrigger) THEN
			IF(xRandomExceptionTrigger) THEN
				xHomingException := TRUE;
			END_IF
			xRandomExceptionTrigger := NOT xRandomExceptionTrigger;
		END_IF

		iq_stExampleLeafModuleItf.q_etState := ET_ExampleLeafModuleState.HomingDone;
	END_IF
END_IF

IF xHomingException THEN
	ReportException(iq_stException := stExceptionHoming);
ELSE
	CancelException(iq_stException := stExceptionHoming);
END_IF

IF(iq_stExampleLeafModuleItf.q_etState <> ET_ExampleLeafModuleState.HomingExecuting) THEN
	(* If homing is not running, allow exit of homing by xHomingEnable = FALSE *)
	IF(NOT xHomingEnable) THEN
		xHomingActive := FALSE;
	END_IF
END_IF
(* End application code *)
