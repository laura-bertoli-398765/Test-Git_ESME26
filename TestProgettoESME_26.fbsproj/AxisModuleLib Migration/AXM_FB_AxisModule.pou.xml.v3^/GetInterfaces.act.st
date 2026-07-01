__METADATA__
{
  "v3Meta": {
    "objectGuid": "d17f2152-ffc0-400a-95a5-caef054ae84b",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__

IF 	(iq_stAxisModuleItf.stMain.i_ifDrive <> 0) THEN 
	IF (ifAxisOld <> iq_stAxisModuleItf.stMain.i_ifDrive) THEN
		ifAxisOld := iq_stAxisModuleItf.stMain.i_ifDrive;
		xSuccess := __QUERYINTERFACE(iq_stAxisModuleItf.stMain.i_ifDrive, ifGetParentDevice);
		IF xSuccess THEN
			ifDeviceAccess := ifGetParentDevice.GetParentDevice();
			xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifDiagnosticAccess);
			IF xSuccess THEN
				ifDiagnostic := ifDiagnosticAccess.Diagnostic;
			END_IF
			xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifDrive2Access);
			IF xSuccess THEN
				ifDrive2 := ifDrive2Access.Drive2;
			END_IF
			xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifDriveAccess);
			IF xSuccess THEN
				ifDrive := ifDriveAccess.Drive;
			END_IF
		END_IF
	END_IF
END_IF

