__METADATA__
{
  "v3Meta": {
    "objectGuid": "02624d47-9188-4124-8b29-d370296fa50a",
    "objectTypeGuid": "5a3b8626-d3e9-4f37-98b5-66420063d91e",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94"
    ],
    "properties": {},
    "subObjects": {
      "get": {
        "objectGuid": "735ec25a-3f73-497e-97ca-5d429e4a5dcf",
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
PROPERTY lrAverage : LREAL
__GETTERDECLARATION__
VAR
END_VAR
__GETTERIMPLEMENTATION__
IF THIS^.xInitialized THEN
	
	lrAverage := THIS^.lrAverage_loc;		

ELSE

	lrAverage := 0;

END_IF
