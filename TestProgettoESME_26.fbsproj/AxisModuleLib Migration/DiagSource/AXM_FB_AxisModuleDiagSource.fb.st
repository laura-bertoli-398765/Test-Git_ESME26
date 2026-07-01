__METADATA__
{
  "v3Meta": {
    "objectGuid": "c4d1a6d0-b0ae-4279-8dcf-1e075a7607bc",
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
FUNCTION_BLOCK PUBLIC AXM_FB_AxisModuleDiagSource
VAR_INPUT
	i_xEnable			: BOOL;
	i_xDiagQuit			: BOOL;
	i_xPrintCamData		: BOOL := TRUE;
END_VAR
VAR_IN_OUT
	iq_stComStructure	: TPL.ST_DiagnosticsManagerToDiagSource;
	iq_stMachineItf		: TPL.ST_StandardModuleInterface;
END_VAR
VAR_OUTPUT
	q_xActive			: BOOL;
	q_xReady			: BOOL;
	q_etDiag			: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt			: AXM_ET_DiagExt := AXM_ET_DiagExt.Disabled;
	q_sMsg				: STRING[80];
END_VAR
VAR
	xEnableFlag		: BOOL;
	diState			: DINT;
	udiOwnSourceId	: UDINT := 0;
	fbTreeWriter	: TPL.FB_TreeWriter;
	diOldCmd		: DINT := 0;
	diCmdExecState	: DINT := 0;
	lrSumNodes		: LREAL := 1;
	pstTmp			: POINTER TO TPL.ST_StandardModuleInterface;
	audiHierarchy	: ARRAY[1..c_udiMaxLevel] OF UDINT;
	udiLevelCounter	: UDINT := 1;
	apstHierarchy	: ARRAY[1..c_udiMaxLevel] OF POINTER TO TPL.ST_StandardModuleInterface;
	xLoop			: BOOL;
	pstInterface	: POINTER TO AXM_ST_ModuleInterface;
	pdw				: POINTER TO TPL.TYPE_ADDRESS;
	sTmp			: STRING[80];
	diMotionParCounter	: DINT;
	diCamPointCounter	: DINT;
	diCount			: DINT;
	pstChar			: POINTER TO STRING;
	sModuleMain		: STRING[80];
	sModuleName		: STRING;
	diLoopBreaker	: DINT;
	etDiag			: GD.ET_Diag;
	etDiagExtTPL	: TPL.ET_DiagExt;
	sMsg			: STRING[80];
	rtrigDiagQuit	: Standard.R_TRIG;
END_VAR
VAR CONSTANT
	c_sName			: STRING[TPL.Gc_udiTableWriterMaxNameLength] := 'AxisModule_Interface' ;
	c_sTypeName		: STRING[TPL.Gc_udiTableWriterMaxNameLength] := 'AXM_Interface' ;
	c_udiMaxLevel	: UDINT := 8;
END_VAR
__IMPLEMENTATION__
IF i_xEnable AND NOT xEnableFlag THEN
	xEnableFlag := TRUE;
	
	q_xActive := TRUE;
	
	SetDiagOutputs(	i_etDiag	:= GD.ET_Diag.Ok,
					i_etDiagExt	:= AXM_ET_DiagExt.WaitUntilDiagnosticsManagerReady,
					i_sMsg		:= '');	
	diState := 10;
	
ELSIF NOT i_xEnable AND xEnableFlag THEN
	xEnableFlag := FALSE;
		
	IF udiOwnSourceId <> 0 THEN		
		SetDiagOutputs(	i_etDiag	:= GD.ET_Diag.Ok,
						i_etDiagExt	:= AXM_ET_DiagExt.WaitUntilDisabled,
						i_sMsg		:= '');
		diState := 100;
		
	ELSIF udiOwnSourceId = 0 THEN		
		SetDiagOutputs(	i_etDiag	:= GD.ET_Diag.Ok,
						i_etDiagExt	:= AXM_ET_DiagExt.Disabled,
						i_sMsg		:= '');
	END_IF
END_IF

DiagQuit();

CASE diState OF
	
	0:	(* Disable & exception state *)
	
	10:	(* Wait until diagnostics manager ready *)
		IF iq_stComStructure.i_xDiagnosticsManagerReady THEN
			
			SetDiagOutputs(	i_etDiag	:= GD.ET_Diag.Ok,
							i_etDiagExt	:= AXM_ET_DiagExt.WaitUntilDiagSourceRegistered,
							i_sMsg		:= '');
			diState := 20;
		END_IF

	20:	(* Wait until diag source registered *)	
		IF NOT iq_stComStructure.i_xDiagnosticsManagerReady THEN
			
			SetDiagOutputs(	i_etDiag	:= GD.ET_Diag.Ok,
							i_etDiagExt	:= AXM_ET_DiagExt.WaitUntilDiagnosticsManagerReady,
							i_sMsg		:= '');	
			diState := 10;
			RETURN;
	
		(* only write to register structure if no one else has done it in this cylce *)
		ELSIF (NOT iq_stComStructure.iq_stRegister.xUsed AND iq_stComStructure.iq_stRegister.udiNextId <> 0) THEN
			(* register *)
			iq_stComStructure.iq_stRegister.xUsed := TRUE;
			
			iq_stComStructure.iq_stRegister.sName		:= c_sName;
			iq_stComStructure.iq_stRegister.sTypeName	:= c_sTypeName;
			
			udiOwnSourceId := iq_stComStructure.iq_stRegister.udiNextId; (* register with this id; required for the following communication *)
		ELSE
			RETURN;
		END_IF
		
		q_xReady := TRUE;
		
		SetDiagOutputs(	i_etDiag	:= GD.ET_Diag.Ok,
						i_etDiagExt	:= AXM_ET_DiagExt.WaitForCommunication,
						i_sMsg		:= '');
		diState := 30;
	
	30:	(* Wait for communication *)	
		IF NOT iq_stComStructure.i_xDiagnosticsManagerReady THEN

			CancelWriting();
									
			udiOwnSourceId	:= 0;
			
			SetDiagOutputs(	i_etDiag	:= GD.ET_Diag.Ok,
							i_etDiagExt	:= AXM_ET_DiagExt.WaitUntilDiagnosticsManagerReady,
							i_sMsg		:= '');	
			diState := 10;
			RETURN;
			
		ELSIF (iq_stComStructure.i_udiComWithId = udiOwnSourceId) THEN		(* Am I adressed? *)
			
			WriteDiagDataControl();

		ELSE
			iq_stComStructure.q_lrProgress := 0.0;
			
			CancelWriting();
						
			SetDiagOutputs(	i_etDiag	:= GD.ET_Diag.Ok,
							i_etDiagExt	:= AXM_ET_DiagExt.WaitForCommunication,
							i_sMsg		:= '');
		END_IF
		
	100: (* Wait until disabled *)	
		IF NOT iq_stComStructure.i_xDiagnosticsManagerReady THEN

			CancelWriting();
									
			udiOwnSourceId	:= 0;
			
			SetDiagOutputs(	i_etDiag	:= GD.ET_Diag.Ok,
							i_etDiagExt	:= AXM_ET_DiagExt.Disabled,
							i_sMsg		:= '');	
	
		ELSIF (iq_stComStructure.i_udiComWithId = udiOwnSourceId) THEN		(* Am I adressed? *)
			
			WriteDiagDataControl();
			
		(* only write to register structure if no one else has done it in this cylce *)
		ELSIF (NOT iq_stComStructure.iq_stRegister.xUsed AND NOT iq_stComStructure.iq_stRegister.xUnsubscribe) AND 
			   NOT iq_stComStructure.i_xDiagnosticsActive THEN
			   
			iq_stComStructure.iq_stRegister.xUsed			:= TRUE;
			
			iq_stComStructure.iq_stRegister.xUnsubscribe	:= TRUE;
			iq_stComStructure.iq_stRegister.udiSourceId		:= udiOwnSourceId;
			
			q_xActive := FALSE;
			
			SetDiagOutputs(	i_etDiag	:= GD.ET_Diag.Ok,
							i_etDiagExt	:= AXM_ET_DiagExt.Disabled,
							i_sMsg		:= '');
		END_IF
END_CASE

IF q_xActive THEN	
	IF(diCmdExecState <> 0) THEN
		WriteDiagDataToFile();
		
		IF(iq_stComStructure.iq_diCmd <= 0) THEN
			diOldCmd := iq_stComStructure.iq_diCmd;
		END_IF
	END_IF	
END_IF
	
