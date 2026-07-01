__METADATA__
{
  "v3Meta": {
    "objectGuid": "76e67663-b71a-4f5e-a322-ea1d8397eb9e",
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
FUNCTION AXM_FC_EtMultiCamCsModeSlaveToString : STRING[80]
VAR_INPUT
	i_etCsModeSlave	: PDL_ET_MultiCamCsModeSlave;
END_VAR
VAR
END_VAR
__IMPLEMENTATION__
AXM_FC_EtMultiCamCsModeSlaveToString := To_string(i_etCsModeSlave);
