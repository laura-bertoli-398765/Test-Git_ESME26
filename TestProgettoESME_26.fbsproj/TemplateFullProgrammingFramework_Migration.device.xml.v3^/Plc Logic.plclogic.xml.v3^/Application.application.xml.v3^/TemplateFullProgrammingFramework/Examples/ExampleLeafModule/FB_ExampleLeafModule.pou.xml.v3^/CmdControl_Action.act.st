__METADATA__
{
  "v3Meta": {
    "objectGuid": "ce727a76-8094-4b5a-8c9f-e08d9a80c993",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* CMD execution

	algorithm:
	----------

	detect new command?
		check command?
			execute command;
		end
	end

	is command running (at least one cycle)?	
		is command finished?
			signal success/unsuccessful
		end
	end
*)

xCommandAcceptedInThisCycle := FALSE;

(* Detect new command *)
IF(iq_stStandardModuleItf.i_xEnable) THEN
	IF (iq_stStandardModuleItf.iq_diCMD > 0 AND (NOT iq_stStandardModuleItf.q_xCMDActive (* In case no command is active *)
			OR iq_stStandardModuleItf.iq_diCMD <> iq_stStandardModuleItf.q_diCMDActive) (* In case a command is active *)) THEN
	
		xCommandRefused := FALSE; (* Flag is set by RefuseCommand() action *)
	
		(* Check command *)
		CheckCmd();
		IF(xCheckCmdException) THEN
			(*** Check for unknown command ***)
			stExceptionCmdUnknown.sMsg := Standard.CONCAT('Cmd unknown: ',DINT_TO_STRING(iq_stStandardModuleItf.iq_diCmd));
			ReportException(iq_stException := stExceptionCmdUnknown); 
			RefuseCommand();
		ELSE
			(*** Check for impossible overwrite ***)
			IF(iq_stStandardModuleItf.q_xCMDActive AND iq_stStandardModuleItf.iq_diCMD <> ET_ExampleLeafModuleCmd.Stop) THEN (* In this module only the ET_ExampleLeafModuleCmd.Stop command can overwrite other commands *)
				stExceptionCmdImpossibleOverwrite.sMsg := SE_CTBX.FC_MultiConcat(	i_sString1 := 'Cmd impossible: ',
																				i_sString2 := FC_EtExampleLeafModuleCmdToString(i_diCmd := iq_stStandardModuleItf.iq_diCmd),
																				i_sString3 := '; Cmd active: ',
																				i_sString4 := FC_EtExampleLeafModuleCmdToString(i_diCmd := iq_stStandardModuleItf.q_diCmdActive) );
				ReportException(iq_stException := stExceptionCmdImpossibleOverwrite);	
				RefuseCommand();
			ELSE
				(*** Check for impossible state ***)
				IF(NOT xOpModeCmd AND (* In this module, all OpMode commands are always possible independent of the state *)
					(iq_stExampleLeafModuleItf.q_etState = ET_ExampleLeafModuleState.NoOp (* Start and Hold are not possible in NoOp *)
					OR (iq_stExampleLeafModuleItf.q_etState = ET_ExampleLeafModuleState.HomingWaitForStart OR iq_stExampleLeafModuleItf.q_etState = ET_ExampleLeafModuleState.HomingDone) AND iq_stStandardModuleItf.iq_diCMD = ET_ExampleLeafModuleCmd.Hold) (* Hold is not supported in homing *)
					) THEN
					stExceptionCmdImpossibleState.sMsg := SE_CTBX.FC_MultiConcat(	i_sString1 := 'Cmd impossible: ',
																				i_sString2 := FC_EtExampleLeafModuleCmdToString(i_diCmd := iq_stStandardModuleItf.iq_diCmd),
																				i_sString3 := '; State: ',
																				i_sString4 := FC_EtExampleLeafModuleStateToString(i_etState := iq_stExampleLeafModuleItf.q_etState) );
					ReportException(iq_stException := stExceptionCmdImpossibleState);
					RefuseCommand();
				ELSE
					(* Check for impossible commands due to active error reactions *)
					IF	iq_stStandardModuleItf.iq_diCMD = ET_ExampleLeafModuleCmd.Start 
							AND (stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop] OR 
								 stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH] OR 
								 stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL] OR 
								 stModuleReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle]) (* Start impossible if error reaction 4 or higher *)
						OR 
						
						iq_stStandardModuleItf.iq_diCMD <> ET_ExampleLeafModuleCmd.Stop 
							AND (stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop] OR 
								 stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH] OR 
								 stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL]) THEN (* Everything else, with exception of Stop, impossible if error reaction 3 or higher *)

						stWarningCmdImpossibleReaction.sMsg := SE_CTBX.FC_MultiConcat(	i_sString1 := 'Cmd impossible: ',
																					i_sString2 := FC_EtExampleLeafModuleCmdToString(i_diCmd := iq_stStandardModuleItf.iq_diCmd),
																					i_sString3 := '; Reaction: ',
																					i_sString4 := TPL.FC_GetStandardReactionName(iq_stReaction := stModuleReaction));
						ReportException(iq_stException := stWarningCmdImpossibleReaction);
						RefuseCommand();
					END_IF
				END_IF
			END_IF
		END_IF
	
		IF(NOT xCommandRefused) THEN (* Command has passed all checks, execute command *)
			IF fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.UserAction THEN
				fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
											i_etDiag		:= GD.ET_Diag.Ok,
											i_udiDiagExt	:= ET_DiagExtExampleLeafModule.Ok,
											i_sMessage		:= Standard.CONCAT(Standard.CONCAT(Standard.CONCAT('Command executing: ', FC_etExampleLeafModuleCmdToString(i_diCmd := iq_stStandardModuleItf.iq_diCmd)),' number: '),DINT_TO_STRING(iq_stStandardModuleItf.iq_diCmd)),
											q_etDiag		:= ,
											q_etDiagExt		:= );
			END_IF
			(* Accept command *)
			iq_stStandardModuleItf.q_xCMDActive := TRUE;
			iq_stStandardModuleItf.q_xCMDDone := FALSE;
			iq_stStandardModuleItf.q_diCMDActive := iq_stStandardModuleItf.iq_diCMD;
	
			xCommandAcceptedInThisCycle := TRUE; (* Signal for command done checks *)
	
			IF(xOpModeCMD) THEN
				DisableAllJobs();
				
				CASE iq_stStandardModuleItf.iq_diCMD OF
					ET_ExampleLeafModuleCmd.Stop:
						;	(* Do nothing, disabled OpMode flags automatically lead to NoOp *)
						
					ET_ExampleLeafModuleCmd.Homing:
						xHomingEnable := TRUE;
					
					ET_ExampleLeafModuleCmd.Auto:
						xAutoEnable := TRUE;
				END_CASE
			ELSE
				(* Action commands *)
				CASE iq_stStandardModuleItf.iq_diCMD OF
					ET_ExampleLeafModuleCmd.Start:
						xStartFlag := TRUE;
					
					ET_ExampleLeafModuleCmd.Hold:
						xStartFlag := FALSE;
				END_CASE
			END_IF
		END_IF (* New command? *)
	END_IF

(********************************************* Check successful and unsucessful of given commands ****************************************)

	(* Check if active command is done or is stopped by an error *)
	IF(NOT xCommandAcceptedInThisCycle) THEN (* Don't execute these checks if we accepted a new command in this cycle
		to ensure that execution of every command requires a minimum of 2 cycles *)

		IF(iq_stStandardModuleItf.q_xCMDActive) THEN
			CASE iq_stStandardModuleItf.iq_diCmd OF
				ET_ExampleLeafModuleCmd.Homing:
					(* Successful *)
					IF(xHomingActive) THEN
						SignalSuccessfulExecution();
					END_IF
					(* Unsucessful *)
					IF (stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop] OR 
						stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL] OR 
						stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH]) THEN
						
						SignalUnsuccessfulExecution();
					END_IF
					
				ET_ExampleLeafModuleCmd.Auto:
					(* Successful *)
					IF(xAutoActive) THEN
						SignalSuccessfulExecution();
					END_IF
					(* Unsucessful *)
					IF (stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop] OR 
						stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL] OR 
						stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH]) THEN

						SignalUnsuccessfulExecution();
					END_IF
	
				ET_ExampleLeafModuleCmd.Stop:
					(* Successful *)
					IF(iq_stExampleLeafModuleItf.q_etState = ET_ExampleLeafModuleState.NoOp) THEN
						SignalSuccessfulExecution();
					END_IF
					
				ET_ExampleLeafModuleCmd.Start:
					IF(iq_stExampleLeafModuleItf.q_etState = ET_ExampleLeafModuleState.HomingDone) THEN
						xStartFlag := FALSE;
					END_IF
					(* Successful *)
					IF(iq_stExampleLeafModuleItf.q_etState = ET_ExampleLeafModuleState.HomingDone AND NOT xHomingException
						OR iq_stExampleLeafModuleItf.q_etState = ET_ExampleLeafModuleState.AutoRunning) THEN
						SignalSuccessfulExecution();
					END_IF
					(* Unsucessful *)
					IF (stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop] OR 
						stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL] OR 
						stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH] OR 
						stModuleReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle]  OR
						iq_stExampleLeafModuleItf.q_etState = ET_ExampleLeafModuleState.HomingDone AND xHomingException) THEN
						
						SignalUnsuccessfulExecution();
					END_IF
					
				ET_ExampleLeafModuleCmd.Hold:
					(* Successful *)
					IF(iq_stExampleLeafModuleItf.q_etState = ET_ExampleLeafModuleState.AutoWaitForStart) THEN
						SignalSuccessfulExecution();
					END_IF
					(* Unsucessful *)
					IF (stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop] OR 
						stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL] OR 
						stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH]) THEN

						SignalUnsuccessfulExecution();
					END_IF
			END_CASE
		END_IF
	END_IF
ELSE
	(* Module is going to be disabled *)
	iq_stStandardModuleItf.q_xReady := FALSE;
	xEnableFlag := FALSE;
	
	DisableAllJobs();
	
	xStartFlag := FALSE;

	IF(iq_stStandardModuleItf.q_xCmdActive) THEN (* If a command is currently active, cancel its execution *)
		SignalUnsuccessfulExecution();
	ELSE
		InactiveCmdExecution(); (* Command processing as if we were disabled *)
	END_IF
END_IF
