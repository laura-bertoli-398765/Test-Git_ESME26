__METADATA__
{
  "v3Meta": {
    "objectGuid": "b6f056a0-3bc2-4953-a592-2415c150c947",
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
{attribute 'hide'}
METHOD SetDiagOutput : BOOL
VAR_INPUT
	i_etDiag	: GD.ET_Diag;
	i_etDiagExt	: PDL_ET_DiagExt;
	i_sMsg		: STRING[80];
END_VAR
VAR
END_VAR
__IMPLEMENTATION__
IF q_etDiag = GD.ET_Diag.OK OR i_etDiagExt = PDL_ET_DiagExt.Disabled THEN

	q_etDiag 	:= i_etDiag;
	q_etDiagExt := i_etDiagExt;
	q_sMsg 		:= i_sMsg;
	
END_IF
