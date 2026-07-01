__METADATA__
{
  "v3Meta": {
    "objectGuid": "16bad4a6-4b4e-448d-b199-fd8403ae4b00",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* Locate the current module according to the information in audiHierarchy *)
udiCurrentLevel3Size := 0;
pstCurrentFirstLevel3Module := 0;
pstCurrentParent := 0;
dwCurrentAddInterface := 0;
pstCurrent := ADR(SR_MainMachine.stMachineInterface); (* here we have to start at SR_MainMachine.stMachineInterface
instead of our local copy because otherwise it would not be possible to send commands to the MainMachine using the Vis. *)
FOR udiTmp := 2 TO udiCurrentLevel DO
	(* Only navigate to existing modules *)
	IF(pstCurrent^.iq_stExt.udiNumberOfSubModules + pstCurrent^.iq_stExt.udiNumberOfControlModules < audiHierarchy[udiTmp]) THEN
		audiHierarchy[udiTmp] := pstCurrent^.iq_stExt.udiNumberOfSubModules + pstCurrent^.iq_stExt.udiNumberOfControlModules;
	END_IF
	IF(audiHierarchy[udiTmp] <= 0) THEN
		audiHierarchy[udiTmp] := 1;
	END_IF
	IF(pstCurrent^.iq_stExt.udiNumberOfSubModules = 0 AND pstCurrent^.iq_stExt.udiNumberOfControlModules = 0) THEN
		(* Stop, the hierarchy was invalid *)
		udiCurrentLevel := udiTmp - 1;
	ELSE
		(* In case the stSubModules structure of this module is invalid, create an error and stop *)
		IF(pstCurrent^.iq_stExt.dwSubModulesItf = 0) THEN
			stPointerException.sMsg:=						'SR_VisControl: dwSubModuleInterfaces of module was 0';
		END_IF
		IF (pstCurrent^.iq_stExt.pdwSubModulesAddItf = 0 AND pstCurrent^.iq_stExt.dwControlModulesItf = 0) THEN
			stPointerException.sMsg:=						'SR_VisControl: pdwSubModuleAddInterfaces of module was 0';
		END_IF
		(*Set an error if there is no sub module (control module or equipment module)*)
		IF( (pstCurrent^.iq_stExt.dwSubModulesItf = 0 )
			OR (pstCurrent^.iq_stExt.pdwSubModulesAddItf = 0) ) AND pstCurrent^.iq_stExt.dwControlModulesItf = 0 THEN
			(* Error, the structures are not set in the expected way *)
		
			stPointerException.etDiag			:= GD.ET_Diag.UnexpectedProgramBehavior;
			stPointerException.udiDiagExt		:= ET_DiagExt.InvalidPointer;
			stPointerException.sDiagExt			:= FC_EtDiagExtToString(stPointerException.udiDiagExt);
//			stPointerException.sMsg				:= '';
			stPointerException.udiModuleId		:= pstCurrent^.i_udiModuleId;
			stPointerException.sModuleName		:= pstCurrent^.i_sModuleName;
			stPointerException.etSource			:= TPL.ET_ExceptionSource.Vis;
			stPointerException.timDelayTime		:= T#0MS;
			stPointerException.wHmiAttributes	:= 0;
			stPointerException.xAutoQuit		:= FALSE;
			stPointerException.stReaction.axReaction[TPL.ET_Reaction.AsyncStop] := TRUE;

			TPL.FC_SetException(i_xExceptionActive	:= TRUE,
								iq_stException		:= stPointerException,
								iq_stExceptionList	:= G_stExceptionList,
								iq_stLogDataList	:= G_stLogDataList);
								
			xPointerExceptionActive := TRUE;
			RETURN;
		END_IF
		
		pstCurrentParent := pstCurrent;
		(* Only navigate to existing equipment modules *)
		IF pstCurrentParent^.iq_stExt.udiNumberOfSubModules >= audiHierarchy[udiTmp] THEN
			pstCurrent := pstCurrent^.iq_stExt.dwSubModulesItf
				+ UDINT_TO_DWORD((audiHierarchy[udiTmp] - 1) * SIZEOF(vpq_stCurrentModuleStandardInterface));
			IF(udiTmp = 2) THEN
				udiCurrentLevel3Size := pstCurrent^.iq_stExt.udiNumberOfSubModules;
				pstCurrentFirstLevel3Module := pstCurrent^.iq_stExt.dwSubModulesItf;
			END_IF
		END_IF
		(*Initialize pointer for level 2*)
		IF udiTmp = 2 THEN
			pstCurrentLevel2 := pstCurrent;
		END_IF

	END_IF
END_FOR

(*Set pointer to the current module interface*)
IF pstCurrentParent = 0  THEN
	pstCurrentControlModuleStandardInterface 	:= pstCurrent^.iq_stExt.dwControlModulesItf;
	udiCurrentNumberOfControlModules 			:= pstCurrent^.iq_stExt.udiNumberOfControlModules;
ELSE
	pstCurrentControlModuleStandardInterface 	:= pstCurrentParent^.iq_stExt.dwControlModulesItf;
	udiCurrentNumberOfControlModules 			:= pstCurrentParent^.iq_stExt.udiNumberOfControlModules;
END_IF
IF pstCurrentLevel2 <> 0 THEN
	udiNumberOfControlModulesLevel2:= pstCurrentLevel2^.iq_stExt.udiNumberOfControlModules;
ELSE
	udiNumberOfControlModulesLevel2:= 0;
END_IF





























