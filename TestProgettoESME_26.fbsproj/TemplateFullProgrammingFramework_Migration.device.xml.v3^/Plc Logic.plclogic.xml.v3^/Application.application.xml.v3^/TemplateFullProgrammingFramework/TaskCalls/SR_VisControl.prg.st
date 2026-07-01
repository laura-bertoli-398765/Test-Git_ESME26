__METADATA__
{
  "v3Meta": {
    "objectGuid": "509b7c28-f27c-46f3-a560-bda45510093f",
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
PROGRAM SR_VisControl
VAR CONSTANT
	c_udiMaxHierarchyLevels : UDINT      := 10;
	c_stEmptyCmdTableStep   : TPL.ST_Cmd := (sTitle := '', diStep := 0, udiModuleName := 0, diCmd := 0, timTimeOut := T#60S, xEndCmd := FALSE);
END_VAR
VAR (*User specific variables*)
	
END_VAR
VAR
	iState                : INT  := 0;
	vpq_xDoEnable         : BOOL := FALSE;
	xEnableFlag           : BOOL;
	iDoEnableCycleCounter : INT  := 0;
	
	IFB_RTOPMode : STANDARD.R_TRIG;
	
	(* Cmd table of main machine on VIS_Main *)
	pstStep    : POINTER TO TPL.ST_Cmd;
	udiCounter : UDINT;
	
	vpq_astActualCmdTableMain   : ARRAY[1..10] OF TPL.ST_Cmd;
	vpq_udiNumberOfCmdStepsMain : UDINT;
	vpq_sCmdTitelMain           : STRING;
	vpiq_udiIndexMinMain        : UDINT := 1;
	udiIndexMaxMainTable        : UDINT := 1;
	udiIndexOldMainTable        : UDINT := 1;
	
	vpq_xDisableScrollUpMain   : BOOL;
	vpq_xDisableScrollDownMain : BOOL;
	
	(* Visualization of the main machine on the VIS_Main *)
	vpq_stMachineInterface : TPL.ST_StandardModuleInterface;
	
	vpq_xMachineInException           : BOOL;
	vpq_etMainModuleControllerDiag    : GD.ET_Diag;
	vpq_etMainModuleControllerDiagExt : TPL.ET_DiagExt;
	vpq_sMainModuleControllerMsg      : STRING[80];
	
	(*Exception*)
	vpiq_xTestUserException1 : BOOL;
	xTestUserException1Old   : BOOL;
	vpiq_xTestUserException2 : BOOL;
	xTestUserException2Old   : BOOL;
	vpiq_xTestUserException3 : BOOL;
	xTestUserException3Old   : BOOL;
	vpiq_xTestUserException4 : BOOL;
	xTestUserException4Old   : BOOL;
	vpiq_xTestUserException5 : BOOL;
	xTestUserException5Old   : BOOL;
	
	vpq_udiReactionIndexMin : UDINT := 1;
	udiReactionIndexMax     : UDINT := 1;
	udiReactionIndexOld     : UDINT := 1;
	vpq_axReaction          : ARRAY[1..10] OF BOOL;
	
	udiCount           : UDINT;
	stActiveReactions  : TPL.ST_Reaction;
	vpiq_xReactionUp   : BOOL;
	vpiq_xReactionDown : BOOL;
	
	(*Vis*)
	vpiq_xShowControlFrame    : BOOL;
	vpiq_xShowModuleInterface : BOOL;
	vpiq_iPositionX           : INT;
	vpiq_iPositionY           : INT;
	
	vpq_xShowLogDataListDetails    : BOOL := FALSE;
	vpiq_xButtonLogDataListDetails : BOOL := FALSE;
	
	(* Visualization of the actCmdTable of the current module *)
	pstEQCMDTable                 : POINTER TO TPL.ST_Cmd; (* Pointer to active CMD Table *)
	pstEQCMDTableEntry            : POINTER TO TPL.ST_Cmd;
	vpq_astActualCmdTableModule   : ARRAY[1..10] OF TPL.ST_Cmd;
	vpiq_udiIndexMinModule        : UDINT := 1;
	udiEQTableIndexMax            : UDINT := 1;
	udiEQTableIndexOld            : UDINT := 1;
	vpq_udiNumberOfCmdStepsModule : UDINT := 0;
	pstEQCMDTableListEntry        : POINTER TO TPL.ST_CmdTable;
	vpq_sCmdTitleModule           : STRING[80];
	udiEQTableStepCountOld        : UDINT;
	
	(* Navigation in the command table *)
	vpq_xDisableScrollUpModule   : BOOL;
	vpq_xDisableScrollDownModule : BOOL;
	vpq_xDisplayCmdTable         : BOOL;
	
	(* 2d navigation buttons *)
	vpiq_xNavUp         : BOOL;
	vpiq_xNavDown       : BOOL;
	vpiq_xNavLeft       : BOOL;
	vpiq_xNavRight      : BOOL;
	vpq_xEnableNavUp    : BOOL;
	vpq_xEnableNavDown  : BOOL;
	vpq_xEnableNavLeft  : BOOL;
	vpq_xEnableNavRight : BOOL;
	vpq_sNameNavUp      : STRING[80];
	vpq_sNameNavDown    : STRING[80];
	vpq_sNameNavLeft    : STRING[80];
	vpq_sNameNavRight   : STRING[80];
	
	(* Navigation flags *)
	pstCurrentParent       : POINTER TO TPL.ST_StandardModuleInterface;
	pstCurrent             : POINTER TO TPL.ST_StandardModuleInterface;
	xCurrentIsNoNodeModule : BOOL;
	dwCurrentAddInterface  : TPL.TYPE_ADDRESS; // change DWORD to ADDRESS
	xUpdateForOtherFBs     : BOOL;
	audiHierarchy          : ARRAY[1..c_udiMaxHierarchyLevels] OF UDINT; (* Selected modules in each level of the hierarchy *)
	udiCurrentLevel        : UDINT := 1; (* Level of the hierarchy we are working on*)
	udiCurrentLevelSize    : UDINT := 1;
	xCurrentHasSubModules  : BOOL  := FALSE;
	pstTmp                 : POINTER TO TPL.ST_StandardModuleInterface;
	pdwTmp                 : POINTER TO TPL.TYPE_ADDRESS; // change DWORD to ADDRESS
	
	xUpdateData : BOOL := FALSE;
	dwDummy     : TPL.TYPE_ADDRESS; // change DWORD to ADDRESSDWORD;
	
	vpq_xButtonSetJogTargetInvisible  : BOOL := FALSE;
	vpiq_xButtonSetCurrentAsJogTarget : BOOL;
	vpq_xCurrentIsJogTarget           : BOOL := FALSE;
	udiSetAsJogTarget                 : UDINT;
	//	udiSetAsJogTargetNum					: UDINT;
	IFB_FTrigxCurrentIsJogTarget : STANDARD.F_TRIG;
	
	(* Direct navigation buttons *)
	axClearBoolA5 : ARRAY[1..5] OF BOOL;
	
	vpiq_xModuleListDown            : BOOL; (* Module table scroll buttons *)
	vpq_xDisableModuleListDown      : BOOL;
	vpiq_xModuleListUp              : BOOL;
	vpq_xDisableModuleListUp        : BOOL;
	vpiq_axModuleList               : ARRAY[1..5] OF BOOL;
	vpiq_axControlModuleList        : ARRAY[1..5] OF BOOL;
	vpq_axDisableModuleList         : ARRAY[1..5] OF BOOL;
	vpq_axActiveModuleList          : ARRAY[1..5] OF BOOL; (* Highlight active module *)
	vpq_axControlModuleActive       : ARRAY[1..5] OF BOOL; (* Highlight active control module *)
	vpq_audiIdModuleList            : ARRAY[1..5] OF UDINT; (* Module ids *)
	vpq_axIdModuleListValid         : ARRAY[1..5] OF BOOL;
	vpq_axControlModuleValid        : ARRAY[1..5] OF BOOL;
	audiControlModuleNumber         : ARRAY[1..5] OF UDINT;
	vpq_asNameModuleList            : ARRAY[1..5] OF STRING[80]; (* Module name *)
	vpq_asToolTipControlModuleList  : ARRAY[1..5] OF STRING[80];
	vpq_asControlModuleButtonName   : ARRAY[1..5] OF STRING[60];
	udiNumberOfControlModulesLevel2 : UDINT;
	
	vpiq_xSubModuleListDown       : BOOL;
	vpq_xDisableSubModuleListDown : BOOL;
	vpiq_xSubModuleListUp         : BOOL;
	vpq_xDisableSubModuleListUp   : BOOL;
	
	vpiq_axSubModuleList              : ARRAY[1..5] OF BOOL;
	vpq_axDisableSubModuleList        : ARRAY[1..5] OF BOOL;
	vpq_axActiveSubModuleList         : ARRAY[1..5] OF BOOL; (* Highlight active module *)
	vpq_audiIdSubModuleList           : ARRAY[1..5] OF UDINT; (* Module ids *)
	vpq_axIdSubModuleListValid        : ARRAY[1..5] OF BOOL;
	vpq_asNameSubModuleList           : ARRAY[1..5] OF STRING[60]; (* Module names *)
	vpiq_axSubControlModuleList       : ARRAY[1..5] OF BOOL;
	vpq_axSubControlModuleValid       : ARRAY[1..5] OF BOOL;
	audiSubControlModuleID            : ARRAY[1..5] OF UDINT;
	vpq_asToolTipSubControlModuleList : ARRAY[1..5] OF STRING[80];
	vpq_axSubControlModuleActive      : ARRAY[1..5] OF BOOL;
	vpq_asSubControlModuleButtonName  : ARRAY[1..5] OF STRING[60];
	udiCurrentLevel3Size              : UDINT := 0; (* How many submodules does the current module have on level 2 *)
	pstCurrentFirstLevel3Module       : POINTER TO TPL.ST_StandardModuleInterface;
	udiCurrentNumberOfControlModules  : UDINT;
	
	(*Variables for selecting control modules *)
	vpq_udiActiveControlModuleNumber         : UDINT;
	pstCurrentNodeInterface                  : POINTER TO TPL.ST_StandardModuleInterface;
	pstControlModuleInterface                : POINTER TO TPL.ST_ControlModuleInterface;
	pstCurrentControlModuleStandardInterface : POINTER TO TPL.ST_ControlModuleInterface;
	pstTempCtrlModule                        : POINTER TO TPL.ST_ControlModuleInterface;
	stCurrentControlModuleStandardInterface  : TPL.ST_ControlModuleInterface;
	udiControlModuleSelectedInLevel          : UDINT;
	xControlModuleSelected                   : BOOL;
	xCurrentHasControlModules                : BOOL;
	pstCurrentLevel2                         : POINTER TO TPL.ST_StandardModuleInterface;
	
	(* Direct navigation flags *)
	udiMinModuleList    : UDINT;
	udiMinSubModuleList : UDINT;
	
	(* Struct for displaying values of the current module *)
	vpq_stCurrentModuleStandardInterface : TPL.ST_StandardModuleInterface;
	vpq_sCurrentModuleReaction           : STRING[255];
	stDummyStandardInterface             : TPL.ST_StandardModuleInterface;
	
	(* Exceptions the vis can create *)
	stPointerException      : TPL.ST_Exception;
	xPointerExceptionActive : BOOL;
	
	udiSetAsCurrentModule : UDINT; (* If <> 0, specifies the ID of a module, to set as current module *)
	
	(* Flags of the SetCurrentModule action *)
	udiTmp2 : UDINT;
	udiTmp  : UDINT;
	
	(* Inputs, for module control *)
	vpiq_diCmdToSet           : DINT;
	vpiq_diStartStepToSet     : DINT;
	vpiq_xSetCmdClicked       : BOOL; (* Set by the vis, reset by SR_VisControl, if true, diCmdToSet is written to the CMD of the current module *)
	xDiagQuit_Touch           : BOOL; (* Set by the vis, if true, the DiagQuit Input of the module is set *)
	xDiagQuit_WasTouched      : BOOL; (* Internal flag *)
	vpiq_xEnableModuleClicked : BOOL; (* Set by the vis, reset by SR_VisControl, if true, the xEnable of the module is toggled *)
	
	stModuleReactions             : TPL.ST_Reaction;
	vpiq_xModuleReactionUp        : BOOL;
	vpiq_xModuleReactionDown      : BOOL;
	vpq_udiModuleReactionIndexMin : UDINT := 1;
	udiModuleReactionIndexMax     : UDINT := 1;
	udiModuleReactionIndexOld     : UDINT := 1;
	vpq_axModuleReaction          : ARRAY[1..10] OF BOOL;
	udiCount2                     : UDINT;
	udiMaxValue                   : UDINT;
	
	(*FR_ExceptionList, navigation in the global ExceptionList*)
	vpiq_udiExceptionListIndexMin          : UDINT := 1;
	vpq_asReaction                         : ARRAY[1..10] OF STRING[80];
	vpq_udiExceptionListIndexMax           : UDINT := 1;
	vpq_xDisplayScrollDown                 : BOOL;
	vpq_astExceptionListTable              : ARRAY[1..10] OF TPL.ST_Exception;
	vpiq_udiExceptionListGoToDetailsOfLine : UDINT; (* index of the line that was selected in the exception list; set by vis to value, restet by VisControl; *)
	
	vpq_xShowExtendedTimes        : BOOL := FALSE;
	vpq_xShowExtended2            : BOOL := FALSE;
	vpiq_xButtonShowExtendedTimes : BOOL := FALSE;
	vpiq_xButtonShowExtended2     : BOOL := FALSE;
	
	vpq_udiNumberOfExceptions : UDINT;
	
	udiIndex                : UDINT;
	vpq_sAllActiveReactions : STRING[255];
	(* --- exception list --- *)

	udiExceptionListDetailsSelectIndex : UDINT;
	
	(*FR_ASCIILoggerList, navigation in the LoggerList*)
	vpiq_udiLogDataListIndexMin : UDINT := 1;
	vpq_udiLogDataListIndexMax  : UDINT := 1;
	vpiq_udiNumberOfLogData     : UDINT;
	vpq_xLogDataScrollDown      : BOOL;
	vpq_astLogDataTableAscii    : ARRAY[1..12] OF TPL.ST_LogDataAscii;
	vpq_astLogDataTable         : ARRAY[1..12] OF TPL.ST_LogData;
	udiIndex2                   : UDINT;
	udiIndex3                   : UDINT;
	
	(*Variables to change color of the DiagQuit button*)
	vpq_dwDiagQuitColor : DWORD;
	xRedColor           : BOOL;
	
	(* test exceptions *)
	stUserException1 : TPL.ST_Exception;
	stUserException2 : TPL.ST_Exception;
	stUserException3 : TPL.ST_Exception;
	stUserException4 : TPL.ST_Exception;
	stUserException5 : TPL.ST_Exception;
	
	(* copy of the ExceptionList *)
	fbCopyExceptionList  : TPL.FB_CopyExceptionList;
	astExceptionListCopy : ARRAY[1..TPL.Gc_udiMaxNumberOfExceptions] OF TPL.ST_Exception;
	
	vpiq_fbVisContExHandling : TPL.FB_VisControllerExceptionHandling;
	
	(* Additional FBs for other types of modules *)
	vpiq_fbAxisModuleVisController : AXM_FB_AxisModuleVisController;
	(* For the RoboticModule *)
	//vpiq_fbRoboticModuleVisController : RM.FB_RoboticModuleVisController;

	(* For the ExampleLeafModule *)
	vpiq_fbExampleLeafModuleVisController : FB_ExampleLeafModuleVisController;
	
	fbDetectOnlineChange        : TPL.FB_DetectOnlineChange;
	xDetectOnlineChangeActive   : BOOL;
	xDetectOnlineChangeReady    : BOOL;
	etDetectOnlineChangeDiag    : GD.ET_Diag;
	etDetectOnlineChangeDiagExt : TPL.ET_DiagExt;
	sDetectOnlineChangeMsg      : STRING[80];
	xUpdatePointer              : BOOL;
	fbLoggerPoint               : APL.FB_LoggerPoint;
	
	(* Highlight the currently active OpMode (VIS_AxisModule) *)
	v_diLastOpMode        : DINT;
	v_xHomeModeActive     : BOOL;
	v_xManualModeActive   : BOOL;
	v_xMultiCamCSActive   : BOOL;
	v_xMultiCamWSActive   : BOOL;
	v_xEndlessActive      : BOOL;
	v_xEndlessILSActive   : BOOL;
	v_xPositioningActive  : BOOL;
	v_xBrakeActive        : BOOL;
	v_xAdditionalCSActive : BOOL;
	v_xAdditionalWSActive : BOOL;
END_VAR
__IMPLEMENTATION__
(* Make sure that after an online-change, the main machine program has been executed
   before you update the pointers in the VisControl. *)

fbDetectOnlineChange(	i_xEnable	:= TRUE, 
						i_xDetect	:= TRUE, 
						q_xActive	=> xDetectOnlineChangeActive, 
						q_xReady	=> xDetectOnlineChangeReady, 
						q_etDiag	=> etDetectOnlineChangeDiag, 
						q_etDiagExt	=> etDetectOnlineChangeDiagExt, 
						q_sMsg		=> sDetectOnlineChangeMsg, 
						q_xChange	=> );
							
IF fbDetectOnlineChange.q_xChange THEN
	xUpdatePointer := TRUE;
	RETURN;
END_IF

IF G_xDoEnableVis THEN
	IF SR_MainMachine.stMachineInterface.q_xActive AND (iDoEnableCycleCounter < 3) THEN
		(* Wait until main machine ist active, otherwise some module vis
		controllers would read a wrong module structure. *)

		iDoEnableCycleCounter := iDoEnableCycleCounter + 1;
		IF iDoEnableCycleCounter >= 3 THEN
			(* This also assures, that all values and structures are initialized
			by the main machine when this task tries to access them. *)
			vpq_xDoEnable := TRUE;
		END_IF
	END_IF
ELSE
	vpq_xDoEnable := FALSE;
	
	iDoEnableCycleCounter := 0;
END_IF
;

IF vpq_xDoEnable AND NOT xEnableFlag THEN
	xEnableFlag := TRUE;
	
	(* Initialize navigation *)
	pstCurrentParent          := 0;
	pstCurrent                := ADR(SR_MainMachine.stMachineInterface);
	udiCurrentLevel           := 1;
	udiCurrentLevelSize       := 1;
	audiHierarchy[1]          := 1;
	xCurrentHasSubModules     := (pstCurrent^.iq_stExt.udiNumberOfSubModules > 0);
	xCurrentHasControlModules := (pstCurrent^.iq_stExt.udiNumberOfControlModules > 0);
	xPointerExceptionActive   := FALSE;
	xUpdateData               := TRUE;
	udiMinModuleList          := 1;
	udiMinSubModuleList       := 1;
	udiCurrentLevel3Size      := 0;
	vpiq_axModuleList         := axClearBoolA5;
	vpiq_axSubModuleList      := axClearBoolA5;
	
	udiCurrentNumberOfControlModules := 0;
	udiNumberOfControlModulesLevel2  := 0;
	udiControlModuleSelectedInLevel  := 0;
	vpq_udiActiveControlModuleNumber := 0;
	
	(* init test exceptions *)
	vpq_stMachineInterface := SR_MainMachine.stMachineInterface; (* required *)
	
	InitTestExceptions();
	
	vpq_xCurrentIsJogTarget := FALSE;
	
	fbLoggerPoint.RegisterLoggerPoint(
		i_ifParent  := APL.G_ifApplicationLogger,
		i_sName     := 'VisControl',
		i_sType     := 'SR_VisControl',
		i_sSource   := 'Project',
		q_etDiag    =>,
		q_etDiagExt => );
	iState := 10;
	
ELSIF NOT vpq_xDoEnable AND xEnableFlag THEN
	xEnableFlag := FALSE;
	
	G_xPrepareActive      := FALSE;
	G_xAutoActive         := FALSE;
	G_xManualActive       := FALSE;
	G_xJogMachineActive   := FALSE;
	G_xBrakeReleaseActive := FALSE;
	
	iState := 5;
END_IF

CASE iState OF
	
	0:
		iState := 5;
	5:
		;
	10:
		
		OpModeControl();
		
		(* Copy the machine interface into local variable, the local variable is read by the vis *)
		vpq_stMachineInterface := SR_MainMachine.stMachineInterface;
		
		vpq_xMachineInException := G_stExceptionList.udiNumberOfActiveExceptions > 0;
		
		vpq_etMainModuleControllerDiag    := SR_MainMachine.fbModuleController.q_etDiag;
		vpq_etMainModuleControllerDiagExt := SR_MainMachine.fbModuleController.q_etDiagExt;
		vpq_sMainModuleControllerMsg      := SR_MainMachine.fbModuleController.q_sMsg;
		
		MainPageCmdTable();
		
		ExceptionVis();
		
		LoggerVis();
		
		IF (G_xDiagQuitEpas AND xPointerExceptionActive) THEN
			xPointerExceptionActive := FALSE;
			
			udiCurrentLevel                   := 1;
			audiHierarchy[udiCurrentLevel]    := 1;
			udiCurrentLevelSize               := 1;
			xUpdateData                       := TRUE;
			vpiq_xButtonSetCurrentAsJogTarget := FALSE;
		END_IF
		
		IF (NOT xPointerExceptionActive) THEN
			
			ModuleNavigationIn();
			
			IF (xUpdateData OR xUpdatePointer) THEN
				xUpdateData    := FALSE;
				xUpdatePointer := FALSE;
				
				xUpdateForOtherFBs := TRUE;
				
				(* Select current module *)
				SearchCurrentModule();
				
				ModuleNavigationOut();
				
			END_IF (* xUpdateData *)
			
			ModuleReaction();
			
			(* Cyclic reading of values from the structures *)
			IF pstCurrent <> 0 THEN (* Security check *)
				
				(* Execute user inputs first *)
				IF (vpiq_xEnableModuleClicked) THEN
					vpiq_xEnableModuleClicked := FALSE;
					pstCurrent^.i_xEnable     := NOT pstCurrent^.i_xEnable;
				END_IF
				
				IF (vpiq_xSetCmdClicked) THEN
					vpiq_xSetCmdClicked        := FALSE;
					pstCurrent^.iq_diCmd       := vpiq_diCmdToSet;
					pstCurrent^.iq_diStartStep := vpiq_diStartStepToSet;
				END_IF
				
				IF (xDiagQuit_Touch) THEN
					xDiagQuit_WasTouched    := TRUE;
					pstCurrent^.i_xDiagQuit := TRUE;
				ELSIF (xDiagQuit_WasTouched) THEN
					xDiagQuit_WasTouched    := FALSE;
					pstCurrent^.i_xDiagQuit := FALSE;
				END_IF
				
				vpq_stCurrentModuleStandardInterface := pstCurrent^;
				
				(* If the current module is not selected as target for the jogForw, jogBack Buttons *)
				vpq_xCurrentIsJogTarget :=
					(vpq_stCurrentModuleStandardInterface.i_udiModuleId = SR_MainMachine.stMachineMotionInterface.i_udiModuleSelect);
				
				(* this detects a change of the current module ==> the user has navigated to a different module.
				To avoid that the old and no longer visible module is jogged further, delete the jog target *)
				IFB_FTrigxCurrentIsJogTarget(CLK := vpq_xCurrentIsJogTarget);
				IF IFB_FTrigxCurrentIsJogTarget.Q THEN
					G_udiManualModuleSelect := 0; (*No Module can be jogged unintentionally*)
				END_IF
				
			ELSE
				vpq_stCurrentModuleStandardInterface := stDummyStandardInterface;
				udiCurrentLevelSize                  := 0;
				xCurrentHasSubModules                := FALSE;
				udiCurrentLevel                      := 1;
				xUpdateData                          := TRUE;
				vpq_xCurrentIsJogTarget              := FALSE;
			END_IF
			
			IF pstCurrentControlModuleStandardInterface <> 0 AND vpq_udiActiveControlModuleNumber > 0 THEN
				pstTempCtrlModule :=
					pstCurrentControlModuleStandardInterface +
					UDINT_TO_DWORD((vpq_udiActiveControlModuleNumber - 1) * SIZEOF(pstCurrentControlModuleStandardInterface^));
				stCurrentControlModuleStandardInterface := pstTempCtrlModule^;
			ELSE
				stCurrentControlModuleStandardInterface.udiControlModuleNumber := 0;
				stCurrentControlModuleStandardInterface.udiControlModuleType   := 0;
				stCurrentControlModuleStandardInterface.dwControlModuleAddItf  := 0;
				stCurrentControlModuleStandardInterface.sControlModuleName     := '';
			END_IF
			
			vpq_xButtonSetJogTargetInvisible := NOT SR_MainMachine.xOutputManualActive;
			
			(* Select the current module as target for the jogging *)
			IF (SR_MainMachine.xOutputManualActive) THEN
				(* Check whether we are really in jog mode *)
				IF (vpiq_xButtonSetCurrentAsJogTarget) THEN
					G_udiManualModuleSelect := vpq_stCurrentModuleStandardInterface.i_udiModuleId;
				END_IF
			END_IF
			
			vpiq_xButtonSetCurrentAsJogTarget := FALSE;
			
			(* generate additional output for the frame FR_CurrentModule *)
			vpq_sCurrentModuleReaction := TPL.FC_ReactionToString(iq_stReaction := vpq_stCurrentModuleStandardInterface.i_stReaction);
			
			CurrentModuleCmdTable();
		END_IF (* xPointerExceptionActive *)
		(****************************************************************************************************************************************************)
END_CASE

IF (NOT xPointerExceptionActive) THEN
	(* point to call additional visualization controllers *)

	(* from Vis_ActiveExceptionList to Vis_ExceptionDetails *)
	IF (vpiq_udiExceptionListGoToDetailsOfLine <> 0) THEN
		IF (vpiq_udiExceptionListGoToDetailsOfLine > 0 AND vpiq_udiExceptionListGoToDetailsOfLine <= 10) THEN
			udiExceptionListDetailsSelectIndex := vpiq_udiExceptionListIndexMin + vpiq_udiExceptionListGoToDetailsOfLine - 1;
		END_IF
		vpiq_udiExceptionListGoToDetailsOfLine := 0;
	END_IF
	
	(* exception handling *)
	vpiq_fbVisContExHandling(
		i_xEnable                         := vpq_xDoEnable,
		i_pstMachineStandardItf           := ADR(SR_MainMachine.stMachineInterface),
		i_pstCurrentStandardItf           := pstCurrent,
		i_xUpdateData                     := xUpdateForOtherFBs,
		i_udiNumberOfExceptions           := vpq_udiNumberOfExceptions,
		iq_stExceptionList                := G_stExceptionList,
		iq_stLogDataList                  := G_stLogDataList,
		iq_astExceptionListCopy           := astExceptionListCopy,
		iq_udiExceptionDetailsSelectIndex := udiExceptionListDetailsSelectIndex,
		q_udiSetAsCurrentModule           => udiSetAsCurrentModule);
	
	SetCurrentModule();
	
	(* module specific vis controllers are called inside this action *)
	ModuleVisController();
	
	(* End of area for vis control fbs of different module types *)
	xUpdateForOtherFBs := FALSE;
END_IF

(* Detect change of OpMode for AxisModule *)
DetectOpModeChange();
