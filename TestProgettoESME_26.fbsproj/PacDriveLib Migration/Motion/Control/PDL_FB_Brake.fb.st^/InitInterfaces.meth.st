__METADATA__
{
  "v3Meta": {
    "objectGuid": "a4f43fad-eb3d-480f-a2f1-22c55380a9d8",
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
{attribute 'conditionalshow_all_locals'}
METHOD PRIVATE InitInterfaces : BOOL
VAR_INPUT
END_VAR
__IMPLEMENTATION__
InitInterfaces := FALSE;
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
					i_sMsg		:= 'i_ifDrive - ifGetParentDevice not implemented');	
	RETURN;
ELSE
	ifDeviceAccess := ifGetParentDevice.GetParentDevice();
END_IF

xSuccess := __QUERYINTERFACE(ifDeviceAccess,ifBrakeAccess);
IF NOT xSuccess OR ifBrakeAccess = 0 THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg		:= 'i_ifDrive - IF_Brake not implemented');	
	RETURN;
END_IF
ifBrake := ifBrakeAccess.Brake;

xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifWorkingModeAccess);
IF NOT xSuccess OR ifWorkingModeAccess = 0 THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg		:= 'i_ifDrive - IF_WorkingMode not implemented');	
	RETURN;
END_IF
ifWorkingMode := ifWorkingModeAccess.WorkingMode;

xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifDeviceTreeObjectAccess);
IF xSuccess THEN
	sDriveName := ifDeviceTreeObjectAccess.DeviceTreeObject.Name;
ELSE
	sDriveName := '';
END_IF

InitInterfaces := TRUE;
