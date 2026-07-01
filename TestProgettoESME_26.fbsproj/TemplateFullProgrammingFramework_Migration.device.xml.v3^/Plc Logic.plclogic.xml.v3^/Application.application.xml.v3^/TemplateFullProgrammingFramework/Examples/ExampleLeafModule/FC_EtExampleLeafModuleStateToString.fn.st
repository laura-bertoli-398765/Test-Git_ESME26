__METADATA__
{
  "v3Meta": {
    "objectGuid": "07121f34-bc31-4d34-80aa-e903942079c2",
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
FUNCTION FC_EtExampleLeafModuleStateToString : STRING[25]
VAR_INPUT
	i_etState	: ET_ExampleLeafModuleState;
END_VAR
VAR_OUTPUT
	q_etDiag	: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt	: ET_DiagExtExampleLeafModule := ET_DiagExtExampleLeafModule.Ok;
END_VAR
__IMPLEMENTATION__
CASE i_etState OF
	ET_ExampleLeafModuleState.Disabled:
		FC_EtExampleLeafModuleStateToString := 'Disabled';
	ET_ExampleLeafModuleState.Initializing:
		FC_EtExampleLeafModuleStateToString := 'Initializing';
	ET_ExampleLeafModuleState.NoOp:
		FC_EtExampleLeafModuleStateToString := 'NoOp';
	ET_ExampleLeafModuleState.HomingWaitForStart:
		FC_EtExampleLeafModuleStateToString := 'HomingWaitForStart';
	ET_ExampleLeafModuleState.HomingExecuting:
		FC_EtExampleLeafModuleStateToString := 'HomingExecuting';
	ET_ExampleLeafModuleState.HomingDone:
		FC_EtExampleLeafModuleStateToString := 'HomingDone';
	ET_ExampleLeafModuleState.AutoWaitForStart:
		FC_EtExampleLeafModuleStateToString := 'AutoWaitForStart';
	ET_ExampleLeafModuleState.AutoRunning:
		FC_EtExampleLeafModuleStateToString := 'AutoRunning';
	ELSE
		FC_EtExampleLeafModuleStateToString := CONCAT('Unkown State ', UDINT_TO_STRING(i_etState));
		
		q_etDiag := GD.ET_Diag.InputParameterInvalid;
		q_etDiagExt := ET_DiagExtExampleLeafModule.UnknownState;
END_CASE
