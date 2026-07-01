__METADATA__
{
  "v3Meta": {
    "objectGuid": "00364677-2067-459f-b6ee-9a34612b9357",
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
FUNCTION FC_IsDriveVirtual : BOOL
VAR_INPUT
	i_ifDrive	: MOIN.IF_Axis;
END_VAR

VAR_OUTPUT
	q_etDiag	: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt	: ET_DiagExt := ET_DiagExt.Ok;
	q_sMsg		: STRING[80];
END_VAR

VAR
	xSuccess			: BOOL;
	ifWorkingModeAccess :  CFDI.IF_WorkingModeAccess;
	ifGetParentDevice   : DTSI.IF_GetParentDevice;
	ifDeviceAccess		: DTSI.IF_DeviceAccess;
END_VAR
__IMPLEMENTATION__
IF i_ifDrive = 0 THEN
	q_etDiag	:= GD.ET_Diag.InputParameterInvalid;
	q_etDiagExt	:= ET_DiagExt.DriveInvalid;
	q_sMsg		:= 'FC_IsDriveVirtual: i_ifDrive not set';		
ELSE
	xSuccess := __QUERYINTERFACE(i_ifDrive, ifGetParentDevice);
	IF NOT xSuccess OR ifGetParentDevice = 0 THEN
		// not a device-tree axis with user functions -> virtual axis
		FC_IsDriveVirtual := TRUE;
		RETURN;
	END_IF
	ifDeviceAccess := ifGetParentDevice.GetParentDevice();
	
	xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifWorkingModeAccess);
	IF NOT xSuccess OR ifWorkingModeAccess = 0 THEN
		// not a device-tree axis with user functions -> virtual axis
		FC_IsDriveVirtual := TRUE;
	ELSE
		// device-tree axis with user funciton working mode -> read out working mode
		FC_IsDriveVirtual := (ifWorkingModeAccess.WorkingMode.DesiredMode = CFDI.ET_WorkingMode.Virtual);
	END_IF
END_IF	

