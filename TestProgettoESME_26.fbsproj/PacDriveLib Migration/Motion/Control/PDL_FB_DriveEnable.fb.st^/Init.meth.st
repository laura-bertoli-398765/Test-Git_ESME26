__METADATA__
{
  "v3Meta": {
    "objectGuid": "5e6f3216-f829-4ed1-8ff7-ca40dd14205e",
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
{attribute 'hide'}
METHOD PRIVATE Init : BOOL
VAR_INPUT
END_VAR
__IMPLEMENTATION__
Init := FALSE;

IF i_ifDrive <> 0 THEN
	fbStop.Axis := i_ifDrive;
	fbPower.Axis := i_ifDrive;
	fbReset.Axis := i_ifDrive;
ELSE
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid,
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg		:= 'i_ifDrive - Invalid Interface');
	RETURN;
END_IF



xSuccess := __QUERYINTERFACE(i_ifDrive, ifGetParentDevice);
IF NOT xSuccess THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid,
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg		:= 'i_ifDrive - DTSI.IF_GetParentDevice not implemented');
	RETURN;
END_IF

ifDeviceAccess := ifGetParentDevice.GetParentDevice();
xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifDiagnosticAccess);
IF xSuccess THEN
	ifDiagnostic := ifDiagnosticAccess.Diagnostic;
ELSE
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid,
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg		:= 'i_ifDrive - UFMPLCI.IF_DiagnosticAccess not implemented');
	RETURN;
END_IF

xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifDriveConfigAccess);
IF xSuccess THEN
	ifDriveConfig := ifDriveConfigAccess.DriveConfig;
ELSE
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid,
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg		:= 'i_ifDrive - DDI.IF_DriveConfigAccess not implemented');
	RETURN;
END_IF

xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifDrivePowerSupplyAccess);
IF xSuccess THEN
	ifDrivePowerSupply := ifDrivePowerSupplyAccess.DrivePowerSupply;
ELSE
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid,
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg		:= 'i_ifDrive - DDI.IF_DrivePowerSupplyAccess not implemented');
	RETURN;
END_IF

xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifWorkingModeAccess);
IF xSuccess THEN
	ifWorkingMode := ifWorkingModeAccess.WorkingMode;
ELSE
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid,
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg		:= 'i_ifDrive - DDI.IF_DrivePowerSupplyAccess not implemented');
	RETURN;
END_IF
 

IF ifWorkingMode.ActualState = CFDI.ET_WorkingState.Physical THEN
	ifPowerSupplyDevice := ifDrivePowerSupply.GetDevice();
	xSuccess := __QUERYINTERFACE(ifPowerSupplyDevice, ifPowerSupplyAccess);
	IF xSuccess THEN
		ifPowerSupply := ifPowerSupplyAccess.PowerSupply;
	ELSE
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid,
						i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
						i_sMsg		:= 'i_ifDrive - DDI.IF_PowerSupplyAccess not implemented');
		RETURN;
	END_IF
	
	xSuccess := __QUERYINTERFACE(ifPowerSupplyDevice, ifPowerSupplyDiagnosticAccess);
	IF xSuccess THEN
		ifPowerSupplyDiagnostic := ifPowerSupplyDiagnosticAccess.Diagnostic;
	ELSE
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid,
						i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
						i_sMsg		:= 'PowerSupply - UFMPLCI.IF_DiagnosticAccess not implemented');
		RETURN;
	END_IF
	xDriveIsReal := TRUE;
	Init := TRUE;
ELSE
	xDriveIsReal := FALSE;
	Init := TRUE;
END_IF


xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifDeviceTreeObjectAccess);
IF xSuccess THEN
	sDriveName := ifDeviceTreeObjectAccess.DeviceTreeObject.Name;
ELSE
	sDriveName := 'Axis';
END_IF
