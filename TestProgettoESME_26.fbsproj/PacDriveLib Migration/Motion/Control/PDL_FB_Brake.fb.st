__METADATA__
{
  "v3Meta": {
    "objectGuid": "395ce99c-f83e-4ff7-a42f-68a07e0753b4",
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
FUNCTION_BLOCK PDL_FB_Brake
VAR_INPUT
	i_xEnable  : BOOL;
	i_xRelease : BOOL;
	i_ifDrive  : Moin.IF_Axis;
END_VAR
VAR_OUTPUT
	q_xActive   : BOOL;
	q_xReady    : BOOL;
	q_etDiag    : GD.ET_Diag     := GD.ET_Diag.Ok;
	q_etDiagExt : PDL_ET_DiagExt := PDL_ET_DiagExt.Disabled;
	q_sMsg      : STRING[80];
	q_xReleased : BOOL;
END_VAR
VAR
	xSuccess                 : BOOL;
	ifDeviceTreeObjectAccess : UFMPLCI.IF_DeviceTreeObjectAccess;
	sDriveName               : STRING(80);
	ifBrakeAccess            : DDI.IF_BrakeAccess;
	ifBrake                  : DDI.IF_Brake;
	ifGetParentDevice        : DTSI.IF_GetParentDevice;
	ifDeviceAccess           : DTSI.IF_DeviceAccess;
	ifWorkingModeAccess      : CFDI.IF_WorkingModeAccess;
	ifWorkingMode            : CFDI.IF_WorkingMode;
	etWorkingState           : CFDI.ET_WorkingState;
	etSercosState            : SMI.ET_SercosState;
	etAxisState              : MOIN.ET_AxisState;
	etDiagExt                : PDL_ET_DiagExt := PDL_ET_DiagExt.Disabled;
	diState                  : DINT;
	xEnableFlag              : BOOL;
	fbLoggerPoint            : APL.FB_LoggerPoint;
	fbBrakeReleaseSet        : FB_BrakeReleaseSet;
	fbBrakeDisconnectionTime : FB_BrakeDisconnectionTime;
	fbBrakeCouplingTime      : FB_BrakeCouplingTime;
	xError                   : BOOL;
	tonTimeOutBrake          : Standard.TON;
	tonTimeOutException      : Standard.TON;
	tBrakeCouplingTemp       : TIME := T#500MS;
	tBrakeDisconnectTemp     : TIME := T#500MS;
	sResultMsg               : STRING(80);
	etResult                 : SE_Async.ET_Result;
	
END_VAR
VAR CONSTANT
	c_timTimeOutException : TIME := T#1S;
END_VAR
__IMPLEMENTATION__
IF i_xEnable AND NOT xEnableFlag THEN (* Input action *)
	xEnableFlag := TRUE;
	
	THIS^.fbLoggerPoint.AddLogEntry(
		i_etLogLevel := APL.ET_LogLevel.UserAction,
		i_etDiag     := q_etDiag,
		i_udiDiagExt := q_etDiagExt,
		i_sMessage   := 'enable function block',
		q_etDiag     =>,
		q_etDiagExt  => );
		
	q_xActive   := TRUE;
	q_xReady    := FALSE;
	q_xReleased := FALSE;
	SetDiagOutput(
		i_etDiag    := GD.ET_Diag.Ok,
		i_etDiagExt := PDL_ET_DiagExt.Initializing,
		i_sMsg      := '');
	xSuccess := InitInterfaces();
	IF NOT xSuccess THEN
		RETURN;
	ELSE
		IF SE_Async.G_ifAsyncMgr.xInitDone THEN
			q_xReady    := TRUE;
			q_xReleased := (ifBrake.BrakeState = DDI.ET_BrakeState.released);
			IF q_xReleased THEN // Bremse is open --> wait for closing Brake (i_xRelease = false)
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.Ok,
					i_etDiagExt := PDL_ET_DiagExt.WaitForNotRelease,
					i_sMsg      := '');
				diState := 40;
			ELSE // brake is closed --> wait for opening brake (i_xRelease = true)
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.Ok,
					i_etDiagExt := PDL_ET_DiagExt.WaitForRelease,
					i_sMsg      := '');
				diState := 10;
			END_IF
		ELSE
			SE_Async.G_ifAsyncMgr.Init();
			diState := 150;
		END_IF
	END_IF
	
ELSIF NOT i_xEnable AND xEnableFlag AND q_xActive THEN
	xEnableFlag := FALSE;
	THIS^.fbLoggerPoint.AddLogEntry(
		i_etLogLevel := APL.ET_LogLevel.UserAction,
		i_etDiag     := q_etDiag,
		i_udiDiagExt := q_etDiagExt,
		i_sMessage   := 'disable function block',
		q_etDiag     =>,
		q_etDiagExt  => );
	SetDiagOutput(
		i_etDiag    := GD.ET_Diag.Ok,
		i_etDiagExt := PDL_ET_DiagExt.WaitUntilDisabled,
		i_sMsg      := '');
		
	q_xReady := FALSE;
	IF diState = 10 THEN // Brake is already closed
		diState := 120;
	ELSE
		fbBrakeReleaseSet.ifBrake  := ifBrake;
		fbBrakeReleaseSet.xRelease := FALSE;
		SE_Async.G_ifAsyncMgr.Start(
			i_ifAsync    := fbBrakeReleaseSet,
			q_etResult   => etResult,
			q_sResultMsg => sResultMsg,
			q_xError     => xError);
		IF xError THEN
			diState := 120;
		ELSE
			tonTimeOutBrake(IN := FALSE, PT := c_timTimeOutException);
			diState := 100;
		END_IF
	END_IF
END_IF

IF q_xReady THEN
	etSercosState  := FC_GetSercosState();
	etWorkingState := ifWorkingMode.ActualState;
	etAxisState    := i_ifDrive.etAxisState;
	IF etSercosState <> SMI.ET_SercosState.Phase4 THEN
		q_xReady    := FALSE;
		q_xReleased := FALSE;
		SetDiagOutput(
			i_etDiag    := GD.ET_Diag.SercosConditionInvalid,
			i_etDiagExt := PDL_ET_DiagExt.SercosNotInPhaseFour,
			i_sMsg      := 'Sercos not in phase four');
		diState := 0;
	ELSIF etWorkingState = CFDI.ET_WorkingState.Deactivated THEN
		q_xReady    := FALSE;
		q_xReleased := FALSE;
		SetDiagOutput(
			i_etDiag    := GD.ET_Diag.DriveConditionInvalid,
			i_etDiagExt := PDL_ET_DiagExt.DriveNotReady,
			i_sMsg		:= STANDARD.CONCAT(sDriveName, '.WorkingMode = deactivated'));
		diState := 0;
	ELSIF etAxisState <> Moin.ET_AxisState.Disabled THEN
		q_xReady    := FALSE;
		q_xReleased := FALSE;
		SetDiagOutput(
			i_etDiag    := GD.ET_Diag.DriveConditionInvalid,
			i_etDiagExt := PDL_ET_DiagExt.DriveNotReady,
			i_sMsg		:= STANDARD.CONCAT(sDriveName, '.AxisState <> Disabled; Drive has to be disabled'));
		diState := 0;
	END_IF
END_IF

CASE diState OF
	0: (* No operation / FB disabled *)
		;
	10: // Brake closed, wait for releasing Brake (i_xRelease = true)
		IF i_xRelease THEN // input release Brake 
			fbLoggerPoint.AddLogEntry(
				i_etLogLevel := APL.ET_LogLevel.UserAction,
				i_etDiag     := q_etDiag,
				i_udiDiagExt := q_etDiagExt,
				i_sMessage   := 'Release Brake - read out disconnection time',
				q_etDiag     =>,
				q_etDiagExt  => );
			etSercosState := FC_GetSercosState();
			fbBrakeDisconnectionTime.ifBrake  := ifBrake;
			SE_Async.G_ifAsyncMgr.Start(
				i_ifAsync    := fbBrakeDisconnectionTime, // read Disconnecting time from Drive 
				q_etResult   => etResult,
				q_sResultMsg => sResultMsg,
				q_xError     => xError);
			IF xError THEN
				IF etResult = SE_Async.ET_Result.MaxNumOfReusableObjectsExceeded THEN
					diState := diState; // Try again to Start Async in next cycle
				ELSE
					AsyncExtDiagTranslation();
					diState := 200;
				END_IF
			ELSE
				tonTimeOutBrake(IN := FALSE, PT := c_timTimeOutException);
				diState := 15;
			END_IF
		END_IF
	15: // Wait for BrakeDisconnectionTime has been read
		tonTimeOutBrake(IN := TRUE);
		IF fbBrakeDisconnectionTime.xDone THEN
			tBrakeDisconnectTemp       := fbBrakeDisconnectionTime.timTime;
			fbBrakeReleaseSet.ifBrake  := ifBrake;
			fbBrakeReleaseSet.xRelease := TRUE;
			SE_Async.G_ifAsyncMgr.Start(
				i_ifAsync    := fbBrakeReleaseSet,
				q_etResult   => etResult,
				q_sResultMsg => sResultMsg,
				q_xError     => xError);
			IF xError THEN
				IF etResult = SE_Async.ET_Result.MaxNumOfReusableObjectsExceeded THEN
					diState := diState; // Try again to Start Async in next cycle
				ELSE
					AsyncExtDiagTranslation();
					diState := 200;
				END_IF
			ELSE
				fbLoggerPoint.AddLogEntry(
					i_etLogLevel := APL.ET_LogLevel.DebugMessage,
					i_etDiag     := q_etDiag,
					i_udiDiagExt := q_etDiagExt,
					i_sMessage   := 'Release Brake - brake release set',
					q_etDiag     =>,
					q_etDiagExt  => );
				tonTimeOutBrake(IN := FALSE, PT := c_timTimeOutException);
				diState := 20;
			END_IF
		ELSIF tonTimeOutBrake.Q THEN
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.AsyncAddWasNotSuccessful,
				i_sMsg      := 'Timeout at read of BrakeDisconnectionTime');
			diState := 200;
		END_IF
	20: // Wait for Brake is release, Release Commando Done
		tonTimeOutBrake(IN := TRUE);
		IF fbBrakeReleaseSet.xDone THEN
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.Ok,
				i_etDiagExt := PDL_ET_DiagExt.WaitUntilBrakeReleased,
				i_sMsg      := '');
			tonTimeOutBrake(IN := FALSE, PT := tBrakeDisconnectTemp);
			tonTimeOutException(IN := FALSE, PT := c_timTimeOutException);
			diState := 25;
		ELSIF tonTimeOutBrake.Q THEN
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.AsyncAddWasNotSuccessful,
				i_sMsg      := 'Timeout at BrakeReleaseSet');
			diState := 200;
		END_IF
	25: // wait till brake has to be open (check both, system signal and own time out)
		tonTimeOutBrake(IN := TRUE);
		tonTimeOutException(IN := TRUE);
		IF tonTimeOutBrake.Q THEN 
			IF (ifBrake.BrakeState = DDI.ET_BrakeState.released) THEN // Brake is released
				q_xReleased := TRUE;
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.Ok,
					i_etDiagExt := PDL_ET_DiagExt.WaitForNotRelease,
					i_sMsg      := '');
				diState := 40;
			ELSE
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
					i_etDiagExt := PDL_ET_DiagExt.BrakeStateChangedNotInTime,
					i_sMsg      := 'Timeout at wait for Brake Release');
				diState := 200;
			END_IF
		ELSIF tonTimeOutException.Q THEN
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.BrakeStateChangedNotInTime,
				i_sMsg      := 'Timeout at wait for Brake Release');
			diState := 200;
		END_IF
	40: // Brake released, wait for Brake is coupled (i_xRelease = FALSE)
		IF NOT i_xRelease THEN 
			fbLoggerPoint.AddLogEntry(
				i_etLogLevel := APL.ET_LogLevel.UserAction,
				i_etDiag     := q_etDiag,
				i_udiDiagExt := q_etDiagExt,
				i_sMessage   := 'Close Brake - read out coupling time',
				q_etDiag     =>,
				q_etDiagExt  => );
			fbBrakeCouplingTime.ifBrake  := ifBrake;
			SE_Async.G_ifAsyncMgr.Start(
				i_ifAsync    := fbBrakeCouplingTime,
				q_etResult   => etResult,
				q_sResultMsg => sResultMsg,
				q_xError     => xError);
			IF xError THEN
				IF etResult = SE_Async.ET_Result.MaxNumOfReusableObjectsExceeded THEN
					diState := diState; // Try again to Start Async in next cycle
				ELSE
					AsyncExtDiagTranslation();
					diState := 200;
				END_IF
			ELSE
				tonTimeOutBrake(IN := FALSE, PT := c_timTimeOutException);
				diState := 45;
			END_IF
		END_IF
	45: // wait for BrakeCouplingTime has been read out
		tonTimeOutBrake(IN := TRUE);
		IF fbBrakeCouplingTime.xDone THEN
			tBrakeCouplingTemp         := fbBrakeCouplingTime.timTime;
			fbBrakeReleaseSet.ifBrake  := ifBrake;
			fbBrakeReleaseSet.xRelease := FALSE;
			SE_Async.G_ifAsyncMgr.Start(
				i_ifAsync    := fbBrakeReleaseSet,
				q_etResult   => etResult,
				q_sResultMsg => sResultMsg,
				q_xError     => xError);
			IF xError THEN
				AsyncExtDiagTranslation();
				diState := 200;
			ELSE
				fbLoggerPoint.AddLogEntry(
					i_etLogLevel := APL.ET_LogLevel.DebugMessage,
					i_etDiag     := q_etDiag,
					i_udiDiagExt := q_etDiagExt,
					i_sMessage   := 'Close Brake - brake release set',
					q_etDiag     =>,
					q_etDiagExt  => );
				tonTimeOutBrake(IN := FALSE, PT := c_timTimeOutException);
				diState := 50;
			END_IF
		ELSIF tonTimeOutBrake.Q THEN
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.AsyncAddWasNotSuccessful,
				i_sMsg      := 'Timeout at read of BrakeCouplingTime');
			diState := 200;
		END_IF
	50: // Wait for BrakeRelaseSet Done	
		tonTimeOutBrake(IN := TRUE);
		IF fbBrakeReleaseSet.xDone THEN
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.Ok,
				i_etDiagExt := PDL_ET_DiagExt.WaitUntilBrakeClosed,
				i_sMsg      := '');
			tonTimeOutBrake(IN := FALSE, PT := tBrakeCouplingTemp);
			tonTimeOutException(IN := FALSE, PT := c_timTimeOutException);
			diState := 55;
		ELSIF tonTimeOutBrake.Q THEN
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.AsyncAddWasNotSuccessful,
				i_sMsg      := 'Timeout at BrakeReleaseSet');
			diState := 200;
		END_IF
	55: // wait till brake is closed (check both, system signal and own time out)
		tonTimeOutBrake(IN := TRUE);
		tonTimeOutException(IN := TRUE);
		IF tonTimeOutBrake.Q THEN 
			IF (ifBrake.BrakeState = DDI.ET_BrakeState.coupled)  THEN
				tonTimeOutException(IN := FALSE);
				tonTimeOutBrake(IN := FALSE);
				q_xReleased := FALSE;
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.Ok,
					i_etDiagExt := PDL_ET_DiagExt.WaitForRelease,
					i_sMsg      := '');
				diState := 10;
			ELSE
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
					i_etDiagExt := PDL_ET_DiagExt.BrakeStateChangedNotInTime,
					i_sMsg      := 'Timeout at wait for Brake coupled');
				diState := 200;
			END_IF
		ELSIF tonTimeOutBrake.Q THEN
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.BrakeStateChangedNotInTime,
				i_sMsg      := 'Timeout at wait for Brake Close');
			diState := 200;
		END_IF
		
		//---------------------------------------------------------------------------------		
	100:
		tonTimeOutBrake(IN := TRUE);
		IF fbBrakeReleaseSet.xDone THEN
			IF i_ifDrive.etAxisState = MOIN.ET_AxisState.Disabled THEN
				tonTimeOutBrake(IN := FALSE, PT := c_timTimeOutException);
				diState := 110;
			ELSE
				diState := 120;
			END_IF
		ELSIF tonTimeOutBrake.Q THEN
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.AsyncAddWasNotSuccessful,
				i_sMsg      := 'Timeout at FC_BrakeReleaseSet');
			diState := 120;
		END_IF
	110: (* AxisState = 1 or 2 *)
		tonTimeOutBrake(IN := TRUE);
		IF (ifBrake.BrakeState = DDI.ET_BrakeState.coupled) THEN
			tonTimeOutBrake(IN := FALSE, PT := tBrakeCouplingTemp);
			diState := 115;
		ELSIF tonTimeOutBrake.Q THEN
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.BrakeStateChangedNotInTime,
				i_sMsg      := 'Timeout at wait for Brake Close');
			diState := 120;
		END_IF
	115:
		tonTimeOutBrake(IN := TRUE);
		IF tonTimeOutBrake.Q THEN
			diState := 120;
		END_IF
	120:
		q_xActive   := FALSE;
		q_xReady    := FALSE;
		q_xReleased := FALSE;
		SetDiagOutput(
			i_etDiag    := GD.ET_Diag.Ok,
			i_etDiagExt := PDL_ET_DiagExt.Disabled,
			i_sMsg      := '');
		tonTimeOutBrake(IN := FALSE);
		diState := 0;
		
	150:
		SE_Async.G_ifAsyncMgr.Init(
			q_xError     => xError,
			q_etResult   => etResult,
			q_sResultMsg => sResultMsg);
		IF xError THEN
			AsyncExtDiagTranslation();
			diState := 200;
		ELSIF SE_Async.G_ifAsyncMgr.xInitDone THEN 
			q_xReady    := TRUE;
			q_xReleased := (ifBrake.BrakeState = DDI.ET_BrakeState.released);
			IF q_xReleased THEN // Bremse is open --> wait for closing Brake (i_xRelease = false)
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.Ok,
					i_etDiagExt := PDL_ET_DiagExt.WaitForNotRelease,
					i_sMsg      := '');
				diState := 40;
			ELSE // brake is closed --> wait for opening brake (i_xRelease = true)
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.Ok,
					i_etDiagExt := PDL_ET_DiagExt.WaitForRelease,
					i_sMsg      := '');
				diState := 10;
			END_IF
		END_IF
		
	200: 		
		q_xReady    := FALSE;
		q_xReleased := (ifBrake.BrakeState = DDI.ET_BrakeState.released);
		diState := 0;
		
		
		
END_CASE
