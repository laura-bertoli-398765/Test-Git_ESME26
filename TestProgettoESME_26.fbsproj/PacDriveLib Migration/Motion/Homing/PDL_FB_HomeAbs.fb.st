__METADATA__
{
  "v3Meta": {
    "objectGuid": "75539cb7-42f9-4380-b91f-de5ef9edfcd2",
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
FUNCTION_BLOCK PDL_FB_HomeAbs
VAR_INPUT
	i_xEnable        : BOOL;
	i_ifDrive        : MOIN.IF_Axis;
	i_lrHomePosition : LREAL;
	i_lrAbsEncOffset : LREAL;
	i_lrUserPeriod   : LREAL;
	i_xExecute       : BOOL;
END_VAR
VAR_OUTPUT
	q_xActive       : BOOL;
	q_xReady        : BOOL;
	q_xBusy         : BOOL;
	q_xDone         : BOOL;
	q_etDiag        : GD.ET_Diag     := GD.ET_Diag.Ok;
	q_etDiagExt     : PDL_ET_DiagExt := PDL_ET_DiagExt.Disabled;
	q_sMsg          : STRING[80];
	q_xDisableDrive : BOOL;
	q_lrPosition    : LREAL;
	q_xHomeOk       : BOOL;
END_VAR
VAR
	xEnableFlag      : BOOL;
	diState          : DINT;
	lrEncoderPeriode : LREAL;
	lrSavePosition   : LREAL;
	fbTonTimeOut     : TON;
	lrHomePosition   : LREAL;
	lrSetPosPosition : LREAL;
	fbHomeSetPos     : PDL_FB_HomeSetpos;
	lrVelocity       : LREAL;
	fbMovingAverage  : PDL_FB_MovingAverage;
	lrTurns          : LREAL;
	diSercosState    : DINT;
	
	ifScalingAccess     : DMFI.IF_ScalingAccess;
	ifScaling           : DMFI.IF_Scaling;
	ifDrive2Access      : DDI.IF_Drive2Access;
	ifDrive2            : DDI.IF_Drive2;
	ifDriveAccess       : DMFI.IF_DriveAccess;
	ifDrive             : DMFI.IF_Drive;
	ifDriveConfigAccess : DDI.IF_DriveConfigAccess;
	ifDriveConfig       : DDI.IF_DriveConfig;
	ifMotorAccess       : DDI.IF_MotorAccess;
	ifMotor             : DDI.IF_Motor;
	ifEncoderAccess     : DDI.IF_EncoderAccess;
	ifEncoder           : DDI.IF_Encoder;
	ifLXM62DriveAccess  : LXM62SI.IF_Lexium62DriveAccess;
	ifLXM62Drive        : LXM62SI.IF_Lexium62Drive;
	ifDeviceType		: DeviceTypeInterfaces.IF_Device_Type;
	
	xInterfacesInitialized : BOOL;
	xSuccess               : BOOL;
	
	sDummyString : STRING[80];
	etDiagInt    : GD.ET_Diag     := GD.ET_Diag.Ok;
	etDiagExtInt : PDL_ET_DiagExt := PDL_ET_DiagExt.Ok;
	
	fbSetDrvEncPosGetState                     : PDL_FB_SetDrvEncPosGetState;
	fbSetDrvEncPos                             : PDL_FB_SetDrvEncPos;
	etDiag                                     : GD.ET_Diag := GD.ET_Diag.Ok;
	etDiagExt                                  : PDL_ET_DiagExt := PDL_ET_DiagExt.Disabled;
	fbLoggerPoint                              : APL.FB_LoggerPoint;
	xError                                     : BOOL;
	etResult                                   : SE_Async.ET_Result;
	sResultMsg                                 : STRING(80);
	lrQuotientEncPeriodToUserPeriod            : LREAL;
	diTruncFromQuotient                        : DINT;
	lrAbsDifferenceQuotientToTruncFromQuotient : LREAL;
	xUserPeriodFitsIntoEncoderPeriod           : BOOL;
END_VAR

VAR CONSTANT
	c_lrNoVel         : LREAL := 10.0;
	c_timDisableTime  : TIME  := T#1500MS;
	c_timProgramTime  : TIME  := T#3000MS;
	c_timSettlingTime : TIME  := T#400MS;
END_VAR
__IMPLEMENTATION__
IF i_xEnable AND NOT xEnableFlag THEN (* Pos. edge on Enable *)
	xEnableFlag := TRUE;
	THIS^.fbLoggerPoint.AddLogEntry(
		i_etLogLevel := APL.ET_LogLevel.UserAction,
		i_etDiag     := q_etDiag,
		i_udiDiagExt := q_etDiagExt,
		i_sMessage   := 'enable function block',
		q_etDiag     =>,
		q_etDiagExt  =>
	);
	q_xActive       := TRUE;
	q_xReady        := FALSE;
	q_xBusy         := FALSE;
	q_xDone         := FALSE;
	q_xHomeOk       := FALSE;
	q_xDisableDrive := FALSE;
	fbTonTimeOut(IN := FALSE);
	xInterfacesInitialized := THIS^.InitInterfaces();
	IF (q_etDiag <> GD.ET_Diag.Ok) THEN
		diState := 0; // exception message is already set in ParameterCheckEnable()
	ELSE
		IF SE_Async.G_ifAsyncMgr.xInitDone THEN
			q_xReady := TRUE;
			SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitForExecute, i_sMsg := '');
			diState := 10;
		ELSE
			SE_Async.G_ifAsyncMgr.Init();
			diState := -10003;
		END_IF
	END_IF
	i_ifDrive.xIsHomed := FALSE;
	
ELSIF NOT i_xEnable AND xEnableFlag AND q_xActive THEN (* Neg. edge on Enable *)
	xEnableFlag := FALSE;
	THIS^.fbLoggerPoint.AddLogEntry(
		i_etLogLevel := APL.ET_LogLevel.UserAction,
		i_etDiag     := q_etDiag,
		i_udiDiagExt := q_etDiagExt,
		i_sMessage   := 'disable function block',
		q_etDiag     =>,
		q_etDiagExt  =>
	);
	fbTonTimeOut(IN := FALSE);
	fbHomeSetPos(i_xEnable := FALSE);
	xInterfacesInitialized := FALSE;
	
	q_xActive       := FALSE;
	q_xReady        := FALSE;
	q_xBusy         := FALSE;
	q_xDone         := FALSE;
	q_xDisableDrive := FALSE;
	q_lrPosition    := 0.0;
	q_xHomeOk       := FALSE;
	
	SetDiagOutput(i_etDiag := GD.ET_Diag.OK, i_etDiagExt := PDL_ET_DiagExt.Disabled, i_sMsg := '');
	diState := 0;
ELSIF NOT q_xActive THEN
	RETURN;
END_IF

// set position output cyclically
IF xInterfacesInitialized THEN
	lrVelocity   := i_ifDrive.RefVelocity;
	q_lrPosition := i_ifDrive.RefPosition;
	q_xBusy      := q_etDiag = GD.ET_Diag.Ok AND NOT q_xDone AND diState > 10;
ELSE
	diState  := 0;
	q_xReady := FALSE;
	RETURN;
END_IF

CASE diState OF
	-10001: (* WaitState for async jobs *)
		IF fbSetDrvEncPos.xDone = TRUE THEN
			diState := 24;
		END_IF
	-10002:
		IF fbSetDrvEncPosGetState.xDone = TRUE THEN
			diState := 31;
		END_IF
	-10003:
		SE_Async.G_ifAsyncMgr.Init(q_xError => xError, q_etResult => etResult, q_sResultMsg => sResultMsg);
		IF xError THEN
			AsyncExtDiagTranslation(i_etResult := etResult);
			diState := 0;
		ELSIF SE_Async.G_ifAsyncMgr.xInitDone THEN
			q_xReady := TRUE;
			SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitForExecute, i_sMsg := '');
			diState := 10;
		END_IF
	0:
		; (* Idle or Error *)
	10: (* Waiting for Start *)
		IF i_xExecute THEN
			THIS^.fbLoggerPoint.AddLogEntry(
				i_etLogLevel := APL.ET_LogLevel.UserAction,
				i_etDiag     := q_etDiag,
				i_udiDiagExt := q_etDiagExt,
				i_sMessage   := 'write position',
				q_etDiag     =>,
				q_etDiagExt  =>
			);
			lrEncoderPeriode 			:= ifEncoder.Revolutions 
											* ifScaling.PositionResolution 
											* TO_LREAL(ifScaling.GearIn) / TO_LREAL(ifScaling.GearOut) 
											* TO_LREAL( ifEncoder.GearOut) / TO_LREAL(ifEncoder.GearIn);

						// Calculation if UserPeriod fits into EncoderPeriod										
			IF (i_lrUserPeriod > CMT.Gc_lrZeroTolerance) AND (lrEncoderPeriode > CMT.Gc_lrZeroTolerance) THEN 			
						
				lrQuotientEncPeriodToUserPeriod					:= lrEncoderPeriode/i_lrUserPeriod;
				diTruncFromQuotient 							:= TRUNC(lrQuotientEncPeriodToUserPeriod);	
				lrAbsDifferenceQuotientToTruncFromQuotient		:= ABS (lrQuotientEncPeriodToUserPeriod - TO_LREAL(diTruncFromQuotient));
				
				IF (lrAbsDifferenceQuotientToTruncFromQuotient < CMT.Gc_lrZeroTolerance)
				OR ((1 - lrAbsDifferenceQuotientToTruncFromQuotient < CMT.Gc_lrZeroTolerance) AND (lrAbsDifferenceQuotientToTruncFromQuotient <= 1)) THEN
					xUserPeriodFitsIntoEncoderPeriod	:= TRUE;			
				ELSE
					xUserPeriodFitsIntoEncoderPeriod	:= FALSE;		
				END_IF
				
			END_IF									
			
			IF (i_lrUserPeriod < 0.0) THEN
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid,
								i_etDiagExt := PDL_ET_DiagExt.UserPeriodRange,
								i_sMsg		:= '0.0 <= i_lrUserPeriod');
				diState := 0;
			ELSIF (i_lrUserPeriod < CMT.Gc_lrZeroTolerance) AND ( (i_lrAbsEncOffset < CMT.Gc_lrZeroTolerance) OR (i_lrAbsEncOffset > (lrEncoderPeriode - CMT.Gc_lrZeroTolerance)) ) THEN
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid,
								i_etDiagExt := PDL_ET_DiagExt.AbsEncOffsetRange,
								i_sMsg		:= STANDARD.CONCAT('0.0 < i_lrAbsEncOffset <= ', SE_CTBX.FC_LrealToString(i_sFormat := '#0.00', i_lrInput := lrEncoderPeriode - CMT.Gc_lrZeroTolerance) ));
				diState := 0;
			(* Check if UserPeriode fits into EncoderPeriode. *)
			ELSIF (i_lrUserPeriod > CMT.Gc_lrZeroTolerance) AND NOT xUserPeriodFitsIntoEncoderPeriod THEN
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid,
								i_etDiagExt := PDL_ET_DiagExt.UserPeriodRange,
								i_sMsg		:= STANDARD.CONCAT('i_lrUserPeriod has to be a divsior of ', SE_CTBX.FC_LrealToString(i_sFormat := '#0.00', i_lrInput := lrEncoderPeriode)));
				diState := 0;

			ELSE
				q_xHomeOk       := FALSE;
				lrSavePosition  := ifdrive.ActualPosition; (* Store position before axis disabling *)
				q_xDisableDrive := TRUE; (* The Enable of the axis is switched off externally  *)
				fbTonTimeOut(IN := TRUE, PT := c_timDisableTime);
				SetDiagOutput(i_etDiag := GD.ET_Diag.OK, i_etDiagExt := PDL_ET_DiagExt.WaitUntilDriveDisabled, i_sMsg := '');
				q_xBusy := TRUE;
				q_xDone := FALSE;
				diState := 20;
				
				fbMovingAverage.Init(i_uiOrder := Gc_uiMovingAverageMaxOrder, q_etDiag => etDiagInt, q_etDiagExt => etDiagExtInt);
				IF etDiagInt <> GD.ET_Diag.Ok THEN
					SetDiagOutput(
						i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
						i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
						i_sMsg      := CONCAT('PDL_FB_MovingAverage.Init(): ', UDINT_TO_STRING(etDiagExtInt))
					);
					diState := 0;
				END_IF
			END_IF
		END_IF
	20: (* Waiting for axis disabled *)
		fbTonTimeOut();
		fbMovingAverage.Insert(i_lrValue := lrVelocity, q_etDiag => etDiagInt, q_etDiagExt => etDiagExtInt);
		IF etDiagInt <> GD.ET_Diag.Ok THEN
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
				i_sMsg      := CONCAT('PDL_FB_MovingAverage.Insert(): ', UDINT_TO_STRING(etDiagExtInt))
			);
			diState := 0;
		END_IF
		
		(* Timeout for disabling axis and axis is disabled and standing*)
		IF
			fbTonTimeOut.Q AND
			i_ifDrive.etAxisState <= Moin.ET_AxisState.Disabled AND
			ABS(fbMovingAverage.lrAverage) < c_lrNoVel AND
			(fbMovingAverage.uiLevel >= Gc_uiMovingAverageMaxOrder)
		THEN
			fbTonTimeOut(IN := FALSE);
			fbMovingAverage.Init(i_uiOrder := Gc_uiMovingAverageMaxOrder, q_etDiag => etDiagInt, q_etDiagExt => etDiagExtInt);
			IF etDiagInt <> GD.ET_Diag.Ok THEN
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
					i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
					i_sMsg      := CONCAT('PDL_FB_MovingAverage.Init(): ', UDINT_TO_STRING(etDiagExtInt))
				);
				diState := 0;
			END_IF
			diState := 22;
		END_IF
		
		(* Timeout for disabling axis and axis not standing *)
		IF fbTonTimeOut.Q AND ABS(fbMovingAverage.lrAverage) >= c_lrNoVel AND (fbMovingAverage.uiLevel >= Gc_uiMovingAverageMaxOrder) THEN
			fbTonTimeOut(IN := FALSE);
			fbMovingAverage.Init(i_uiOrder := Gc_uiMovingAverageMaxOrder, q_etDiag => etDiagInt, q_etDiagExt => etDiagExtInt);
			IF etDiagInt <> GD.ET_Diag.Ok THEN
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
					i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
					i_sMsg      := CONCAT('PDL_FB_MovingAverage.Init(): ', UDINT_TO_STRING(etDiagExtInt))
				);
				diState := 0;
			END_IF
			SetDiagOutput(i_etDiag := GD.ET_Diag.DriveConditionInvalid, i_etDiagExt := PDL_ET_DiagExt.DriveIsMoving, i_sMsg := '');
			diState := 0;
			
			(* Timeout for disabling axis and axis not disabled*)
		ELSIF fbTonTimeOut.Q AND i_ifDrive.etAxisState > MOIN.ET_AxisState.Disabled THEN
			fbTonTimeOut(IN := FALSE);
			fbMovingAverage.Init(i_uiOrder := Gc_uiMovingAverageMaxOrder, q_etDiag => etDiagInt, q_etDiagExt => etDiagExtInt);
			IF etDiagInt <> GD.ET_Diag.Ok THEN
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
					i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
					i_sMsg      := CONCAT('PDL_FB_MovingAverage.Init(): ', UDINT_TO_STRING(etDiagExtInt))
				);
				diState := 0;
			END_IF
			SetDiagOutput(i_etDiag := GD.ET_Diag.DriveConditionInvalid, i_etDiagExt := PDL_ET_DiagExt.DriveNotDisabled, i_sMsg := '');
			diState := 0;
		END_IF
	22:
		lrEncoderPeriode := ifEncoder.Revolutions * ifScaling.PositionResolution * TO_LREAL(ifScaling.GearIn) / TO_LREAL(ifScaling.GearOut);
		lrHomePosition   := lrSetPosPosition := i_lrHomePosition + ifDrive.ActualPosition - lrSavePosition;
		(* Bring lrHomePosition into Encoder period*)
		lrTurns := TRUNC_INT(lrHomePosition / lrEncoderPeriode);
		IF lrHomePosition < 0 THEN
			lrTurns := lrTurns - 1;
		END_IF
		lrHomePosition := lrHomePosition - lrTurns * lrEncoderPeriode;
		(* Write EEPROM depending on direction of motor *)
		IF ifScaling.InvertDirection = FALSE THEN (* Motor direction right *)
			IF lrHomePosition = lrEncoderPeriode THEN
				lrHomePosition := 0.0;
			END_IF
			fbSetDrvEncPos.lrPosition := lrHomePosition;
		ELSE (* Motor direction left *)
			IF (lrEncoderPeriode - lrHomePosition) = lrEncoderPeriode THEN
				fbSetDrvEncPos.lrPosition := 0.0;
			ELSE
				fbSetDrvEncPos.lrPosition := lrEncoderPeriode - lrHomePosition;
			END_IF
		END_IF
		
		fbSetDrvEncPos.ifDeviceType         := ifDeviceType;
		SE_Async.G_ifAsyncMgr.Start(i_ifAsync := fbSetDrvEncPos, q_etResult => etResult, q_sResultMsg => sResultMsg, q_xError => xError);
		IF xError THEN
			AsyncExtDiagTranslation(i_etResult := etResult);
			RETURN;
		ELSE
			diState := -10001;
		END_IF
	24:
		(* Check Result of writing *)
		IF fbSetDrvEncPos.diResultSetDrvEncPos = 0 THEN
			SetDiagOutput(i_etDiag := GD.ET_Diag.OK, i_etDiagExt := PDL_ET_DiagExt.WaitUntilEncoderWritten, i_sMsg := '');
			fbTonTimeOut(IN := TRUE, PT := c_timProgramTime);
			diState := 30; (* Wait for programming time over *)
		ELSIF fbSetDrvEncPos.diResultSetDrvEncPos = -3 THEN
			SetDiagOutput(
				i_etDiag := GD.ET_Diag.InputParameterInvalid, i_etDiagExt := PDL_ET_DiagExt.DriveInvalid, i_sMsg := 'Drive must not be virtual'
			);
			diState := 0;
		ELSIF fbSetDrvEncPos.diResultSetDrvEncPos = -4 THEN
			SetDiagOutput(
				i_etDiag := GD.ET_Diag.InputParameterInvalid, i_etDiagExt := PDL_ET_DiagExt.DriveInvalid, i_sMsg := 'Drive must not be deactivated'
			);
			diState := 0;
		ELSE (* Programming error *)
			SetDiagOutput(
				i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
				i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
				i_sMsg      := CONCAT('SystemInterface.FC_DrvEncSetPosition: ', DINT_TO_STRING(fbSetDrvEncPos.diResultSetDrvEncPos))
			);
			diState := 0;
		END_IF
	30: (* Wait for programming done *)
		(*Execute after increasing cycle-time or asynchronous*)
		(* increased cycle time was set before and is still active *)
		fbSetDrvEncPosGetState.ifDeviceType := ifDeviceType;
		SE_Async.G_ifAsyncMgr.Start(i_ifAsync := fbSetDrvEncPosGetState, q_etResult => etResult, q_sResultMsg => sResultMsg, q_xError => xError);
		IF xError THEN
			AsyncExtDiagTranslation(i_etResult := etResult);
			RETURN;
		ELSE
			diState := -10002;
		END_IF
	31:
		fbTonTimeOut();
		(* Programming finished *)
		IF fbSetDrvEncPosGetState.diResultSetDrvEncGetState = 1 THEN
			diState := 30;
			RETURN;
			
		ELSIF fbSetDrvEncPosGetState.diResultSetDrvEncGetState = 0 THEN
			fbTonTimeOut(IN := FALSE);
			fbTonTimeOut(IN := TRUE, PT := c_timSettlingTime); (* Delay before reading *)
			SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WritingPositionDone, i_sMsg := '');
			diState := 40;
			
		ELSIF fbSetDrvEncPosGetState.diResultSetDrvEncGetState = 2 THEN
			SetDiagOutput(i_etDiag := GD.ET_Diag.DriveConditionInvalid, i_etDiagExt := PDL_ET_DiagExt.ProgrammingInvalidEEPROM, i_sMsg := '');
			diState := 0;
			fbTonTimeOut(IN := FALSE);
			
		ELSIF fbSetDrvEncPosGetState.diResultSetDrvEncGetState = 3 THEN
			SetDiagOutput(i_etDiag := GD.ET_Diag.DriveConditionInvalid, i_etDiagExt := PDL_ET_DiagExt.NoAccessToEEPROM, i_sMsg := '');
			diState := 0;
			fbTonTimeOut(IN := FALSE);
			
		ELSIF fbTonTimeOut.Q THEN
			fbTonTimeOut(IN := FALSE);
			SetDiagOutput(i_etDiag := GD.ET_Diag.UnexpectedProgramBehavior, i_etDiagExt := PDL_ET_DiagExt.EncoderWriteTimeOut, i_sMsg := '');
			diState := 0;
		END_IF
	40: (* Wait for settling time over *)
		fbTonTimeOut();
		IF fbTonTimeOut.Q THEN
			fbTonTimeOut(IN := FALSE);
			fbHomeSetPos(
				i_xEnable        := TRUE, (* Set axis positions to the same position *)
				i_xExecute       := TRUE,
				i_ifDrive        := i_ifDrive,
				i_etMode         := PDL_ET_HomeSetPosMode.RestorePosFromAxisencoder,
				i_lrAbsEncOffset := i_lrAbsEncOffset,
				i_lrUserPeriod   := i_lrUserPeriod
			);
			
			SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitUntilPositionSetFromEncoder, i_sMsg := '');
			diState := 50;
		END_IF
	50: (* wait for fbHomeSetPos finished *)
		fbHomeSetPos();
		
		IF fbHomeSetPos.q_etDiag <> GD.ET_Diag.Ok THEN
			sDummyString :=
				SE_CTBX.FC_MultiConcat(
					i_sString1 := 'FB_HomeSetpos error: ',
					i_sString2 := PDL_FC_EtDiagExtToString(i_etDiagExt := fbHomeSetPos.q_etDiagExt),
					i_sString3 := '',
					i_sString4 := ''
				);
			SetDiagOutput(i_etDiag := GD.ET_Diag.UnexpectedProgramBehavior, i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback, i_sMsg := sDummyString);
			diState := 0;
		ELSIF NOT fbHomeSetPos.q_xBusy THEN (* Reading is finished without error *)
			q_xHomeOk := fbHomeSetPos.q_xHomeOk;
			fbHomeSetPos(i_xEnable := FALSE);
			q_xDisableDrive := FALSE; (* Enable Axis *)
			
			SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.HomingDone, i_sMsg := '');
			q_xDone := TRUE;
			diState := 60;
		END_IF
	60: (* Wait for NOT Execute *)
		IF NOT i_xExecute THEN
			SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitForExecute, i_sMsg := '');
			diState := 10;
		END_IF
	ELSE
		SetDiagOutput(
			i_etDiag := GD.ET_Diag.UnexpectedProgramBehavior, i_etDiagExt := PDL_ET_DiagExt.UnknownState, i_sMsg := DINT_TO_STRING(diState)
		);
		diState := 0;
END_CASE
