__METADATA__
{
  "v3Meta": {
    "objectGuid": "19acd82f-ccc9-4c02-babe-7b1c0a5d2b5c",
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
FUNCTION_BLOCK PDL_FB_ResetTrackingDeviation IMPLEMENTS SE_Async.IF_Async
VAR_INPUT
END_VAR
VAR_OUTPUT
END_VAR
VAR
	xDone_loc                   : BOOL;
	ifDrive2_loc                : DDI.IF_Drive2;
	lrOldTrackingDeviationLimit : LREAL;
END_VAR
__IMPLEMENTATION__

