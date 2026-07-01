__METADATA__
{
  "v3Meta": {
    "objectGuid": "f6f9ed11-c115-4c50-b3a9-4322940e64ce",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
iq_stStandardModuleItf.q_xActive := FALSE;
iq_stStandardModuleItf.q_xReady := FALSE;
iq_stStandardModuleItf.q_etDiag := GD.ET_Diag.Ok;
iq_stStandardModuleItf.q_udiDiagExt := AXM_ET_DiagExt.Disabled;
iq_stStandardModuleItf.q_sDiagExt := AXM_FC_EtDiagExtToString(i_etDiagExt := iq_stStandardModuleItf.q_udiDiagExt);
iq_stStandardModuleItf.q_sMsg := AXM_FC_EtDiagExtToString(i_etDiagExt := AXM_ET_DiagExt.Disabled);
iq_stStandardModuleItf.q_dwModuleType := TPL.ET_ModuleType.AxisModule;
iq_stStandardModuleItf.q_sModuleTypeName := 'AxisModule';
iq_stStandardModuleItf.q_udiModuleVersion := 1;

iq_stAxisModuleItf.stMain.q_etOpMode := AXM_ET_OpMode.NoOp;
iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.Disabled;

THIS^.DiagQuit();
THIS^.InactiveCMDExecution();

(* detect invalid configurations and avoid array index out of range error *)
IF(iq_stStandardModuleItf.iq_stExt.udiReactionOffset + TPL.ET_Reaction.MainsContactorOff > TPL.Gc_udiMaxNumberOfReactions) OR xExceptionReactionOutsideRange THEN (* module uses error reactions 1 to 5 *)
	xExceptionReactionOutsideRange := TRUE; (* create unquittable error *)
	(* create exception *)
	stExceptionInit.etDiag					:= GD.ET_Diag.InputParameterInvalid;
	stExceptionInit.udiDiagExt				:= AXM_ET_DiagExt.ReactionOffsetRange;
	stExceptionInit.sMsg					:= Standard.CONCAT('Value: ', UDINT_TO_STRING(iq_stStandardModuleItf.iq_stExt.udiReactionOffset));
	stExceptionInit.udiModuleId				:= iq_stStandardModuleItf.i_udiModuleId;
	stExceptionInit.sModuleName				:= iq_stStandardModuleItf.i_sModuleName;
	stExceptionInit.etSource				:= TPL.ET_ExceptionSource.AxisModule;
	stExceptionInit.timDelayTime			:= T#0MS;
	stExceptionInit.wHmiAttributes			:= 0;
	stExceptionInit.xAutoQuit				:= FALSE;
	stExceptionInit.stReaction.axReaction[TPL.ET_Reaction.AsyncStop]	:= TRUE; (* without offset on purpose *)
	iq_stStandardModuleItf.iq_stExt.udiReactionOffset := 0;
	ReportException(iq_stException := stExceptionInit);
ELSIF(iq_stStandardModuleItf.i_xEnable) THEN
	stReaction1 := stEmptyReaction;
	stReaction1.axReaction[iq_stStandardModuleItf.iq_stExt.udiReactionOffset + TPL.ET_Reaction.AsyncStop] := TRUE;
	stReaction2 := stEmptyReaction;
	stReaction2.axReaction[iq_stStandardModuleItf.iq_stExt.udiReactionOffset + TPL.ET_Reaction.SyncStopEL] := TRUE;
	stReaction3 := stEmptyReaction;
	stReaction3.axReaction[iq_stStandardModuleItf.iq_stExt.udiReactionOffset + TPL.ET_Reaction.SyncStopEH] := TRUE;
	stReaction4 := stEmptyReaction;
	stReaction4.axReaction[iq_stStandardModuleItf.iq_stExt.udiReactionOffset + TPL.ET_Reaction.StopEndOfCycle] := TRUE;

	(* Initialization of exception structures *)
	stExceptionCmdUnknown.etDiag			:= GD.ET_Diag.ExecutionAborted;
	stExceptionCmdUnknown.udiDiagExt		:= AXM_ET_DiagExt.CmdUnknown;
	stExceptionCmdUnknown.sMsg				:= 'Command unknown'; (* Replaced on usage *)
	stExceptionCmdUnknown.udiModuleId		:= iq_stStandardModuleItf.i_udiModuleId;
	stExceptionCmdUnknown.sModuleName		:= iq_stStandardModuleItf.i_sModuleName;
	stExceptionCmdUnknown.etSource			:= TPL.ET_ExceptionSource.AxisModule;
	stExceptionCmdUnknown.timDelayTime		:= T#0MS;
	stExceptionCmdUnknown.wHmiAttributes	:= 0;
	stExceptionCmdUnknown.xAutoQuit			:= FALSE;
	stExceptionCmdUnknown.stReaction		:= stReaction1;

	stExceptionCmdImpossibleOverwrite.etDiag			:= GD.ET_Diag.ExecutionAborted;
	stExceptionCmdImpossibleOverwrite.udiDiagExt		:= AXM_ET_DiagExt.CmdImpossibleOverwrite;
	stExceptionCmdImpossibleOverwrite.sMsg				:= 'Impossible command overwrite'; (* Replaced on usage *)
	stExceptionCmdImpossibleOverwrite.udiModuleId		:= iq_stStandardModuleItf.i_udiModuleId;
	stExceptionCmdImpossibleOverwrite.sModuleName		:= iq_stStandardModuleItf.i_sModuleName;
	stExceptionCmdImpossibleOverwrite.etSource			:= TPL.ET_ExceptionSource.AxisModule;
	stExceptionCmdImpossibleOverwrite.timDelayTime		:= T#0MS;
	stExceptionCmdImpossibleOverwrite.wHmiAttributes	:= 0;
	stExceptionCmdImpossibleOverwrite.xAutoQuit			:= FALSE;
	stExceptionCmdImpossibleOverwrite.stReaction		:= stReaction1;
	
	stExceptionCmdImpossibleState.etDiag			:= GD.ET_Diag.ExecutionAborted;
	stExceptionCmdImpossibleState.udiDiagExt		:= AXM_ET_DiagExt.CmdImpossibleState;
	stExceptionCmdImpossibleState.sMsg				:= 'Impossible command for state'; (* Replaced on usage *)
	stExceptionCmdImpossibleState.udiModuleId		:= iq_stStandardModuleItf.i_udiModuleId;
	stExceptionCmdImpossibleState.sModuleName		:= iq_stStandardModuleItf.i_sModuleName;
	stExceptionCmdImpossibleState.etSource			:= TPL.ET_ExceptionSource.AxisModule;
	stExceptionCmdImpossibleState.timDelayTime		:= T#0MS;
	stExceptionCmdImpossibleState.wHmiAttributes	:= 0;
	stExceptionCmdImpossibleState.xAutoQuit			:= FALSE;
	stExceptionCmdImpossibleState.stReaction		:= stReaction1;

	stWarningCmdImpossibleReaction.etDiag			:= GD.ET_Diag.ExecutionAborted;
	stWarningCmdImpossibleReaction.udiDiagExt		:= AXM_ET_DiagExt.CmdImpossibleReaction;
	stWarningCmdImpossibleReaction.sMsg				:= 'Impossible command on reaction'; (* Replaced on usage *)
	stWarningCmdImpossibleReaction.udiModuleId		:= iq_stStandardModuleItf.i_udiModuleId;
	stWarningCmdImpossibleReaction.sModuleName		:= iq_stStandardModuleItf.i_sModuleName;
	stWarningCmdImpossibleReaction.etSource			:= TPL.ET_ExceptionSource.AxisModule;
	stWarningCmdImpossibleReaction.timDelayTime	:= T#0MS;
	stWarningCmdImpossibleReaction.wHmiAttributes	:= 0;
	stWarningCmdImpossibleReaction.xAutoQuit		:= FALSE;

	stExceptionDriveFatal.etDiag			:= GD.ET_Diag.DriveConditionInvalid;
	stExceptionDriveFatal.udiDiagExt		:= AXM_ET_DiagExt.DriveExceptionFatal;
	stExceptionDriveFatal.sMsg				:= 'Drive diag'; (* Replaced on usage *)
	stExceptionDriveFatal.udiModuleId		:= iq_stStandardModuleItf.i_udiModuleId;
	stExceptionDriveFatal.sModuleName		:= iq_stStandardModuleItf.i_sModuleName;
	stExceptionDriveFatal.etSource			:= TPL.ET_ExceptionSource.AxisModule;
	stExceptionDriveFatal.timDelayTime		:= T#0MS;
	stExceptionDriveFatal.wHmiAttributes	:= 0;
	stExceptionDriveFatal.xAutoQuit			:= FALSE;
	stExceptionDriveFatal.stReaction		:= stReaction1;
	
	stExcepitonDrive.etDiag			:= GD.ET_Diag.DriveConditionInvalid;
	stExcepitonDrive.udiDiagExt		:= AXM_ET_DiagExt.DriveException;
	stExcepitonDrive.sMsg			:= 'Drive diag'; (* Replaced on usage *)
	stExcepitonDrive.udiModuleId	:= iq_stStandardModuleItf.i_udiModuleId;
	stExcepitonDrive.sModuleName	:= iq_stStandardModuleItf.i_sModuleName;
	stExcepitonDrive.etSource		:= TPL.ET_ExceptionSource.AxisModule;
	stExcepitonDrive.timDelayTime	:= T#0MS;
	stExcepitonDrive.wHmiAttributes	:= 0;
	stExcepitonDrive.xAutoQuit		:= FALSE;
	stExcepitonDrive.stReaction		:= stReaction2;

	stWarningDrive.etDiag			:= GD.ET_Diag.DriveConditionInvalid;
	stWarningDrive.udiDiagExt		:= AXM_ET_DiagExt.DriveWarning;
	stWarningDrive.sMsg				:= 'Drive warning'; (* Replaced on usage *)
	stWarningDrive.udiModuleId		:= iq_stStandardModuleItf.i_udiModuleId;
	stWarningDrive.sModuleName		:= iq_stStandardModuleItf.i_sModuleName;
	stWarningDrive.etSource			:= TPL.ET_ExceptionSource.AxisModule;
	stWarningDrive.timDelayTime		:= T#0MS;
	stWarningDrive.wHmiAttributes	:= 0;
	stWarningDrive.xAutoQuit		:= FALSE;
	stWarningDrive.stReaction		:= stReaction4;

	stExceptionPosHwLimit.etDiag			:= GD.ET_Diag.LimitReached;
	stExceptionPosHwLimit.udiDiagExt		:= AXM_ET_DiagExt.HwLimitPosReached;
	stExceptionPosHwLimit.sMsg				:= '';
	stExceptionPosHwLimit.udiModuleId		:= iq_stStandardModuleItf.i_udiModuleId;
	stExceptionPosHwLimit.sModuleName		:= iq_stStandardModuleItf.i_sModuleName;
	stExceptionPosHwLimit.etSource			:= TPL.ET_ExceptionSource.AxisModule;
	stExceptionPosHwLimit.timDelayTime		:= T#0MS;
	stExceptionPosHwLimit.wHmiAttributes	:= 0;
	stExceptionPosHwLimit.xAutoQuit			:= FALSE;
	stExceptionPosHwLimit.stReaction		:= stReaction3;

	stExceptionNegHwLimit.etDiag			:= GD.ET_Diag.LimitReached;
	stExceptionNegHwLimit.udiDiagExt		:= AXM_ET_DiagExt.HwLimitNegReached;
	stExceptionNegHwLimit.sMsg				:= '';
	stExceptionNegHwLimit.udiModuleId		:= iq_stStandardModuleItf.i_udiModuleId;
	stExceptionNegHwLimit.sModuleName		:= iq_stStandardModuleItf.i_sModuleName;
	stExceptionNegHwLimit.etSource			:= TPL.ET_ExceptionSource.AxisModule;
	stExceptionNegHwLimit.timDelayTime		:= T#0MS;
	stExceptionNegHwLimit.wHmiAttributes	:= 0;
	stExceptionNegHwLimit.xAutoQuit			:= FALSE;
	stExceptionNegHwLimit.stReaction		:= stReaction3;

	stWarningPosHwLimit.etDiag			:= GD.ET_Diag.LimitReached;
	stWarningPosHwLimit.udiDiagExt		:= AXM_ET_DiagExt.HwLimitPosWarning;
	stWarningPosHwLimit.sMsg			:= '';
	stWarningPosHwLimit.udiModuleId		:= iq_stStandardModuleItf.i_udiModuleId;
	stWarningPosHwLimit.sModuleName		:= iq_stStandardModuleItf.i_sModuleName;
	stWarningPosHwLimit.etSource		:= TPL.ET_ExceptionSource.AxisModule;
	stWarningPosHwLimit.timDelayTime	:= T#0MS;
	stWarningPosHwLimit.wHmiAttributes	:= 0;
	stWarningPosHwLimit.xAutoQuit		:= TRUE;

	stWarningNegHwLimit.etDiag			:= GD.ET_Diag.LimitReached;
	stWarningNegHwLimit.udiDiagExt		:= AXM_ET_DiagExt.HwLimitNegWarning;
	stWarningNegHwLimit.sMsg			:= '';
	stWarningNegHwLimit.udiModuleId		:= iq_stStandardModuleItf.i_udiModuleId;
	stWarningNegHwLimit.sModuleName		:= iq_stStandardModuleItf.i_sModuleName;
	stWarningNegHwLimit.etSource		:= TPL.ET_ExceptionSource.AxisModule;
	stWarningNegHwLimit.timDelayTime	:= T#0MS;
	stWarningNegHwLimit.wHmiAttributes	:= 0;
	stWarningNegHwLimit.xAutoQuit		:= TRUE;

	stExceptionVelLimitCrossed.etDiag			:= GD.ET_Diag.LimitReached;
	stExceptionVelLimitCrossed.udiDiagExt		:= AXM_ET_DiagExt.ReducedVelocityLImit;
	stExceptionVelLimitCrossed.sMsg				:= '';
	stExceptionVelLimitCrossed.udiModuleId		:= iq_stStandardModuleItf.i_udiModuleId;
	stExceptionVelLimitCrossed.sModuleName		:= iq_stStandardModuleItf.i_sModuleName;
	stExceptionVelLimitCrossed.etSource			:= TPL.ET_ExceptionSource.AxisModule;
	stExceptionVelLimitCrossed.timDelayTime		:= T#0MS;
	stExceptionVelLimitCrossed.wHmiAttributes	:= 0;
	stExceptionVelLimitCrossed.xAutoQuit		:= FALSE;
	stExceptionVelLimitCrossed.stReaction		:= stReaction1;
	
	stExceptionUnexpected.etDiag			:= GD.ET_Diag.UnexpectedProgramBehavior;
	stExceptionUnexpected.udiDiagExt		:= AXM_ET_DiagExt.UnknownFeedback;
	stExceptionUnexpected.sMsg				:= ''; (* Replaced on usage *)
	stExceptionUnexpected.udiModuleId		:= iq_stStandardModuleItf.i_udiModuleId;
	stExceptionUnexpected.sModuleName		:= iq_stStandardModuleItf.i_sModuleName;
	stExceptionUnexpected.etSource			:= TPL.ET_ExceptionSource.AxisModule;
	stExceptionUnexpected.timDelayTime		:= T#0MS;
	stExceptionUnexpected.wHmiAttributes	:= 0;
	stExceptionUnexpected.xAutoQuit			:= FALSE;
	stExceptionUnexpected.stReaction		:= stReaction1;

	stExceptionModuleReaction1.etDiag			:= GD.ET_Diag.InputParameterInvalid;(* Replaced on usage *)
	stExceptionModuleReaction1.udiDiagExt		:= AXM_ET_DiagExt.DriveInvalid;(* Replaced on usage *)
	stExceptionModuleReaction1.sMsg				:= '';(* Replaced on usage *)
	stExceptionModuleReaction1.udiModuleId		:= iq_stStandardModuleItf.i_udiModuleId;
	stExceptionModuleReaction1.sModuleName		:= iq_stStandardModuleItf.i_sModuleName;
	stExceptionModuleReaction1.etSource			:= TPL.ET_ExceptionSource.AxisModule;
	stExceptionModuleReaction1.timDelayTime		:= T#0MS;
	stExceptionModuleReaction1.wHmiAttributes	:= 0;
	stExceptionModuleReaction1.xAutoQuit		:= FALSE;
	stExceptionModuleReaction1.stReaction		:= stReaction1;

	stExceptionModuleReaction2.etDiag			:= GD.ET_Diag.InputParameterInvalid;(* Replaced on usage *)
	stExceptionModuleReaction2.udiDiagExt		:= AXM_ET_DiagExt.DriveInvalid;(* Replaced on usage *)
	stExceptionModuleReaction2.sMsg				:= '';(* Replaced on usage *)
	stExceptionModuleReaction2.udiModuleId		:= iq_stStandardModuleItf.i_udiModuleId;
	stExceptionModuleReaction2.sModuleName		:= iq_stStandardModuleItf.i_sModuleName;
	stExceptionModuleReaction2.etSource			:= TPL.ET_ExceptionSource.AxisModule;
	stExceptionModuleReaction2.timDelayTime		:= T#0MS;
	stExceptionModuleReaction2.wHmiAttributes	:= 0;
	stExceptionModuleReaction2.xAutoQuit		:= FALSE;
	stExceptionModuleReaction2.stReaction		:= stReaction2;

	stExceptionModuleReaction3.etDiag			:= GD.ET_Diag.InputParameterInvalid;(* Replaced on usage *)
	stExceptionModuleReaction3.udiDiagExt		:= AXM_ET_DiagExt.DriveInvalid;(* Replaced on usage *)
	stExceptionModuleReaction3.sMsg				:= '';(* Replaced on usage *)
	stExceptionModuleReaction3.udiModuleId		:= iq_stStandardModuleItf.i_udiModuleId;
	stExceptionModuleReaction3.sModuleName		:= iq_stStandardModuleItf.i_sModuleName;
	stExceptionModuleReaction3.etSource			:= TPL.ET_ExceptionSource.AxisModule;
	stExceptionModuleReaction3.timDelayTime		:= T#0MS;
	stExceptionModuleReaction3.wHmiAttributes	:= 0;
	stExceptionModuleReaction3.xAutoQuit		:= FALSE;
	stExceptionModuleReaction3.stReaction		:= stReaction3;

	stExceptionModuleReaction4.etDiag			:= GD.ET_Diag.InputParameterInvalid;(* Replaced on usage *)
	stExceptionModuleReaction4.udiDiagExt		:= AXM_ET_DiagExt.DriveInvalid;(* Replaced on usage *)
	stExceptionModuleReaction4.sMsg				:= '';(* Replaced on usage *)
	stExceptionModuleReaction4.udiModuleId		:= iq_stStandardModuleItf.i_udiModuleId;
	stExceptionModuleReaction4.sModuleName		:= iq_stStandardModuleItf.i_sModuleName;
	stExceptionModuleReaction4.etSource			:= TPL.ET_ExceptionSource.AxisModule;
	stExceptionModuleReaction4.timDelayTime		:= T#0MS;
	stExceptionModuleReaction4.wHmiAttributes	:= 0;
	stExceptionModuleReaction4.xAutoQuit		:= FALSE;
	stExceptionModuleReaction4.stReaction		:= stReaction4;
	

	IF (iq_stAxisModuleItf.stMain.i_ifDrive = 0) THEN
		stExceptionModuleReaction1.etDiag		:= GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction1.udiDiagExt	:= AXM_ET_DiagExt.DriveInvalid;
		stExceptionModuleReaction1.sMsg			:= 'No drive given';
		ReportException(iq_stException := stExceptionModuleReaction1);
	ELSE
		iq_stStandardModuleItf.q_xActive := TRUE;
		FOR udii := 1 TO TPL.Gc_udiMaxNumberOfReactions DO
			stLocalReaction.axReaction[udii] := FALSE;
		END_FOR
		xSuccess := __QUERYINTERFACE(iq_stAxisModuleItf.stMain.i_ifDrive, ifGetParentDevice);
		IF xSuccess THEN
			ifDeviceAccess := ifGetParentDevice.GetParentDevice();
			xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifDeviceTreeObjectAccess);
			IF xSuccess THEN
				iq_stAxisModuleItf.stMain.q_sDriveName := ifDeviceTreeObjectAccess.DeviceTreeObject.Name;
			END_IF
		ELSE
			//no device tree object
			iq_stAxisModuleItf.stMain.q_sDriveName := '';
		END_IF
		xEnableFlag := TRUE;

		stCamTab:=	iq_stAxisModuleItf.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Idle];
		xInitHomingDone := FALSE;
		udiInitHoming := 0;
		iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.Initializing;
		xStartBitLastCycle := FALSE;
		etPowerState := AXM_ET_PowerState.PowerOff;
		
		IF fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.UserAction THEN
			fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
										i_etDiag		:= GD.ET_Diag.Ok,
										i_udiDiagExt	:= AXM_ET_DiagExt.Ok,
										i_sMessage		:= 'enabeling Module',
										q_etDiag		:= ,
										q_etDiagExt		:= );
		END_IF
		fbDriveEnable.RegisterLoggerPoint(	i_ifParent	:= fbLoggerPoint,
											i_sName		:= 'DriveEnable',
											q_etDiag	=> ,
											q_etDiagExt => );
	END_IF

END_IF
THIS^.Output_active();
