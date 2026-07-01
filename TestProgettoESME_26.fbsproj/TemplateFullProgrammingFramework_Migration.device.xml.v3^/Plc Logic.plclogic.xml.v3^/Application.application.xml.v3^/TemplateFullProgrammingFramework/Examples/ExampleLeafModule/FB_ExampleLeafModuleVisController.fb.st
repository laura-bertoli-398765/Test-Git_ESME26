__METADATA__
{
  "v3Meta": {
    "objectGuid": "67edbb64-84e0-457c-8df6-d9b1ea4c94ac",
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
FUNCTION_BLOCK FB_ExampleLeafModuleVisController

VAR_INPUT
	i_xEnable								: BOOL;
	i_pstMachineStandardItf					: POINTER TO TPL.ST_StandardModuleInterface;
	i_pstCurrentStandardItf					: POINTER TO TPL.ST_StandardModuleInterface;
	i_dwCurrentAddItf						: TPL.TYPE_ADDRESS; // change DWORD to ADDRESS
	i_xUpdateData							: BOOL; (* Signals the selection of another module *)
	i_udiCurrentJogTarget					: UDINT;
END_VAR

VAR_IN_OUT
	iq_stExceptionList				: TPL.ST_ExceptionList;
	iq_stLogDataList	   			: TPL.ST_LogDataList;
END_VAR

VAR_OUTPUT
	q_xActive								: BOOL;
	q_xReady								: BOOL;
	q_etDiag								: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt								: ET_DiagExtExampleLeafModule := ET_DiagExtExampleLeafModule.Disabled;
	q_sMsg									: STRING[80] := '';
	q_udiSetAsCurrentModule					: UDINT; (* A moduleID, if <> 0, it is set as the current module *)
	q_udiSetAsJogTarget						: UDINT;
END_VAR

VAR
	xCurrentIsOfMyType						: BOOL;
	pstCurrentExampleLeafModuleInterface	: POINTER TO ST_ExampleLeafModuleInterface;
	stCurrentExampleLeafModuleInterface		: ST_ExampleLeafModuleInterface;
	iPaneSelect								: INT := 1; (* Variable for selecting the active pane *)

	(* Variables to detect user changes in the vis *)
	xInitUserInputs							: BOOL;

	(* list of all example leaf modules in the machine *)
	audiExampleLeafModuleId					: ARRAY[1..c_udiMaxExampleLeafModules] OF UDINT; (* if <> 0, module exists *)
	asExampleLeafModuleName					: ARRAY[1..c_udiMaxExampleLeafModules] OF STRING[80]; (* if <> 0, module exists *)
	udiCountExampleLeafModules				: UDINT;
	udiSetAsCurrentModule					: UDINT;

	(* temporary variable, not to be used after init *)
	apExampleLeafModuleInterface			: ARRAY[1..c_udiMaxExampleLeafModules] OF POINTER TO TPL.ST_StandardModuleInterface;
	udiTmp									: UDINT;
	xEnableFlag								: BOOL;

	(* Variables to detect user changes in the vis *)
	lrPosMax								: LREAL;
END_VAR

VAR CONSTANT
	c_udiMaxExampleLeafModules : UDINT := 10;
END_VAR
__IMPLEMENTATION__
q_udiSetAsCurrentModule 	:= 0;
q_udiSetAsJogTarget			:= 0;

(*********************************************************************)

IF i_xEnable AND NOT xEnableFlag THEN
	xEnableFlag := TRUE;
	
	q_xActive	:= TRUE;	
	
	q_etDiag	:= GD.ET_Diag.Ok;
	q_etDiagExt := ET_DiagExtExampleLeafModule.Initializing;
	q_sMsg		:= '';
	
	
		
	udiCountExampleLeafModules := TPL.FC_GetAllModulesOfType(	i_pstMachineStandardItf	:= i_pstMachineStandardItf,
																i_dwWantedType			:= ET_ModuleType.ExampleLeafModule,  
																i_pdwResultSet			:= ADR(apExampleLeafModuleInterface), 
																i_udiResultSetSize		:= c_udiMaxExampleLeafModules);
	FOR udiTmp := 1 TO udiCountExampleLeafModules DO
		(* module version check *)
		IF(apExampleLeafModuleInterface[udiTmp]^.q_udiModuleVersion = 1) THEN
			audiExampleLeafModuleId[udiTmp] := apExampleLeafModuleInterface[udiTmp]^.i_udiModuleId;
			asExampleLeafModuleName[udiTmp] := apExampleLeafModuleInterface[udiTmp]^.i_sModuleName;
		END_IF
	END_FOR
	
	q_xReady	:= TRUE;
	
	q_etDiag	:= GD.ET_Diag.Ok;
	q_etDiagExt	:= ET_DiagExtExampleLeafModule.Working;
	q_sMsg		:= '';
	
ELSIF NOT i_xEnable AND xEnableFlag THEN
	xEnableFlag := FALSE;
	
	q_xActive				:= FALSE;	
	q_xReady				:= FALSE;
	q_etDiag				:= GD.ET_Diag.Ok;
	q_etDiagExt				:= ET_DiagExtExampleLeafModule.Disabled;
	q_sMsg					:= '';
	q_udiSetAsCurrentModule	:= 0;		
	q_udiSetAsJogTarget		:= 0;		
END_IF

IF i_xEnable THEN
	q_udiSetAsCurrentModule := udiSetAsCurrentModule;
	udiSetAsCurrentModule := 0;
END_IF


(*********************************************************************)


IF i_xEnable THEN
	IF i_pstCurrentStandardItf = 0 THEN
		q_xReady := FALSE;
		q_etDiag := GD.ET_Diag.InputParameterInvalid;
		q_etDiagExt := ET_DiagExtExampleLeafModule.CurrentStandardItfInvalidPointer;
		q_sMsg := '';
	ELSIF i_dwCurrentAddItf = 0 THEN
		q_xReady := FALSE;
		q_etDiag := GD.ET_Diag.InputParameterInvalid;
		q_etDiagExt := ET_DiagExtExampleLeafModule.CurrentAddItfInvalidPointer;
		q_sMsg := '';
	ELSE
		q_xReady	:= TRUE;
	
		q_etDiag	:= GD.ET_Diag.Ok;
		q_etDiagExt	:= ET_DiagExtExampleLeafModule.Working;
		q_sMsg		:= '';
		
		IF (i_pstCurrentStandardItf^.q_dwModuleType = UDINT_TO_DWORD(ET_ModuleType.ExampleLeafModule)) THEN
			(* Module version check *)
			IF(i_pstCurrentStandardItf^.q_udiModuleVersion = 1) THEN
				pstCurrentExampleLeafModuleInterface := i_dwCurrentAddItf;
				xCurrentIsOfMyType := TRUE;
			END_IF
		ELSE
			pstCurrentExampleLeafModuleInterface := 0;
			xCurrentIsOfMyType := FALSE;
		END_IF	
	
		IF(xCurrentIsOfMyType) THEN
			(* Execute changes requested by user first *)
			IF(NOT xInitUserInputs) THEN
				xInitUserInputs := TRUE;
				(* Ignore values of variables now *)
			ELSE
				(* Detect user changes *)
				IF stCurrentExampleLeafModuleInterface.i_lrPosMax <> lrPosMax THEN
					pstCurrentExampleLeafModuleInterface^.i_lrPosMax := stCurrentExampleLeafModuleInterface.i_lrPosMax;
				END_IF
	
				(* ... *)
			END_IF
			stCurrentExampleLeafModuleInterface := pstCurrentExampleLeafModuleInterface^;
	
		ELSE
			;
			(* Reset other flags *)
		END_IF
	END_IF
ELSE
	xCurrentIsOfMyType := FALSE;
END_IF
