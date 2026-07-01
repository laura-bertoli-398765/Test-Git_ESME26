__METADATA__
{
  "v3Meta": {
    "objectGuid": "414b5816-777d-4180-924c-5bf00f60692e",
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
METHOD INTERNAL GetMasterPosition: LREAL
VAR_INPUT
END_VAR
VAR
END_VAR
__IMPLEMENTATION__
GetMasterPosition := 0.0;

IF (iq_stAxisModuleItf.stMain.i_ifMaster <> 0) THEN
	GetMasterPosition := iq_stAxisModuleItf.stMain.i_ifMaster.lrPosition;
END_IF
