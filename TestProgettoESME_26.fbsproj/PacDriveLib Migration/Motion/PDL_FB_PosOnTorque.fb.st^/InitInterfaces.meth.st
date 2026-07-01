__METADATA__
{
  "v3Meta": {
    "objectGuid": "17b19519-112c-44f4-abb4-81de9b0338d1",
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
METHOD InitInterfaces : BOOL
VAR_INPUT
END_VAR
__IMPLEMENTATION__

	IF i_ifDrive = 0 THEN
		q_etDiag	:= GD.ET_Diag.InputParameterInvalid; 
		q_etDiagExt := PDL_ET_DiagExt.DriveInvalid;
		q_sMsg		:= 'i_ifDrive - Invalid Interface';
		RETURN;	
	END_IF

	xSuccess := __QUERYINTERFACE(i_ifDrive, ifGetParentDevice);
	IF NOT xSuccess OR ifGetParentDevice = 0 THEN
		q_etDiag	:= GD.ET_Diag.InputParameterInvalid; 
		q_etDiagExt := PDL_ET_DiagExt.DriveInvalid;
		q_sMsg		:= 'i_ifDrive - IF_GetParentDevice not implemented.';
		RETURN;
	END_IF
	ifDeviceAccess := ifGetParentDevice.GetParentDevice();

	xSuccess := __QUERYINTERFACE(ifDeviceAccess,ifDriveConfigAccess ); 
	IF (NOT xSuccess OR ifDriveConfigAccess = 0) THEN
		q_etDiag	:= GD.ET_Diag.InputParameterInvalid; 
		q_etDiagExt := PDL_ET_DiagExt.DriveInvalid;
		q_sMsg		:= 'i_ifDrive - IF_DriveConfig not implemented.';
		diState := 0;
		RETURN;
	END_IF
	ifDriveConfig := ifDriveConfigAccess.DriveConfig;

	xSuccess := __QUERYINTERFACE(ifDeviceAccess,ifDriveCurrentAccess ); 
	IF (NOT xSuccess OR ifDriveCurrentAccess = 0) THEN
		q_etDiag	:= GD.ET_Diag.InputParameterInvalid; 
		q_etDiagExt := PDL_ET_DiagExt.DriveInvalid;
		q_sMsg		:= 'i_ifDrive - IF_DriveCurrent not implemented.';
		diState := 0;
		RETURN;
	END_IF
	ifDriveCurrent := ifDriveCurrentAccess.DriveCurrent;
	
	xSuccess := __QUERYINTERFACE(ifDeviceAccess,ifDriveAccess ); 
	IF (NOT xSuccess OR ifDriveAccess = 0) THEN
		q_etDiag	:= GD.ET_Diag.InputParameterInvalid; 
		q_etDiagExt := PDL_ET_DiagExt.DriveInvalid;
		q_sMsg		:= 'i_ifDrive - IF_Drive not implemented.';
		diState := 0;
		RETURN;
	END_IF
	ifDrive := ifDriveAccess.Drive;

	xSuccess := __QUERYINTERFACE(ifDeviceAccess,ifMotorAccess ); 
	IF (NOT xSuccess OR ifMotorAccess = 0) THEN
		q_etDiag	:= GD.ET_Diag.InputParameterInvalid; 
		q_etDiagExt := PDL_ET_DiagExt.DriveInvalid;
		q_sMsg		:= 'i_ifDrive - IF_Motor not implemented.';
		diState := 0;
		RETURN;
	END_IF
	ifMotor := ifMotorAccess.Motor;
