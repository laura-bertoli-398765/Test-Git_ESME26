__METADATA__
{
  "v3Meta": {
    "objectGuid": "0bd67396-5b42-4d41-aa4c-88fe8bf541c9",
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
		stMachineInterface.iq_diCmd	:= ET_Cmd.Stop;
	ELSIF stMachineInterface.q_xCmdDone AND NOT stMachineInterface.q_xCmdActive THEN
		stMachineInterface.iq_diCmd	:= ET_Cmd.Stop;
	ELSE
		stMachineInterface.iq_diCmd	:= ET_Cmd.Abort;
	END_IF
(* End of system generated code, could be modified for your application *)
