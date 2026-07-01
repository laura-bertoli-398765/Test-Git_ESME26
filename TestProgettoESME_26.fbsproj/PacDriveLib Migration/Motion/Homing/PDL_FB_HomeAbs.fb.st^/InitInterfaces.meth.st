__METADATA__
{
  "v3Meta": {
    "objectGuid": "bfa68033-3ce8-4ad4-a34a-009b8a843912",
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
METHOD PRIVATE InitInterfaces : BOOL

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
					i_sMsg		:= 'i_ifDrive = 0');
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

xSuccess := __QUERYINTERFACE(ifDeviceAccess,ifDrive2Access ); 
IF (NOT xSuccess OR ifDrive2Access = 0) THEN
	q_etDiag	:= GD.ET_Diag.InputParameterInvalid; 
	q_etDiagExt := PDL_ET_DiagExt.DriveInvalid;
	q_sMsg		:= 'i_ifDrive - IF_Drive2 not implemented.';
	RETURN;
END_IF
ifDrive2 := ifDrive2Access.Drive2;
	
xSuccess := __QUERYINTERFACE(ifDeviceAccess,ifDriveAccess ); 
IF (NOT xSuccess OR ifDriveAccess = 0) THEN
	q_etDiag	:= GD.ET_Diag.InputParameterInvalid; 
	q_etDiagExt := PDL_ET_DiagExt.DriveInvalid;
	q_sMsg		:= 'i_ifDrive - IF_Drive not implemented.';
	RETURN;
END_IF
ifDrive := ifDriveAccess.Drive;

xSuccess := __QUERYINTERFACE(ifDeviceAccess,ifDriveConfigAccess ); 
IF (NOT xSuccess OR ifDriveConfigAccess = 0) THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg		:= 'i_ifDrive - IF_DriveConfig not implemented.');
	diState := 0;
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

xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifDeviceType); 
IF (NOT xSuccess OR ifDeviceType = 0) THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg 		:= 'i_ifDrive - IF_Device_Type not implemented');
	diState := 0;
	RETURN;
END_IF




InitInterfaces := TRUE;
