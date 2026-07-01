__METADATA__
{
  "v3Meta": {
    "objectGuid": "07d6aa58-0565-4f47-8048-7bdd25741778",
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
	IF (iq_stStandardModuleItf.iq_diCmd > 0 AND (NOT iq_stStandardModuleItf.q_xCmdActive (* In case no command is active *)
			OR iq_stStandardModuleItf.iq_diCmd <> iq_stStandardModuleItf.q_diCmdActive) (* In case a command is active *)) THEN

		xCommandRefused := FALSE; (* Flag is set by RefuseCommand() action *)

(****** Check if command execution is possible ******)
		CheckCMD();
		IF(xCheckCMDError) THEN
			(*** Check for unknown command ***)
			stExceptionCmdUnknown.sMsg := Standard.CONCAT('Cmd unknown: ',DINT_TO_STRING(iq_stStandardModuleItf.iq_diCmd));
			ReportException(iq_stException := stExceptionCmdUnknown); 
			RefuseCommand();
		ELSE
			(*** Check for impossible overwrite ***)
			IF(iq_stStandardModuleItf.q_xCmdActive AND NOT((iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.Stop) OR
															(iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.BrakeRelease) OR
															((iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.Hold) AND (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Positioning) AND (iq_stStandardModuleItf.q_diCmdActive = AXM_ET_Cmd.Start)) OR
															((iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.Start) AND (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Endless) AND (iq_stStandardModuleItf.q_diCmdActive = AXM_ET_Cmd.Hold)))) THEN
				stExceptionCmdImpossibleOverwrite.sMsg := SE_CTBX.FC_MultiConcat(	i_sString1 := 'Cmd impossible: ',
																				//i_sString2 := iq_stStandardModuleItf.iq_diCmd
																				i_sString2 := AXM_FC_EtCmdToString(i_etCmd := iq_stStandardModuleItf.iq_diCmd),
																				i_sString3 := '; Cmd active: ',
																				i_sString4 := AXM_FC_EtCmdToString(i_etCmd := iq_stStandardModuleItf.q_diCmdActive) );
				ReportException(iq_stException := stExceptionCmdImpossibleOverwrite);	
				RefuseCommand();
			ELSE
				(*** Check for impossible state ***)
				IF (((iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.NoOpDriveDisabled) OR (iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.NoOpDriveEnabled) ) AND 
																								((iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.Start) OR 
																								(iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.WsStart) OR 
																								(iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.StartTrig) OR 
																								(iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.StartTrigWaitInPos)) ) OR
					((iq_stAxisModuleItf.stMain.q_etState <> AXM_ET_State.MultiCamWaitForWsStart) AND (iq_stAxisModuleItf.stMain.q_etState <> AXM_ET_State.MultiCamRunning) AND (iq_stAxisModuleItf.stMain.q_etOpMode <> AXM_ET_OpMode.Additional) AND (iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.WsStart)) OR
					((iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.MultiCamWaitForWsStart) AND ((iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.WsStart) AND ((iq_stAxisModuleItf.stMultiCam.i_etWsMode = PDL_ET_MultiCamWsMode.StoredCamShowCamPosition) OR 
																																		(iq_stAxisModuleItf.stMultiCam.i_etWsMode = PDL_ET_MultiCamWsMode.NewCamShowCamPosition)) ) ) OR
					((iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Manual) AND ((iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.Hold) OR 
																											(iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.Start)) ) OR
					((iq_stAxisModuleItf.stMain.q_etOpMode <> AXM_ET_OpMode.Positioning) AND (iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.StartTrigWaitInPos)) OR 
					((iq_stAxisModuleItf.stMain.q_etOpMode <> AXM_ET_OpMode.Endless) AND (iq_stAxisModuleItf.stMain.q_etOpMode <> AXM_ET_OpMode.MultiCam) AND (iq_stAxisModuleItf.stMain.q_etOpMode <> AXM_ET_OpMode.Positioning) AND (iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.StartTrig))
					THEN
					stExceptionCmdImpossibleState.sMsg := SE_CTBX.FC_MultiConcat(	i_sString1 := 'Cmd impossible: ',
																				i_sString2 := AXM_FC_EtCmdToString(i_etCmd := iq_stStandardModuleItf.iq_diCmd),
																				i_sString3 := '; State: ',
																				i_sString4 := AXM_FC_EtStateToString(i_etState := iq_stAxisModuleItf.stMain.q_etState) );
					ReportException(iq_stException := stExceptionCmdImpossibleState);
					RefuseCommand();
				ELSIF ((iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Homing OR
						iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Manual OR
						iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.MultiCam OR
						iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Endless OR
						iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Positioning OR
						iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.BrakeRelease OR
						iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Additional) AND ((iq_stAxisModuleItf.stMain.i_xStart OR xStartBitLastCycle) AND (iq_stStandardModuleItf.iq_diCMD = AXM_ET_Cmd.Start OR
																																						iq_stStandardModuleItf.iq_diCMD = AXM_ET_Cmd.Hold OR
																																						iq_stStandardModuleItf.iq_diCMD = AXM_ET_Cmd.StartTrig OR
																																						iq_stStandardModuleItf.iq_diCMD = AXM_ET_Cmd.StartTrigWaitInPos) )) THEN
					IF(iq_stAxisModuleItf.stMain.i_xStart) THEN
						stExceptionCmdImpossibleState.sMsg := SE_CTBX.FC_MultiConcat(	i_sString1 := 'Cmd impossible: ',
																					i_sString2 := AXM_FC_EtCmdToString(i_etCmd := iq_stStandardModuleItf.iq_diCmd),
																					i_sString3 := '; State: ',
																					i_sString4 := 'xStart input is TRUE');
						ReportException(iq_stException := stExceptionCmdImpossibleState);
						RefuseCommand();
					ELSE
						stExceptionCmdImpossibleState.sMsg := SE_CTBX.FC_MultiConcat(	i_sString1 := 'Cmd impossible: ',
																					i_sString2 := AXM_FC_EtCmdToString(i_etCmd := iq_stStandardModuleItf.iq_diCmd),
																					i_sString3 := '; State: ',
																					i_sString4 := 'xStart input was TRUE last cycle');
						ReportException(iq_stException := stExceptionCmdImpossibleState);
						RefuseCommand();
					END_IF					
				ELSE
					(*** Check for impossible commands due to active error reactions ***)
					IF (stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop] 
						OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH] 
						OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL] 
						OR stModuleReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle]) 
						AND NOT (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.BrakeRelease)
						AND	((iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.Start) OR
							(iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.WsStart) OR
							(iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.StartTrig) OR
							(iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.StartTrigWaitInPos)) THEN (* Start impossible if error reaction 4 or higher *)
							stWarningCmdImpossibleReaction.sMsg := SE_CTBX.FC_MultiConcat(	i_sString1 := 'Cmd impossible: ',
																						i_sString2 := AXM_FC_EtCmdToString(i_etCmd := iq_stStandardModuleItf.iq_diCmd),
																						i_sString3 := '; Reaction: ',
																						i_sString4 := TPL.FC_GetStandardReactionName(iq_stReaction := stModuleReaction));
							ReportException(iq_stException := stWarningCmdImpossibleReaction);
							RefuseCommand();
					ELSIF ((stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop] 
							OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH] 
							OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL] ) 
							AND xOpModeCmd AND
							NOT ((iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.Stop) OR (iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.DriveEnableOff) OR (iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.BrakeRelease)) ) THEN  
							stWarningCmdImpossibleReaction.sMsg := SE_CTBX.FC_MultiConcat(	i_sString1 := 'Cmd impossible: ',
																						i_sString2 := AXM_FC_EtCmdToString(i_etCmd := iq_stStandardModuleItf.iq_diCmd),
																						i_sString3 := '; Reaction: ',
																						i_sString4 := TPL.FC_GetStandardReactionName(iq_stReaction := stModuleReaction));
							ReportException(iq_stException := stWarningCmdImpossibleReaction);
							RefuseCommand();
					ELSIF ((stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop] 
							OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL]) 
							AND (iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.DriveEnableOn)) THEN
							stWarningCmdImpossibleReaction.sMsg := SE_CTBX.FC_MultiConcat(	i_sString1 := 'Cmd impossible: ',
																						i_sString2 := AXM_FC_EtCmdToString(i_etCmd := iq_stStandardModuleItf.iq_diCmd),
																						i_sString3 := '; Reaction: ',
																						i_sString4 := TPL.FC_GetStandardReactionName(iq_stReaction := stModuleReaction));
							ReportException(iq_stException := stWarningCmdImpossibleReaction);
							RefuseCommand();
					END_IF
				END_IF
			END_IF
		END_IF

		IF(NOT xCommandRefused) THEN (* Command has passed all checks, execute command *)
			(* Accept command *)
			iq_stStandardModuleItf.q_xCmdActive := TRUE;
			iq_stStandardModuleItf.q_xCmdDone := FALSE;
			iq_stStandardModuleItf.q_diCmdActive := iq_stStandardModuleItf.iq_diCmd;

			xCommandAcceptedInThisCycle := TRUE; (* Signal for command done checks *)
			IF fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.UserAction THEN
				fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
											i_etDiag		:= GD.ET_Diag.Ok,
											i_udiDiagExt	:= AXM_ET_DiagExt.Ok,
											i_sMessage		:= Standard.CONCAT(Standard.CONCAT(Standard.CONCAT('Command executing: ', AXM_FC_EtCmdToString(i_etCmd := iq_stStandardModuleItf.iq_diCmd)),' number: '),DINT_TO_STRING(iq_stStandardModuleItf.iq_diCmd)),
											q_etDiag		:= ,
											q_etDiagExt		:= );
			END_IF
		
			IF(xOpModeCmd) THEN
				DisableAllJobs();
				xWsSelect			:= FALSE;
				xWsStartFlag		:= FALSE;
				
				CASE iq_stStandardModuleItf.iq_diCmd OF
				AXM_ET_Cmd.Stop:
					(* Do nothing, disabled OpMode flags automatically lead to NoOp *)
					xStartFlag := FALSE;
					
				AXM_ET_Cmd.Homing:
					xRefEnable := TRUE;
					
					IF iq_stAxisModuleItf.stHome.stSetPos.i_xKeepPowerDisabled AND 
						( iq_stAxisModuleItf.stHome.i_etMode = PDL_ET_HomeMode.RestorePosFromAxisEncoder
						OR iq_stAxisModuleItf.stHome.i_etMode = PDL_ET_HomeMode.RestorePosFromRetain
						OR iq_stAxisModuleItf.stHome.i_etMode = PDL_ET_HomeMode.SetPosAxisAndLogEncoderPosition
						OR iq_stAxisModuleItf.stHome.i_etMode = PDL_ET_HomeMode.SetPosAxisPosition
						OR iq_stAxisModuleItf.stHome.i_etMode = PDL_ET_HomeMode.SetPosLogEncoderPosition )THEN
						xCMDPowerOn := FALSE;
					ELSE
						xCMDPowerOn := TRUE;
					END_IF	
					
					IF NOT (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Homing) THEN
						xStartFlag := FALSE;
					END_IF
					
				AXM_ET_Cmd.Manual:
					xManEnable := TRUE;
					xCMDPowerOn := TRUE;
				
				AXM_ET_Cmd.CamCs:
					xCamEnable := TRUE;
					xCMDPowerOn := TRUE;
					xWsSelect := FALSE;
					xWsStartFlag := FALSE;
					IF NOT (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.MultiCam) THEN
						xStartFlag := FALSE;
					END_IF
					
				AXM_ET_Cmd.CamWs:
					xCamEnable := TRUE;
					xCMDPowerOn := TRUE;
					xWsSelect := TRUE;
					xWsStartFlag := FALSE;
					IF NOT (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.MultiCam) THEN
						xStartFlag := FALSE;
					END_IF
				
				AXM_ET_Cmd.Endless:
					xEndlessEnable := TRUE;
					xCMDPowerOn := TRUE;
					IF NOT (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Endless) THEN
						xStartFlag := FALSE;
					END_IF
				
				AXM_ET_Cmd.Positioning:
					xPosEnable := TRUE;
					xCMDPowerOn := TRUE;
					IF NOT (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Positioning) THEN
						xStartFlag := FALSE;
					END_IF
				
				AXM_ET_Cmd.BrakeRelease:
					xBrakeEnable := TRUE;
					xCMDPowerOn := FALSE;
					IF NOT (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.BrakeRelease) THEN
						xStartFlag := FALSE;
					END_IF
				
				AXM_ET_Cmd.AdditionalCs:
					xAdditionalEnable := TRUE;
					xCMDPowerOn := TRUE;
					xWsSelect := FALSE;
					xWsStartFlag := FALSE;
					IF NOT (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Additional) THEN
						xStartFlag := FALSE;
					END_IF
					
				AXM_ET_Cmd.AdditionalWs:
					xAdditionalEnable := TRUE;
					xCMDPowerOn := TRUE;
					xWsSelect := TRUE;
					xWsStartFlag := FALSE;
					IF NOT (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Additional) THEN
						xStartFlag := FALSE;
					END_IF
				
				AXM_ET_Cmd.DriveEnableOff:
					xCMDPowerOn := FALSE;
					xStartFlag := FALSE;
				ELSE
					stExceptionModuleReaction1.etDiag := GD.ET_Diag.UnexpectedProgramBehavior;
					stExceptionModuleReaction1.udiDiagExt := AXM_ET_DiagExt.UnknownCase;
					stExceptionModuleReaction1.sMsg := '';
					ReportException(iq_stException := stExceptionModuleReaction1);
				END_CASE
			ELSE
				CASE iq_stStandardModuleItf.iq_diCmd OF
				AXM_ET_Cmd.Start:
					xStartFlag := TRUE;
					IF (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Homing) THEN
						(* Reset HomeOk when a new homing is started *)
						iq_stAxisModuleItf.stMain.q_xHomeOk := FALSE;
					END_IF
					
				AXM_ET_Cmd.StartTrig:
					xStartFlag := TRUE;
					
				AXM_ET_Cmd.StartTrigWaitInPos:
					xStartFlag := TRUE;
					
				AXM_ET_Cmd.WsStart:
					xWsStartFlag := TRUE;
					(* In additional mode it has to be possible to set WsStart independent of start *)
					IF NOT (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Additional) THEN
						xStartFlag  := TRUE;
					END_IF
					
				AXM_ET_Cmd.Hold:
					xStartFlag := FALSE;
					
				AXM_ET_Cmd.DriveEnableOn:
					xCMDPowerOn := TRUE;
				
				ELSE
					stExceptionModuleReaction1.etDiag := GD.ET_Diag.UnexpectedProgramBehavior;
					stExceptionModuleReaction1.udiDiagExt := AXM_ET_DiagExt.UnknownCase;
					stExceptionModuleReaction1.sMsg := '';
					ReportException(iq_stException := stExceptionModuleReaction1);
				END_CASE
			
			END_IF
		END_IF (* New command? *)
	END_IF

(********************************************* Check successful and unsucessful of given commands ****************************************)
	
	(* Check if active command is done or is stopped by an error *)
	IF(NOT xCommandAcceptedInThisCycle) THEN (* Don't execute these checks if we accepted a new command in this cycle
		to ensure that execution of every command requires a minimum of 2 cycles *)

		IF(iq_stStandardModuleItf.q_xCmdActive) THEN
			CASE iq_stStandardModuleItf.iq_diCmd OF
			AXM_ET_Cmd.Homing:
				(* Successful *)
				IF (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Homing) AND NOT (iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.HomingInit) THEN
					SignalSuccessfulExecution();
				END_IF
				(* Unsucessful *)
				IF(stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL]) THEN
					SignalUnsuccessfulExecution();
				END_IF
				
			AXM_ET_Cmd.Manual:
				(* Successful *)
				IF (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Manual) AND NOT (iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.ManualInit) THEN
					SignalSuccessfulExecution();
				END_IF
				(* Unsucessful *)
				IF(stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL]) THEN
					SignalUnsuccessfulExecution();
				END_IF
				
			AXM_ET_Cmd.CamCs:
				(* Successful *)
				IF (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.MultiCam) AND NOT (iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.MultiCamInit) THEN
					SignalSuccessfulExecution();
				END_IF
				(* Unsucessful *)
				IF(stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL]) THEN
					SignalUnsuccessfulExecution();
				END_IF
				
			AXM_ET_Cmd.CamWs:
				(* Successful *)
				IF (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.MultiCam) AND NOT (iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.MultiCamInit) THEN
					SignalSuccessfulExecution();
				END_IF
				(* Unsucessful *)
				IF(stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL]) THEN
					SignalUnsuccessfulExecution();
				END_IF
				
			AXM_ET_Cmd.Endless:
				(* Successful *)
				IF (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Endless) AND NOT (iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.EndlessInit) THEN
					SignalSuccessfulExecution();
				END_IF
				(* Unsucessful *)
				IF(stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL]) THEN
					SignalUnsuccessfulExecution();
				END_IF
				
			AXM_ET_Cmd.Positioning:
				(* Successful *)
				IF (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Positioning) AND NOT (iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.PositioningInit) THEN
					SignalSuccessfulExecution();
				END_IF
				(* Unsucessful *)
				IF(stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL]) THEN
					SignalUnsuccessfulExecution();
				END_IF
				
			AXM_ET_Cmd.BrakeRelease:
				(* Successful *)
				IF (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.BrakeRelease) AND 
					( (NOT fbBrake.i_xRelease AND (iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.BrakeClosed)) OR
					(fbBrake.i_xRelease AND (iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.BrakeReleased)) ) THEN
					// real axis can still be in state brake open if gone to brake release opmode,
					// therefore delay signal cmd successfull till brake closed is reached
					SignalSuccessfulExecution();
				END_IF
				
			AXM_ET_Cmd.AdditionalCs:
				(* Successful *)
				IF (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Additional) AND NOT (iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.AdditionalInit) THEN
					SignalSuccessfulExecution();
				END_IF
				(* Unsucessful *)
				IF(stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL]) THEN
					SignalUnsuccessfulExecution();
				END_IF
				
			AXM_ET_Cmd.AdditionalWs:
				(* Successful *)
				IF (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Additional) AND NOT (iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.AdditionalInit) THEN
					SignalSuccessfulExecution();
				END_IF
				(* Unsucessful *)
				IF(stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL]) THEN
					SignalUnsuccessfulExecution();
				END_IF
				
			AXM_ET_Cmd.Start:
				(* Successful *)
				IF ((iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.HomingWaitForStart) AND iq_stAxisModuleItf.stMain.q_xHomeOk) OR
					(iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.HomingDone) OR
					(iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.MultiCamWaitForWsStart) OR
					(iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.MultiCamRunning) OR
					(iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.EndlessRunning) OR
					(iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.PositioningRunning) OR
					(iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.BrakeReleased) OR
					((iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Additional) AND iq_stAxisModuleItf.stAdditional.i_xActionCmdDone) THEN
					SignalSuccessfulExecution();
				END_IF
				(* Unsucesful *)
				IF(stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle])
					AND NOT (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.BrakeRelease) THEN
					SignalUnsuccessfulExecution();
				END_IF
				
			AXM_ET_Cmd.StartTrig:
				(* Successful *)
				IF (iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.PositioningRunning) OR
					(iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.MultiCamRunning) OR
					(iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.EndlessRunning) THEN
					xStartFlag := FALSE;
					SignalSuccessfulExecution();
				END_IF
				(* Unsucesful *)
				IF(stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL]
					)
					AND NOT (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.BrakeRelease) THEN
					SignalUnsuccessfulExecution();
				END_IF
			
			AXM_ET_Cmd.StartTrigWaitInPos:
				(* Successful *)
				IF fbVarioPos.q_xInPosition THEN
					xStartFlag := FALSE;
					SignalSuccessfulExecution();
				END_IF
				(* Unsucesful *)
				IF(stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL]
					)
					AND NOT (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.BrakeRelease) THEN
					SignalUnsuccessfulExecution();
				END_IF
			
			AXM_ET_Cmd.Stop:
				(* Successful *)
				IF (iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.NoOpDriveDisabled) OR
					(iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.NoOpDriveEnabled) THEN
					iq_stAxisModuleItf.stMain.q_etOpMode := AXM_ET_OpMode.NoOp;
					SignalSuccessfulExecution();
				END_IF

				
			AXM_ET_Cmd.Hold:
				IF iq_stAxisModuleItf.stMain.i_xStart THEN
					stExceptionModuleReaction2.sMsg := 'rising edge of xStart input during execution of CMD Hold';
					ReportException(iq_stException := stExceptionModuleReaction2);
					RefuseCommand();
				ELSIF (* Successful *)
					(iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.HomingWaitForStart) OR
					(iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.MultiCamWaitForStart) OR
					(iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.EndlessWaitForStart) OR
					(iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.PositioningWaitForStart) OR
					(iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.BrakeClosed) OR
					(iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.AdditionalWaitForStart) OR
					(iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.NoOpDriveDisabled) OR
					(iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.NoOpDriveEnabled) OR
					((iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Additional) AND iq_stAxisModuleItf.stAdditional.i_xActionCmdDone) THEN
					SignalSuccessfulExecution();
				ELSIF (* Unsucessful *)
					(stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL]) AND NOT (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.BrakeRelease) THEN
					SignalUnsuccessfulExecution();
				END_IF
				
			AXM_ET_Cmd.WsStart:
				(* Successful *)
				IF ((iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.HomingWaitForStart) AND iq_stAxisModuleItf.stMain.q_xHomeOk) OR
					(iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.MultiCamRunning) OR
					(iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.EndlessRunning) OR
					(iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.PositioningRunning) OR
					(iq_stAxisModuleItf.stMain.q_etState = AXM_ET_State.BrakeReleased) OR
					((iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Additional) AND iq_stAxisModuleItf.stAdditional.i_xActionCmdDone) THEN
					SignalSuccessfulExecution();
				END_IF
				(* Unsucesful *)
				IF(stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle]) THEN
					SignalUnsuccessfulExecution();
				END_IF
				
			AXM_ET_Cmd.DriveEnableOn:
				(* Successful *)
				IF(etPowerState = AXM_ET_PowerState.PowerOn) THEN
					SignalSuccessfulExecution();
				END_IF
				(* Unsucessful *)
				IF(stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH]
					OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL]) THEN 
					SignalUnsuccessfulExecution();
				END_IF
				
			AXM_ET_Cmd.DriveEnableOff:
				(* Successful *)
				IF(etPowerState = AXM_ET_PowerState.PowerOff) THEN
					SignalSuccessfulExecution();
				END_IF

			ELSE
				stExceptionModuleReaction1.etDiag := GD.ET_Diag.UnexpectedProgramBehavior;
				stExceptionModuleReaction1.udiDiagExt := AXM_ET_DiagExt.UnknownCase;
				stExceptionModuleReaction1.sMsg := '';
				ReportException(iq_stException := stExceptionModuleReaction1);
			END_CASE
		END_IF
	END_IF
ELSE
	(* Module is going to be disabled *)
	IF xEnableFlag THEN
		etPowerState := AXM_ET_PowerState.WaitForDisabled;
		IF fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.UserAction THEN
			fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
										i_etDiag		:= GD.ET_Diag.Ok,
										i_udiDiagExt	:= AXM_ET_DiagExt.Ok,
										i_sMessage		:= 'disabeling Module',
										q_etDiag		:= ,
										q_etDiagExt		:= );
		END_IF
	END_IF
	iq_stStandardModuleItf.q_xReady := FALSE;
	xEnableFlag := FALSE;
	xCMDPowerOn := FALSE;
	DisableAllJobs();
	xStartFlag := FALSE;
	xWsSelect := FALSE;
	xWsStartFlag := FALSE;
	IF(iq_stStandardModuleItf.q_xCmdActive) THEN (* If a command is currently active, cancel its execution *)
		SignalUnsuccessfulExecution();
	ELSE
		InactiveCmdExecution(); (* Command processing as if we were disabled *)
	END_IF
END_IF
xStartBitLastCycle := iq_stAxisModuleItf.stMain.i_xStart;
