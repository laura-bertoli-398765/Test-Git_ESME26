__METADATA__
{
  "v3Meta": {
    "objectGuid": "03381925-e32e-4ac1-91be-27ba8ff57275",
    "objectTypeGuid": "5a3b8626-d3e9-4f37-98b5-66420063d91e",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94"
    ],
    "properties": {},
    "subObjects": {
      "get": {
        "objectGuid": "292d2253-6923-4799-8c8e-61ff42ec39ab",
        "objectTypeGuid": "792f2eb6-721e-4e64-ba20-bc98351056db",
        "embeddedObjectTypeGuids": [
          "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
          "3b83b776-fb25-43b8-99f2-3c507c9143fc"
        ],
        "properties": {},
        "subObjects": {}
      },
      "set": {
        "objectGuid": "6b2bcdcb-99e4-4779-9bb4-8867be7dd060",
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
PROPERTY stTorque : PDL_ST_HomeTorque
__GETTERDECLARATION__
VAR
END_VAR
__GETTERIMPLEMENTATION__
stTorque := THIS^.stTorque_loc;
__SETTERDECLARATION__
VAR
END_VAR
__SETTERIMPLEMENTATION__
THIS^.stTorque_loc := stTorque;
