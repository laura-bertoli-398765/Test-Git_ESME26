__METADATA__
{
  "v3Meta": {
    "objectGuid": "50c5ea6b-fc6c-4b00-9714-f3a88e9d2f57",
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
METHOD INTERNAL GetMasterVel : LREAL
VAR_INPUT
END_VAR
VAR

END_VAR
__IMPLEMENTATION__
GetMasterVel := 0.0;

IF (iq_stAxisModuleItf.stMain.i_ifMaster <> 0) THEN
	GetMasterVel := iq_stAxisModuleItf.stMain.i_ifMaster.RefVelocity;
END_IF

