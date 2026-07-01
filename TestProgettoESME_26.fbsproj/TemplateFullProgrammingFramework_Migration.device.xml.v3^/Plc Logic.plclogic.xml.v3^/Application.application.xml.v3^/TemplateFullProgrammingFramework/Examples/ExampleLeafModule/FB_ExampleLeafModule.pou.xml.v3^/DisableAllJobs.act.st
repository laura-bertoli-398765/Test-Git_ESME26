__METADATA__
{
  "v3Meta": {
    "objectGuid": "2c5e899e-b63e-4ad1-8cf5-59807e997d54",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* Disable current OpMode and enable next one *)
xHomingEnable := FALSE;
xAutoEnable := FALSE;

xStartFlag := FALSE; (* On OpMode change, always reset the start flag *)
