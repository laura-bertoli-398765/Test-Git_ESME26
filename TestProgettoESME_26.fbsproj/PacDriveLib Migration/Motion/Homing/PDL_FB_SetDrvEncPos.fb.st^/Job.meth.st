__METADATA__
{
  "v3Meta": {
    "objectGuid": "50c22017-b8ae-4dc8-9677-622309dff6e7",
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
THIS^.diResultSetDrvEnc_loc := LXM62S.FC_DrvEncSetPosition(
											i_ifDevicetype  := THIS^.ifDeviceType_loc, 
											i_lrPosition 	:= THIS^.lrPosition_loc);


