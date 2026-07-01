__METADATA__
{
  "v3Meta": {
    "objectGuid": "431951bb-cc3c-466d-9ef2-f8a5b522f94c",
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
VAR_INPUT
END_VAR

VAR
	ifGetParentDevice      : DTSI.IF_GetParentDevice;
	ifDeviceAccess         : DTSI.IF_DeviceAccess;
END_VAR
__IMPLEMENTATION__
InitInterfaces := FALSE;
IF i_ifDrive = 0 THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg		:= 'i_ifDrive - Invalid Interface');
	RETURN;	
ELSE
	xSuccess := __QUERYINTERFACE(i_ifDrive, ifGetParentDevice);
	IF NOT xSuccess OR ifGetParentDevice = 0 THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
						i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
						i_sMsg		:= 'i_ifDrive - IF_GetParentDevice not implemented.');
		RETURN;
	END_IF
	ifDeviceAccess := ifGetParentDevice.GetParentDevice();

	xSuccess := __QUERYINTERFACE(ifDeviceAccess,ifDriveConfigAccess ); 
	IF (NOT xSuccess OR ifDriveConfigAccess = 0) THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
						i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
						i_sMsg		:= 'i_ifDrive - IF_DriveConfig not implemented.');
		diState := 0;
		RETURN;
	END_IF
	ifDriveConfig := ifDriveConfigAccess.DriveConfig;

	xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifDeviceTreeObjectAccess);
	IF xSuccess THEN
		sDriveName := ifDeviceTreeObjectAccess.DeviceTreeObject.Name;
	ELSE
		sDriveName := 'Axis';
	END_IF
	
	THIS^.fbHalt.Axis         := i_ifDrive;
	THIS^.fbStop.Axis         := i_ifDrive;
	THIS^.fbSetPos.Axis       := i_ifDrive;
	THIS^.fbMoveRelative.Axis := i_ifDrive;
END_IF


InitInterfaces := TRUE;
