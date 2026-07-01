__METADATA__
{
  "v3Meta": {
    "objectGuid": "72729bd1-42e4-425a-9ec7-25eb08cd37a0",
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
FUNCTION_BLOCK INTERNAL FB_BrakeReleaseSet IMPLEMENTS SE_Async.IF_Async
VAR
	ifBrake_loc           : DDI.IF_Brake;
	xDone_loc             : BOOL;
	xRelease_loc          : BOOL;
END_VAR
__IMPLEMENTATION__

