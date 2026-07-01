__METADATA__
{
  "v3Meta": {
    "objectGuid": "69b50c4f-ccd9-4e4c-9e6b-4dd6af3a59ff",
    "objectTypeGuid": "f8a58466-d7f6-439f-bbb8-d4600e41d099",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__DECLARATION__
METHOD SetOutputs
VAR_INPUT
END_VAR
__IMPLEMENTATION__
IF xNotAbleToSetException THEN
	; (* Do nothing. Diag outputs show not reportable exception *)
	iq_stStandardModuleItf.q_xReady := FALSE;
ELSIF stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop] THEN
	iq_stStandardModuleItf.q_etDiag := GD.ET_Diag.ExecutionAborted;
	iq_stStandardModuleItf.q_udiDiagExt := ET_DiagExtExampleLeafModule.AsyncStop;
	iq_stStandardModuleItf.q_sDiagExt := 'AsyncStop';
	iq_stStandardModuleItf.q_sMsg := '';
	
	iq_stStandardModuleItf.q_xReady := FALSE;
ELSIF stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL] THEN
	iq_stStandardModuleItf.q_etDiag := GD.ET_Diag.ExecutionAborted;
	iq_stStandardModuleItf.q_udiDiagExt := ET_DiagExtExampleLeafModule.SyncStopEL;
	iq_stStandardModuleItf.q_sDiagExt := 'SyncStopEL';
	iq_stStandardModuleItf.q_sMsg := '';
	
	iq_stStandardModuleItf.q_xReady := FALSE;
ELSIF stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH] THEN
	iq_stStandardModuleItf.q_etDiag := GD.ET_Diag.ExecutionAborted;
	iq_stStandardModuleItf.q_udiDiagExt := ET_DiagExtExampleLeafModule.SyncStopEH;
	iq_stStandardModuleItf.q_sDiagExt := 'SyncStopEH';
	iq_stStandardModuleItf.q_sMsg := '';
	
	iq_stStandardModuleItf.q_xReady := FALSE;
ELSIF stModuleReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle] THEN
	iq_stStandardModuleItf.q_etDiag := GD.ET_Diag.ExecutionAborted;
	iq_stStandardModuleItf.q_udiDiagExt := ET_DiagExtExampleLeafModule.StopEndOfCycle;
	iq_stStandardModuleItf.q_sDiagExt := 'StopEndOfCycle';
	iq_stStandardModuleItf.q_sMsg := '';
	
	iq_stStandardModuleItf.q_xReady := FALSE;
ELSE
	IF (iq_stExampleLeafModuleItf.q_etState <> ET_ExampleLeafModuleState.Disabled) AND
	   (iq_stExampleLeafModuleItf.q_etState <> ET_ExampleLeafModuleState.Initializing) THEN

		iq_stStandardModuleItf.q_xReady := TRUE;
	ELSE
		iq_stStandardModuleItf.q_xReady := FALSE;
	END_IF
		
	iq_stStandardModuleItf.q_etDiag := GD.ET_Diag.Ok;
	CASE iq_stExampleLeafModuleItf.q_etState OF
		ET_ExampleLeafModuleState.NoOp: 
			iq_stStandardModuleItf.q_udiDiagExt := ET_DiagExtExampleLeafModule.NoOp;
		ET_ExampleLeafModuleState.Disabled:
			iq_stStandardModuleItf.q_udiDiagExt := ET_DiagExtExampleLeafModule.Disabled;
		ET_ExampleLeafModuleState.Initializing:
			iq_stStandardModuleItf.q_udiDiagExt := ET_DiagExtExampleLeafModule.Initializing;
		ET_ExampleLeafModuleState.HomingWaitForStart:
			iq_stStandardModuleItf.q_udiDiagExt := ET_DiagExtExampleLeafModule.HomingWaitForStart;
		ET_ExampleLeafModuleState.HomingExecuting:
			iq_stStandardModuleItf.q_udiDiagExt := ET_DiagExtExampleLeafModule.HomingExecuting;
		ET_ExampleLeafModuleState.HomingDone:
			iq_stStandardModuleItf.q_udiDiagExt := ET_DiagExtExampleLeafModule.HomingDone;
		ET_ExampleLeafModuleState.AutoWaitForStart:
			iq_stStandardModuleItf.q_udiDiagExt := ET_DiagExtExampleLeafModule.AutoWaitForStart;
		ET_ExampleLeafModuleState.AutoRunning:
			iq_stStandardModuleItf.q_udiDiagExt := ET_DiagExtExampleLeafModule.AutoRunning;
	END_CASE
	iq_stStandardModuleItf.q_sDiagExt := FC_EtDiagExtExampleLeafModuleToString(i_etDiagExt := iq_stStandardModuleItf.q_udiDiagExt);
	iq_stStandardModuleItf.q_sMsg := '';
END_IF

IF fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.StatusMessage THEN
	IF (iq_stExampleLeafModuleItf.q_etState <> etStateOld) THEN
		fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.StatusMessage,
									i_etDiag		:= GD.ET_Diag.Ok,
									i_udiDiagExt	:= ET_DiagExtExampleLeafModule.Ok,
									i_sMessage		:= Standard.CONCAT('State changed to: ', FC_EtExampleLeafModuleStateToString(i_etState := iq_stExampleLeafModuleItf.q_etState)),
									q_etDiag		:= ,
									q_etDiagExt		:= );
	END_IF
	etStateOld := iq_stExampleLeafModuleItf.q_etState;
END_IF
