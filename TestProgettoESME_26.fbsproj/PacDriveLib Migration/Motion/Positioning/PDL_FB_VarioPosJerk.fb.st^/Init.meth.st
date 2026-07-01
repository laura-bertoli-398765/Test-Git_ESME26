__METADATA__
{
  "v3Meta": {
    "objectGuid": "1cc4dbea-dc8e-4ea1-9c37-06e767314fa4",
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


IF i_ifDrive = 0 THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg		:= 'i_ifDrive - Invalid Interface');
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

	fbHalt.Axis := i_ifDrive;
	fbStop.Axis := i_ifDrive;
	fbMoveAbsolute.Axis := i_ifDrive;
	fbMoveRelative.Axis := i_ifDrive;

END_IF


//i_ifDrive.lrModuloPeriod



Init := TRUE;
