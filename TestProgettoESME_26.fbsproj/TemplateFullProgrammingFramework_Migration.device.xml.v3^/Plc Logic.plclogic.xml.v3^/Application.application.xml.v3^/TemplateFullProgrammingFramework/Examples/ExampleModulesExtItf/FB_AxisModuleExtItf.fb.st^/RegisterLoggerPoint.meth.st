__METADATA__
{
  "v3Meta": {
    "objectGuid": "465a5fc3-64c2-4505-bfe6-63a171f50899",
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
METHOD PUBLIC RegisterLoggerPoint
VAR_INPUT
	i_ifParent		: APL.IF_LoggerPoint;
	i_sName			: STRING[80];
END_VAR
VAR_OUTPUT
	q_etDiag		: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt		: AXM_ET_DiagExt := AXM_ET_DiagExt.Ok;
END_VAR
__IMPLEMENTATION__
THIS^.fbAxisModule.RegisterLoggerPoint(	i_ifParent	:= i_ifParent,
										i_sName		:= i_sName,
										q_etDiag	=> q_etDiag,
										q_etDiagExt	=> q_etDiagExt);
