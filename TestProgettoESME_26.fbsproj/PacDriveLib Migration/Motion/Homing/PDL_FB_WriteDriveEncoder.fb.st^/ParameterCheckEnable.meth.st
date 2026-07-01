__METADATA__
{
  "v3Meta": {
    "objectGuid": "152fbe54-1a68-46e2-9246-b0b7ae32a924",
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
METHOD PRIVATE ParameterCheckEnable : BOOL

VAR
	ifGetParentDevice      : DTSI.IF_GetParentDevice;
	ifDeviceAccess         : DTSI.IF_DeviceAccess;
END_VAR
__IMPLEMENTATION__
diSercosState := FC_GetSercosState();

IF diSercosState <> 4 THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.SercosConditionInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.SercosNotInPhaseFour,
					i_sMsg		:= '');
	RETURN;
END_IF

IF i_ifDrive = 0 THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg		:= 'i_ifDrive - Invalid Interface');
	RETURN;	
END_IF	
	
xSuccess := __QUERYINTERFACE(i_ifDrive, ifGetParentDevice);
IF NOT xSuccess OR ifGetParentDevice = 0 THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg		:= 'i_ifDrive - IF_GetParentDevice not implemented.');
	RETURN;
END_IF

ifDeviceAccess := ifGetParentDevice.GetParentDevice();

xSuccess := __QUERYINTERFACE(ifDeviceAccess,ifScalingAccess ); 
IF (NOT xSuccess OR ifScalingAccess = 0) THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg		:= 'i_ifDrive - IF_Scaling not implemented.');
	RETURN;
END_IF
ifScaling := ifScalingAccess.Scaling;

xSuccess := __QUERYINTERFACE(ifDeviceAccess,ifDriveAccess ); 
IF (NOT xSuccess OR ifDriveAccess = 0) THEN
	q_etDiag	:= GD.ET_Diag.InputParameterInvalid; 
	q_etDiagExt := PDL_ET_DiagExt.DriveInvalid;
	q_sMsg		:= 'i_ifDrive - IF_Drive not implemented.';
	RETURN;
END_IF
ifDrive := ifDriveAccess.Drive;

xSuccess := __QUERYINTERFACE(ifDeviceAccess,ifDrive2Access ); 
IF (NOT xSuccess OR ifDrive2Access = 0) THEN
	q_etDiag	:= GD.ET_Diag.InputParameterInvalid; 
	q_etDiagExt := PDL_ET_DiagExt.DriveInvalid;
	q_sMsg		:= 'i_ifDrive - IF_Drive2 not implemented.';
	RETURN;
END_IF
ifDrive2 := ifDrive2Access.Drive2;
	
xSuccess := __QUERYINTERFACE(ifDeviceAccess,ifDriveConfigAccess ); 
IF (NOT xSuccess OR ifDriveConfigAccess = 0) THEN
	q_etDiag	:= GD.ET_Diag.InputParameterInvalid; 
	q_etDiagExt := PDL_ET_DiagExt.DriveInvalid;
	q_sMsg		:= 'i_ifDrive - IF_Drive not implemented.';
	RETURN;
END_IF
ifDriveConfig := ifDriveConfigAccess.DriveConfig;

xSuccess := __QUERYINTERFACE(ifDeviceAccess,ifMotorAccess ); 
IF (NOT xSuccess OR ifMotorAccess = 0) THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg		:= 'i_ifDrive - IF_Motor not implemented.');
	diState := 0;
	RETURN;
END_IF
ifMotor := ifMotorAccess.Motor;

xSuccess := __QUERYINTERFACE(ifDeviceAccess,ifEncoderAccess ); 
IF (NOT xSuccess OR ifEncoderAccess = 0) THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg		:= 'i_ifDrive - IF_Encoder not implemented.');
	diState := 0;
	RETURN;
END_IF
ifEncoder := ifEncoderAccess.Encoder;

xSuccess := __QUERYINTERFACE(ifDeviceAccess,ifLXM62DriveAccess ); 
IF (NOT xSuccess OR ifLXM62DriveAccess = 0) THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg		:= 'i_ifDrive - IF_LXM62DriveAccess not implemented.');
	diState := 0;
	RETURN;
END_IF
ifLXM62Drive := ifLXM62DriveAccess.Lexium62Drive;

xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifWorkingModeAccess);
IF (NOT xSuccess OR ifLXM62DriveAccess = 0) THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg		:= 'i_ifDrive - IF_LXM62DriveAccess not implemented.');
	RETURN;
END_IF
ifWorkingMode := ifWorkingModeAccess.WorkingMode;

xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifDeviceType); 
IF (NOT xSuccess OR ifDeviceType = 0) THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg 		:= 'i_ifDrive - IF_Device_Type not implemented');
	diState := 0;
	RETURN;
END_IF

lrEncoderRange := ifEncoder.Revolutions;
IF (ABS(lrEncoderRange) < 1.0E-3) THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.DriveConditionInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DriveEncoderInvalid,
					i_sMsg		:= '');
	RETURN;
ELSE	
	lrEncoderPeriode := ifEncoder.Revolutions * ifScaling.PositionResolution * TO_LREAL(ifScaling.GearIn) / TO_LREAL(ifScaling.GearOut);
END_IF
			
IF (ifWorkingMode.ActualState <> CFDI.ET_WorkingState.Physical) THEN		// prüfen, ob Achse real und Motor angeschlossen
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.DriveConditionInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.NoRealDrive,
					i_sMsg		:= '');
	RETURN;
ELSIF (i_lrUserPeriod < 0.0) THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.UserPeriodRange,
					i_sMsg		:= '0.0 <= i_lrUserPeriod');
	RETURN;
ELSIF (i_lrUserPeriod < c_lrRealNull) AND ( (i_lrAbsEncOffset < c_lrRealNull) OR (i_lrAbsEncOffset > (lrEncoderPeriode - c_lrRealNull)) ) THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.AbsEncOffsetRange,
					i_sMsg		:= STANDARD.CONCAT('0.0 < i_lrAbsEncOffset <= ', SE_CTBX.FC_LrealToString(i_sFormat := '#0.00', i_lrInput := lrEncoderPeriode - c_lrRealNull) ));
	RETURN;
(* Check if UserPeriode fits into EncoderPeriode *)  
ELSIF(i_lrUserPeriod > c_lrRealNull) AND ( ABS(lrEncoderPeriode/i_lrUserPeriod - TRUNC_INT(lrEncoderPeriode / i_lrUserPeriod)) > c_lrRealNull ) THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.UserPeriodRange,
					i_sMsg		:= STANDARD.CONCAT('i_lrUserPeriod has to be a divsior of ', SE_CTBX.FC_LrealToString(i_sFormat := '#0.00', i_lrInput := lrEncoderPeriode)));	 
	RETURN;
END_IF	



ParameterCheckEnable := TRUE;
