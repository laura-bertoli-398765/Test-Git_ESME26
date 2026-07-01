__METADATA__
{
  "v3Meta": {
    "objectGuid": "12c60175-4687-45be-8ca3-0470d544f109",
    "objectTypeGuid": "5a3b8626-d3e9-4f37-98b5-66420063d91e",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94"
    ],
    "properties": {},
    "subObjects": {
      "set": {
        "objectGuid": "55bb71fb-82ae-4818-9426-90fc4dcf3389",
        "objectTypeGuid": "792f2eb6-721e-4e64-ba20-bc98351056db",
        "embeddedObjectTypeGuids": [
          "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
          "3b83b776-fb25-43b8-99f2-3c507c9143fc"
        ],
        "properties": {},
        "subObjects": {}
      },
      "get": {
        "objectGuid": "888ea97c-6567-4a2c-9a89-00faaf12c35d",
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
PROPERTY stMoveOnPos : PDL_ST_HomeMoveOnPos
__SETTERDECLARATION__
VAR
END_VAR
__SETTERIMPLEMENTATION__
THIS^.stMoveOnPos_loc := stMoveOnPos;
__GETTERDECLARATION__
VAR
END_VAR
__GETTERIMPLEMENTATION__
stMoveOnPos := THIS^.stMoveOnPos_loc;
