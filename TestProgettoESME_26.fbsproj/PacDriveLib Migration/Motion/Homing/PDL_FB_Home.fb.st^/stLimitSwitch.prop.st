__METADATA__
{
  "v3Meta": {
    "objectGuid": "937f4606-782c-4acf-be8a-664c2adb63ca",
    "objectTypeGuid": "5a3b8626-d3e9-4f37-98b5-66420063d91e",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94"
    ],
    "properties": {},
    "subObjects": {
      "set": {
        "objectGuid": "e86e0817-4d44-420a-9d48-b50195f3f133",
        "objectTypeGuid": "792f2eb6-721e-4e64-ba20-bc98351056db",
        "embeddedObjectTypeGuids": [
          "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
          "3b83b776-fb25-43b8-99f2-3c507c9143fc"
        ],
        "properties": {},
        "subObjects": {}
      },
      "get": {
        "objectGuid": "f8926207-e232-4aa9-bc2a-5566960cf496",
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
PROPERTY stLimitSwitch : PDL_ST_HomeLimitSwitch
__SETTERDECLARATION__
VAR
END_VAR
__SETTERIMPLEMENTATION__
THIS^.stLimitSwitch_loc := stLimitSwitch;
__GETTERDECLARATION__
VAR
END_VAR
__GETTERIMPLEMENTATION__
stLimitSwitch := THIS^.stLimitSwitch_loc;
