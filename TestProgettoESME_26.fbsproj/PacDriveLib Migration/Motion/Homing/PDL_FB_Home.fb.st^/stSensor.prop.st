__METADATA__
{
  "v3Meta": {
    "objectGuid": "8c133912-fb4b-4c10-9186-8949df5b5bbf",
    "objectTypeGuid": "5a3b8626-d3e9-4f37-98b5-66420063d91e",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94"
    ],
    "properties": {},
    "subObjects": {
      "set": {
        "objectGuid": "3fce3b96-31fd-4473-83c8-5fb8af651ca8",
        "objectTypeGuid": "792f2eb6-721e-4e64-ba20-bc98351056db",
        "embeddedObjectTypeGuids": [
          "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
          "3b83b776-fb25-43b8-99f2-3c507c9143fc"
        ],
        "properties": {},
        "subObjects": {}
      },
      "get": {
        "objectGuid": "e1398d75-15f4-4a89-ab07-184c63b0aa16",
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
PROPERTY stSensor : PDL_ST_HomeIn
__SETTERDECLARATION__
VAR
END_VAR
__SETTERIMPLEMENTATION__
THIS^.stSensor_loc := stSensor;
__GETTERDECLARATION__
VAR
END_VAR
__GETTERIMPLEMENTATION__
stSensor := THIS^.stSensor_loc;
