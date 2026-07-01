__METADATA__
{
  "v3Meta": {
    "objectGuid": "55f0cfab-2a9b-4ca6-bb28-7bf4ced63a17",
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
FUNCTION PUBLIC AXM_FC_EtMotionActiveVelTypeToString : STRING[20]
VAR_INPUT
	i_etMotionActiveVelType : AXM_ET_MotionActiveVelType;
END_VAR
VAR_OUTPUT
	q_etDiag	: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt	: AXM_ET_DiagExt := AXM_ET_DiagExt.Ok;
END_VAR
VAR
END_VAR
__IMPLEMENTATION__
AXM_FC_EtMotionActiveVelTypeToString := TO_STRING(i_etMotionActiveVelType);
