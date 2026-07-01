__METADATA__
{
  "v3Meta": {
    "objectGuid": "d3c1fe7e-00cc-4b38-a0ad-9c562b2c5ffb",
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
METHOD PRIVATE SetTpEdge
VAR_INPUT
	i_xOppositeFlank	: BOOL;
END_VAR
__IMPLEMENTATION__
IF i_etMode = PDL_ET_HomeTpMode.PosDirectionNegEdgeTp OR i_etMode = PDL_ET_HomeTpMode.NegDirectionNegEdgeTp THEN
	IF NOT i_xOppositeFlank THEN
		ifTouprobeData.CaptureEdgeSet := 0; // trigger on falling edge
	ELSE
		ifTouprobeData.CaptureEdgeSet := 1; // trigger on rising edge
	END_IF
ELSE
	IF NOT i_xOppositeFlank THEN
		ifTouprobeData.CaptureEdgeSet := 1; // trigger on rising edge
	ELSE
		ifTouprobeData.CaptureEdgeSet := 0; // trigger on falling edge
	END_IF
END_IF
 
