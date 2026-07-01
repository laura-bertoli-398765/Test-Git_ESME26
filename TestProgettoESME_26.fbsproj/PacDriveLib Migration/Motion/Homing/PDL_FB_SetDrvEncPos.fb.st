__METADATA__
{
  "v3Meta": {
    "objectGuid": "9d215bf8-4815-44f9-9f23-2f4937ec7969",
    "objectTypeGuid": "6f9dac99-8de1-4efc-8465-68ac443b7d08",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__DECLARATION__
FUNCTION_BLOCK PDL_FB_SetDrvEncPos IMPLEMENTS SE_Async.IF_Async
VAR_INPUT
END_VAR
VAR_OUTPUT
END_VAR
VAR
	ifDeviceType_loc 		: DeviceTypeInterfaces.IF_Device_Type;
	diResultSetDrvEnc_loc	: DINT;
	lrPosition_loc			: LREAL;
	xDone_loc				: BOOL;
END_VAR
__IMPLEMENTATION__

