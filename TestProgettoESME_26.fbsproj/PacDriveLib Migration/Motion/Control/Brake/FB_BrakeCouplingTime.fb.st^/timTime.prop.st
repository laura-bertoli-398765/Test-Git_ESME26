__METADATA__
{
  "v3Meta": {
    "objectGuid": "6b921cf5-9e47-47c4-8917-f86ffcfbc16f",
    "objectTypeGuid": "5a3b8626-d3e9-4f37-98b5-66420063d91e",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94"
    ],
    "properties": {},
    "subObjects": {
      "get": {
        "objectGuid": "e99961c2-08c8-4f48-89df-8a2c0c66b3ce",
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
PROPERTY INTERNAL timTime : TIME
__GETTERDECLARATION__
VAR
END_VAR
__GETTERIMPLEMENTATION__
timTime:= tBrakeCouplingTemp;
