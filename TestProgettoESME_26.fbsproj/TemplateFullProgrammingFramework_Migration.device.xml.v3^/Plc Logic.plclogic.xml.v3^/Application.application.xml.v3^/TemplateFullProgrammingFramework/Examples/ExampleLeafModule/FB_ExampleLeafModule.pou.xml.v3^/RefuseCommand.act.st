__METADATA__
{
  "v3Meta": {
    "objectGuid": "b0b5a87f-03ec-4065-95b0-fc557712b327",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
iq_stStandardModuleItf.q_xCMDActive := FALSE;
iq_stStandardModuleItf.q_xCMDDone := FALSE;
iq_stStandardModuleItf.iq_diCMD := - iq_stStandardModuleItf.iq_diCMD;

xCommandRefused := TRUE;
