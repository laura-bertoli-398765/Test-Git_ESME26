__METADATA__
{
  "v3Meta": {
    "objectGuid": "f2afe82f-b7a0-4e6a-a3a3-e350ed638645",
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
FUNCTION FC_EtExampleLeafModuleCmdToString : STRING[15]
VAR_INPUT
	i_diCmd		: DINT;
END_VAR
VAR_OUTPUT
	q_etDiag	: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt	: ET_DiagExtExampleLeafModule := ET_DiagExtExampleLeafModule.Ok;
END_VAR
__IMPLEMENTATION__
CASE i_diCMD OF
	ET_ExampleLeafModuleCmd.Homing:
		FC_EtExampleLeafModuleCmdToString := 'Homing';
	ET_ExampleLeafModuleCmd.Auto:
		FC_EtExampleLeafModuleCmdToString := 'Auto';
	ET_ExampleLeafModuleCmd.Stop:
		FC_EtExampleLeafModuleCmdToString := 'Stop';
	ET_ExampleLeafModuleCmd.Start:
		FC_EtExampleLeafModuleCmdToString := 'Start';
	ET_ExampleLeafModuleCmd.Hold:
		FC_EtExampleLeafModuleCmdToString := 'Hold';
	ELSE
		FC_EtExampleLeafModuleCmdToString := CONCAT('Unkown Cmd ', DINT_TO_STRING(i_diCMD));
		
		q_etDiag := GD.ET_Diag.InputParameterInvalid;
		q_etDiagExt := ET_DiagExtExampleLeafModule.UnknownCmd;
END_CASE
