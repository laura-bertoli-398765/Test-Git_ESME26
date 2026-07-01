__METADATA__
{
  "v3Meta": {
    "objectGuid": "3e7aa7fe-3739-4af4-8005-8a51f614c73e",
    "objectTypeGuid": "5a3b8626-d3e9-4f37-98b5-66420063d91e",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94"
    ],
    "properties": {},
    "subObjects": {
      "get": {
        "objectGuid": "ac2b075c-0200-44ec-bf3f-8a25d5ce231b",
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
PROPERTY PUBLIC diResultSetDrvEncGetState : DINT
__GETTERDECLARATION__
VAR
END_VAR
__GETTERIMPLEMENTATION__
diResultSetDrvEncGetState := diResultSetDrvEncGetState_loc;
