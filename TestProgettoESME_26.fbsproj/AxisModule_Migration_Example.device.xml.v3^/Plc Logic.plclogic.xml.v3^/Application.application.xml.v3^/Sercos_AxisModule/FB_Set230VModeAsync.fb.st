__METADATA__
{
  "v3Meta": {
    "objectGuid": "fe096794-d776-4373-9aad-6e7a3d865a62",
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
FUNCTION_BLOCK FB_Set230VModeAsync IMPLEMENTS SE_Async.IF_Async
VAR_INPUT
	i_ifSercosIdentificationAccess : SDI.IF_SercosIdentificationAccess;
END_VAR
VAR_OUTPUT
	q_diResult : DINT;
	q_sDiagMsg : STRING[255];	
END_VAR
VAR
	xDone_loc : Bool;
END_VAR
__IMPLEMENTATION__

