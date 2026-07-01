__METADATA__
{
  "v3Meta": {
    "objectGuid": "d102a434-b901-479f-a6a3-d44f7833dca5",
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
METHOD RegisterLoggerPoint
VAR_INPUT
	i_ifParent	: APL.IF_LoggerPoint;
	i_sName		: STRING[80];
END_VAR
VAR_OUTPUT
	q_etDiag	: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt	: ET_DiagExt := ET_DiagExt.Ok;
END_VAR
__IMPLEMENTATION__
fbLoggerPoint.RegisterLoggerPoint(	i_ifParent	:= i_ifParent,
									i_sName		:= i_sName,
									i_sType		:= 'Node Module',
									i_sSource	:= 'Program',
									q_etDiag	=> ,
									q_etDiagExt	=> );
