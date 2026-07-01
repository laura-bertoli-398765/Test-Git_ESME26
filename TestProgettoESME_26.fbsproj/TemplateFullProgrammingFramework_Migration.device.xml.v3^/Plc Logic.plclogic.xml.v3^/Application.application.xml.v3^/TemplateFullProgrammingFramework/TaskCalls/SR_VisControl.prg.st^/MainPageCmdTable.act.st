__METADATA__
{
  "v3Meta": {
    "objectGuid": "646a95cf-1bae-45aa-b332-bb923a04f8d8",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* Find the current table*)
vpq_udiNumberOfCmdStepsModule		:= 0; (* Default values, for security *)
pstEQCMDTableListEntry	:= 0;
pstEQCMDTable			:= 0;

IF(vpq_stMachineInterface.q_diCmdActive <> 0 AND vpq_stMachineInterface.iq_stExt.udiNumberOfCmdTables > 0 AND vpq_stMachineInterface.iq_stExt.pstListofCMDTables <> 0) THEN
	FOR udiTmp2 := 1 TO vpq_stMachineInterface.iq_stExt.udiNumberOfCMDTables DO
		pstEQCMDTableListEntry := vpq_stMachineInterface.iq_stExt.pstListofCMDTables +  UDINT_TO_DWORD((udiTmp2-1)*SIZEOF(pstEQCMDTableListEntry^));
		IF(pstEQCMDTableListEntry^.diCMD = vpq_stMachineInterface.q_diCmdActive) THEN (* Found *)
			vpq_udiNumberOfCmdStepsModule := pstEQCMDTableListEntry^.udiNumberOfCmdSteps;
			vpq_udiNumberOfCmdStepsMain := vpq_udiNumberOfCmdStepsModule;
			pstEQCMDTable := pstEQCMDTableListEntry^.pstCMDTable;
			vpq_sCmdTitelMain := pstEQCMDTableListEntry^.sTitle;
			EXIT;
		END_IF
	END_FOR
END_IF

(***********************************************************************************************************************)
(* Check the limits of the Vis/ shown table *)
udiIndexOldMainTable := 0;
IF vpiq_udiIndexMinMain <> udiIndexOldMainTable THEN
														(*More than 10 steps ??*)
	IF (vpiq_udiIndexMinMain + 9 < vpq_udiNumberOfCmdStepsMain) THEN
		udiIndexMaxMainTable := vpiq_udiIndexMinMain + 9;
	ELSE
		udiIndexMaxMainTable := vpq_udiNumberOfCmdStepsMain;
	END_IF
														(*Additional safety check*)
	IF (vpiq_udiIndexMinMain < 1) OR (vpiq_udiIndexMinMain > vpq_udiNumberOfCmdStepsMain) THEN
		vpiq_udiIndexMinMain :=1;
		udiIndexMaxMainTable := 10;
	END_IF

	udiIndexOldMainTable := vpiq_udiIndexMinMain;
END_IF (*udiEQMainTableIndexMin <> udiEQMainTableIndexOld*)

vpq_xDisableScrollUpMain	:= NOT (vpiq_udiIndexMinMain > 1);
vpq_xDisableScrollDownMain	:= NOT (vpiq_udiIndexMinMain + 9 < vpq_udiNumberOfCmdStepsMain) ;

(***********************************************************************************************************************)
(*Refresh the values in the table if more then "Max commands" should be shown!*)
IF(pstEQCMDTable <> 0) THEN
	FOR udiCounter := udiIndexOldMainTable TO udiIndexMaxMainTable DO
		pstEQCMDTableEntry := pstEQCMDTable +  UDINT_TO_DWORD(((udiCounter-1) * SIZEOF(pstEQCMDTable^)));
		vpq_astActualCmdTableMain[udiCounter - udiIndexOldMainTable + 1] := pstEQCMDTableEntry^;
	END_FOR
	FOR udiCounter := udiIndexMaxMainTable + 1 TO udiIndexOldMainTable + 9 DO
		vpq_astActualCmdTableMain[udiCounter - udiIndexOldMainTable + 1] := c_stEmptyCmdTableStep;
	END_FOR
END_IF
