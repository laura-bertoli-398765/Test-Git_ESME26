__METADATA__
{
  "v3Meta": {
    "objectGuid": "f9d79a2e-b8c7-41e3-bdd8-e7d0a879f631",
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
METHOD PRIVATE Init : BOOL
VAR_INPUT
END_VAR
__IMPLEMENTATION__
Init := FALSE;


//check axis
IF i_lencMaster = 0 THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg		:= 'i_lencMaster - Invalid Interface');
	RETURN;	
				
END_IF	


Init := TRUE;
