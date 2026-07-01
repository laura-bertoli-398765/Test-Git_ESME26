__METADATA__
{
  "v3Meta": {
    "objectGuid": "1fb46ed0-13bb-4942-a8cb-1f8d4531a4e1",
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
THIS^.diResultSetDrvEncGetState_loc := LXM62S.FC_DrvEncPositionGetState(i_ifDevicetype := THIS^.ifDeviceType_loc);

