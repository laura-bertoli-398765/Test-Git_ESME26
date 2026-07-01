__METADATA__
{
  "v3Meta": {
    "objectGuid": "8770426d-e03f-4704-9fd6-634eb42fad49",
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
IF i_etDiag <> GD.ET_Diag.Ok THEN
	q_xReady := FALSE;
END_IF


IF q_etDiag = GD.ET_Diag.OK OR i_etDiagExt = PDL_ET_DiagExt.Disabled THEN

	q_etDiag 	:= i_etDiag;
	q_etDiagExt := i_etDiagExt;
	q_sMsg 		:= i_sMsg;
	
END_IF
