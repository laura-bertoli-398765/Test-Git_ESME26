__METADATA__
{
  "v3Meta": {
    "objectGuid": "9cfc9afa-cc21-4e7a-a281-d943cf3a293e",
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


//check axis
IF i_ifDrive = 0 THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg		:= 'i_ifDrive - Invalid Interface');
	RETURN;	
	
ELSIF iq_lencMaster = 0 THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg		:= 'iq_lencMaster - Invalid Interface');
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
	fbCamIn.Slave := i_ifDrive;
	fbCamIn.Master := iq_lencMaster;
	fbCamIn2.Slave := i_ifDrive;
	fbCamIn2.Master := iq_lencMaster;

	xSlaveIsModulo := i_ifDrive.xIsModulo;
						
END_IF	


//read cycle time
pstTaskInfo := __CURRENTTASK.pTaskInfo;
IF pstTaskInfo <> 0 
THEN
	lrOwnPlcTaskInterval	:= DWORD_TO_LREAL(pstTaskInfo^.dwInterval) / 1000000.0; //usec to sec
	lrTSwitch				:= DINT_TO_LREAL(i_diTXend) / 1000.0 + lrOwnPlcTaskInterval;
ELSE
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
					i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
					i_sMsg		:= 'IecTaskGetInfo3 - reading cycle time failed');
	RETURN;	
END_IF


Init := TRUE;
