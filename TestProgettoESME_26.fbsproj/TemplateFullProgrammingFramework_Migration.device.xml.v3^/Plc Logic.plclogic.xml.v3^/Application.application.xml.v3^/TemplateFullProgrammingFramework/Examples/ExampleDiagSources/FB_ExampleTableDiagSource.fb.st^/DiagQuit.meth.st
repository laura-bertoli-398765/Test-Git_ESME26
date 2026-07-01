__METADATA__
{
  "v3Meta": {
    "objectGuid": "5a78044c-c929-4d59-95a8-08d88a82bf44",
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
METHOD DiagQuit : BOOL
VAR_INPUT
END_VAR
__IMPLEMENTATION__
IF THIS^.i_xEnable AND THIS^.q_xActive AND THIS^.q_etDiag <> GD.ET_Diag.Ok AND THIS^.diState = 0 THEN

	THIS^.rtrigDiagQuit(CLK := THIS^.i_xDiagQuit);
	IF THIS^.rtrigDiagQuit.Q THEN
		CancelWriting();
									
		THIS^.udiOwnSourceId	:= 0;
		
		THIS^.fbTableWriter.FB_Init(bInitRetains := FALSE, bInCopyCode := FALSE);
			
		THIS^.q_xReady		:= TRUE;
		THIS^.q_etDiag		:= GD.ET_Diag.Ok;
		THIS^.q_etDiagExt	:= ET_DiagExt.WaitUntilDiagnosticsManagerReady;
		THIS^.q_sMsg		:= '';
	
		THIS^.diState := 10;
	END_IF

END_IF
