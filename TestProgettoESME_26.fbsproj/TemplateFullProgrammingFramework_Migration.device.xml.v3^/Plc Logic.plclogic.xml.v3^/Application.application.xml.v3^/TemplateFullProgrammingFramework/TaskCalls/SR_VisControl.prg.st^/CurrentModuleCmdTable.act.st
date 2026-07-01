__METADATA__
{
  "v3Meta": {
    "objectGuid": "ef0d38f4-1bb2-4067-ad44-161d1bb29efb",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* Find the active CMD table *)
vpq_udiNumberOfCmdStepsModule :=  0; (* Default values, for security *)
pstEQCMDTableListEntry := 0;
pstEQCMDTable := 0;
IF (vpq_stCurrentModuleStandardInterface.q_diCMDActive <> 0 AND 
	vpq_stCurrentModuleStandardInterface.iq_stExt.udiNumberOfCMDTables > 0 AND 
	vpq_stCurrentModuleStandardInterface.iq_stExt.pstListofCMDTables <> 0) THEN
	
	FOR udiTmp2 := 1 TO vpq_stCurrentModuleStandardInterface.iq_stExt.udiNumberOfCMDTables DO
		pstEQCMDTableListEntry := vpq_stCurrentModuleStandardInterface.iq_stExt.pstListofCMDTables +  UDINT_TO_DWORD((udiTmp2-1)*SIZEOF(pstEQCMDTableListEntry^));
		IF(pstEQCMDTableListEntry^.diCMD = vpq_stCurrentModuleStandardInterface.q_diCMDActive) THEN (* Found *)
			vpq_udiNumberOfCmdStepsModule := pstEQCMDTableListEntry^.udiNumberOfCmdSteps;
			pstEQCMDTable := pstEQCMDTableListEntry^.pstCMDTable;
			vpq_sCmdTitleModule := pstEQCMDTableListEntry^.sTitle;
			EXIT;
		END_IF
	END_FOR
END_IF

(*Command steps > 10 and index changed??*)
IF vpq_udiNumberOfCmdStepsModule <> udiEQTableIndexOld OR udiEQTableStepCountOld <> vpq_udiNumberOfCmdStepsModule THEN
														(*More than 10 steps ??*)
	IF (vpiq_udiIndexMinModule + 9 < vpq_udiNumberOfCmdStepsModule) THEN
		udiEQTableIndexMax := vpiq_udiIndexMinModule + 9;
	ELSE
		udiEQTableIndexMax := vpq_udiNumberOfCmdStepsModule;
	END_IF
														(*Additional safety check*)
	IF (vpiq_udiIndexMinModule < 1) OR (vpiq_udiIndexMinModule > vpq_udiNumberOfCmdStepsModule) THEN
		vpiq_udiIndexMinModule :=1;
		udiEQTableIndexMax := 10;
	END_IF

	udiEQTableIndexOld := vpiq_udiIndexMinModule;
	udiEQTableStepCountOld := vpq_udiNumberOfCmdStepsModule;
END_IF (*vpiq_udiIndexMinModule <> udiEQTableIndexOld*)

vpq_xDisableScrollUpModule := NOT (vpiq_udiIndexMinModule > 1);
vpq_xDisableScrollDownModule := NOT (vpiq_udiIndexMinModule + 9 < vpq_udiNumberOfCmdStepsModule);

IF(pstEQCMDTable <> 0) THEN
	FOR udiCounter := udiEQTableIndexOld TO udiEQTableIndexMax DO
		pstEQCMDTableEntry := pstEQCMDTable +  UDINT_TO_DWORD(((udiCounter-1) * SIZEOF(pstEQCMDTable^)));
		vpq_astActualCmdTableModule[udiCounter - udiEQTableIndexOld + 1] := pstEQCMDTableEntry^;
	END_FOR
	FOR udiCounter := udiEQTableIndexMax + 1 TO udiEQTableIndexOld + 9 DO
		vpq_astActualCmdTableModule[udiCounter - udiEQTableIndexOld + 1] := c_stEmptyCmdTableStep;
	END_FOR
	vpq_xDisplayCmdTable := TRUE;
ELSE
	vpq_xDisplayCmdTable := FALSE;
END_IF
