__METADATA__
{
  "v3Meta": {
    "objectGuid": "8085c862-c2fb-4bea-a50a-41ed401048d6",
    "objectTypeGuid": "5a3b8626-d3e9-4f37-98b5-66420063d91e",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94"
    ],
    "properties": {},
    "subObjects": {
      "set": {
        "objectGuid": "93e0c449-a3c3-4517-8fa4-39a5bdc16d27",
        "objectTypeGuid": "792f2eb6-721e-4e64-ba20-bc98351056db",
        "embeddedObjectTypeGuids": [
          "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
          "3b83b776-fb25-43b8-99f2-3c507c9143fc"
        ],
        "properties": {},
        "subObjects": {}
      },
      "get": {
        "objectGuid": "b6893131-ba6f-4e48-a0a7-d100862feab2",
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
PROPERTY stWritePos : PDL_ST_HomeWritePos
__SETTERDECLARATION__
VAR
END_VAR
__SETTERIMPLEMENTATION__
THIS^.stWritePos_loc := stWritePos;
__GETTERDECLARATION__
VAR
END_VAR
__GETTERIMPLEMENTATION__
stWritePos := THIS^.stWritePos_loc;
