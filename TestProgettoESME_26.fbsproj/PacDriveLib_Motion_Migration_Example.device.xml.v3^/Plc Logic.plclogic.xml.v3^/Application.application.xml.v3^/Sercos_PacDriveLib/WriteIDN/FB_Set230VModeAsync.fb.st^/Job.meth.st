__METADATA__
{
  "v3Meta": {
    "objectGuid": "5fcec13f-5fa7-4fc0-9653-cfe748ec4aa4",
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
METHOD Job : BOOL
__IMPLEMENTATION__
q_diResult := Set230VMode(
	i_ifSercosIdentificationAccess := i_ifSercosIdentificationAccess,
	q_sDiagMsg => q_sDiagMsg);

Job := TRUE;
