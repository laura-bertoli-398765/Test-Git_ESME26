__METADATA__
{
  "v3Meta": {
    "objectGuid": "4f5e6757-dbb1-4a03-902a-12064de47948",
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
METHOD INTERNAL DisableAllJobs
VAR_INPUT
END_VAR
__IMPLEMENTATION__
(* OpModes *)
	xRefEnable := FALSE;
	xManEnable := FALSE;
	xCamEnable := FALSE;
	xEndlessEnable := FALSE;
	xPosEnable := FALSE;
	xBrakeEnable := FALSE;
	xAdditionalEnable := FALSE;
