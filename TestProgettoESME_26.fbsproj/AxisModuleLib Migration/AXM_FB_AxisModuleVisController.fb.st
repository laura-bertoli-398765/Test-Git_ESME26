__METADATA__
{
  "v3Meta": {
    "objectGuid": "5b485cf9-b3c9-4581-9ae6-c188d9b65200",
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
FUNCTION_BLOCK PUBLIC AXM_FB_AxisModuleVisController
VAR_INPUT
	i_xEnable               : BOOL;
	i_pstMachineStandardItf : POINTER TO TPL.ST_StandardModuleInterface;
	i_pstCurrentStandardItf : POINTER TO TPL.ST_StandardModuleInterface;
	i_dwCurrentAddItf       : TPL.TYPE_ADDRESS; // change DWORD to TYPE_ADDRESS
	i_xUpdateData           : BOOL;
	i_udiCurrentJogTarget   : UDINT;
END_VAR
VAR_IN_OUT
	iq_stExceptionList : TPL.ST_ExceptionList;
	iq_stLogDataList   : TPL.ST_LogDataList;
END_VAR
VAR_OUTPUT
	q_xActive                          : BOOL;
	q_xReady                           : BOOL;
	q_etDiag                           : GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt                        : AXM_ET_DiagExt := AXM_ET_DiagExt.Disabled;
	q_sMsg                             : STRING[80] := '';
	q_udiSetAsCurrentModule            : UDINT;
	q_udiSetAsJogTarget                : UDINT;
	q_xSimulateExceptionStopEndOfCycle : BOOL;
END_VAR
VAR
	xEnableFlag              : BOOL;
	pstCurrentAxisInterface  : POINTER TO AXM_ST_ModuleInterface;
	stOldAxisInterface       : AXM_ST_ModuleInterface;
	pstCurrent               : POINTER TO TPL.ST_StandardModuleInterface;
	xInitUserInputs          : BOOL;
	dwOldCurrentAddInterface : TPL.TYPE_ADDRESS; // change DWORD to TYPE_ADDRESS
	xSuccess                 : BOOL;
END_VAR
VAR
	viq_stCurrentAxisInterface      : AXM_ST_ModuleInterface;
	viq_pstCurrentStandardInterface : POINTER TO TPL.ST_StandardModuleInterface;
	vq_xCurrentIsOfMyType           : BOOL;
	vi_iPaneSelect                  : INT  := 1;
	vq_iShowOpMode                  : DINT := -1;
	vq_sOpMode                      : STRING[40];
	vi_iSelectOpMode                : INT  := -1;
	vq_sDriveName                   : STRING[40];
	vq_lrDriveRefPosition           : LREAL;
	vq_uiDriveTopologyAddress       : UINT;
	vq_diDriveState                 : DINT;
	vq_diDriveDiagCode              : DINT;
	vq_sDriveDiagMsg                : STRING[39];
	vq_lrDriveMaxVel                : LREAL;
	vq_lrDriveMaxAcc                : LREAL;
	vq_xDriveControllerEnable       : BOOL;
	vq_diDriveWorkingState          : DINT;
	vq_sMasterName                  : STRING[40];
	vq_xTpValue                     : BOOL;
	viq_xCmdStart                   : BOOL;
	viq_xCmdWSStart                 : BOOL;
	viq_xCmdHold                    : BOOL;
	viq_xDriveEnableOn              : BOOL;
	viq_xDriveEnableOff             : BOOL;
	viq_xReactionEndOfCycle         : BOOL;
	viq_xHomeLimitSwitchInvisible   : BOOL;
	viq_xHomeMoveOnPosInvisible     : BOOL;
	viq_xHomeSensorInvisible        : BOOL;
	viq_xHomeSetPosInvisible        : BOOL;
	viq_xHomeTorqueInvisible        : BOOL;
	viq_xHomeTouchProbeInvisible    : BOOL;
	viq_xHomeWritePosInvisible      : BOOL;
	viq_xHomeForceInvisible         : BOOL;
	viq_xJogForw                    : BOOL;
	viq_xJogBack                    : BOOL;
	xJogForwEdgeDetect              : BOOL := FALSE;
	xJogBackEdgeDetect              : BOOL := FALSE;
	viq_xEditCamTablesInvisible     : BOOL := TRUE;
	viq_udiEditCamTablesTableNo     : UDINT := 4;
	viq_diEditCamTablesPointNo      : DINT := 0;
	v_xHideTabHandler               : BOOL := TRUE;
	ifDiagnostic                    : UFMPLCI.IF_Diagnostic;
	ifDiagnosticAccess              : UFMPLCI.IF_DiagnosticAccess;
	ifGetParentDevice               : DTSI.IF_GetParentDevice;
	ifDeviceAccess                  : DTSI.IF_DeviceAccess;
	ifSercosIdentificationAccess    : SDI.IF_SercosIdentificationAccess;
	ifSercosIdentification          : SDI.IF_SercosIdentification;
	ifWorkingModeAccess             : CFDI.IF_WorkingModeAccess;
	ifWorkingMode                   : CFDI.IF_WorkingMode;
	ifDeviceTreeObjectSlaveAccess   : UFMPLCI.IF_DeviceTreeObjectAccess;
	ifDeviceTreeObjectMasterAccess  : UFMPLCI.IF_DeviceTreeObjectAccess;
	ifDriveConfigAccess             : DDI.IF_DriveConfigAccess;
	ifDriveConfig                   : DDI.IF_DriveConfig;
	ifOldMaster                     : MOIN.IF_Axis;
	ifTouprobeData                  : IODI.IF_TouchprobeData;
	ifTouprobeDataAccess            : IODI.IF_TouchprobeDataAccess;
	
END_VAR
__IMPLEMENTATION__
q_udiSetAsCurrentModule            := 0;
q_udiSetAsJogTarget                := 0;
pstCurrent                         := i_pstCurrentStandardItf;
q_xSimulateExceptionStopEndOfCycle := viq_xReactionEndOfCycle;

// Calculate Homing mode invisible BOOLs
viq_xHomeLimitSwitchInvisible := viq_stCurrentAxisInterface.stHome.i_etMode < 8 OR viq_stCurrentAxisInterface.stHome.i_etMode > 11;
viq_xHomeMoveOnPosInvisible   := viq_stCurrentAxisInterface.stHome.i_etMode <> 14;
viq_xHomeSensorInvisible      := viq_stCurrentAxisInterface.stHome.i_etMode < 4 OR viq_stCurrentAxisInterface.stHome.i_etMode > 7;
viq_xHomeSetPosInvisible      := viq_stCurrentAxisInterface.stHome.i_etMode < 15 OR viq_stCurrentAxisInterface.stHome.i_etMode > 19;
viq_xHomeTorqueInvisible      := viq_stCurrentAxisInterface.stHome.i_etMode < 12 OR viq_stCurrentAxisInterface.stHome.i_etMode > 13;
viq_xHomeTouchProbeInvisible  := viq_stCurrentAxisInterface.stHome.i_etMode < 0 OR viq_stCurrentAxisInterface.stHome.i_etMode > 3;
viq_xHomeWritePosInvisible    := viq_stCurrentAxisInterface.stHome.i_etMode <> 20;
viq_xHomeForceInvisible       := viq_stCurrentAxisInterface.stHome.i_etMode < 21 OR viq_stCurrentAxisInterface.stHome.i_etMode > 22;

IF i_xEnable THEN
	q_xActive := TRUE;
	IF (i_pstCurrentStandardItf = 0) THEN
		q_xReady    := FALSE;
		q_etDiag    := GD.ET_Diag.InputParameterInvalid;
		q_etDiagExt := AXM_ET_DiagExt.CurrentStandardItfInvalid;
		q_sMsg      := 'pointer is null';
	ELSIF (i_dwCurrentAddItf = 0) THEN
		q_xReady    := FALSE;
		q_etDiag    := GD.ET_Diag.InputParameterInvalid;
		q_etDiagExt := AXM_ET_DiagExt.CurrentAddItfInvalid;
		q_sMsg      := 'pointer is null';
	ELSE
		q_xReady    := TRUE;
		q_etDiag    := GD.ET_Diag.Ok;
		q_etDiagExt := AXM_ET_DiagExt.Working;
		q_sMsg      := AXM_FC_EtDiagExtToString(i_etDiagExt := AXM_ET_DiagExt.Working);
		IF (i_pstCurrentStandardItf^.q_dwModuleType = UDINT_TO_DWORD(TPL.ET_ModuleType.AxisModule)) THEN
			(* Module version check *)
			IF (i_pstCurrentStandardItf^.q_udiModuleVersion = 1) THEN
				pstCurrentAxisInterface := i_dwCurrentAddItf;
				vq_xCurrentIsOfMyType   := TRUE;
			END_IF
		ELSE
			pstCurrentAxisInterface := 0;
			vq_xCurrentIsOfMyType   := FALSE;
		END_IF
		
		IF (vq_xCurrentIsOfMyType) THEN
			(* Execute changes requested by user first *)
			IF (NOT xInitUserInputs) THEN
				xInitUserInputs := TRUE;
				(* Ignore values of variables now *)
			ELSE
				DetectUserChanges();
			END_IF
			
			IF dwOldCurrentAddInterface <> i_dwCurrentAddItf THEN
				dwOldCurrentAddInterface        := i_dwCurrentAddItf;
				viq_stCurrentAxisInterface      := pstCurrentAxisInterface^;
				stOldAxisInterface              := viq_stCurrentAxisInterface;
				viq_pstCurrentStandardInterface := i_pstCurrentStandardItf;
				
				IF (viq_stCurrentAxisInterface.stMain.i_ifDrive <> 0) THEN
					xSuccess := __QUERYINTERFACE(viq_stCurrentAxisInterface.stMain.i_ifDrive, ifGetParentDevice);
					IF xSuccess THEN
						ifDeviceAccess := ifGetParentDevice.GetParentDevice();
						xSuccess       := __QUERYINTERFACE(ifDeviceAccess, ifDiagnosticAccess);
						IF xSuccess THEN
							ifDiagnostic := ifDiagnosticAccess.Diagnostic;
						END_IF
						xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifDriveConfigAccess);
						IF xSuccess THEN
							ifDriveConfig := ifDriveConfigAccess.DriveConfig;
						END_IF
						xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifDeviceTreeObjectSlaveAccess);
						IF xSuccess THEN
							vq_sDriveName := ifDeviceTreeObjectSlaveAccess.DeviceTreeObject.Name;
						END_IF
						xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifSercosIdentificationAccess);
						IF xSuccess THEN
							ifSercosIdentification := ifSercosIdentificationAccess.SercosIdentification;
						END_IF
						xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifWorkingModeAccess);
						IF xSuccess THEN
							ifWorkingMode := ifWorkingModeAccess.WorkingMode;
						END_IF
					ELSE
						vq_sDriveName := '';
					END_IF
				END_IF
				IF viq_stCurrentAxisInterface.stHome.stTouchProbe.i_ifTouchProbe <> 0 THEN
					xSuccess := __QUERYINTERFACE(viq_stCurrentAxisInterface.stHome.stTouchProbe.i_ifTouchProbe, ifGetParentDevice);
					IF xSuccess THEN
						ifDeviceAccess := ifGetParentDevice.GetParentDevice();
						xSuccess       := __QUERYINTERFACE(ifDeviceAccess, ifTouprobeDataAccess);
						IF xSuccess THEN
							ifTouprobeData := ifTouprobeDataAccess.TouchprobeData;
						END_IF
					END_IF
				END_IF
			END_IF
			
			(* generate VisData *)
			IF (vi_iSelectOpMode < 0) THEN
				(* Show actual OpMode *)
				vq_ishowOpMode := DINT_TO_INT(viq_stCurrentAxisInterface.stMain.q_etOpMode);
			ELSE
				vq_ishowOpMode := vi_iSelectOpMode;
			END_IF
			
			IF (viq_stCurrentAxisInterface.stMain.i_ifDrive <> 0) THEN
				vq_diDriveState       := TO_DINT(viq_stCurrentAxisInterface.stMain.i_ifDrive.etAxisState);
				vq_lrDriveRefPosition := viq_stCurrentAxisInterface.stMain.i_ifDrive.lrPosition;
				vq_sOpMode            := AXM_FC_EtOpModeToString(i_etOpMode := viq_stCurrentAxisInterface.stMain.q_etOpMode);
			END_IF
			
			IF ifDiagnostic <> 0 THEN
				vq_diDriveDiagCode := ifDiagnostic.DiagCode;
				vq_sDriveDiagMsg   := ifDiagnostic.DiagMsg;
			ELSE
				vq_diDriveDiagCode := 0;
				vq_sDriveDiagMsg   := '';
			END_IF
			
			IF ifSercosIdentification <> 0 THEN
				vq_uiDriveTopologyAddress := ifSercosIdentification.TopologyAddress;
			ELSE
				vq_uiDriveTopologyAddress := 0;
			END_IF
			
			IF ifWorkingMode <> 0 THEN
				vq_diDriveWorkingState := ifWorkingMode.ActualState;
			ELSE
				vq_diDriveWorkingState := 0;
			END_IF
			
			IF (viq_stCurrentAxisInterface.stMain.i_ifDrive <> 0) THEN
				vq_lrDriveRefPosition := viq_stCurrentAxisInterface.stMain.i_ifDrive.lrPosition;
				vq_sOpMode            := AXM_FC_EtOpModeToString(i_etOpMode := viq_stCurrentAxisInterface.stMain.q_etOpMode);
				
				IF ifDriveConfig = 0 THEN
					vq_lrDriveMaxVel := 0.0;
					vq_lrDriveMaxAcc := 0.0;
				ELSE
					vq_lrDriveMaxVel := ifDriveConfig.MaxVel;
					vq_lrDriveMaxAcc := ifDriveConfig.MaxAcc;
				END_IF
				
				//xSuccess := __QUERYINTERFACE(viq_stCurrentAxisInterface.stMain.i_ifDrive, ifDrivePowerControlMandatory);
				//IF NOT xSuccess OR (ifDrivePowerControlMandatory = 0) THEN
				//	(* ignore error *)
				//	ifDrivePowerControlMandatory := 0;
				//	vq_xDriveControllerEnable := FALSE;
				//ELSE
				//	vq_xDriveControllerEnable := ifDrivePowerControlMandatory.ControllerEnable;
				//END_IF
			ELSE
				vq_xDriveControllerEnable := FALSE;
				vq_lrDriveMaxVel          := 0.0;
				vq_lrDriveMaxAcc          := 0.0;
				vq_lrDriveRefPosition     := 0.0;
			END_IF
			
			IF (viq_stCurrentAxisInterface.stMain.i_ifMaster <> 0) THEN
				IF ifOldMaster <> viq_stCurrentAxisInterface.stMain.i_ifMaster THEN
					ifOldMaster := viq_stCurrentAxisInterface.stMain.i_ifMaster;
					xSuccess    := __QUERYINTERFACE(viq_stCurrentAxisInterface.stMain.i_ifMaster, ifGetParentDevice);
					IF xSuccess THEN
						ifDeviceAccess := ifGetParentDevice.GetParentDevice();
						xSuccess       := __QUERYINTERFACE(ifDeviceAccess, ifDeviceTreeObjectMasterAccess);
						IF xSuccess THEN
							vq_sMasterName := ifDeviceTreeObjectMasterAccess.DeviceTreeObject.Name;
						END_IF
					ELSE
						//no device tree object
						vq_sMasterName := '';
					END_IF
				END_IF
			ELSE
				vq_sMasterName := 'not set';
			END_IF
			
			IF (ifTouprobeData <> 0) THEN
				vq_xTpValue := ifTouprobeData.Value;
			ELSE
				vq_xTpValue := FALSE;
			END_IF
			
			IF iq_stExceptionList.udiNumberOfActiveExceptions > 0 AND viq_stCurrentAxisInterface.stMain.q_etOpMode = AXM_ET_OpMode.NoOp THEN
				pstCurrentAxisInterface^.stMain.i_xStart   := FALSE;
				viq_stCurrentAxisInterface.stMain.i_xStart := FALSE;
				stOldAxisInterface.stMain.i_xStart         := FALSE;
				
				pstCurrentAxisInterface^.stPos.i_xStop   := FALSE;
				viq_stCurrentAxisInterface.stPos.i_xStop := FALSE;
				stOldAxisInterface.stPos.i_xStop         := FALSE;
			END_IF
			
			IF (viq_xJogForw) THEN
				viq_stCurrentAxisInterface.stManual.i_xJogForw := TRUE;
				xJogForwEdgeDetect                             := TRUE;
			ELSE
				IF (xJogForwEdgeDetect) THEN
					viq_stCurrentAxisInterface.stManual.i_xJogForw := FALSE;
					xJogForwEdgeDetect                             := FALSE;
				END_IF
			END_IF
			
			IF (viq_xJogBack) THEN
				viq_stCurrentAxisInterface.stManual.i_xJogBack := TRUE;
				xJogBackEdgeDetect                             := TRUE;
			ELSE
				IF (xJogBackEdgeDetect) THEN
					viq_stCurrentAxisInterface.stManual.i_xJogBack := FALSE;
					xJogBackEdgeDetect                             := FALSE;
				END_IF
			END_IF
			
			IF (i_udiCurrentJogTarget <> i_pstCurrentStandardItf^.i_udiModuleId) AND (viq_xJogForw OR viq_xJogBack) THEN
				q_udiSetAsJogTarget                            := i_pstCurrentStandardItf^.i_udiModuleId; (* select as jog target whenever a jog button is pushed *)
				viq_stCurrentAxisInterface.stManual.i_xJogForw := FALSE;
				viq_stCurrentAxisInterface.stManual.i_xJogBack := FALSE;
			END_IF
			
		ELSE
			;
		END_IF
	END_IF
ELSE
	vq_xCurrentIsOfMyType := FALSE;
	q_xActive             := FALSE;
	q_xReady              := FALSE;
	q_etDiag              := GD.ET_Diag.Ok;
	q_etDiagExt           := AXM_ET_DiagExt.Disabled;
	q_sMsg                := AXM_FC_EtDiagExtToString(i_etDiagExt := AXM_ET_DiagExt.Disabled);
END_IF
