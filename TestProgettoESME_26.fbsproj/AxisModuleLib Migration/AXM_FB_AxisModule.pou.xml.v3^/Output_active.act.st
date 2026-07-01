__METADATA__
{
  "v3Meta": {
    "objectGuid": "e6be1b92-6fa1-4507-8656-3f00fb93657e",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
IF xNotAbleToSetException THEN
	; (* Do nothing. Diag outputs show not reportable exception *)
	iq_stStandardModuleItf.q_xReady := FALSE;
ELSIF stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop] THEN
	iq_stStandardModuleItf.q_etDiag := GD.ET_Diag.ExecutionAborted;
	iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.AsyncStop;
	iq_stStandardModuleItf.q_sDiagExt := 'AsyncStop';
	iq_stStandardModuleItf.q_sMsg := AXM_FC_EtDiagExtToString(i_etDiagExt := AXM_ET_DiagExt.AsyncStop);
	iq_stStandardModuleItf.q_xReady := FALSE;
ELSIF stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL] THEN
	iq_stStandardModuleItf.q_etDiag := GD.ET_Diag.ExecutionAborted;
	iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.SyncStopEL;
	iq_stStandardModuleItf.q_sDiagExt := 'SyncStopEL';
	iq_stStandardModuleItf.q_sMsg := AXM_FC_EtDiagExtToString(i_etDiagExt := AXM_ET_DiagExt.SyncStopEL);
	iq_stStandardModuleItf.q_xReady := FALSE;
ELSIF stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH] THEN
	iq_stStandardModuleItf.q_etDiag := GD.ET_Diag.ExecutionAborted;
	iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.SyncStopEH;
	iq_stStandardModuleItf.q_sDiagExt := 'SyncStopEH';
	iq_stStandardModuleItf.q_sMsg := AXM_FC_EtDiagExtToString(i_etDiagExt := AXM_ET_DiagExt.SyncStopEH);
	iq_stStandardModuleItf.q_xReady := FALSE;
ELSIF stModuleReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle] THEN
	iq_stStandardModuleItf.q_etDiag := GD.ET_Diag.ExecutionAborted;
	iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.StopEndOfCycle;
	iq_stStandardModuleItf.q_sDiagExt := 'StopEndOfCycle';
	iq_stStandardModuleItf.q_sMsg := AXM_FC_EtDiagExtToString(i_etDiagExt := AXM_ET_DiagExt.StopEndOfCycle);
	iq_stStandardModuleItf.q_xReady := FALSE;
ELSE
	IF (iq_stStandardModuleItf.i_xEnable) AND
		(iq_stAxisModuleItf.stMain.q_etState <> AXM_ET_State.Disabled) AND
		(iq_stAxisModuleItf.stMain.q_etState <> AXM_ET_State.Initializing) THEN
		iq_stStandardModuleItf.q_xReady := TRUE;
	ELSE
		iq_stStandardModuleItf.q_xReady := FALSE;
	END_IF
	iq_stStandardModuleItf.q_etDiag := GD.ET_Diag.Ok;
	CASE iq_stAxisModuleItf.stMain.q_etState OF
		AXM_ET_State.Disabled:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.Disabled;
		AXM_ET_State.Initializing:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.Initializing;
		AXM_ET_State.NoOpDriveEnabled:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.NoOpDriveEnabled;
		AXM_ET_State.NoOpDriveDisabled:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.NoOpDriveDisabled;
		AXM_ET_State.HomingInit:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.HomingInit;
		AXM_ET_State.HomingWaitForStart:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.HomingWaitForStart;
		AXM_ET_State.HomingExecuting:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.HomingExecuting;
		AXM_ET_State.HomingDone:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.HomingDone;
		AXM_ET_State.HomingExit:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.HomingExit;
		AXM_ET_State.ManualInit:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.ManualInit;
		AXM_ET_State.ManualRunning:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.ManualRunning;
		AXM_ET_State.ManualExit:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.ManualExit;
		AXM_ET_State.MultiCamInit:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.MultiCamInit;
		AXM_ET_State.MultiCamWaitForStart:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.MultiCamWaitForStart;
		AXM_ET_State.MultiCamWaitForWsStart:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.MultiCamWaitForWsStart;
		AXM_ET_State.MultiCamWsExecuting:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.MultiCamWsExecuting;
		AXM_ET_State.MultiCamRunning:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.MultiCamRunning;
		AXM_ET_State.MultiCamExit:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.MultiCamExit;
		AXM_ET_State.EndlessInit:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.EndlessInit;
		AXM_ET_State.EndlessWaitForStart:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.EndlessWaitForStart;
		AXM_ET_State.EndlessRunning:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.EndlessRunning;
		AXM_ET_State.EndlessExit:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.EndlessExit;
		AXM_ET_State.PositioningInit:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.PositioningInit;
		AXM_ET_State.PositioningWaitForStart:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.PositioningWaitForStart;
		AXM_ET_State.PositioningRunning:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.PositioningRunning;
		AXM_ET_State.PositioningExit:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.PositioningExit;
		AXM_ET_State.BrakeReleaseInit:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.BrakeReleaseInit;
		AXM_ET_State.BrakeClosed:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.BrakeClosed;
		AXM_ET_State.BrakeReleased:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.BrakeReleased;
		AXM_ET_State.BrakeReleaseExit:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.BrakeReleaseExit;
		AXM_ET_State.AdditionalInit:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.AdditionalInit;
		AXM_ET_State.AdditionalWaitForStart:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.AdditionalWaitForStart;
		AXM_ET_State.AdditionalRunning:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.AdditionalRunning;
		AXM_ET_State.AdditionalExit:
			iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.AdditionalExit;
	END_CASE
	iq_stStandardModuleItf.q_sDiagExt := AXM_FC_EtDiagExtToString(i_etDiagExt := iq_stStandardModuleItf.q_udiDiagExt);
	iq_stStandardModuleItf.q_sMsg := AXM_FC_EtDiagExtToString(i_etDiagExt := iq_stStandardModuleItf.q_udiDiagExt);
END_IF

IF iq_stStandardModuleItf.q_xActive THEN
	iq_stAxisModuleItf.stMain.q_lrPosition := iq_stAxisModuleItf.stMain.i_ifDrive.lrPosition;
ELSE
	iq_stStandardModuleItf.q_xException := FALSE;
	xInitActualValuesPos := FALSE;
END_IF

IF fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.StatusMessage THEN
	IF (iq_stAxisModuleItf.stMain.q_etOpMode <> etOpModeOld) THEN
		fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.StatusMessage,
									i_etDiag		:= GD.ET_Diag.Ok,
									i_udiDiagExt	:= AXM_ET_DiagExt.Ok,
									i_sMessage		:= Standard.CONCAT('OpMode changed to: ', AXM_FC_EtOpModeToString(i_etOpMode := iq_stAxisModuleItf.stMain.q_etOpMode)),
									q_etDiag		:= ,
									q_etDiagExt		:= );
	END_IF
	etOpModeOld := iq_stAxisModuleItf.stMain.q_etOpMode;

	IF (iq_stAxisModuleItf.stMain.q_etState <> etStateOld) THEN
		fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.StatusMessage,
									i_etDiag		:= GD.ET_Diag.Ok,
									i_udiDiagExt	:= AXM_ET_DiagExt.Ok,
									i_sMessage		:= Standard.CONCAT('State changed to: ', AXM_FC_EtStateToString(i_etState := iq_stAxisModuleItf.stMain.q_etState)),
									q_etDiag		:= ,
									q_etDiagExt		:= );
	END_IF
	etStateOld := iq_stAxisModuleItf.stMain.q_etState;
END_IF
