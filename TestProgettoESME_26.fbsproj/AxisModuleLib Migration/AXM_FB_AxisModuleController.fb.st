__METADATA__
{
  "v3Meta": {
    "objectGuid": "1eadfffd-1b3d-4003-9c42-606499625392",
    "objectTypeGuid": "6f9dac99-8de1-4efc-8465-68ac443b7d08",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__DECLARATION__
FUNCTION_BLOCK PUBLIC AXM_FB_AxisModuleController
VAR_INPUT
	i_xEnable			: BOOL;
END_VAR
VAR_IN_OUT
	iq_stStandardModuleItf			: TPL.ST_StandardModuleInterface;
	iq_stStandardMotionItf			: TPL.ST_StandardMotionInterface;
	iq_stExceptionList				: TPL.ST_ExceptionList;
	iq_stLogDataList				: TPL.ST_LogDataList;
END_VAR
VAR_OUTPUT
	q_xActive			: BOOL;
	q_xReady			: BOOL;
	q_etDiag			: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt			: AXM_ET_DiagExt := AXM_ET_DiagExt.Disabled;
	q_sMsg				: STRING[80] := '';
END_VAR
VAR
	pdw								: POINTER TO TPL.TYPE_ADDRESS; // change from DWORD to TYPE_ADDRESS;
	udiModul						: UDINT;
	pstStandardInterface			: POINTER TO TPL.ST_StandardModuleInterface;
	pstAxisInterface				: POINTER TO AXM_ST_ModuleInterface;
	xSercState						: BOOL;
	xSercStateOld					: BOOL := TRUE;
	xJogForwEdgeDetect              : BOOL := FALSE;
	xJogBackEdgeDetect              : BOOL := FALSE;
END_VAR
__IMPLEMENTATION__
IF i_xEnable AND NOT q_xActive THEN
	q_xActive := TRUE;
	q_xReady := TRUE;
	q_etDiag := GD.ET_Diag.Ok;
	q_etDiagExt := AXM_ET_DiagExt.Working;
	q_sMsg		:= '';
ELSIF NOT i_xEnable AND q_xActive THEN
	IF(iq_stStandardModuleItf.iq_stExt.dwSubModulesItf <> 0 AND iq_stStandardModuleItf.iq_stExt.pdwSubModulesAddItf <> 0) THEN
		FOR udiModul:= 1 TO iq_stStandardModuleItf.iq_stExt.udiNumberOfSubModules DO
			pstStandardInterface := iq_stStandardModuleItf.iq_stExt.dwSubModulesItf + UDINT_TO_DWORD((udiModul - 1) * SIZEOF(pstStandardInterface^));
			IF(pstStandardInterface^.q_dwModuleType = UDINT_TO_DWORD(TPL.ET_ModuleType.AxisModule)) THEN
				(* Module version check *)
				IF(pstStandardInterface^.q_udiModuleVersion = 1) THEN
					pdw := iq_stStandardModuleItf.iq_stExt.pdwSubModulesAddItf + UDINT_TO_DWORD((udiModul - 1) * SIZEOF(pdw^));
					pstAxisInterface := pdw^;
					IF(pstAxisInterface <> 0) THEN
						pstAxisInterface^.stManual.i_xJogForw := FALSE;
						pstAxisInterface^.stManual.i_xJogBack := FALSE;
					END_IF
				END_IF
			END_IF
		END_FOR
	END_IF
	q_xReady 	:= FALSE;
	q_xActive	:= FALSE;
	q_etDiag	:= GD.ET_Diag.Ok;
	q_etDiagExt	:= AXM_ET_DiagExt.Disabled;
	q_sMsg		:= '';
END_IF
IF ((iq_stStandardModuleItf.iq_stExt.udiNumberOfSubModules <> 0)
	AND ((iq_stStandardModuleItf.iq_stExt.pdwSubModulesAddItf = 0) OR (iq_stStandardModuleItf.iq_stExt.dwSubModulesItf = 0))) THEN
	q_xReady := FALSE;
	q_etDiag := GD.ET_Diag.InputParameterInvalid;
	q_etDiagExt := AXM_ET_DiagExt.MissingExtInit;
	q_sMsg := 'Missing Call of FC_UpdateAddInterfaceStruct';
END_IF

IF q_xActive AND q_xReady  THEN
 	IF (FC_GetSercosState() >= SMI.ET_SercosState.NRT) THEN 
		xSercState := (FC_GetSercosState() = SMI.ET_SercosState.Phase4);
		IF(iq_stStandardModuleItf.iq_stExt.dwSubModulesItf <> 0 AND iq_stStandardModuleItf.iq_stExt.pdwSubModulesAddItf <> 0) THEN
			FOR udiModul := 1 TO iq_stStandardModuleItf.iq_stExt.udiNumberOfSubModules DO
				pstStandardInterface := iq_stStandardModuleItf.iq_stExt.dwSubModulesItf + UDINT_TO_DWORD((udiModul - 1) * SIZEOF(pstStandardInterface^));
				IF(pstStandardInterface^.q_dwModuleType = TPL.ET_ModuleType.AxisModule) THEN
					(* Module version check *)
					IF(pstStandardInterface^.q_udiModuleVersion = 1) THEN
						pdw := iq_stStandardModuleItf.iq_stExt.pdwSubModulesAddItf +  UDINT_TO_DWORD((udiModul - 1) * SIZEOF(pdw^));
						IF(pdw^ = 0) THEN (* Configuration error in stSubModules *)
							q_xReady := FALSE;
							q_etDiag := GD.ET_Diag.InputParameterInvalid;
							q_etDiagExt := AXM_ET_DiagExt.MissingExtInit;
							q_sMsg := 'Missing Call of FC_UpdateAddInterfaceStruct';
							RETURN;
						END_IF
						pstAxisInterface := pdw^;
						IF(pstAxisInterface <> 0) THEN
							(* Implementation of axis select *)
							IF iq_stStandardMotionItf.i_udiModuleSelect > 0 AND iq_stStandardMotionItf.i_udiModuleSelect = pstStandardInterface^.i_udiModuleId THEN
								
								(* Don't set pstAxisInterface^.stManual.i_xJog* from iq_stStandardMotionItf.i_xJog* blindly since the Vis might want to jog as well *)
								IF (iq_stStandardMotionItf.i_xJogForw) THEN
									pstAxisInterface^.stManual.i_xJogForw := TRUE;
									xJogForwEdgeDetect := TRUE;
								ELSE
									IF (xJogForwEdgeDetect) THEN
										pstAxisInterface^.stManual.i_xJogForw := FALSE;
										xJogForwEdgeDetect := FALSE;
								    END_IF
								END_IF
								IF (iq_stStandardMotionItf.i_xJogBack) THEN
									pstAxisInterface^.stManual.i_xJogBack := TRUE;
									xJogBackEdgeDetect := TRUE;
								ELSE
									IF (xJogBackEdgeDetect) THEN
										pstAxisInterface^.stManual.i_xJogBack := FALSE;
										xJogBackEdgeDetect := FALSE;
								    END_IF
								END_IF
								
							ELSE
								pstAxisInterface^.stManual.i_xJogForw := FALSE;
								pstAxisInterface^.stManual.i_xJogBack := FALSE;
							END_IF
							(* Implementation of HomeOkReset *)
							IF NOT xSercState  THEN (* As long as the sercos state is <> 4, set the reset home ok to true *)
								pstAxisInterface^.stHome.i_xResetHomeOk := TRUE;
							ELSIF NOT xSercStateOld THEN (* Detect a positive edge in xSercState, the sercos has entered state 4 *)
								pstAxisInterface^.stHome.i_xResetHomeOk := FALSE;
							END_IF
						END_IF
					END_IF
				END_IF
			END_FOR
 		END_IF
	ELSE
		xSercState := FALSE;
		q_xReady := FALSE;
		q_etDiag := GD.ET_Diag.SercosConditionInvalid;
		q_etDiagExt := AXM_ET_DiagExt.GlobalSercosInterfaceInvalid;
		q_sMsg := AXM_FC_EtDiagExtToString(i_etDiagExt := AXM_ET_DiagExt.GlobalSercosInterfaceInvalid);
	END_IF
	xSercStateOld := xSercState;
END_IF
