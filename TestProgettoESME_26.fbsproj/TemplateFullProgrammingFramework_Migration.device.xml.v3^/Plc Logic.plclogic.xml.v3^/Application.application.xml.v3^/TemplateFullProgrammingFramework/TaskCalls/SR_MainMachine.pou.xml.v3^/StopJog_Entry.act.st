__METADATA__
{
  "v3Meta": {
    "objectGuid": "ce43bf9a-d673-4884-aeb5-5131247b18e3",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* System generated code, could be modified for your application *)
	xCMDwasActive:=FALSE;
	IF	xReactionActive	THEN
		;
	ELSIF stMachineInterface.q_xCmdDone AND NOT stMachineInterface.q_xCmdActive THEN
		stMachineInterface.iq_diCmd	:= ET_Cmd.HoldJM;
	ELSE
		stMachineInterface.iq_diCmd	:= ET_Cmd.Abort;
	END_IF
(* End of system generated code, could be modified for your application *)
