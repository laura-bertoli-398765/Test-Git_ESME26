__METADATA__
{
  "v3Meta": {
    "objectGuid": "a24d3bfb-b984-4207-aff5-70e75f5541df",
    "objectTypeGuid": "5a3b8626-d3e9-4f37-98b5-66420063d91e",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94"
    ],
    "properties": {},
    "subObjects": {
      "get": {
        "objectGuid": "268d5b42-4562-43d3-83ea-8c5139d6f6db",
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
PROPERTY uiOrder : UINT
__GETTERDECLARATION__
VAR
END_VAR
__GETTERIMPLEMENTATION__
uiOrder := THIS^.uiOrder_loc;
