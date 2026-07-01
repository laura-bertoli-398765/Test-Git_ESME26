__METADATA__
{
  "v3Meta": {
    "objectGuid": "a4f9a6a2-b5df-412b-ae1a-c295f01329c2",
    "objectTypeGuid": "5a3b8626-d3e9-4f37-98b5-66420063d91e",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94"
    ],
    "properties": {},
    "subObjects": {
      "get": {
        "objectGuid": "a09198bf-7252-428b-a884-30a5d4f5bcfe",
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
{attribute 'monitoring' := 'call'}
PROPERTY ifGetControlChannel : MOIN.IF_Axis
__GETTERDECLARATION__
VAR
END_VAR
__GETTERIMPLEMENTATION__


ifGetControlChannel := ifControlChannel;
