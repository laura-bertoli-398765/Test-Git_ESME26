__METADATA__
{
  "v3Meta": {
    "objectGuid": "700ea207-77f2-474e-9fff-caefd9d76732",
    "objectTypeGuid": "5a3b8626-d3e9-4f37-98b5-66420063d91e",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94"
    ],
    "properties": {},
    "subObjects": {
      "get": {
        "objectGuid": "e3d2cff4-6fe6-4329-88c4-f6c3c214bc01",
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
PROPERTY ifGetOffsetChannel : MOIN.IF_Axis
__GETTERDECLARATION__
VAR
END_VAR
__GETTERIMPLEMENTATION__


ifGetOffsetChannel := ifOffsetChannel;



