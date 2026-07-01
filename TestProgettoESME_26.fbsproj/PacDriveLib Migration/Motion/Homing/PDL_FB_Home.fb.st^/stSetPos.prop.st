__METADATA__
{
  "v3Meta": {
    "objectGuid": "3c1fce6f-56aa-4d6d-a462-8436a008be2d",
    "objectTypeGuid": "5a3b8626-d3e9-4f37-98b5-66420063d91e",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94"
    ],
    "properties": {},
    "subObjects": {
      "set": {
        "objectGuid": "2fb73f0c-1af5-49d7-9281-b7a887c490d2",
        "objectTypeGuid": "792f2eb6-721e-4e64-ba20-bc98351056db",
        "embeddedObjectTypeGuids": [
          "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
          "3b83b776-fb25-43b8-99f2-3c507c9143fc"
        ],
        "properties": {},
        "subObjects": {}
      },
      "get": {
        "objectGuid": "77b336fb-2f22-49dc-9262-eb56ec86b9cc",
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
PROPERTY stSetPos : PDL_ST_HomeSetPos
__SETTERDECLARATION__
VAR
END_VAR
__SETTERIMPLEMENTATION__
THIS^.stSetPos_loc := stSetPos;
__GETTERDECLARATION__
VAR
END_VAR
__GETTERIMPLEMENTATION__
stSetPos := THIS^.stSetPos_loc;
