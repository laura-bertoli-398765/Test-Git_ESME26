__METADATA__
{
  "v3Meta": {
    "objectGuid": "027a414b-2e1b-4ec2-826d-53250118d89b",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
IF iq_stStandardModuleItf.q_xActive THEN

(* -----------------------------------------------------------------------------------------------*)
(* Check Axis Exceptions *)
(* -----------------------------------------------------------------------------------------------*)
	GetInterfaces();
	IF ifDiagnostic <> 0 THEN
		IF (ifDiagnostic.DiagClass > 0)  AND (ifDiagnostic.DiagClass < 3) THEN	
			sDiagMsgExt := ifDiagnostic.DiagExtMsg;
			stWarningDrive.sMsg := SE_CTBX.FC_MultiConcat(	i_sString1 := Standard.CONCAT('DiagCode: ', DINT_TO_STRING(ifDiagnostic.DiagCode)),
														i_sString2 := Standard.CONCAT(' Msg: ', ifDiagnostic.DiagMsg),
														i_sString3 := ' Ext: ',
														i_sString4 := sDiagMsgExt);
			stWarningDrive.udiExceptionNumber := TPL.FC_GenerateExceptionNumber(	i_etSource		:= TPL.ET_ExceptionSource.System,
																					i_udiDiagExt	:= DINT_TO_UDINT(ifDiagnostic.DiagCode),
																					q_etDiag		=> , // function has no errors
																					q_etDiagExt		=> );
			ReportException(iq_stException := stWarningDrive);
		END_IF
		IF (ifDiagnostic.DiagClass = 3) THEN	
			sDiagMsgExt := ifDiagnostic.DiagExtMsg;
			stExcepitonDrive.sMsg := SE_CTBX.FC_MultiConcat(	i_sString1 := Standard.CONCAT('DiagCode: ', DINT_TO_STRING(ifDiagnostic.DiagCode)),
															i_sString2 := Standard.CONCAT(' Msg: ', ifDiagnostic.DiagMsg),
															i_sString3 := ' Ext: ',
															i_sString4 := sDiagMsgExt);
			stExcepitonDrive.udiExceptionNumber := TPL.FC_GenerateExceptionNumber(	i_etSource		:= TPL.ET_ExceptionSource.System,
																					i_udiDiagExt	:= DINT_TO_UDINT(ifDiagnostic.DiagCode),
																					q_etDiag		=> , // function has no errors
																					q_etDiagExt		=> );
			ReportException(iq_stException := stExcepitonDrive);
		END_IF
		IF (ifDiagnostic.DiagClass > 3) THEN	
			sDiagMsgExt := ifDiagnostic.DiagExtMsg;
			stExceptionDriveFatal.sMsg := SE_CTBX.FC_MultiConcat(	i_sString1 := Standard.CONCAT('DiagCode: ', DINT_TO_STRING(ifDiagnostic.DiagCode)),
																i_sString2 := Standard.CONCAT(' Msg: ', ifDiagnostic.DiagMsg),
																i_sString3 := ' Ext: ',
																i_sString4 := sDiagMsgExt);
			stExceptionDriveFatal.udiExceptionNumber := TPL.FC_GenerateExceptionNumber(	i_etSource		:= TPL.ET_ExceptionSource.System,
																						i_udiDiagExt	:= DINT_TO_UDINT(ifDiagnostic.DiagCode),
																						q_etDiag		=> , // function has no errors
																						q_etDiagExt		=> );
			ReportException(iq_stException := stExceptionDriveFatal);
		END_IF
	ELSE
		sDiagMsgExt := '';
	END_IF

(* -----------------------------------------------------------------------------------------------*)
(* HW Limitswitches *)
(* -----------------------------------------------------------------------------------------------*)
	
	IF iq_stAxisModuleItf.stMain.i_xHwLimitPos AND
		(iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.MultiCam OR
		iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Endless OR
		iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Positioning OR
		iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Additional) THEN
		
		ReportException(iq_stException := stExceptionPosHwLimit);

	ELSIF iq_stAxisModuleItf.stMain.i_xHwLimitPos AND
			iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Homing AND
			(iq_stAxisModuleItf.stHome.i_etMode = PDL_ET_HomeMode.PosDirectionPosEdgeHWLimitPos OR
			 iq_stAxisModuleItf.stHome.i_etMode = PDL_ET_HomeMode.PosDirectionNegEdgeHWLimitPos) THEN 
		; //do nothing and ignore HW-Limit Sensor		
	ELSIF iq_stAxisModuleItf.stMain.i_xHwLimitPos AND (iq_stAxisModuleItf.stMain.q_etOpMode <> AXM_ET_OpMode.NoOp) THEN
		ReportException(iq_stException := stWarningPosHwLimit);
	ELSIF NOT iq_stAxisModuleItf.stMain.i_xHwLimitPos THEN
		CancelException(iq_stException := stWarningPosHwLimit);
	END_IF

	IF iq_stAxisModuleItf.stMain.i_xHwLimitNeg AND
		(iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.MultiCam OR
		iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Endless OR
		iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Positioning OR
		iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Additional) THEN
		
		ReportException(iq_stException := stExceptionNegHwLimit);

	ELSIF iq_stAxisModuleItf.stMain.i_xHwLimitNeg AND
			iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.Homing AND
			(iq_stAxisModuleItf.stHome.i_etMode = PDL_ET_HomeMode.NegDirectionPosEdgeHWLimitNeg OR
			 iq_stAxisModuleItf.stHome.i_etMode = PDL_ET_HomeMode.NegDirectionNegEdgeHWLimitNeg) THEN 
		; //do nothing and ignore HW-Limit Sensor
	ELSIF iq_stAxisModuleItf.stMain.i_xHwLimitNeg AND (iq_stAxisModuleItf.stMain.q_etOpMode <> AXM_ET_OpMode.NoOp) THEN
		ReportException(iq_stException := stWarningNegHwLimit);
	ELSIF NOT iq_stAxisModuleItf.stMain.i_xHwLimitNeg THEN
		CancelException(iq_stException := stWarningNegHwLimit);
	END_IF
	
(* -----------------------------------------------------------------------------------------------*)
(* Check Axis MechVelocity / ReducedVelocity *)
(* -----------------------------------------------------------------------------------------------*)
	IF iq_stAxisModuleItf.stMain.stReducedVelocity.i_xEnableReducedVelocity THEN
		
		IF ifDrive <> 0 THEN
			IF ABS(ifDrive.ActualPosition) > ABS(iq_stAxisModuleItf.stMain.stReducedVelocity.i_lrMaxReducedVelocity * iq_stAxisModuleItf.stMain.stReducedVelocity.i_lrReducedVelocityCheckFactor) THEN
					stExceptionVelLimitCrossed.sMsg := Standard.CONCAT('Vel: ', LREAL_TO_STRING(ifDrive.ActualVelocity));
					ReportException(iq_stException := stExceptionVelLimitCrossed);	
			END_IF
		END_IF
		
	ELSE
		xInitReducedVel := FALSE;
	END_IF
	
(* -----------------------------------------------------------------------------------------------*)
(* Check StartPositionSelect (SCR#1459) *)
(* -----------------------------------------------------------------------------------------------*)
	IF iq_stAxisModuleItf.stMultiCam.iq_stExt.xStartPositionSelect THEN
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.StartPositionSelectInvalid;
		stExceptionModuleReaction2.sMsg := 'xStartPositionSelect has to be false';
		ReportException(iq_stException := stExceptionModuleReaction2);
	END_IF
	
(* -----------------------------------------------------------------------------------------------*)
(* Check StopModi *)
(* -----------------------------------------------------------------------------------------------*)
(******* Reaction TPL.ET_Reaction.AsyncStop ********)
	IF stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop] THEN				(* Stop with ControllerStopt *)
		xCMDPowerOn := FALSE;	
		IF NOT (xBrakeActive OR xBrakeEnable) THEN
			xStartFlag := FALSE;
			DisableAllJobs();
		END_IF
		xWsStartFlag := FALSE;	
	
(******* Reaction TPL.ET_Reaction.SyncStopEL and TPL.ET_Reaction.SyncStopEH ********)
	ELSIF stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH] OR stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL] THEN
		fbTimeOut(IN:=TRUE, PT:= iq_stAxisModuleItf.stMain.i_timMasterStop);
		IF (iq_stAxisModuleItf.stMain.i_ifMaster <> 0) AND (iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.MultiCam) THEN
			lrMasterVel := GetMasterVel();
			IF (ABS(lrMasterVel) < 0.5 ) OR  fbTimeOut.Q THEN			(* Wait for Master stop or Timeout *)
				(* we have to wait until delay between master and slave caused by the deadtime is over,
					bevore we can disable the slaves cam job.
					Otherwise it would stop "asynchron" meaning, not completely synchron *)
				fbSyncStopDeadTimeDelay(IN:= TRUE, PT :=  T#2MS(*2ms = 2x sercos cycle time*));
				(* deadtime until the ref position (in the plc configuration) is up to date (= has taken the value it
				should have according to master.RefPosition*CAM) is 1 sercos cycle, to be on the secure side we wait 
				2 sercos cylces, also because we don't test for refVelocity = 0 but < 0.5 *)
				IF(fbSyncStopDeadTimeDelay.Q OR fbTimeOut.Q) THEN
					(* synchron stop done and deadtime is over, or timeout (of IFB_TimeOut) *)
					IF NOT xBrakeActive AND NOT xBrakeEnable THEN
						xStartFlag := FALSE;
						xWsStartFlag := FALSE;
						DisableAllJobs();
					(* Reaction TPL.ET_Reaction.SyncStopEL *)
						IF stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL] THEN
							xCMDPowerOn := FALSE;
						END_IF
					END_IF
				END_IF
			END_IF
		ELSE
		(*** immediately reaction if no master was found ***)
			IF NOT xBrakeActive AND NOT xBrakeEnable THEN
				xStartFlag := FALSE;
				xWsStartFlag := FALSE;
				DisableAllJobs();
				IF fbTimeOut.Q OR
					(iq_stAxisModuleItf.stMain.q_etOpMode = AXM_ET_OpMode.NoOp) THEN
					(* Reaction TPL.ET_Reaction.SyncStopEL *)
					IF stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL] THEN
						xCMDPowerOn := FALSE;
					END_IF
				END_IF
			END_IF
		END_IF
		
(******* Reaction TPL.ET_Reaction.StopEndOfCycle ********)
	ELSIF stModuleReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle] THEN
		IF NOT xCamActive AND NOT xBrakeActive THEN
			xStartFlag := FALSE;
			xWsStartFlag := FALSE;
		END_IF
	ELSE
		fbTimeOut(IN:= FALSE);
		fbSyncStopDeadTimeDelay(IN := FALSE);
	END_IF
	
END_IF
