__METADATA__
{
  "v3Meta": {
    "objectGuid": "751013bb-180a-4f54-9a15-47d47e5bec3c",
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
{attribute 'conditionalshow_all_locals'}
METHOD Job : BOOL
__IMPLEMENTATION__
IF ifBrake_loc.BrakeDisconnectionTime > 0 THEN
	tBrakeDisconnectTemp := DINT_TO_TIME(ifBrake_loc.BrakeDisconnectionTime);
ELSE
	tBrakeDisconnectTemp := T#500MS;
END_IF	
