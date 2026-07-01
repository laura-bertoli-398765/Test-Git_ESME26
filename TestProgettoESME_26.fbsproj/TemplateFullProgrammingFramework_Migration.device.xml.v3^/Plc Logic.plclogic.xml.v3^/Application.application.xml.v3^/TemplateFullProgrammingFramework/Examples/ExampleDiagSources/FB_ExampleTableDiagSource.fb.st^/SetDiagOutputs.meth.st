__METADATA__
{
  "v3Meta": {
    "objectGuid": "52f78225-cf0e-46de-b93e-1a733809611a",
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
METHOD SetDiagOutputs : BOOL
VAR_INPUT
	i_etDiag		: GD.ET_Diag;
	i_etDiagExt		: ET_DiagExt;
	i_sMsg			: STRING[80];
END_VAR
__IMPLEMENTATION__
IF THIS^.q_etDiag = GD.ET_Diag.Ok OR i_etDiagExt = ET_DiagExt.Disabled THEN

	IF i_etDiag <> GD.ET_Diag.Ok OR i_etDiagExt = ET_DiagExt.Disabled THEN
		
		IF i_etDiag <> GD.ET_Diag.Ok THEN
			THIS^.iq_stComStructure.iq_diCmd := -THIS^.iq_stComStructure.iq_diCmd;
		END_IF
		
		IF i_etDiagExt = ET_DiagExt.Disabled THEN
			THIS^.q_xActive := FALSE;
			
			CancelWriting();
		END_IF
		
		THIS^.q_xReady := FALSE;
		THIS^.diState := 0;
	END_IF
	
	THIS^.q_etDiag		:= i_etDiag;
	THIS^.q_etDiagExt	:= i_etDiagExt;
	THIS^.q_sMsg		:= i_sMsg;

END_IF
