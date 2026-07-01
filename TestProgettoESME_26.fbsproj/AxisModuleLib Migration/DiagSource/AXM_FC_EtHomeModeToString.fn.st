__METADATA__
{
  "v3Meta": {
    "objectGuid": "12a3fb14-4805-4340-b4a0-9980e2ce2593",
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
FUNCTION INTERNAL AXM_FC_EtHomeModeToString : STRING[80]
VAR_INPUT
	i_etHomeMode : PDL_ET_HomeMode;
END_VAR
VAR
END_VAR
__IMPLEMENTATION__
AXM_FC_EtHomeModeToString := TO_STRING(i_etHomeMode);
