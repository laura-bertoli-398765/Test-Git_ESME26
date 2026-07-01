__METADATA__
{
  "v3Meta": {
    "objectGuid": "dab4e01f-cbbc-4055-995c-099d0ea00f03",
    "objectTypeGuid": "5a3b8626-d3e9-4f37-98b5-66420063d91e",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94"
    ],
    "properties": {},
    "subObjects": {
      "set": {
        "objectGuid": "7b63721b-8fc8-4a94-a78c-ce09d6122059",
        "objectTypeGuid": "792f2eb6-721e-4e64-ba20-bc98351056db",
        "embeddedObjectTypeGuids": [
          "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
          "3b83b776-fb25-43b8-99f2-3c507c9143fc"
        ],
        "properties": {},
        "subObjects": {}
      },
      "get": {
        "objectGuid": "d98bf177-8183-445c-9b4f-201fb5e7fe4f",
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
PROPERTY PUBLIC lrOldTrackDevLim : LREAL
__SETTERDECLARATION__
VAR
END_VAR
__SETTERIMPLEMENTATION__

__GETTERDECLARATION__
VAR
END_VAR
__GETTERIMPLEMENTATION__
lrOldTrackDevLim := lrOldTrackingDeviationLimit;
