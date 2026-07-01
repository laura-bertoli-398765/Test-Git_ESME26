__METADATA__
{
  "v3Meta": {
    "objectGuid": "93bf29bc-d8d7-46c1-b37a-9c3caa16f4f7",
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
{attribute 'conditionalshow_all_locals'}
METHOD INTERNAL RefuseCommand
VAR_INPUT
END_VAR
__IMPLEMENTATION__
iq_stStandardModuleItf.q_xCmdActive := FALSE;
iq_stStandardModuleItf.q_xCmdDone := FALSE;
iq_stStandardModuleItf.iq_diCMD := -iq_stStandardModuleItf.iq_diCMD;

xCommandRefused := TRUE;
