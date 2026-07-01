__METADATA__
{
  "v3Meta": {
    "objectGuid": "b89a5f7b-05e1-45a7-b54a-d98946a9078c",
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
METHOD PRIVATE EnableParameterCheck : BOOL
VAR
	xSuccess	: BOOL;
	ifGetParentDevice      : DTSI.IF_GetParentDevice;
	ifDeviceAccess         : DTSI.IF_DeviceAccess;
END_VAR
__IMPLEMENTATION__
EnableParameterCheck := FALSE;
// querry all interfaces during enabeling
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
	diState := 0;
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


xSuccess := __QUERYINTERFACE(i_ifTouchProbe, ifGetParentDevice);
IF NOT xSuccess OR ifGetParentDevice = 0 THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg		:= 'i_ifTouchProbe - IF_GetParentDevice not implemented.');
	RETURN;
END_IF
ifDeviceAccess := ifGetParentDevice.GetParentDevice();

xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifTouprobeDataAccess);
IF NOT xSuccess OR (ifTouprobeDataAccess = 0) THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.TouchProbeInvalid,
					i_sMsg		:= 'i_ifTouchProbe - IF_TouprobeDataAccess not implemented');
	RETURN;
END_IF
ifTouprobeData := ifTouprobeDataAccess.TouchprobeData;

xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifDeviceTreeObjectAccess);
IF xSuccess THEN
	sDriveName := ifDeviceTreeObjectAccess.DeviceTreeObject.Name;
ELSE
	sDriveName := '';
END_IF

IF NOT StartParameterCheck() THEN
	; // parametrization fault -> diag message already set in StartParameterCheck()
ELSE
	fbSetPos.Axis           	:= i_ifDrive;

	fbStop.Axis 				:= i_ifDrive;
	fbStop.Deceleration 		:= i_lrDec;
	fbStop.Jerk 				:= i_lrJerk;
	
	fbMoveAbsolute.Axis    		:= i_ifDrive;
	fbMoveAbsolute.Velocity 	:= i_lrVel;
	fbMoveAbsolute.Deceleration := i_lrDec;
	fbMoveAbsolute.Acceleration := i_lrAcc;
	fbMoveAbsolute.Jerk 		:= i_lrJerk;
	fbMoveAbsolute.BufferMode	:= PLCO.MC_Buffer_Mode.Aborting;
	fbMoveAbsolute.Direction	:= PLCO.MC_Direction.PositiveDirection; 
	
	fbMoveRelative.Axis     	:= i_ifDrive;
	fbMoveRelative.Velocity 	:= i_lrVel;
	fbMoveRelative.Deceleration := i_lrDec;
	fbMoveRelative.Acceleration := i_lrAcc;
	fbMoveRelative.Jerk 		:= i_lrJerk;
	fbMoveRelative.BufferMode	:= PLCO.MC_Buffer_Mode.Aborting;
	
	fbAbortTouchprobe.Axis  	:= i_ifDrive;
	fbAbortTouchprobe.ifTrigger	:= i_ifTouchProbe;
	
	fbTouchProbe.Axis 			:= i_ifDrive;
	fbTouchProbe.ifTrigger		:= i_ifTouchProbe;	

	EnableParameterCheck := TRUE;
END_IF
