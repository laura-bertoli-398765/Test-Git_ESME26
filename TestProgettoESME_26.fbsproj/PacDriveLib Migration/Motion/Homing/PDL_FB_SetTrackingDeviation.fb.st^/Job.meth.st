__METADATA__
{
  "v3Meta": {
    "objectGuid": "6bef49d8-4dd0-47ca-8762-c55b9bf590b1",
    "objectTypeGuid": "f8a58466-d7f6-439f-bbb8-d4600e41d099",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__DECLARATION__
METHOD Job : BOOL
__IMPLEMENTATION__
lrOldTrackingDeviationLimit         := ifDrive2_loc.TrackingDeviationLimit;
ifDrive2_loc.TrackingDeviationLimit := 100.0;
lrCurrentTrackingDeviationLimit     := ifDrive2_loc.TrackingDeviationLimit;
