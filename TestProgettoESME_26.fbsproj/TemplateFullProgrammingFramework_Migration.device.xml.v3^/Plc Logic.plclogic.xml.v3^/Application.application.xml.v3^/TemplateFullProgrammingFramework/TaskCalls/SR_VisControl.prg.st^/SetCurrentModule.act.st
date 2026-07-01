__METADATA__
{
  "v3Meta": {
    "objectGuid": "ab20dbcb-837f-4a83-b47c-01047379e20a",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(*
	handles all requests coming from the special vis controllers

	sets the current module by modifying aiHierachy
	also sets the jog target

inputs:
	diSetAsCurrentModule - if <> 0 contains the module ID of the module to set as current module

in_out:
	audiHierarchy	
	udiCurrentLevel

flags:
	

*)
IF(udiSetAsCurrentModule > 0) THEN
	udiTmp2 := 1;
	WHILE(udiSetAsCurrentModule > udiTmp2 * 100) DO
		udiTmp2 := udiTmp2 * 100;
	END_WHILE

	udiCurrentLevel := 0;
	WHILE(udiTmp2 > 0) DO
		udiCurrentLevel := udiCurrentLevel + 1;
		audiHierarchy[udiCurrentLevel] := udiSetAsCurrentModule / udiTmp2;
		udiSetAsCurrentModule := udiSetAsCurrentModule MOD udiTmp2;
		udiTmp2 := udiTmp2 / 100;
	END_WHILE

	IF(udiCurrentLevel < 1) THEN
		udiCurrentLevel := 1;
	END_IF

	udiSetAsCurrentModule := 0;
	xUpdateData := TRUE;
END_IF

IF(udiSetAsJogTarget <> 0) THEN
	G_udiManualModuleSelect		:= udiSetAsJogTarget;
//	G_udiManualElementSelect	:= udiSetAsJogTargetNum;
	udiSetAsJogTarget := 0;
//	udiSetAsJogTargetNum := 0;
END_IF
