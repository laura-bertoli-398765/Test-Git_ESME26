__METADATA__
{
  "v3Meta": {
    "objectGuid": "afde0fe7-df52-4277-9a3a-d8f8e3aa70e8",
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
FUNCTION_BLOCK PDL_FB_HomeTorque
VAR_INPUT
	i_xEnable        : BOOL;
	i_ifDrive        : MOIN.IF_Axis;
	i_lrMaxTorque    : LREAL;
	i_diTorqueTime   : DINT;
	i_lrLowLimit     : LREAL;
	i_lrHighLimit    : LREAL;
	i_etMode         : PDL_ET_HomeTorqueMode;
	i_lrOffset       : LREAL;
	i_lrMaxTravel    : LREAL;
	i_lrHomePosition : LREAL;
	i_lrVel          : LREAL;
	i_lrAcc          : LREAL;
	i_lrDec          : LREAL;
	i_lrJerk         : LREAL;
	i_xStart         : BOOL;
END_VAR
VAR_OUTPUT
	q_xActive                  : BOOL;
	q_xReady                   : BOOL;
	q_etDiag                   : GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt                : PDL_ET_DiagExt := PDL_ET_DiagExt.Disabled;
	q_sMsg                     : STRING[80];
	q_xMotionInstructionActive : BOOL;
	q_lrPosition               : LREAL;
	q_xHomeOk                  : BOOL;
END_VAR
VAR
	fbLoggerPoint            : APL.FB_LoggerPoint;
	ifDeviceTreeObjectAccess : UFMPLCI.IF_DeviceTreeObjectAccess;
	sDriveName               : STRING(80);
	ifDriveConfigAccess      : DDI.IF_DriveConfigAccess;
	ifDriveConfig            : DDI.IF_DriveConfig;
	ifDriveCurrent           : DDI.IF_DriveCurrent;
	ifDriveCurrentAccess     : DDI.IF_DriveCurrentAccess;
	ifDrive2                 : DDI.IF_Drive2;
	ifDrive2Access           : DDI.IF_Drive2Access;
	ifDriveAccess            : DMFI.IF_DriveAccess;
	ifDrive                  : DMFI.IF_Drive;
	xSuccess                 : BOOL;
	xInterfacesInitialised   : BOOL;
	
	xEnableFlag : BOOL;
	
	diState   : DINT;
	etDiagExt : PDL_ET_DiagExt;
	
	fbStop                      : PLCO.MC_Stop;
	fbSetPos                    : PLCO.MC_SetPosition;
	xError                      : BOOL;
	etResult                    : SE_Async.ET_Result;
	sResultMsg                  : STRING(80);
	xStartFlag                  : BOOL;
	lrOldUserCurrentLimit       : REAL;
	lrOldTrackingDeviationLimit : LREAL;
	fbSetTrackDev               : PDL_FB_SetTrackingDeviation;
	fbResetTrackDev             : PDL_FB_ResetTrackingDeviation;
	fbPosOnTorque               : PDL_FB_PosOnTorque;
END_VAR
__IMPLEMENTATION__
IF i_xEnable AND NOT xEnableFlag THEN
	xEnableFlag := TRUE;
	THIS^.fbLoggerPoint.AddLogEntry(
		i_etLogLevel := APL.ET_LogLevel.UserAction,
		i_etDiag     := q_etDiag,
		i_udiDiagExt := q_etDiagExt,
		i_sMessage   := 'enable function block',
		q_etDiag     =>,
		q_etDiagExt  =>
	);
	q_xActive                  := TRUE;
	q_xReady                   := FALSE;
	q_xHomeOk                  := FALSE;
	q_xMotionInstructionActive := FALSE;
	diState                    := 0;
	SetDiagOutput(
		i_etDiag    := GD.ET_Diag.OK,
		i_etDiagExt := PDL_ET_DiagExt.Initializing,
		i_sMsg      := ''
	);
	
	xSuccess := InitInterfaces();
	IF NOT xSuccess THEN
		xInterfacesInitialised := FALSE;
		RETURN;
	END_IF
	
	xSuccess := InputParameterCheck();
	IF NOT xSuccess THEN
		RETURN;
	END_IF
	i_ifDrive.xIsHomed         := FALSE;
	fbStop(Execute := FALSE);
	
	xStartFlag             := FALSE;
	xInterfacesInitialised := TRUE;
	lrOldUserCurrentLimit  := ifDriveCurrent.UserCurrentLimit;
	diState                := -10000;
	
ELSIF NOT i_xEnable AND xEnableFlag THEN
	xEnableFlag := FALSE;
	THIS^.fbLoggerPoint.AddLogEntry(
		i_etLogLevel := APL.ET_LogLevel.UserAction,
		i_etDiag     := q_etDiag,
		i_udiDiagExt := q_etDiagExt,
		i_sMessage   := 'disable function block',
		q_etDiag     =>,
		q_etDiagExt  =>
	);
	q_xReady := FALSE;
	IF xInterfacesInitialised THEN
		IF ABS(ifDrive2.TrackingDeviation) > lrOldTrackingDeviationLimit THEN
			fbSetPos(
				Execute  := TRUE,
				Position := ifDrive.ActualPosition,
				Relative := FALSE
			);
			fbSetPos(Execute := FALSE);
		END_IF
		SetDiagOutput(
			i_etDiag    := GD.ET_Diag.OK,
			i_etDiagExt := PDL_ET_DiagExt.WaitUntilDisabled,
			i_sMsg      := ''
		);
		ifDriveCurrent.UserCurrentLimit := lrOldUserCurrentLimit;
		diState                         := -10010;
	ELSE
		q_xActive                  := FALSE;
		q_lrPosition               := 0.0;
		q_xMotionInstructionActive := FALSE;
		q_xHomeOk                  := FALSE;
		xInterfacesInitialised     := FALSE;
		SetDiagOutput(
			i_etDiag    := GD.ET_Diag.OK,
			i_etDiagExt := PDL_ET_DiagExt.Disabled,
			i_sMsg      := ''
		);
		diState := 0;
	END_IF
END_IF

IF xInterfacesInitialised AND q_xActive THEN
	IF i_ifDrive.etAxisState < MOIN.ET_AxisState.Standstill AND diState > 0 AND diState < 100 THEN
		diState                    := 0;
		q_xReady                   := FALSE;
		q_xMotionInstructionActive := FALSE;
		SetDiagOutput(
			i_etDiag    := GD.ET_Diag.DriveConditionInvalid,
			i_etDiagExt := PDL_ET_DiagExt.DriveNotReady,
			i_sMsg 		:= STANDARD.CONCAT(sDriveName,': AxisState < Standstill')
		);
	END_IF
	q_lrPosition := i_ifDrive.RefPosition;
END_IF

CASE diState OF
	-10000: // State for Set TrackingDeviation
		IF SE_Async.G_ifAsyncMgr.xInitDone THEN
			fbSetTrackDev.ifDrive2 := ifDrive2;
			SE_Async.G_ifAsyncMgr.Start(
				i_ifAsync    := fbSetTrackDev,
				q_etResult   => etResult,
				q_sResultMsg => sResultMsg,
				q_xError     => xError
			);
			IF xError THEN
				AsyncExtDiagTranslation(i_etResult := etResult);
				RETURN;
			ELSE
				diState := -10001;
			END_IF
		ELSE
			SE_Async.G_ifAsyncMgr.Init(
				q_xError     => xError,
				q_etResult   => etResult,
				q_sResultMsg => sResultMsg
			);
			IF xError THEN
				AsyncExtDiagTranslation(i_etResult := etResult);
				diState := 0;
			END_IF
		END_IF
	-10001: //Waiting State for Set TrackingDeviation Done
		IF fbSetTrackDev.xDone THEN
			lrOldTrackingDeviationLimit := fbSetTrackDev.lrOldTrackDevLim;
			q_xReady                    := TRUE;
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.OK,
				i_etDiagExt := PDL_ET_DiagExt.WaitForStart,
				i_sMsg      := ''
			);
			diState := 10;
		END_IF
	-10010:
		IF SE_Async.G_ifAsyncMgr.xInitDone THEN
			fbResetTrackDev.ifDrive2         := ifDrive2;
			fbResetTrackDev.lrOldTrackDevLim := lrOldTrackingDeviationLimit;
			SE_Async.G_ifAsyncMgr.Start(
				i_ifAsync    := fbResetTrackDev,
				q_etResult   => etResult,
				q_sResultMsg => sResultMsg,
				q_xError     => xError
			);
			IF xError THEN
				AsyncExtDiagTranslation(i_etResult := etResult);
				RETURN;
			ELSE
				diState := -10011;
			END_IF
		ELSE
			SE_Async.G_ifAsyncMgr.Init(
				q_xError     => xError,
				q_etResult   => etResult,
				q_sResultMsg => sResultMsg
			);
			IF xError THEN
				AsyncExtDiagTranslation(i_etResult := etResult);
				diState := 0;
			END_IF
		END_IF
	-10011: // Wait for TrackDev reset
		IF fbResetTrackDev.xDone THEN
			fbStop(Execute := TRUE);
			diState := 100;
		END_IF
	0: (* Exception or No Enable or ready  *)
		;
	10: (* Wait for Start*)
		IF i_xStart AND NOT xStartFlag THEN
			xStartFlag := TRUE;
			THIS^.fbLoggerPoint.AddLogEntry(
				i_etLogLevel := APL.ET_LogLevel.UserAction,
				i_etDiag     := q_etDiag,
				i_udiDiagExt := q_etDiagExt,
				i_sMessage   := 'start homing'
			);
			xSuccess := InputParameterCheck();
			IF NOT xSuccess THEN
				q_xReady := FALSE;
				diState  := 0;
				RETURN;
			END_IF
			q_xHomeOk          := FALSE;
			i_ifDrive.xIsHomed := FALSE;
			
			CASE i_etMode OF
				PDL_ET_HomeTorqueMode.PosDirectionMaxTorque: (* Mode 0:  pos. Direction and MaxTorque *)
					fbPosOnTorque(
						i_ifDrive        := i_ifDrive,
						i_lrMaxTorque    := i_lrMaxTorque,
						i_diTorqueTime   := i_diTorqueTime,
						i_lrLowLimit     := i_lrLowLimit,
						i_lrHighLimit    := i_lrHighLimit,
						i_lrMaxTravel    := ABS(i_lrMaxTravel),
						i_lrOffset       := -ABS(i_lrOffset),
						i_lrVelocity     := i_lrVel,
						i_lrAcceleration := i_lrAcc,
						i_lrDeceleration := i_lrDec,
						i_lrJerk         := i_lrJerk,
						i_xStart         := TRUE
					);
				PDL_ET_HomeTorqueMode.NegDirectionMaxTorque: (* Mode 1:  neg. Direction and MaxTorque *)
					fbPosOnTorque(
						i_ifDrive        := i_ifDrive,
						i_lrMaxTorque    := i_lrMaxTorque,
						i_diTorqueTime   := i_diTorqueTime,
						i_lrLowLimit     := i_lrLowLimit,
						i_lrHighLimit    := i_lrHighLimit,
						i_lrMaxTravel    := -ABS(i_lrMaxTravel),
						i_lrOffset       := ABS(i_lrOffset),
						i_lrVelocity     := i_lrVel,
						i_lrAcceleration := i_lrAcc,
						i_lrDeceleration := i_lrDec,
						i_lrJerk         := i_lrJerk,
						i_xStart         := TRUE
					);
				ELSE
					q_xReady := FALSE;
					SetDiagOutput(
						i_etDiag    := GD.ET_Diag.InputParameterInvalid,
						i_etDiagExt := PDL_ET_DiagExt.UnknownMode,
						i_sMsg      := ''
					);
					diState := 0;
					RETURN;
			END_CASE
			q_xMotionInstructionActive := TRUE;
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.OK,
				i_etDiagExt := PDL_ET_DiagExt.WaitUntilMaxTorqueReached,
				i_sMsg      := ''
			);
			diState := 20;
		ELSIF NOT i_xStart AND xStartFlag THEN
			xStartFlag := FALSE;
		END_IF
	20:
		fbPosOnTorque(i_xStart := FALSE);
		IF fbPosOnTorque.q_etDiagExt = PDL_ET_DiagExt.WaitForStart THEN
			q_xHomeOk                  := fbPosOnTorque.q_xTorqueOk;
			q_xMotionInstructionActive := FALSE;
			IF q_xHomeOk THEN
				fbSetpos(
					Execute  := TRUE,
					Relative := FALSE,
					Position := i_lrHomePosition
				);
				IF fbSetpos.Error THEN
					SetDiagOutput(
						i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
						i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
						i_sMsg      := CONCAT('MC_Setpos: ',PLCO.FC_EtResultToString(fbSetpos.ErrorId))
					);
					RETURN;
				END_IF
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.OK,
					i_etDiagExt := PDL_ET_DiagExt.HomingDone,
					i_sMsg      := ''
				);
				fbSetpos(Execute := FALSE);
				diState := 10;
			ELSE
				i_ifDrive.xIsHomed := FALSE;
				q_xReady           := FALSE;
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
					i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
					i_sMsg      := CONCAT('FB_PosOnTorque: ',PDL_FC_EtDiagExtToString(i_etDiagExt := fbPosOnTorque.q_etDiagExt))
				);
				diState := 0;
			END_IF
			
		ELSIF fbPosOnTorque.q_etDiag <> GD.ET_Diag.Ok THEN
			i_ifDrive.xIsHomed         := FALSE;
			q_xMotionInstructionActive := FALSE;
			q_xReady                   := FALSE;
			SetDiagOutput(
				i_etDiag    := fbPosOnTorque.q_etDiag,
				i_etDiagExt := fbPosOnTorque.q_etDiagExt,
				i_sMsg      := fbPosOnTorque.q_sMsg
			);
			diState := 0;
		END_IF
	100: (* Wait until stopped *)
		fbStop(Execute := TRUE);
		IF
			i_ifDrive.etAxisState = MOIN.ET_AxisState.Disabled OR
			i_ifDrive.etAxisState = MOIN.ET_AxisState.ErrorStop OR
			i_ifDrive.etAxisState = MOIN.ET_AxisState.Standstill OR
			fbStop.Done
		THEN
			fbStop(Execute := FALSE);
			xInterfacesInitialised     := FALSE;
			q_xMotionInstructionActive := FALSE;
			q_xActive                  := FALSE;
			q_lrPosition               := 0.0;
			q_xHomeOk                  := FALSE;
			
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.OK,
				i_etDiagExt := PDL_ET_DiagExt.Disabled,
				i_sMsg      := ''
			);
			diState := 0;
		END_IF
		
		IF fbStop.Error AND fbStop.ErrorId <> PLCO.ET_Result.StoppingInterrupted THEN
			q_xMotionInstructionActive := FALSE;
			q_xReady                   := FALSE;
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
				i_sMsg      := CONCAT('MC_Stop: ',PLCO.FC_EtResultToString(fbStop.ErrorId))
			);
			fbStop(Execute := FALSE);
			diState := 0;
		END_IF
		
		(* Ende Case *)
	ELSE
		q_xReady                   := FALSE;
		q_xMotionInstructionActive := FALSE;
		SetDiagOutput(
			i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
			i_etDiagExt := PDL_ET_DiagExt.UnknownState,
			i_sMsg      := DINT_TO_STRING(diState)
		);
		diState := 0;
END_CASE
