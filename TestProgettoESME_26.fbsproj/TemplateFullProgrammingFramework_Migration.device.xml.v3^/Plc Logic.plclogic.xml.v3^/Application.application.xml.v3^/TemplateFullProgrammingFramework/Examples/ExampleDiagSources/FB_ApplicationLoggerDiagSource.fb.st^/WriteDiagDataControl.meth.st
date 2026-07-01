__METADATA__
{
  "v3Meta": {
    "objectGuid": "4a790d41-a56e-4309-8967-5df78ee0c3fe",
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
METHOD INTERNAL WriteDiagDataControl : BOOL
VAR_INPUT
END_VAR
__IMPLEMENTATION__
IF (THIS^.diOldCmd <> THIS^.iq_stComStructure.iq_diCmd AND THIS^.iq_stComStructure.iq_diCmd > 0) THEN
	THIS^.diOldCmd := THIS^.iq_stComStructure.iq_diCmd;
	
	(* new command, start execution *)
	IF THIS^.iq_stComStructure.iq_diCmd = 1 THEN
		IF (THIS^.iq_stComStructure.i_diFileId > 0) THEN
			SetDiagOutputs(	i_etDiag		:= GD.ET_Diag.Ok,
							i_etDiagExt		:= ET_DiagExt.WritingToFile,
							i_sMsg			:= '');
			THIS^.iq_stComStructure.q_lrProgress := 0.0;
			THIS^.fbTreeWriter.diFileId := THIS^.iq_stComStructure.i_diFileId;
			THIS^.diCmdExecState := 1; (* start writing to file *)
		ELSE
			(* invalid file id *)
			SetDiagOutputs(	i_etDiag		:= GD.ET_Diag.InputParameterInvalid,
							i_etDiagExt		:= ET_DiagExt.FileIdInvalid,
							i_sMsg			:= CONCAT('Invalid file Id iq_stComStructure.i_diFileId: ', TO_STRING(THIS^.iq_stComStructure.i_diFileId)));
		END_IF
	ELSE
		(* unkown cmd *)
		SetDiagOutputs(	i_etDiag		:= GD.ET_Diag.InputParameterInvalid,
						i_etDiagExt		:= ET_DiagExt.CmdUnknown,
						i_sMsg			:= CONCAT('Unknown command iq_stComStructure.diCmd: ', DINT_TO_STRING(THIS^.iq_stComStructure.iq_diCmd)));

		CancelWriting();
	END_IF
END_IF
