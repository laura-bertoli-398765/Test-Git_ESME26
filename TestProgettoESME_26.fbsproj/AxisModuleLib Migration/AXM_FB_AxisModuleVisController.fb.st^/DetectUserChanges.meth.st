__METADATA__
{
  "v3Meta": {
    "objectGuid": "9a51debf-0ca7-4cb5-9da9-c42f40fcf183",
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
METHOD INTERNAL DetectUserChanges
VAR_INPUT
END_VAR
__IMPLEMENTATION__
(* ST_Main *)
IF viq_stCurrentAxisInterface.stMain.i_xStart <> stOldAxisInterface.stMain.i_xStart THEN
	pstCurrentAxisInterface^.stMain.i_xStart := viq_stCurrentAxisInterface.stMain.i_xStart;
END_IF
IF viq_stCurrentAxisInterface.stMain.i_xHwLimitPos <> stOldAxisInterface.stMain.i_xHwLimitPos THEN
	pstCurrentAxisInterface^.stMain.i_xHwLimitPos := viq_stCurrentAxisInterface.stMain.i_xHwLimitPos;
END_IF
IF viq_stCurrentAxisInterface.stMain.i_xHwLimitNeg <> stOldAxisInterface.stMain.i_xHwLimitNeg THEN
	pstCurrentAxisInterface^.stMain.i_xHwLimitNeg := viq_stCurrentAxisInterface.stMain.i_xHwLimitNeg;
END_IF
(* Reduced Vel *)
IF viq_stCurrentAxisInterface.stMain.stReducedVelocity.i_lrMaxReducedVelocity <> stOldAxisInterface.stMain.stReducedVelocity.i_lrMaxReducedVelocity THEN
	pstCurrentAxisInterface^.stMain.stReducedVelocity.i_lrMaxReducedVelocity	:= viq_stCurrentAxisInterface.stMain.stReducedVelocity.i_lrMaxReducedVelocity;
END_IF
IF viq_stCurrentAxisInterface.stMain.stReducedVelocity.i_xEnableReducedVelocity <> stOldAxisInterface.stMain.stReducedVelocity.i_xEnableReducedVelocity THEN
	pstCurrentAxisInterface^.stMain.stReducedVelocity.i_xEnableReducedVelocity	:= viq_stCurrentAxisInterface.stMain.stReducedVelocity.i_xEnableReducedVelocity;
END_IF
IF viq_stCurrentAxisInterface.stMain.stReducedVelocity.i_xOnlyLimitCheck <> stOldAxisInterface.stMain.stReducedVelocity.i_xOnlyLimitCheck THEN
	pstCurrentAxisInterface^.stMain.stReducedVelocity.i_xOnlyLimitCheck	:= viq_stCurrentAxisInterface.stMain.stReducedVelocity.i_xOnlyLimitCheck;
END_IF

(* ST_Home *)
IF viq_stCurrentAxisInterface.stHome.i_etMode <> stOldAxisInterface.stHome.i_etMode THEN
	pstCurrentAxisInterface^.stHome.i_etMode := viq_stCurrentAxisInterface.stHome.i_etMode;
END_IF
(* LimitSwitch *)
IF viq_stCurrentAxisInterface.stHome.stLimitSwitch.i_lrVel <> stOldAxisInterface.stHome.stLimitSwitch.i_lrVel  THEN
	pstCurrentAxisInterface^.stHome.stLimitSwitch.i_lrVel := viq_stCurrentAxisInterface.stHome.stLimitSwitch.i_lrVel ;
END_IF
IF viq_stCurrentAxisInterface.stHome.stLimitSwitch.i_lrAcc <> stOldAxisInterface.stHome.stLimitSwitch.i_lrAcc  THEN
	pstCurrentAxisInterface^.stHome.stLimitSwitch.i_lrAcc  := viq_stCurrentAxisInterface.stHome.stLimitSwitch.i_lrAcc ;
END_IF
IF viq_stCurrentAxisInterface.stHome.stLimitSwitch.i_lrDec <> stOldAxisInterface.stHome.stLimitSwitch.i_lrDec  THEN
	pstCurrentAxisInterface^.stHome.stLimitSwitch.i_lrDec  := viq_stCurrentAxisInterface.stHome.stLimitSwitch.i_lrDec ;
END_IF
IF viq_stCurrentAxisInterface.stHome.stLimitSwitch.i_lrJerk <> stOldAxisInterface.stHome.stLimitSwitch.i_lrJerk  THEN
	pstCurrentAxisInterface^.stHome.stLimitSwitch.i_lrJerk  := viq_stCurrentAxisInterface.stHome.stLimitSwitch.i_lrJerk ;
END_IF
IF viq_stCurrentAxisInterface.stHome.stLimitSwitch.i_lrHomePosition <> stOldAxisInterface.stHome.stLimitSwitch.i_lrHomePosition  THEN
	pstCurrentAxisInterface^.stHome.stLimitSwitch.i_lrHomePosition  := viq_stCurrentAxisInterface.stHome.stLimitSwitch.i_lrHomePosition ;
END_IF
IF viq_stCurrentAxisInterface.stHome.stLimitSwitch.i_lrLowVel <> stOldAxisInterface.stHome.stLimitSwitch.i_lrLowVel  THEN
	pstCurrentAxisInterface^.stHome.stLimitSwitch.i_lrLowVel  := viq_stCurrentAxisInterface.stHome.stLimitSwitch.i_lrLowVel ;
END_IF
IF viq_stCurrentAxisInterface.stHome.stLimitSwitch.i_lrMaxTravel <> stOldAxisInterface.stHome.stLimitSwitch.i_lrMaxTravel  THEN
	pstCurrentAxisInterface^.stHome.stLimitSwitch.i_lrMaxTravel  := viq_stCurrentAxisInterface.stHome.stLimitSwitch.i_lrMaxTravel ;
END_IF
IF viq_stCurrentAxisInterface.stHome.stLimitSwitch.i_lrOffset <> stOldAxisInterface.stHome.stLimitSwitch.i_lrOffset  THEN
	pstCurrentAxisInterface^.stHome.stLimitSwitch.i_lrOffset  := viq_stCurrentAxisInterface.stHome.stLimitSwitch.i_lrOffset;
END_IF
(* MoveOnPos *)
IF viq_stCurrentAxisInterface.stHome.stMoveOnPos.i_lrVel <> stOldAxisInterface.stHome.stMoveOnPos.i_lrVel THEN
	pstCurrentAxisInterface^.stHome.stMoveOnPos.i_lrVel := viq_stCurrentAxisInterface.stHome.stMoveOnPos.i_lrVel;
END_IF
IF viq_stCurrentAxisInterface.stHome.stMoveOnPos.i_lrAcc <> stOldAxisInterface.stHome.stMoveOnPos.i_lrAcc THEN
	pstCurrentAxisInterface^.stHome.stMoveOnPos.i_lrAcc := viq_stCurrentAxisInterface.stHome.stMoveOnPos.i_lrAcc;
END_IF
IF viq_stCurrentAxisInterface.stHome.stMoveOnPos.i_lrDec <> stOldAxisInterface.stHome.stMoveOnPos.i_lrDec THEN
	pstCurrentAxisInterface^.stHome.stMoveOnPos.i_lrDec := viq_stCurrentAxisInterface.stHome.stMoveOnPos.i_lrDec;
END_IF
IF viq_stCurrentAxisInterface.stHome.stMoveOnPos.i_lrJerk <> stOldAxisInterface.stHome.stMoveOnPos.i_lrJerk THEN
	pstCurrentAxisInterface^.stHome.stMoveOnPos.i_lrJerk := viq_stCurrentAxisInterface.stHome.stMoveOnPos.i_lrJerk;
END_IF
IF viq_stCurrentAxisInterface.stHome.stMoveOnPos.i_lrTarget <> stOldAxisInterface.stHome.stMoveOnPos.i_lrTarget THEN
	pstCurrentAxisInterface^.stHome.stMoveOnPos.i_lrTarget := viq_stCurrentAxisInterface.stHome.stMoveOnPos.i_lrTarget;
END_IF
IF viq_stCurrentAxisInterface.stHome.stMoveOnPos.i_lrPeriod <> stOldAxisInterface.stHome.stMoveOnPos.i_lrPeriod THEN
	pstCurrentAxisInterface^.stHome.stMoveOnPos.i_lrPeriod := viq_stCurrentAxisInterface.stHome.stMoveOnPos.i_lrPeriod;
END_IF
IF viq_stCurrentAxisInterface.stHome.stMoveOnPos.i_xRotativeSystem <> stOldAxisInterface.stHome.stMoveOnPos.i_xRotativeSystem THEN
	pstCurrentAxisInterface^.stHome.stMoveOnPos.i_xRotativeSystem := viq_stCurrentAxisInterface.stHome.stMoveOnPos.i_xRotativeSystem;
END_IF
(* Sensor *)
IF viq_stCurrentAxisInterface.stHome.stSensor.i_lrVel <> stOldAxisInterface.stHome.stSensor.i_lrVel THEN
	pstCurrentAxisInterface^.stHome.stSensor.i_lrVel := viq_stCurrentAxisInterface.stHome.stSensor.i_lrVel;
END_IF
IF viq_stCurrentAxisInterface.stHome.stSensor.i_lrAcc <> stOldAxisInterface.stHome.stSensor.i_lrAcc THEN
	pstCurrentAxisInterface^.stHome.stSensor.i_lrAcc := viq_stCurrentAxisInterface.stHome.stSensor.i_lrAcc;
END_IF
IF viq_stCurrentAxisInterface.stHome.stSensor.i_lrDec <> stOldAxisInterface.stHome.stSensor.i_lrDec THEN
	pstCurrentAxisInterface^.stHome.stSensor.i_lrDec := viq_stCurrentAxisInterface.stHome.stSensor.i_lrDec;
END_IF
IF viq_stCurrentAxisInterface.stHome.stSensor.i_lrJerk <> stOldAxisInterface.stHome.stSensor.i_lrJerk THEN
	pstCurrentAxisInterface^.stHome.stSensor.i_lrJerk := viq_stCurrentAxisInterface.stHome.stSensor.i_lrJerk;
END_IF
IF viq_stCurrentAxisInterface.stHome.stSensor.i_lrHomePosition <> stOldAxisInterface.stHome.stSensor.i_lrHomePosition THEN
	pstCurrentAxisInterface^.stHome.stSensor.i_lrHomePosition := viq_stCurrentAxisInterface.stHome.stSensor.i_lrHomePosition;
END_IF
IF viq_stCurrentAxisInterface.stHome.stSensor.i_lrMaxTravel <> stOldAxisInterface.stHome.stSensor.i_lrMaxTravel THEN
	pstCurrentAxisInterface^.stHome.stSensor.i_lrMaxTravel := viq_stCurrentAxisInterface.stHome.stSensor.i_lrMaxTravel;
END_IF
IF viq_stCurrentAxisInterface.stHome.stSensor.i_lrOffset <> stOldAxisInterface.stHome.stSensor.i_lrOffset THEN
	pstCurrentAxisInterface^.stHome.stSensor.i_lrOffset := viq_stCurrentAxisInterface.stHome.stSensor.i_lrOffset;
END_IF
IF viq_stCurrentAxisInterface.stHome.stSensor.i_xRotativeSystem <> stOldAxisInterface.stHome.stSensor.i_xRotativeSystem THEN
	pstCurrentAxisInterface^.stHome.stSensor.i_xRotativeSystem := viq_stCurrentAxisInterface.stHome.stSensor.i_xRotativeSystem;
END_IF
IF viq_stCurrentAxisInterface.stHome.stSensor.i_xSensor <> stOldAxisInterface.stHome.stSensor.i_xSensor THEN
	pstCurrentAxisInterface^.stHome.stSensor.i_xSensor := viq_stCurrentAxisInterface.stHome.stSensor.i_xSensor;
END_IF

(* SetPos *)
IF viq_stCurrentAxisInterface.stHome.stSetPos.i_lrHomePosition <> stOldAxisInterface.stHome.stSetPos.i_lrHomePosition THEN
	pstCurrentAxisInterface^.stHome.stSetPos.i_lrHomePosition := viq_stCurrentAxisInterface.stHome.stSetPos.i_lrHomePosition;
END_IF
IF viq_stCurrentAxisInterface.stHome.stSetPos.i_lrEncoderPosition <> stOldAxisInterface.stHome.stSetPos.i_lrEncoderPosition THEN
	pstCurrentAxisInterface^.stHome.stSetPos.i_lrEncoderPosition := viq_stCurrentAxisInterface.stHome.stSetPos.i_lrEncoderPosition;
END_IF
IF viq_stCurrentAxisInterface.stHome.stSetPos.i_lrAbsEncOffset <> stOldAxisInterface.stHome.stSetPos.i_lrAbsEncOffset THEN
	pstCurrentAxisInterface^.stHome.stSetPos.i_lrAbsEncOffset := viq_stCurrentAxisInterface.stHome.stSetPos.i_lrAbsEncOffset;
END_IF
IF viq_stCurrentAxisInterface.stHome.stSetPos.i_lrUserPeriod <> stOldAxisInterface.stHome.stSetPos.i_lrUserPeriod THEN
	pstCurrentAxisInterface^.stHome.stSetPos.i_lrUserPeriod := viq_stCurrentAxisInterface.stHome.stSetPos.i_lrUserPeriod;
END_IF
IF viq_stCurrentAxisInterface.stHome.stSetPos.i_lrRestoreWindow <> stOldAxisInterface.stHome.stSetPos.i_lrRestoreWindow THEN
	pstCurrentAxisInterface^.stHome.stSetPos.i_lrRestoreWindow := viq_stCurrentAxisInterface.stHome.stSetPos.i_lrRestoreWindow;
END_IF

(* Torque *)
IF viq_stCurrentAxisInterface.stHome.stTorque.i_lrVel <> stOldAxisInterface.stHome.stTorque.i_lrVel THEN
	pstCurrentAxisInterface^.stHome.stTorque.i_lrVel := viq_stCurrentAxisInterface.stHome.stTorque.i_lrVel;
END_IF
IF viq_stCurrentAxisInterface.stHome.stTorque.i_lrAcc <> stOldAxisInterface.stHome.stTorque.i_lrAcc THEN
	pstCurrentAxisInterface^.stHome.stTorque.i_lrAcc := viq_stCurrentAxisInterface.stHome.stTorque.i_lrAcc;
END_IF
IF viq_stCurrentAxisInterface.stHome.stTorque.i_lrDec <> stOldAxisInterface.stHome.stTorque.i_lrDec THEN
	pstCurrentAxisInterface^.stHome.stTorque.i_lrDec := viq_stCurrentAxisInterface.stHome.stTorque.i_lrDec;
END_IF
IF viq_stCurrentAxisInterface.stHome.stTorque.i_lrJerk <> stOldAxisInterface.stHome.stTorque.i_lrJerk THEN
	pstCurrentAxisInterface^.stHome.stTorque.i_lrJerk := viq_stCurrentAxisInterface.stHome.stTorque.i_lrJerk;
END_IF
IF viq_stCurrentAxisInterface.stHome.stTorque.i_lrHomePosition <> stOldAxisInterface.stHome.stTorque.i_lrHomePosition THEN
	pstCurrentAxisInterface^.stHome.stTorque.i_lrHomePosition := viq_stCurrentAxisInterface.stHome.stTorque.i_lrHomePosition;
END_IF
IF viq_stCurrentAxisInterface.stHome.stTorque.i_lrMaxTorque <> stOldAxisInterface.stHome.stTorque.i_lrMaxTorque THEN
	pstCurrentAxisInterface^.stHome.stTorque.i_lrMaxTorque := viq_stCurrentAxisInterface.stHome.stTorque.i_lrMaxTorque;
END_IF
IF viq_stCurrentAxisInterface.stHome.stTorque.i_diTorqueTime <> stOldAxisInterface.stHome.stTorque.i_diTorqueTime THEN
	pstCurrentAxisInterface^.stHome.stTorque.i_diTorqueTime := viq_stCurrentAxisInterface.stHome.stTorque.i_diTorqueTime;
END_IF
IF viq_stCurrentAxisInterface.stHome.stTorque.i_lrMaxTravel <> stOldAxisInterface.stHome.stTorque.i_lrMaxTravel THEN
	pstCurrentAxisInterface^.stHome.stTorque.i_lrMaxTravel := viq_stCurrentAxisInterface.stHome.stTorque.i_lrMaxTravel;
END_IF
IF viq_stCurrentAxisInterface.stHome.stTorque.i_lrOffset <> stOldAxisInterface.stHome.stTorque.i_lrOffset THEN
	pstCurrentAxisInterface^.stHome.stTorque.i_lrOffset := viq_stCurrentAxisInterface.stHome.stTorque.i_lrOffset;
END_IF

(* Force *)
IF viq_stCurrentAxisInterface.stHome.stForce.i_lrVel <> stOldAxisInterface.stHome.stForce.i_lrVel THEN
	pstCurrentAxisInterface^.stHome.stForce.i_lrVel := viq_stCurrentAxisInterface.stHome.stForce.i_lrVel;
END_IF
IF viq_stCurrentAxisInterface.stHome.stForce.i_lrAcc <> stOldAxisInterface.stHome.stForce.i_lrAcc THEN
	pstCurrentAxisInterface^.stHome.stForce.i_lrAcc := viq_stCurrentAxisInterface.stHome.stForce.i_lrAcc;
END_IF
IF viq_stCurrentAxisInterface.stHome.stForce.i_lrDec <> stOldAxisInterface.stHome.stForce.i_lrDec THEN
	pstCurrentAxisInterface^.stHome.stForce.i_lrDec := viq_stCurrentAxisInterface.stHome.stForce.i_lrDec;
END_IF
IF viq_stCurrentAxisInterface.stHome.stForce.i_lrJerk <> stOldAxisInterface.stHome.stForce.i_lrJerk THEN
	pstCurrentAxisInterface^.stHome.stForce.i_lrJerk := viq_stCurrentAxisInterface.stHome.stForce.i_lrJerk;
END_IF
IF viq_stCurrentAxisInterface.stHome.stForce.i_lrHomePosition <> stOldAxisInterface.stHome.stForce.i_lrHomePosition THEN
	pstCurrentAxisInterface^.stHome.stForce.i_lrHomePosition := viq_stCurrentAxisInterface.stHome.stForce.i_lrHomePosition;
END_IF
IF viq_stCurrentAxisInterface.stHome.stForce.i_lrMaxForce <> stOldAxisInterface.stHome.stForce.i_lrMaxForce THEN
	pstCurrentAxisInterface^.stHome.stForce.i_lrMaxForce := viq_stCurrentAxisInterface.stHome.stForce.i_lrMaxForce;
END_IF
IF viq_stCurrentAxisInterface.stHome.stForce.i_diForceTime <> stOldAxisInterface.stHome.stForce.i_diForceTime THEN
	pstCurrentAxisInterface^.stHome.stForce.i_diForceTime := viq_stCurrentAxisInterface.stHome.stForce.i_diForceTime;
END_IF
IF viq_stCurrentAxisInterface.stHome.stForce.i_lrMaxTravel <> stOldAxisInterface.stHome.stForce.i_lrMaxTravel THEN
	pstCurrentAxisInterface^.stHome.stForce.i_lrMaxTravel := viq_stCurrentAxisInterface.stHome.stForce.i_lrMaxTravel;
END_IF
IF viq_stCurrentAxisInterface.stHome.stForce.i_lrOffset <> stOldAxisInterface.stHome.stForce.i_lrOffset THEN
	pstCurrentAxisInterface^.stHome.stForce.i_lrOffset := viq_stCurrentAxisInterface.stHome.stForce.i_lrOffset;
END_IF

(* TouchProbe *)
IF viq_stCurrentAxisInterface.stHome.stTouchProbe.i_lrVel <> stOldAxisInterface.stHome.stTouchProbe.i_lrVel THEN
	pstCurrentAxisInterface^.stHome.stTouchProbe.i_lrVel := viq_stCurrentAxisInterface.stHome.stTouchProbe.i_lrVel;
END_IF
IF viq_stCurrentAxisInterface.stHome.stTouchProbe.i_lrAcc <> stOldAxisInterface.stHome.stTouchProbe.i_lrAcc THEN
	pstCurrentAxisInterface^.stHome.stTouchProbe.i_lrAcc := viq_stCurrentAxisInterface.stHome.stTouchProbe.i_lrAcc;
END_IF
IF viq_stCurrentAxisInterface.stHome.stTouchProbe.i_lrDec <> stOldAxisInterface.stHome.stTouchProbe.i_lrDec THEN
	pstCurrentAxisInterface^.stHome.stTouchProbe.i_lrDec := viq_stCurrentAxisInterface.stHome.stTouchProbe.i_lrDec;
END_IF
IF viq_stCurrentAxisInterface.stHome.stTouchProbe.i_lrJerk <> stOldAxisInterface.stHome.stTouchProbe.i_lrJerk THEN
	pstCurrentAxisInterface^.stHome.stTouchProbe.i_lrJerk := viq_stCurrentAxisInterface.stHome.stTouchProbe.i_lrJerk;
END_IF
IF viq_stCurrentAxisInterface.stHome.stTouchProbe.i_lrHomePosition <> stOldAxisInterface.stHome.stTouchProbe.i_lrHomePosition THEN
	pstCurrentAxisInterface^.stHome.stTouchProbe.i_lrHomePosition := viq_stCurrentAxisInterface.stHome.stTouchProbe.i_lrHomePosition;
END_IF
IF viq_stCurrentAxisInterface.stHome.stTouchProbe.i_lrMaxTravel <> stOldAxisInterface.stHome.stTouchProbe.i_lrMaxTravel THEN
	pstCurrentAxisInterface^.stHome.stTouchProbe.i_lrMaxTravel := viq_stCurrentAxisInterface.stHome.stTouchProbe.i_lrMaxTravel;
END_IF
IF viq_stCurrentAxisInterface.stHome.stTouchProbe.i_lrOffset <> stOldAxisInterface.stHome.stTouchProbe.i_lrOffset THEN
	pstCurrentAxisInterface^.stHome.stTouchProbe.i_lrOffset := viq_stCurrentAxisInterface.stHome.stTouchProbe.i_lrOffset;
END_IF
IF viq_stCurrentAxisInterface.stHome.stTouchProbe.i_xRotativeSystem <> stOldAxisInterface.stHome.stTouchProbe.i_xRotativeSystem THEN
	pstCurrentAxisInterface^.stHome.stTouchProbe.i_xRotativeSystem := viq_stCurrentAxisInterface.stHome.stTouchProbe.i_xRotativeSystem;
END_IF

(* WritePos *)
IF viq_stCurrentAxisInterface.stHome.stWritePos.i_lrHomePosition <> stOldAxisInterface.stHome.stWritePos.i_lrHomePosition THEN
	pstCurrentAxisInterface^.stHome.stWritePos.i_lrHomePosition := viq_stCurrentAxisInterface.stHome.stWritePos.i_lrHomePosition;
END_IF
IF viq_stCurrentAxisInterface.stHome.stWritePos.i_lrAbsEncOffset <> stOldAxisInterface.stHome.stWritePos.i_lrAbsEncOffset THEN
	pstCurrentAxisInterface^.stHome.stWritePos.i_lrAbsEncOffset := viq_stCurrentAxisInterface.stHome.stWritePos.i_lrAbsEncOffset;
END_IF
IF viq_stCurrentAxisInterface.stHome.stWritePos.i_lrUserPeriod <> stOldAxisInterface.stHome.stWritePos.i_lrUserPeriod THEN
	pstCurrentAxisInterface^.stHome.stWritePos.i_lrUserPeriod := viq_stCurrentAxisInterface.stHome.stWritePos.i_lrUserPeriod;
END_IF

(* ST_Manual *)
IF(viq_stCurrentAxisInterface.stManual.i_lrVel <> stOldAxisInterface.stManual.i_lrVel) THEN
	pstCurrentAxisInterface^.stManual.i_lrVel := viq_stCurrentAxisInterface.stManual.i_lrVel;
END_IF
IF(viq_stCurrentAxisInterface.stManual.i_lrAcc <> stOldAxisInterface.stManual.i_lrAcc) THEN
	pstCurrentAxisInterface^.stManual.i_lrAcc := viq_stCurrentAxisInterface.stManual.i_lrAcc;
END_IF
IF(viq_stCurrentAxisInterface.stManual.i_lrDec <> stOldAxisInterface.stManual.i_lrDec) THEN
	pstCurrentAxisInterface^.stManual.i_lrDec := viq_stCurrentAxisInterface.stManual.i_lrDec;
END_IF
IF(viq_stCurrentAxisInterface.stManual.i_lrJerk <> stOldAxisInterface.stManual.i_lrJerk) THEN
	pstCurrentAxisInterface^.stManual.i_lrJerk := viq_stCurrentAxisInterface.stManual.i_lrJerk;
END_IF
IF(viq_stCurrentAxisInterface.stManual.i_lrMaxDistance <> stOldAxisInterface.stManual.i_lrMaxDistance) THEN
	pstCurrentAxisInterface^.stManual.i_lrMaxDistance := viq_stCurrentAxisInterface.stManual.i_lrMaxDistance;
END_IF
IF(viq_stCurrentAxisInterface.stManual.i_lrPeriod <> stOldAxisInterface.stManual.i_lrPeriod) THEN
	pstCurrentAxisInterface^.stManual.i_lrPeriod := viq_stCurrentAxisInterface.stManual.i_lrPeriod;
END_IF
IF(viq_stCurrentAxisInterface.stManual.i_xEndless <> stOldAxisInterface.stManual.i_xEndless) THEN
	pstCurrentAxisInterface^.stManual.i_xEndless := viq_stCurrentAxisInterface.stManual.i_xEndless;
END_IF
IF(viq_stCurrentAxisInterface.stManual.i_xJogForw <> stOldAxisInterface.stManual.i_xJogForw) THEN
	pstCurrentAxisInterface^.stManual.i_xJogForw := viq_stCurrentAxisInterface.stManual.i_xJogForw;
END_IF
IF(viq_stCurrentAxisInterface.stManual.i_xJogBack <> stOldAxisInterface.stManual.i_xJogBack) THEN
	pstCurrentAxisInterface^.stManual.i_xJogBack := viq_stCurrentAxisInterface.stManual.i_xJogBack;
END_IF

(* ST_EndlessFeed *)
IF viq_stCurrentAxisInterface.stEndless.i_lrVel <> stOldAxisInterface.stEndless.i_lrVel THEN
	pstCurrentAxisInterface^.stEndless.i_lrVel := viq_stCurrentAxisInterface.stEndless.i_lrVel;
END_IF
IF  viq_stCurrentAxisInterface.stEndless.i_lrAcc <> stOldAxisInterface.stEndless.i_lrAcc THEN
	pstCurrentAxisInterface^.stEndless.i_lrAcc := viq_stCurrentAxisInterface.stEndless.i_lrAcc;
END_IF
IF viq_stCurrentAxisInterface.stEndless.i_lrDec <> stOldAxisInterface.stEndless.i_lrDec THEN
	pstCurrentAxisInterface^.stEndless.i_lrDec := viq_stCurrentAxisInterface.stEndless.i_lrDec;
END_IF
IF viq_stCurrentAxisInterface.stEndless.i_lrJerk <> stOldAxisInterface.stEndless.i_lrJerk THEN
	pstCurrentAxisInterface^.stEndless.i_lrJerk := viq_stCurrentAxisInterface.stEndless.i_lrJerk;
END_IF
IF viq_stCurrentAxisInterface.stEndless.i_lrPeriod <> stOldAxisInterface.stEndless.i_lrPeriod THEN
	pstCurrentAxisInterface^.stEndless.i_lrPeriod := viq_stCurrentAxisInterface.stEndless.i_lrPeriod;
END_IF
IF viq_stCurrentAxisInterface.stEndless.i_lrStopPosition <> stOldAxisInterface.stEndless.i_lrStopPosition THEN
	pstCurrentAxisInterface^.stEndless.i_lrStopPosition := viq_stCurrentAxisInterface.stEndless.i_lrStopPosition;
END_IF

(* ST_MultiCam *)
IF viq_stCurrentAxisInterface.stMultiCam.i_etCsModeSlave <> stOldAxisInterface.stMultiCam.i_etCsModeSlave THEN
	pstCurrentAxisInterface^.stMultiCam.i_etCsModeSlave:= viq_stCurrentAxisInterface.stMultiCam.i_etCsModeSlave;
END_IF
IF viq_stCurrentAxisInterface.stMultiCam.i_etCsModeMaster <> stOldAxisInterface.stMultiCam.i_etCsModeMaster THEN
	pstCurrentAxisInterface^.stMultiCam.i_etCsModeMaster := viq_stCurrentAxisInterface.stMultiCam.i_etCsModeMaster;
END_IF
IF viq_stCurrentAxisInterface.stMultiCam.i_diTXend <> stOldAxisInterface.stMultiCam.i_diTXend THEN
	pstCurrentAxisInterface^.stMultiCam.i_diTXend := viq_stCurrentAxisInterface.stMultiCam.i_diTXend;
END_IF
IF viq_stCurrentAxisInterface.stMultiCam.i_lrInstantXLimMax <> stOldAxisInterface.stMultiCam.i_lrInstantXLimMax THEN
	pstCurrentAxisInterface^.stMultiCam.i_lrInstantXLimMax := viq_stCurrentAxisInterface.stMultiCam.i_lrInstantXLimMax;
END_IF
IF viq_stCurrentAxisInterface.stMultiCam.i_lrSetEncoderOffset <> stOldAxisInterface.stMultiCam.i_lrSetEncoderOffset THEN
	pstCurrentAxisInterface^.stMultiCam.i_lrSetEncoderOffset := viq_stCurrentAxisInterface.stMultiCam.i_lrSetEncoderOffset;
END_IF
IF viq_stCurrentAxisInterface.stMultiCam.i_lrWsWindow <> stOldAxisInterface.stMultiCam.i_lrWsWindow THEN
	pstCurrentAxisInterface^.stMultiCam.i_lrWsWindow := viq_stCurrentAxisInterface.stMultiCam.i_lrWsWindow;
END_IF
IF viq_stCurrentAxisInterface.stMultiCam.i_lrWsAcc <> stOldAxisInterface.stMultiCam.i_lrWsAcc THEN
	pstCurrentAxisInterface^.stMultiCam.i_lrWsAcc := viq_stCurrentAxisInterface.stMultiCam.i_lrWsAcc;
END_IF
IF viq_stCurrentAxisInterface.stMultiCam.i_lrWsVel <> stOldAxisInterface.stMultiCam.i_lrWsVel THEN
	pstCurrentAxisInterface^.stMultiCam.i_lrWsVel := viq_stCurrentAxisInterface.stMultiCam.i_lrWsVel;
END_IF
IF viq_stCurrentAxisInterface.stMultiCam.i_etWsMode <> stOldAxisInterface.stMultiCam.i_etWsMode THEN
	pstCurrentAxisInterface^.stMultiCam.i_etWsMode := viq_stCurrentAxisInterface.stMultiCam.i_etWsMode;
END_IF
IF viq_stCurrentAxisInterface.stMultiCam.iq_xInstantNewCam <> stOldAxisInterface.stMultiCam.iq_xInstantNewCam THEN
	pstCurrentAxisInterface^.stMultiCam.iq_xInstantNewCam := viq_stCurrentAxisInterface.stMultiCam.iq_xInstantNewCam;
END_IF
IF viq_stCurrentAxisInterface.stMultiCam.iq_xNewCam <> stOldAxisInterface.stMultiCam.iq_xNewCam THEN
	pstCurrentAxisInterface^.stMultiCam.iq_xNewCam := viq_stCurrentAxisInterface.stMultiCam.iq_xNewCam;
END_IF
IF viq_stCurrentAxisInterface.stMultiCam.i_xEnableTabHandler <> stOldAxisInterface.stMultiCam.i_xEnableTabHandler THEN
	pstCurrentAxisInterface^.stMultiCam.i_xEnableTabHandler := viq_stCurrentAxisInterface.stMultiCam.i_xEnableTabHandler;
END_IF
IF viq_stCurrentAxisInterface.stMultiCam.i_udiTableSelectNr <> stOldAxisInterface.stMultiCam.i_udiTableSelectNr THEN
	pstCurrentAxisInterface^.stMultiCam.i_udiTableSelectNr := viq_stCurrentAxisInterface.stMultiCam.i_udiTableSelectNr;
END_IF

(* ST_Positioning *)
IF viq_stCurrentAxisInterface.stPos.i_lrVel <> stOldAxisInterface.stPos.i_lrVel THEN
	pstCurrentAxisInterface^.stPos.i_lrVel := viq_stCurrentAxisInterface.stPos.i_lrVel;
END_IF
IF viq_stCurrentAxisInterface.stPos.i_lrAcc <> stOldAxisInterface.stPos.i_lrAcc THEN
	pstCurrentAxisInterface^.stPos.i_lrAcc := viq_stCurrentAxisInterface.stPos.i_lrAcc;
END_IF
IF viq_stCurrentAxisInterface.stPos.i_lrDec <> stOldAxisInterface.stPos.i_lrDec THEN
	pstCurrentAxisInterface^.stPos.i_lrDec := viq_stCurrentAxisInterface.stPos.i_lrDec;
END_IF
IF viq_stCurrentAxisInterface.stPos.i_lrJerk <> stOldAxisInterface.stPos.i_lrJerk THEN
	pstCurrentAxisInterface^.stPos.i_lrJerk := viq_stCurrentAxisInterface.stPos.i_lrJerk;
END_IF
IF viq_stCurrentAxisInterface.stPos.i_lrTarget <> stOldAxisInterface.stPos.i_lrTarget THEN
	pstCurrentAxisInterface^.stPos.i_lrTarget := viq_stCurrentAxisInterface.stPos.i_lrTarget;
END_IF
IF viq_stCurrentAxisInterface.stPos.i_etPosMode <> stOldAxisInterface.stPos.i_etPosMode THEN
	pstCurrentAxisInterface^.stPos.i_etPosMode := viq_stCurrentAxisInterface.stPos.i_etPosMode;
END_IF
IF viq_stCurrentAxisInterface.stPos.i_xStop	<> stOldAxisInterface.stPos.i_xStop THEN
	pstCurrentAxisInterface^.stPos.i_xStop := viq_stCurrentAxisInterface.stPos.i_xStop;
END_IF

viq_stCurrentAxisInterface := pstCurrentAxisInterface^;
stOldAxisInterface := viq_stCurrentAxisInterface;
