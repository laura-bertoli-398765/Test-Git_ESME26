__METADATA__
{
  "v3Meta": {
    "objectGuid": "faa20d9c-db23-4a6c-b978-d5ec161f8dd0",
    "objectTypeGuid": "5a3b8626-d3e9-4f37-98b5-66420063d91e",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94"
    ],
    "properties": {},
    "subObjects": {
      "get": {
        "objectGuid": "c2fcbf38-3fbd-4727-8ebc-0339336e730c",
        "objectTypeGuid": "792f2eb6-721e-4e64-ba20-bc98351056db",
        "embeddedObjectTypeGuids": [
          "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
          "3b83b776-fb25-43b8-99f2-3c507c9143fc"
        ],
        "properties": {},
        "subObjects": {}
      }
    }
  }
}
__DECLARATION__
PROPERTY uiLevel : UINT
__GETTERDECLARATION__
VAR
END_VAR
__GETTERIMPLEMENTATION__
uiLevel := THIS^.uiLevel_loc;
