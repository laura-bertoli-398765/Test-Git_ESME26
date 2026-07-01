__METADATA__
{
  "v3Meta": {
    "objectGuid": "8ba06ea3-fd58-4371-b4b8-69b7442edf3d",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* Navigation *)

(* 2D navigation *)
IF(vpiq_xNavUp OR vpiq_xNavDown OR vpiq_xNavLeft OR vpiq_xNavRight) THEN
	IF vpiq_xNavRight THEN
		(* Move the the next module on the same level *)
		IF audiHierarchy[udiCurrentLevel] + 1 <= udiCurrentLevelSize + udiCurrentNumberOfControlModules  THEN
			audiHierarchy[udiCurrentLevel] := audiHierarchy[udiCurrentLevel] + 1;
			IF audiHierarchy[udiCurrentLevel]  > udiCurrentLevelSize THEN
				udiControlModuleSelectedInLevel	:= udiCurrentLevel;
				vpq_udiActiveControlModuleNumber:= audiHierarchy[udiCurrentLevel]-udiCurrentLevelSize;
			END_IF
		END_IF
	END_IF
	IF vpiq_xNavLeft THEN
		(* Move the the previous module on the same level *)
		IF audiHierarchy[udiCurrentLevel] -1 >= 1 THEN
			audiHierarchy[udiCurrentLevel] := audiHierarchy[udiCurrentLevel] - 1;
			vpq_udiActiveControlModuleNumber:= audiHierarchy[udiCurrentLevel]-udiCurrentLevelSize;
			IF audiHierarchy[udiCurrentLevel] <= udiCurrentLevelSize THEN
				udiControlModuleSelectedInLevel	:= 0;
				vpq_udiActiveControlModuleNumber:= 0;
			END_IF
		END_IF (* ELSE ignore *)
	END_IF
	IF vpiq_xNavUp THEN
		(* Move one level up *)
		udiControlModuleSelectedInLevel := 0;
		vpq_udiActiveControlModuleNumber:= 0;
		IF udiCurrentLevel - 1 >= 1 THEN
			udiCurrentLevel := udiCurrentLevel - 1;
		END_IF (* ELSE ignore *)
	END_IF
	IF vpiq_xNavDown THEN
		(* Move one level down *)
		IF (udiCurrentLevel + 1 <= c_udiMaxHierarchyLevels) AND (xCurrentHasSubModules OR xCurrentHasControlModules) THEN
			udiCurrentLevel := udiCurrentLevel + 1;
			audiHierarchy[udiCurrentLevel] := 1;
			IF NOT xCurrentHasSubModules AND xCurrentHasControlModules THEN
				udiControlModuleSelectedInLevel := udiCurrentLevel;
				vpq_udiActiveControlModuleNumber:= audiHierarchy[udiCurrentLevel];
			ELSE
				udiControlModuleSelectedInLevel	:= 0;
				vpq_udiActiveControlModuleNumber:= 0;
			END_IF

		END_IF (* ELSE ignore *)
	END_IF

	vpiq_xNavUp		:= FALSE;
	vpiq_xNavDown	:= FALSE;
	vpiq_xNavLeft	:= FALSE;
	vpiq_xNavRight	:= FALSE;
	
	xUpdateData := TRUE;
END_IF (* End 2D navbutton hit *)

(* Direct navigation (on level 2 and 3) *)
(* Module level *)
IF vpiq_axModuleList[1] OR vpiq_axModuleList[2] OR vpiq_axModuleList[3] OR vpiq_axModuleList[4] OR vpiq_axModuleList[5] OR
   vpiq_axControlModuleList[1] OR vpiq_axControlModuleList[2] OR vpiq_axControlModuleList[3] OR vpiq_axControlModuleList[4] OR vpiq_axControlModuleList[5] THEN
	udiCurrentLevel := 2;
	udiCurrentLevel := 2;
	FOR udiTmp := 1 TO 5 DO
		(*select an equipment module via the buttons on level 2*)
		IF(vpiq_axModuleList[udiTmp]) THEN
			audiHierarchy[udiCurrentLevel] := udiTmp + udiMinModuleList - 1;
			vpiq_axModuleList[udiTmp] := FALSE;
			udiControlModuleSelectedInLevel := 0;
			vpq_udiActiveControlModuleNumber:= 0;
		END_IF
		(*select a control module via the buttons on level 2*)
		IF vpiq_axControlModuleList[udiTmp] THEN
			audiHierarchy[udiCurrentLevel] := udiTmp + udiMinModuleList - 1;
			udiControlModuleSelectedInLevel	:= udiCurrentLevel;
			vpiq_axControlModuleList[udiTmp] := FALSE;
		END_IF
	END_FOR
	xUpdateData := TRUE;
END_IF
IF vpiq_xModuleListDown THEN
	vpiq_xModuleListDown := FALSE;
	IF(udiMinModuleList > 1) THEN
		udiMinModuleList := udiMinModuleList - 1;
	END_IF
	xUpdateData := TRUE;
END_IF
IF vpiq_xModuleListUp THEN
	vpiq_xModuleListUp := FALSE;
	IF(udiMinModuleList + 4 <= vpq_stMachineInterface.iq_stExt.udiNumberOfSubModules + vpq_stMachineInterface.iq_stExt.udiNumberOfControlModules) THEN
		udiMinModuleList := udiMinModuleList + 1;
	END_IF
	xUpdateData := TRUE;
END_IF
(* Submodule level *)
IF(udiCurrentLevel >= 2) THEN (* Impossible if the main machine is selected *)
	IF vpiq_axSubModuleList[1] OR vpiq_axSubModuleList[2] OR vpiq_axSubModuleList[3] OR vpiq_axSubModuleList[4] OR vpiq_axSubModuleList[5] OR
	   vpiq_axSubControlModuleList[1] OR vpiq_axSubControlModuleList[2] OR vpiq_axSubControlModuleList[3] OR vpiq_axSubControlModuleList[4] OR vpiq_axSubControlModuleList[5] THEN
		udiCurrentLevel := 3;
		FOR udiTmp := 1 TO 5 DO
			(*select an equipment module via the buttons on level 3*)
			IF(vpiq_axSubModuleList[udiTmp]) THEN
				audiHierarchy[udiCurrentLevel] := udiTmp + udiMinSubModuleList - 1;
				vpiq_axSubModuleList[udiTmp] := FALSE;
				udiControlModuleSelectedInLevel	:= 0;
				vpq_udiActiveControlModuleNumber	:= 0;
			END_IF
			(*select a control module via the buttons on level 3*)
			IF vpiq_axSubControlModuleList[udiTmp] THEN
				audiHierarchy[udiCurrentLevel] := udiTmp + udiMinSubModuleList - 1;
				vpiq_axSubControlModuleList[udiTmp] := FALSE;
				udiControlModuleSelectedInLevel	:= udiCurrentLevel;
			END_IF
		END_FOR
		xUpdateData := TRUE;
	END_IF
	IF vpiq_xSubModuleListDown THEN
		vpiq_xSubModuleListDown := FALSE;
		IF(udiMinSubModuleList > 1) THEN
			udiMinSubModuleList := udiMinSubModuleList - 1;
		END_IF
		xUpdateData := TRUE;
	END_IF
	IF vpiq_xSubModuleListUp THEN
		vpiq_xSubModuleListUp := FALSE;
		IF(udiMinSubModuleList + 4 < udiCurrentLevel3Size + udiNumberOfControlModulesLevel2) THEN
			udiMinSubModuleList := udiMinSubModuleList + 1;
		END_IF
		xUpdateData := TRUE;
	END_IF
END_IF
