__METADATA__
{
  "v3Meta": {
    "objectGuid": "85dd6061-8eea-46f0-9db9-efabd9aa932e",
    "objectTypeGuid": "6f9dac99-8de1-4efc-8465-68ac443b7d08",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {
      "_3S.CoDeSys.LanguageModelManager.BuildProperty": "<?xml version=\"1.0\" encoding=\"utf-8\"?><Single xml:space=\"preserve\" Type=\"{24568a24-c491-472c-a21f-ee5d33859fab}\" Method=\"IArchivable\"><Single Name=\"MemoryReserveForOnlineChange\" Type=\"int\">0</Single><Single Name=\"ExcludeFromBuild\" Type=\"bool\">False</Single><Single Name=\"External\" Type=\"bool\">False</Single><Single Name=\"EnableSystemCall\" Type=\"bool\">False</Single><Single Name=\"CompilerDefines\" Type=\"string\"></Single><Single Name=\"LinkAlways\" Type=\"bool\">True</Single><Array Name=\"Undefines\" Type=\"string\" /></Single>"
    },
    "subObjects": {}
  },
  "linkAlways": true
}
__DECLARATION__
FUNCTION_BLOCK PDL_FB_WriteDriveEncoder
VAR_INPUT
	i_xEnable        : BOOL;
	i_ifDrive        : MOIN.IF_Axis;
	i_lrHomePos      : LREAL;
	i_lrAbsEncOffset : LREAL;
	i_lrUserPeriod   : LREAL;
	i_xExecute       : BOOL;
END_VAR

VAR_OUTPUT
	q_xActive   : BOOL;
	q_xReady    : BOOL;
	q_xBusy     : BOOL;
	q_xDone     : BOOL;
	q_etDiag    : GD.ET_Diag     := GD.ET_Diag.OK;
	q_etDiagExt : PDL_ET_DiagExt := PDL_ET_DiagExt.Disabled;
	q_sMsg      : STRING[80];
END_VAR

VAR CONSTANT
	c_lrStandStillVel : LREAL := 10.0;
	c_timDisableTime  : TIME  := T#1500MS;
	c_timProgramTime  : TIME  := T#1000MS;
	c_lrRealNull      : LREAL := 10E-12;
END_VAR
VAR
	ifScalingAccess        : DMFI.IF_ScalingAccess;
	ifScaling              : DMFI.IF_Scaling;
	ifDrive2Access         : DDI.IF_Drive2Access;
	ifDrive2               : DDI.IF_Drive2;
	ifDriveConfigAccess    : DDI.IF_DriveConfigAccess;
	ifDriveConfig          : DDI.IF_DriveConfig;
	ifDriveAccess          : DMFI.IF_DriveAccess;
	ifDrive                : DMFI.IF_Drive;
	ifMotorAccess          : DDI.IF_MotorAccess;
	ifMotor                : DDI.IF_Motor;
	ifEncoderAccess        : DDI.IF_EncoderAccess;
	ifEncoder              : DDI.IF_Encoder;
	ifLXM62DriveAccess     : LXM62SI.IF_Lexium62DriveAccess;
	ifLXM62Drive           : LXM62SI.IF_Lexium62Drive;
	ifWorkingModeAccess    : CFDI.IF_WorkingModeAccess;
	ifWorkingMode          : CFDI.IF_WorkingMode;
	ifDeviceType		   : DeviceTypeInterfaces.IF_Device_Type;
	xSuccess               : BOOL;
	xInterfacesInitialised : BOOL;
	
	xEnableFlag : BOOL;
	
	diResult         : DINT;
	diState          : DINT;
	lrEncoderPeriode : LREAL;
	lrSavePosition   : LREAL;
	tonTimeOut       : Standard.TON;
	diSercosState    : DINT;
	uiI              : UINT;
	lrSum            : LREAL;
	lrAverage        : LREAL;
	alrA             : ARRAY[0..17] OF LREAL;
	xValid           : BOOL;
	lrModuloPosition : LREAL;
	xAxisEnableFlag  : BOOL;
	
	lrEncoderRange : LREAL;
	etDiag         : GD.ET_Diag;
	etDiagExt      : PDL_ET_DiagExt;
	
	fbSetDrvEncPos         : PDL_FB_SetDrvEncPos;
	fbSetDrvEncPosGetState : PDL_FB_SetDrvEncPosGetState;
	lrPositionTemp         : LREAL;
	diWritePositionState   : DINT;
	xError                 : BOOL;
	etResult               : SE_Async.ET_Result;
	sResultMsg             : STRING(80);
	fbPower                : PLCO.MC_Power;
	sMsg                   : STRING(80);
END_VAR
__IMPLEMENTATION__
IF i_xEnable AND NOT xEnableFlag THEN (* Pos. edge on i_xExecute *)
	xEnableFlag := TRUE;
	
	q_xActive := TRUE;
	q_xReady  := FALSE;
	q_xDone   := FALSE;
	
	SetDiagOutput(i_etDiag := GD.ET_Diag.OK, i_etDiagExt := PDL_ET_DiagExt.Initializing, i_sMsg := '');
	
	diState := 0;
	
	xInterfacesInitialised := FALSE;
	
	IF ParameterCheckEnable() THEN
		xInterfacesInitialised := TRUE;
		
		IF SE_Async.G_ifAsyncMgr.xInitDone THEN
			q_xReady := TRUE;
			SetDiagOutput(i_etDiag := GD.ET_Diag.OK, i_etDiagExt := PDL_ET_DiagExt.WaitForExecute, i_sMsg := '');
			diState := 5;
		ELSE
			SE_Async.G_ifAsyncMgr.Init();
			diState := 150;
		END_IF
	END_IF
	
ELSIF NOT i_xEnable AND xEnableFlag THEN (* Neg. edge on Enable *)
	xEnableFlag := FALSE;
	
	xInterfacesInitialised := FALSE;
	
	q_xActive := FALSE;
	q_xReady  := FALSE;
	q_xBusy   := FALSE;
	q_xDone   := FALSE;
	
	SetDiagOutput(i_etDiag := GD.ET_Diag.OK, i_etDiagExt := PDL_ET_DiagExt.Disabled, i_sMsg := '');
	diState := 0;
	
ELSIF NOT q_xActive THEN
	RETURN;
END_IF

IF xInterfacesInitialised THEN
	AverageVel();
	q_xBusy := q_etDiag = GD.ET_Diag.Ok AND NOT q_xDone AND diState > 5;
END_IF

CASE diState OF
	
	-1000:
		IF fbSetDrvEncPosGetState.xDone THEN
			diState := 21;
		END_IF
	-1003:
		SE_Async.G_ifAsyncMgr.Init(q_xError => xError, q_etResult => etResult, q_sResultMsg => sResultMsg);
		IF xError THEN
			AsyncExtDiagTranslation(i_etResult := etResult);
			diState := 0;
		ELSIF SE_Async.G_ifAsyncMgr.xInitDone THEN
			q_xReady := TRUE;
			SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitForExecute, i_sMsg := '');
			diState := 5;
		END_IF
	0: (* Idle or Error *)
		;
	5:
		IF i_xExecute THEN
			
			lrSavePosition  := i_ifDrive.RefPosition; (* Save Axis Position *)
			xAxisEnableFlag := i_ifDrive.etAxisState >= MOIN.ET_AxisState.Standstill; (* Save state of Axis *)
			//fb needs a edge therefore calling fb twice
			fbPower(Axis := i_ifDrive, Enable := TRUE);
			fbPower(Axis := i_ifDrive, Enable := FALSE);
			
			tonTimeOut(IN := FALSE, PT := c_timDisableTime);
			xValid := FALSE;
			
			FOR uiI := 1 TO 16 DO (* delete array of AverageVel() *)
				alrA[uiI] := 0;
			END_FOR
			
			uiI   := 1;
			lrSum := 0;
			
			SetDiagOutput(i_etDiag := GD.ET_Diag.OK, i_etDiagExt := PDL_ET_DiagExt.WaitUntilDriveDisabled, i_sMsg := '');
			diState := 6;
		END_IF
	6:
		tonTimeOut(IN := TRUE);
		
		IF tonTimeOut.Q THEN
			diState := 10;
		END_IF
	10: (* Waiting for axis disabled *)
		
		(* Timeout for disabling axis and axis not standing *)
		IF (ABS(lrAverage) >= c_lrStandStillVel) THEN
			q_xReady := FALSE;
			
			SetDiagOutput(i_etDiag := GD.ET_Diag.DriveConditionInvalid, i_etDiagExt := PDL_ET_DiagExt.DriveIsMoving, i_sMsg := '');
			diState := 0;
			
			(* Timeout for disabling axis and axis not disabled*)
		ELSIF i_ifDrive.etAxisState > MOIN.ET_AxisState.Disabled THEN
			q_xReady := FALSE;
			
			SetDiagOutput(i_etDiag := GD.ET_Diag.DriveConditionInvalid, i_etDiagExt := PDL_ET_DiagExt.DriveNotDisabled, i_sMsg := '');
			
			diState := 0;
			
			(* Timeout for disabling axis and axis is disabled and standing*)
		ELSIF (ABS(lrAverage) < c_lrStandStillVel) THEN
			diState              := 11; // 	WritePosition();	
			diWritePositionState := 10;
		END_IF
	11:
		WritePosition();
	20: (* Wait for programming done *)
		tonTimeOut(IN := TRUE);
		(* Writing time over *)
		IF tonTimeOut.Q THEN
			fbSetDrvEncPosGetState.ifDeviceType := ifDeviceType;
			SE_Async.G_ifAsyncMgr.Start(i_ifAsync := fbSetDrvEncPosGetState, q_etResult => etResult, q_sResultMsg => sResultMsg, q_xError => xError);
			
			IF xError THEN
				AsyncExtDiagTranslation(i_etResult := etResult);
				RETURN;
			ELSE
				diState := -1000;
			END_IF
		END_IF
	21:
		diResult := fbSetDrvEncPosGetState.diResultSetDrvEncGetState;
		IF diResult = 0 THEN
			
			PDL_FC_ReadDriveEncoder(
				i_ifDrive        := i_ifDrive, (* Read Position from Encoder *)
				i_lrHomePos      := i_lrHomePos,
				i_lrAbsEncOffset := i_lrAbsEncOffset,
				i_lrUserPeriod   := i_lrUserPeriod,
				q_etDiag         => etDiag,
				q_etDiagExt      => etDiagExt,
				q_sMsg			 => sMsg
			);
			
			IF etDiag <> GD.ET_Diag.Ok THEN
				q_xReady := FALSE;
				
				SetDiagOutput(
					i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
					i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
					i_sMsg      := CONCAT('FC_ReadDriveEncoder: ', UDINT_TO_STRING(etDiagExt))
				);
				
				diState := 0;
				RETURN;
			END_IF
			
			IF xAxisEnableFlag THEN (* Restore original State *)
				//fb needs a edge therefore calling fb twice
				fbPower(Axis := i_ifDrive, Enable := FALSE);
				fbPower(Axis := i_ifDrive, Enable := TRUE);
				IF fbPower.Error THEN
					q_xReady := FALSE;
					
					SetDiagOutput(
						i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
						i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
						i_sMsg      := CONCAT('fbPower: ', TO_STRING(fbPower.ErrorId))
					);
					
					diState := 0;
					RETURN;
				END_IF
				
				SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitUntilDriveEnabled, i_sMsg := '');
				diState := 30;
			ELSE
				q_xDone := TRUE;
				
				SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WritingPositionDone, i_sMsg := '');
				
				diState := 0;
			END_IF
			
		ELSIF diResult = 2 THEN
			q_xReady := FALSE;
			
			SetDiagOutput(i_etDiag := GD.ET_Diag.DriveConditionInvalid, i_etDiagExt := PDL_ET_DiagExt.ProgrammingInvalidEEPROM, i_sMsg := '');
			diState := 0;
			
		ELSIF diResult = 3 THEN
			q_xReady := FALSE;
			
			SetDiagOutput(i_etDiag := GD.ET_Diag.DriveConditionInvalid, i_etDiagExt := PDL_ET_DiagExt.NoAccessToEEPROM, i_sMsg := '');
			diState := 0;
			
		ELSE
			q_xReady := FALSE;
			
			SetDiagOutput(i_etDiag := GD.ET_Diag.UnexpectedProgramBehavior, i_etDiagExt := PDL_ET_DiagExt.EncoderWriteTimeOut, i_sMsg := '');
			diState := 0;
		END_IF
	30: (* Wait for AxisState => standstill *)
		IF i_ifDrive.etAxisState >= MOIN.ET_AxisState.Standstill THEN
			q_xDone := TRUE;
			
			SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WritingPositionDone, i_sMsg := '');
			
			diState := 0;
		END_IF
		
		(* End of case *)
	ELSE
		q_xReady := FALSE;
		
		SetDiagOutput(
			i_etDiag := GD.ET_Diag.UnexpectedProgramBehavior, i_etDiagExt := PDL_ET_DiagExt.UnknownState, i_sMsg := DINT_TO_STRING(diState)
		);
		diState := 0;
END_CASE
