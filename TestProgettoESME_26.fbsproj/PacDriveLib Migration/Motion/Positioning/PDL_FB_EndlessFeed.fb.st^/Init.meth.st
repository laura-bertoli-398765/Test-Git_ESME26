__METADATA__
{
  "v3Meta": {
    "objectGuid": "76ba1167-0036-4c5a-8072-1a9c0fa6f5e1",
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
METHOD PRIVATE Init : BOOL
VAR_INPUT
END_VAR
__IMPLEMENTATION__
Init := FALSE;

IF i_ifDrive = 0 THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg		:= 'i_ifDrive - Invalid Interface');
	RETURN;	

ELSIF NOT i_ifDrive.xIsHomed  THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.DriveConditionInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DriveNotHomed,
					i_sMsg		:= 'i_ifDrive - must be homed');
	RETURN;	
					
ELSE
	//get IF_DriveConfig
	xSuccess := __QUERYINTERFACE(i_ifDrive, ifGetParentDevice);
	IF xSuccess AND ifGetParentDevice <> 0 THEN
		ifDeviceAccess := ifGetParentDevice.GetParentDevice();
		xSuccess := __QUERYINTERFACE( ifDeviceAccess, ifDriveConfigAccess );
		IF xSuccess AND ifDriveConfigAccess <> 0 THEN
			ifDriveConfig := ifDriveConfigAccess.DriveConfig;
		END_IF
	END_IF

	xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifDeviceTreeObjectAccess);
	IF xSuccess THEN
		sDriveName := ifDeviceTreeObjectAccess.DeviceTreeObject.Name;
	ELSE
		sDriveName := 'Axis';
	END_IF

	fbStop.Axis := i_ifDrive;
	fbHalt.Axis := i_ifDrive;
	fbMoveAbsolute.Axis := i_ifDrive;
	fbMoveVelocity.Axis := i_ifDrive;
	
	//check axis
	xModuloAxis := i_ifDrive.xIsModulo;
	IF xModuloAxis THEN
		lrModuloPeriod 	:= i_ifDrive.lrModuloPeriod;
	END_IF		
END_IF



Init := TRUE;
