__METADATA__
{
  "v3Meta": {
    "objectGuid": "0698ab08-d2ce-43fe-acce-30a81246925d",
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
FUNCTION_BLOCK FB_BrakeCouplingTime IMPLEMENTS SE_Async.IF_Async
VAR
	xDone_loc          : BOOL;
	ifBrake_loc        : DDI.IF_Brake;
	tBrakeCouplingTemp : TIME := T#500MS;
END_VAR
__IMPLEMENTATION__

