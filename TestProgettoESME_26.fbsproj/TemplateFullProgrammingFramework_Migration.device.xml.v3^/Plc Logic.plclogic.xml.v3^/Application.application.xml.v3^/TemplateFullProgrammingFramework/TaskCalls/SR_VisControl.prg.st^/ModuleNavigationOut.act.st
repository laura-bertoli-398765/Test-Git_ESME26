__METADATA__
{
  "v3Meta": {
    "objectGuid": "fd258ce9-257c-4dd2-b4ca-4f75b1d63acf",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* update 2d nav data *)
vpq_sNameNavUp    := '';
vpq_sNameNavRight := '';
vpq_sNameNavLeft  := '';

IF pstCurrentParent = 0 THEN
	udiCurrentLevelSize := 1;
ELSE
	udiCurrentLevelSize := pstCurrentParent^.iq_stExt.udiNumberOfSubModules;
	
	vpq_sNameNavUp := pstCurrentParent^.i_sModuleName;
	(*If next module is a equipment module*)
	IF (audiHierarchy[udiCurrentLevel] + 1 <= udiCurrentLevelSize) THEN
		pstTmp :=
			pstCurrentParent^.iq_stExt.dwSubModulesItf +
			UDINT_TO_DWORD((audiHierarchy[udiCurrentLevel] - 1 + 1) * SIZEOF(vpq_stCurrentModuleStandardInterface));
		vpq_sNameNavRight := pstTmp^.i_sModuleName;
		(*If next module is a control module*)
	ELSIF audiHierarchy[udiCurrentLevel] + 1 <= udiCurrentLevelSize + pstCurrentParent^.iq_stExt.udiNumberOfControlModules THEN
		pstControlModuleInterface :=
			pstCurrentParent^.iq_stExt.dwControlModulesItf +
			UDINT_TO_DWORD((audiHierarchy[udiCurrentLevel] - udiCurrentLevelSize) * SIZEOF(pstControlModuleInterface^));
		vpq_sNameNavRight := pstControlModuleInterface^.sControlModuleName;
	END_IF
	IF (audiHierarchy[udiCurrentLevel] - 1 >= 1) THEN
		(*If former module is a equipment module*)
		IF audiHierarchy[udiCurrentLevel] - 1 <= udiCurrentLevelSize THEN
			pstTmp :=
				pstCurrentParent^.iq_stExt.dwSubModulesItf +
				UDINT_TO_DWORD((audiHierarchy[udiCurrentLevel] - 1 - 1) * SIZEOF(vpq_stCurrentModuleStandardInterface));
			vpq_sNameNavLeft := pstTmp^.i_sModuleName;
			(*If former module is a control module*)
		ELSE
			pstControlModuleInterface :=
				pstCurrentParent^.iq_stExt.dwControlModulesItf +
				UDINT_TO_DWORD((audiHierarchy[udiCurrentLevel] - udiCurrentLevelSize - 2) * SIZEOF(pstControlModuleInterface^));
			vpq_sNameNavLeft := pstControlModuleInterface^.sControlModuleName;
		END_IF
	END_IF
END_IF

xCurrentHasControlModules := pstCurrent^.iq_stExt.udiNumberOfControlModules > 0;
xCurrentHasSubModules     := ((pstCurrent^.iq_stExt.udiNumberOfSubModules > 0) AND udiControlModuleSelectedInLevel = 0);
xCurrentIsNoNodeModule    := (pstCurrent^.q_dwModuleType <> UDINT_TO_DWORD(TPL.ET_ModuleType.NodeModule));
IF ((xCurrentIsNoNodeModule OR xCurrentHasControlModules) AND udiControlModuleSelectedInLevel = 0) THEN
	IF (pstCurrentParent <> 0) THEN (* Security check *)
		pdwTmp                :=
			ADR(pstCurrentParent^.iq_stExt.pdwSubModulesAddItf^) + UDINT_TO_DWORD((audiHierarchy[udiCurrentLevel] - 1) * SIZEOF(dwDummy));
		dwCurrentAddInterface := pdwTmp^;
	END_IF
END_IF

vpq_xEnableNavUp   := (udiCurrentLevel - 1 >= 1);
vpq_xEnableNavDown :=
	(udiCurrentLevel < c_udiMaxHierarchyLevels) AND (xCurrentHasSubModules OR xCurrentHasControlModules) AND udiControlModuleSelectedInLevel = 0;
vpq_xEnableNavLeft  := (audiHierarchy[udiCurrentLevel] - 1 >= 1);
vpq_xEnableNavRight := (audiHierarchy[udiCurrentLevel] + 1 <= udiCurrentLevelSize + udiCurrentNumberOfControlModules) AND (udiCurrentLevel >= 2);

IF vpq_xEnableNavDown THEN
	(* Name of the first submodule of the current module *)
	IF xCurrentHasSubModules THEN
		pstTmp           := pstCurrent^.iq_stExt.dwSubModulesItf;
		vpq_sNameNavDown := pstTmp^.i_sModuleName;
	ELSE
		pstControlModuleInterface := pstCurrent^.iq_stExt.dwControlModulesItf;
		vpq_sNameNavDown          := pstControlModuleInterface^.sControlModuleName;
	END_IF
	
ELSE
	vpq_sNameNavDown := '';
END_IF

(* Update direct nav data *)
(* Module level *)
vpq_xDisableModuleListDown := NOT (udiMinModuleList > 1);
vpq_xDisableModuleListUp   :=
	NOT (udiMinModuleList + 5 <= vpq_stMachineInterface.iq_stExt.udiNumberOfSubModules + vpq_stMachineInterface.iq_stExt.udiNumberOfControlModules);
FOR udiTmp := 1 TO 5 DO
	vpq_axControlModuleValid[udiTmp] := FALSE;
	audiControlModuleNumber[udiTmp]  :=
		0 (*-1*)
		;
	vpq_asToolTipControlModuleList[udiTmp] := 'None';
	vpq_axDisableModuleList[udiTmp]        := NOT ((udiTmp - 1 + udiMinModuleList) <= vpq_stMachineInterface.iq_stExt.udiNumberOfSubModules);
	vpq_axActiveModuleList[udiTmp]         := (udiCurrentLevel >= 2) AND (audiHierarchy[2] = (udiTmp - 1 + udiMinModuleList));
	vpq_axControlModuleActive[udiTmp]      := FALSE;
	(*Show button for equipment module*)
	IF (NOT vpq_axDisableModuleList[udiTmp]) THEN
		pstTmp :=
			vpq_stMachineInterface.iq_stExt.dwSubModulesItf +
			UDINT_TO_DWORD(((udiTmp - 1 + udiMinModuleList) - 1) * SIZEOF(vpq_stCurrentModuleStandardInterface));
		vpq_audiIdModuleList[udiTmp]    := pstTmp^.i_udiModuleId;
		vpq_axIdModuleListValid[udiTmp] := TRUE;
		
		vpq_asNameModuleList[udiTmp] := pstTmp^.i_sModuleName;
		(*Show button for control module*)
	ELSE
		vpq_audiIdModuleList[udiTmp] :=
			0 (*-1*)
			;
		vpq_axIdModuleListValid[udiTmp] := FALSE;
		vpq_asNameModuleList[udiTmp]    := 'None';
		IF
			vpq_stMachineInterface.iq_stExt.udiNumberOfControlModules <> 0 AND
			udiTmp <= vpq_stMachineInterface.iq_stExt.udiNumberOfControlModules + vpq_stMachineInterface.iq_stExt.udiNumberOfSubModules
		THEN
			pstControlModuleInterface :=
				vpq_stMachineInterface.iq_stExt.dwControlModulesItf +
				UDINT_TO_DWORD((udiTmp - vpq_stMachineInterface.iq_stExt.udiNumberOfSubModules - 1 + udiMinModuleList) - 1) *
					SIZEOF(pstControlModuleInterface^);
			vpq_asToolTipControlModuleList[udiTmp] := pstControlModuleInterface^.sControlModuleName;
			vpq_axControlModuleActive[udiTmp]      := (udiCurrentLevel >= 2) AND (audiHierarchy[2] = (udiTmp - 1 + udiMinModuleList));
			vpq_axControlModuleValid[udiTmp]       := TRUE;
			audiControlModuleNumber[udiTmp]        := pstControlModuleInterface^.udiControlModuleNumber;
			vpq_asControlModuleButtonName[udiTmp]  :=
				CONCAT(
					STR1 := 'Type: ',
					STR2 :=
						CONCAT(
							STR1 := UDINT_TO_STRING(pstControlModuleInterface^.udiControlModuleType),
							STR2 := CONCAT(STR1 := '   #: ', STR2 := UDINT_TO_STRING(pstControlModuleInterface^.udiControlModuleNumber))));
		END_IF
	END_IF
END_FOR

(* Submodule level *)
IF (udiMinSubModuleList + 4 > udiCurrentLevel3Size + udiNumberOfControlModulesLevel2) THEN
	udiMinSubModuleList := 1;
END_IF
vpq_xDisableSubModuleListDown := NOT (udiMinSubModuleList > 1);
vpq_xDisableSubModuleListUp   :=
	NOT (udiMinSubModuleList + 5 <= udiCurrentLevel3Size + udiNumberOfControlModulesLevel2) AND NOT (udiCurrentLevel = 2 AND xControlModuleSelected);
FOR udiTmp := 1 TO 5 DO
	vpq_axDisableSubModuleList[udiTmp] := NOT ((udiTmp - 1 + udiMinSubModuleList) <= udiCurrentLevel3Size);
	vpq_axActiveSubModuleList[udiTmp]  := (udiCurrentLevel >= 3) AND (audiHierarchy[3] = (udiTmp - 1 + udiMinSubModuleList));
	vpq_audiIdSubModuleList[udiTmp]    :=
		0 (*-1*)
		;
	vpq_axIdSubModuleListValid[udiTmp]  := FALSE;
	vpq_asNameSubModuleList[udiTmp]     := 'None';
	vpq_axSubControlModuleValid[udiTmp] := FALSE;
	audiSubControlModuleID[udiTmp]      :=
		0 (*-1*)
		;
	vpq_asToolTipSubControlModuleList[udiTmp] := 'None';
	vpq_axSubControlModuleActive[udiTmp]      := FALSE;
	(*Show button for equipment module*)
	IF (NOT vpq_axDisableSubModuleList[udiTmp]) THEN
		IF (pstCurrentFirstLevel3Module <> 0) THEN
			pstTmp :=
				ADR(pstCurrentFirstLevel3Module^) +
				UDINT_TO_DWORD(((udiTmp - 1 + udiMinSubModuleList) - 1) * SIZEOF(vpq_stCurrentModuleStandardInterface));
			vpq_audiIdSubModuleList[udiTmp]    := pstTmp^.i_udiModuleId;
			vpq_axIdSubModuleListValid[udiTmp] := TRUE;
			
			vpq_asNameSubModuleList[udiTmp] := pstTmp^.i_sModuleName;
		END_IF
		(*Show button for control module*)
	ELSE
		IF udiCurrentLevel >= 2 AND udiControlModuleSelectedInLevel <> 2 THEN
			IF pstCurrentLevel2 <> 0 THEN
				IF
					pstCurrentLevel2^.iq_stExt.udiNumberOfControlModules <> 0 AND
					udiTmp <= pstCurrentLevel2^.iq_stExt.udiNumberOfControlModules + udiCurrentLevel3Size
				THEN
					pstControlModuleInterface :=
						pstCurrentLevel2^.iq_stExt.dwControlModulesItf +
						UDINT_TO_DWORD(
							(udiTmp - pstCurrentLevel2^.iq_stExt.udiNumberOfSubModules - 1 + udiMinSubModuleList - 1) *
							SIZEOF(pstControlModuleInterface^));
					vpq_asToolTipSubControlModuleList[udiTmp] := pstControlModuleInterface^.sControlModuleName;
					vpq_asSubControlModuleButtonName[udiTmp]  :=
						CONCAT(
							STR1 := 'Type: ',
							STR2 :=
								CONCAT(
									STR1 := UDINT_TO_STRING(pstControlModuleInterface^.udiControlModuleType),
									STR2 := CONCAT(STR1 := '   #: ', STR2 := UDINT_TO_STRING(pstControlModuleInterface^.udiControlModuleNumber))));
					vpq_axSubControlModuleActive[udiTmp] := (udiCurrentLevel >= 3) AND (audiHierarchy[3] = (udiTmp - 1 + udiMinSubModuleList));
					vpq_axSubControlModuleValid[udiTmp]  := TRUE;
					audiSubControlModuleID[udiTmp]       := pstControlModuleInterface^.udiControlModuleNumber;
				END_IF
			END_IF
		END_IF
	END_IF
END_FOR

// iEQTableIndexMin := 1;
//iEQTableIndexOld := 0;

(*Select current control module*)
FOR udiTmp := 1 TO 5 DO
	IF vpq_axControlModuleActive[udiTmp] THEN
		vpq_udiActiveControlModuleNumber := audiControlModuleNumber[udiTmp];
	END_IF
	IF vpq_axSubControlModuleActive[udiTmp] THEN
		vpq_udiActiveControlModuleNumber := audiSubControlModuleID[udiTmp];
	END_IF
END_FOR
