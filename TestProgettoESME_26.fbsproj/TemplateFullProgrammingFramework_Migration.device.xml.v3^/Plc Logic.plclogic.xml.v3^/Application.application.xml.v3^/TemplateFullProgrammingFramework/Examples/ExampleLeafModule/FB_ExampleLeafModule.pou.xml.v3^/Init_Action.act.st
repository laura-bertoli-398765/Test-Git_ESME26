__METADATA__
{
  "v3Meta": {
    "objectGuid": "c75349dd-69ff-4dea-bd94-257497dca491",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
iq_stStandardModuleItf.q_xActive			:= FALSE;
iq_stStandardModuleItf.q_xReady				:= FALSE;

iq_stStandardModuleItf.q_etDiag				:= GD.ET_Diag.Ok;
iq_stStandardModuleItf.q_udiDiagExt			:= ET_DiagExtExampleLeafModule.Disabled;
iq_stStandardModuleItf.q_sDiagExt			:= FC_EtDiagExtExampleLeafModuleToString(i_etDiagExt := iq_stStandardModuleItf.q_udiDiagExt);
iq_stStandardModuleItf.q_sMsg				:= '';

iq_stStandardModuleItf.q_dwModuleType		:= ET_ModuleType.ExampleLeafModule;
iq_stStandardModuleItf.q_sModuleTypeName	:= 'ExampleLeafModule';
iq_stStandardModuleItf.q_udiModuleVersion	:= 1;

iq_stExampleLeafModuleItf.q_etState	:= ET_ExampleLeafModuleState.Disabled;

THIS^.DiagQuit();
THIS^.InactiveCmdExecution();

udiMyResultSource := ET_ExceptionSource.ExampleLeafModule; (* Has to be coded this way to get around compiler restrictions*)

(* detect invalid configurations and avoid array index out of range error *)
IF(iq_stStandardModuleItf.iq_stExt.udiReactionOffset + TPL.ET_Reaction.MainsContactorOff > TPL.Gc_udiMaxNumberOfReactions) OR xExceptionReactionOutsideRange THEN (* module uses error reactions 1 to 5 *)
	xExceptionReactionOutsideRange := TRUE; (* create unquittable error *)
	
	(* create exception *)
	stExceptionInit.etDiag					:= GD.ET_Diag.InputParameterInvalid;
	stExceptionInit.udiDiagExt				:= ET_DiagExtExampleLeafModule.ReactionOffsetRange;
	stExceptionInit.sMsg					:= Standard.CONCAT('Value: ', UDINT_TO_STRING(iq_stStandardModuleItf.iq_stExt.udiReactionOffset));
	stExceptionInit.udiModuleId				:= iq_stStandardModuleItf.i_udiModuleId;
	stExceptionInit.sModuleName				:= iq_stStandardModuleItf.i_sModuleName;
	stExceptionInit.etSource				:= udiMyResultSource;
	stExceptionInit.timDelayTime			:= T#0MS;
	stExceptionInit.wHmiAttributes			:= 0;
	stExceptionInit.xAutoQuit				:= FALSE;
	stExceptionInit.stReaction.axReaction[TPL.ET_Reaction.AsyncStop]	:= TRUE; (* without offset on purpose *)
	
	iq_stStandardModuleItf.iq_stExt.udiReactionOffset := 0;
	
	ReportException(iq_stException := stExceptionInit);
ELSIF (iq_stStandardModuleItf.i_xEnable) THEN
	stReaction1 := stEmptyReaction;
	stReaction1.axReaction[iq_stStandardModuleItf.iq_stExt.udiReactionOffset + TPL.ET_Reaction.AsyncStop] := TRUE;
	stReaction2 := stEmptyReaction;
	stReaction2.axReaction[iq_stStandardModuleItf.iq_stExt.udiReactionOffset + TPL.ET_Reaction.SyncStopEL] := TRUE;
	stReaction3 := stEmptyReaction;
	stReaction3.axReaction[iq_stStandardModuleItf.iq_stExt.udiReactionOffset + TPL.ET_Reaction.SyncStopEH] := TRUE;
	stReaction4 := stEmptyReaction;
	stReaction4.axReaction[iq_stStandardModuleItf.iq_stExt.udiReactionOffset + TPL.ET_Reaction.StopEndOfCycle] := TRUE;
	
	(* Initialization of exception structures *)
	stExceptionCmdUnknown.etDiag						:= GD.ET_Diag.ExecutionAborted;
	stExceptionCmdUnknown.udiDiagExt					:= ET_DiagExtExampleLeafModule.CmdUnknown;
	stExceptionCmdUnknown.sMsg							:= 'Command unknown'; (* Replaced on usage *)
	stExceptionCmdUnknown.udiModuleId					:= iq_stStandardModuleItf.i_udiModuleId;
	stExceptionCmdUnknown.sModuleName					:= iq_stStandardModuleItf.i_sModuleName;
	stExceptionCmdUnknown.etSource						:= udiMyResultSource;
	stExceptionCmdUnknown.timDelayTime					:= T#0MS;
	stExceptionCmdUnknown.wHmiAttributes				:= 0;
	stExceptionCmdUnknown.xAutoQuit						:= FALSE;
	stExceptionCmdUnknown.stReaction					:= stReaction1;

	stExceptionCmdImpossibleOverwrite.etDiag			:= GD.ET_Diag.ExecutionAborted;
	stExceptionCmdImpossibleOverwrite.udiDiagExt		:= ET_DiagExtExampleLeafModule.CmdImpossibleOverwrite;
	stExceptionCmdImpossibleOverwrite.sMsg				:= 'Impossible command overwrite'; (* Replaced on usage *)
	stExceptionCmdImpossibleOverwrite.udiModuleId		:= iq_stStandardModuleItf.i_udiModuleId;
	stExceptionCmdImpossibleOverwrite.sModuleName		:= iq_stStandardModuleItf.i_sModuleName;
	stExceptionCmdImpossibleOverwrite.etSource			:= udiMyResultSource;
	stExceptionCmdImpossibleOverwrite.timDelayTime		:= T#0MS;
	stExceptionCmdImpossibleOverwrite.wHmiAttributes	:= 0;
	stExceptionCmdImpossibleOverwrite.xAutoQuit			:= FALSE;
	stExceptionCmdImpossibleOverwrite.stReaction		:= stReaction1;
	
	stExceptionCmdImpossibleState.etDiag				:= GD.ET_Diag.ExecutionAborted;
	stExceptionCmdImpossibleState.udiDiagExt			:= ET_DiagExtExampleLeafModule.CmdImpossibleState;
	stExceptionCmdImpossibleState.sMsg					:= 'Impossible command for state'; (* Replaced on usage *)
	stExceptionCmdImpossibleState.udiModuleId			:= iq_stStandardModuleItf.i_udiModuleId;
	stExceptionCmdImpossibleState.sModuleName			:= iq_stStandardModuleItf.i_sModuleName;
	stExceptionCmdImpossibleState.etSource				:= udiMyResultSource;
	stExceptionCmdImpossibleState.timDelayTime			:= T#0MS;
	stExceptionCmdImpossibleState.wHmiAttributes		:= 0;
	stExceptionCmdImpossibleState.xAutoQuit				:= FALSE;
	stExceptionCmdImpossibleState.stReaction			:= stReaction1;

	stWarningCmdImpossibleReaction.etDiag				:= GD.ET_Diag.ExecutionAborted;
	stWarningCmdImpossibleReaction.udiDiagExt			:= ET_DiagExtExampleLeafModule.CmdImpossibleReaction;
	stWarningCmdImpossibleReaction.sMsg					:= 'Impossible command on reaction'; (* Replaced on usage *)
	stWarningCmdImpossibleReaction.udiModuleId			:= iq_stStandardModuleItf.i_udiModuleId;
	stWarningCmdImpossibleReaction.sModuleName			:= iq_stStandardModuleItf.i_sModuleName;
	stWarningCmdImpossibleReaction.etSource				:= udiMyResultSource;
	stWarningCmdImpossibleReaction.timDelayTime			:= T#0MS;
	stWarningCmdImpossibleReaction.wHmiAttributes		:= 0;
	stWarningCmdImpossibleReaction.xAutoQuit			:= FALSE;
	
	stExceptionModuleReaction1.etDiag					:= GD.ET_Diag.InputParameterInvalid;(* Replaced on usage *)
	stExceptionModuleReaction1.udiDiagExt				:= ET_DiagExtExampleLeafModule.Ok;(* Replaced on usage *)
	stExceptionModuleReaction1.sMsg						:= '';(* Replaced on usage *)
	stExceptionModuleReaction1.udiModuleId				:= iq_stStandardModuleItf.i_udiModuleId;
	stExceptionModuleReaction1.sModuleName				:= iq_stStandardModuleItf.i_sModuleName;
	stExceptionModuleReaction1.etSource					:= udiMyResultSource;
	stExceptionModuleReaction1.timDelayTime				:= T#0MS;
	stExceptionModuleReaction1.wHmiAttributes			:= 0;
	stExceptionModuleReaction1.xAutoQuit				:= FALSE;
	stExceptionModuleReaction1.stReaction				:= stReaction1;

	stExceptionModuleReaction2.etDiag					:= GD.ET_Diag.InputParameterInvalid;(* Replaced on usage *)
	stExceptionModuleReaction2.udiDiagExt				:= ET_DiagExtExampleLeafModule.Ok;(* Replaced on usage *)
	stExceptionModuleReaction2.sMsg						:= '';(* Replaced on usage *)
	stExceptionModuleReaction2.udiModuleId				:= iq_stStandardModuleItf.i_udiModuleId;
	stExceptionModuleReaction2.sModuleName				:= iq_stStandardModuleItf.i_sModuleName;
	stExceptionModuleReaction2.etSource					:= udiMyResultSource;
	stExceptionModuleReaction2.timDelayTime				:= T#0MS;
	stExceptionModuleReaction2.wHmiAttributes			:= 0;
	stExceptionModuleReaction2.xAutoQuit				:= FALSE;
	stExceptionModuleReaction2.stReaction				:= stReaction2;

	stExceptionModuleReaction3.etDiag					:= GD.ET_Diag.InputParameterInvalid;(* Replaced on usage *)
	stExceptionModuleReaction3.udiDiagExt				:= ET_DiagExtExampleLeafModule.Ok;(* Replaced on usage *)
	stExceptionModuleReaction3.sMsg						:= '';(* Replaced on usage *)
	stExceptionModuleReaction3.udiModuleId				:= iq_stStandardModuleItf.i_udiModuleId;
	stExceptionModuleReaction3.sModuleName				:= iq_stStandardModuleItf.i_sModuleName;
	stExceptionModuleReaction3.etSource					:= udiMyResultSource;
	stExceptionModuleReaction3.timDelayTime				:= T#0MS;
	stExceptionModuleReaction3.wHmiAttributes			:= 0;
	stExceptionModuleReaction3.xAutoQuit				:= FALSE;
	stExceptionModuleReaction3.stReaction				:= stReaction3;

	stExceptionModuleReaction4.etDiag					:= GD.ET_Diag.InputParameterInvalid;(* Replaced on usage *)
	stExceptionModuleReaction4.udiDiagExt				:= ET_DiagExtExampleLeafModule.Ok;(* Replaced on usage *)
	stExceptionModuleReaction4.sMsg						:= '';(* Replaced on usage *)
	stExceptionModuleReaction4.udiModuleId				:= iq_stStandardModuleItf.i_udiModuleId;
	stExceptionModuleReaction4.sModuleName				:= iq_stStandardModuleItf.i_sModuleName;
	stExceptionModuleReaction4.etSource					:= udiMyResultSource;
	stExceptionModuleReaction4.timDelayTime				:= T#0MS;
	stExceptionModuleReaction4.wHmiAttributes			:= 0;
	stExceptionModuleReaction4.xAutoQuit				:= FALSE;
	stExceptionModuleReaction4.stReaction				:= stReaction4;
	
	stExceptionDriveFatal.etDiag						:= GD.ET_Diag.DriveConditionInvalid;
	stExceptionDriveFatal.udiDiagExt					:= ET_DiagExtExampleLeafModule.DriveFatalException;
	stExceptionDriveFatal.sMsg							:= 'Drive diag'; (* Replaced on usage *)
	stExceptionDriveFatal.udiModuleId					:= iq_stStandardModuleItf.i_udiModuleId;
	stExceptionDriveFatal.sModuleName					:= iq_stStandardModuleItf.i_sModuleName;
	stExceptionDriveFatal.etSource						:= udiMyResultSource;
	stExceptionDriveFatal.timDelayTime					:= T#0MS;
	stExceptionDriveFatal.wHmiAttributes				:= 0;
	stExceptionDriveFatal.xAutoQuit						:= FALSE;
	stExceptionDriveFatal.stReaction					:= stReaction1;
	
	stExcepitonDrive.etDiag								:= GD.ET_Diag.DriveConditionInvalid;
	stExcepitonDrive.udiDiagExt							:= ET_DiagExtExampleLeafModule.DriveException;
	stExcepitonDrive.sMsg								:= 'Drive diag'; (* Replaced on usage *)
	stExcepitonDrive.udiModuleId						:= iq_stStandardModuleItf.i_udiModuleId;
	stExcepitonDrive.sModuleName						:= iq_stStandardModuleItf.i_sModuleName;
	stExcepitonDrive.etSource							:= udiMyResultSource;
	stExcepitonDrive.timDelayTime						:= T#0MS;
	stExcepitonDrive.wHmiAttributes						:= 0;
	stExcepitonDrive.xAutoQuit							:= FALSE;
	stExcepitonDrive.stReaction							:= stReaction2;

	stWarningDrive.etDiag								:= GD.ET_Diag.DriveConditionInvalid;
	stWarningDrive.udiDiagExt							:= ET_DiagExtExampleLeafModule.DriveWarning;
	stWarningDrive.sMsg									:= 'Drive warning'; (* Replaced on usage *)
	stWarningDrive.udiModuleId							:= iq_stStandardModuleItf.i_udiModuleId;
	stWarningDrive.sModuleName							:= iq_stStandardModuleItf.i_sModuleName;
	stWarningDrive.etSource								:= udiMyResultSource;
	stWarningDrive.timDelayTime							:= T#0MS;
	stWarningDrive.wHmiAttributes						:= 0;
	stWarningDrive.xAutoQuit							:= FALSE;
	stWarningDrive.stReaction							:= stReaction4;

	stExceptionInit.etDiag								:= GD.ET_Diag.InputParameterInvalid; (* Replaced on usage *)
	stExceptionInit.udiDiagExt							:= ET_DiagExtExampleLeafModule.Ok; (* Replaced on usage *)
	stExceptionInit.sMsg								:= ''; (* Replaced on usage *)
	stExceptionInit.udiModuleId							:= iq_stStandardModuleItf.i_udiModuleId;
	stExceptionInit.sModuleName							:= iq_stStandardModuleItf.i_sModuleName;
	stExceptionInit.etSource							:= udiMyResultSource;
	stExceptionInit.timDelayTime						:= T#0MS;
	stExceptionInit.wHmiAttributes						:= 0;
	stExceptionInit.xAutoQuit							:= FALSE;
	stExceptionInit.stReaction							:= stReaction1;
	
	stExceptionHoming.etDiag							:= GD.ET_Diag.HomingFailed;
	stExceptionHoming.udiDiagExt						:= ET_DiagExtExampleLeafModule.RandomException;
	stExceptionHoming.sMsg								:= '';
	stExceptionHoming.udiModuleId						:= iq_stStandardModuleItf.i_udiModuleId;
	stExceptionHoming.sModuleName						:= iq_stStandardModuleItf.i_sModuleName;
	stExceptionHoming.etSource							:= udiMyResultSource;
	stExceptionHoming.timDelayTime						:= T#0MS;
	stExceptionHoming.wHmiAttributes					:= 0;
	stExceptionHoming.xAutoQuit							:= FALSE;
	stExceptionHoming.stReaction						:= stReaction4;

	IF (iq_stExampleLeafModuleItf.i_ifDrive = 0) THEN
		stExceptionModuleReaction1.etDiag		:= GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction1.udiDiagExt	:= ET_DiagExtExampleLeafModule.DriveInvalid;
		stExceptionModuleReaction1.sMsg			:= 'No drive given';
		
		ReportException(iq_stException := stExceptionModuleReaction1);
	ELSE
		xEnableFlag := TRUE;
		iq_stStandardModuleItf.q_xActive := TRUE;
		
		FOR udii := 1 TO TPL.Gc_udiMaxNumberOfReactions DO
			stLocalReaction.axReaction[udii] := FALSE;
		END_FOR
		
		xInitHomingDone := FALSE;
		
		iq_stExampleLeafModuleItf.q_etState := ET_ExampleLeafModuleState.Initializing;
		
		iq_stStandardModuleItf.q_etDiag		:= GD.ET_Diag.Ok;
		iq_stStandardModuleItf.q_udiDiagExt	:= ET_DiagExtExampleLeafModule.Initializing;
		iq_stStandardModuleItf.q_sDiagExt	:= FC_EtDiagExtExampleLeafModuleToString(ET_DiagExtExampleLeafModule.Initializing);
		iq_stStandardModuleItf.q_sMsg		:= '';
		
		IF fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.UserAction THEN
			fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
										i_etDiag		:= GD.ET_Diag.Ok,
										i_udiDiagExt	:= ET_DiagExtExampleLeafModule.Ok,
										i_sMessage		:= 'enabeling Module',
										q_etDiag		:= ,
										q_etDiagExt		:= );
		END_IF
	END_IF

END_IF

THIS^.SetOutputs();
