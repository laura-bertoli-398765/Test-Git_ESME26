__METADATA__
{
  "v3Meta": {
    "objectGuid": "c3084866-41e5-434a-90f6-f65266ca1c98",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* System generated code, could be modified for your application *)

(* Standard interface *)
astSubModuleInterface[c_udiSlave1].i_sModuleName := CONCAT(STR1 := iq_stStandardModuleItf.i_sModuleName, STR2 := ': Slave1');

astSubModuleInterface[c_udiSlave1].i_xLogEnable     := TRUE;
astSubModuleInterface[c_udiSlave1].i_wLogDataFilter := UDINT_TO_WORD(TPL.ET_LogDataFilter.ModuleDefault);

fbSlave1Module.RegisterLoggerPoint(i_ifParent := fbLoggerPoint, i_sName := 'Slave1', q_etDiag :=, q_etDiagExt :=);

(* AxisModule specific interface *)
stSlave1Interface.stMain.i_ifMaster 		:= i_ifMaster; (* Master *)
stSlave1Interface.stMain.i_ifDrive  := DRV_Slave1.Axis;

stSlave1Interface.stMain.iq_lencEncoder		:= LE_Slave1.Axis;

DRV_Slave1.Axis.SetErrorStopRamp(i_lrDeceleration := 50_000,
								 i_lrJerk		  := 500_000);
								 

xDriveIsVirtual := FC_IsDriveVirtual(	i_ifDrive	:= stSlave1Interface.stMain.i_ifDrive,
										q_etDiag	=> etDiag,
										q_etDiagExt	=> etDiagExt,
										q_sMsg		=> sMsgBuffer);

IF etDiag <> GD.ET_Diag.Ok AND NOT xIsDriveVirtualException THEN
	stIsDriveVirtualException.etDiag 	:= etDiag;
	stIsDriveVirtualException.udiDiagExt:= etDiagExt;
	stIsDriveVirtualException.sDiagExt 	:= FC_EtDiagExtToString(i_etDiagExt := etDiagExt);															
	stIsDriveVirtualException.sMsg 		:= sMsgBuffer;
	xIsDriveVirtualException 			:= TRUE;
END_IF

fbExceptionHandler.SetException(i_xExceptionActive	:= xIsDriveVirtualException, 
								iq_stException		:= stIsDriveVirtualException, 
								iq_stExceptionList	:= iq_stExceptionList);
					
xInitSuccessful := xInitSuccessful AND NOT xIsDriveVirtualException;
etDiag := GD.ET_Diag.Ok;


stSlave1Interface.stMain.i_lrMotionActiveVelLimit := 15.0; (* Limit for max. velocity of astAxisModuleInterface to switch output AxisMove in Units/s *)
stSlave1Interface.stMain.i_etMotionActiveVelType  := AXM_ET_MotionActiveVelType.RefVelocity;

stSlave1Interface.stMain.i_timMasterStop := T#1S;
stSlave1Interface.stMain.i_xHwLimitPos   := FALSE;
stSlave1Interface.stMain.i_xHwLimitNeg   := FALSE;

stSlave1Interface.stMain.stReducedVelocity.i_xEnableReducedVelocity		:= FALSE;
stSlave1Interface.stMain.stReducedVelocity.i_xOnlyLimitCheck			:= FALSE;
stSlave1Interface.stMain.stReducedVelocity.i_lrMaxReducedVelocity		:= 50.0;

stSlave1Interface.stMain.i_xStart := FALSE;

(***************************************************************************************************************************************************************************************************)
(*** Homing ***)
	IF xDriveIsVirtual THEN
		stSlave1Interface.stHome.i_etMode := PDL_ET_HomeMode.SetPosAxisAndLogEncoderPosition;			(* Homing Mode  in case of virtual axis *)
	ELSE
		stSlave1Interface.stHome.i_etMode := PDL_ET_HomeMode.PosDirectionPosEdgeSensor;						(* Homing Mode in case of real axis *)
	END_IF
	
	stSlave1Interface.stHome.i_xEnableInitAbsReadPos := FALSE;		(* TRUE : Restores the AxisPosition depending on the stHome.etMode
																			  If stHome.i_etMode is equal to PDL_ET_HomeMode.RestorePosFromAxisEncoder or 
																			  to PDL_ET_HomeMode.WriteAxisEncoder, the encoder of the axis is read,
																			  or else the position will be restored from the retain area *)
																			  
	stSlave1Interface.stHome.stSetpos.iq_pstRestorePosRetain := ADR(Grp_stRestorePositionAxis2);
	
	stSlave1Interface.stHome.i_xResetHomeOk := FALSE;
	
	(* Possible modes for homing mode Sensor:
		PDL_ET_HomeMode.PosDirectionPosEdgeSensor
		PDL_ET_HomeMode.NegDirectionPosEdgeSensor
		PDL_ET_HomeMode.NegDirectionNegEdgeSensor
		PDL_ET_HomeMode.PosDirectionNegEdgeSensor
	*)
	stSlave1Interface.stHome.stSensor.i_lrHomePosition			:= 0.0;			(* Position at the end of homing in units *)
	stSlave1Interface.stHome.stSensor.i_lrVel					:= 10.0;		(* Homing ceiling velocity in units/s *)
	stSlave1Interface.stHome.stSensor.i_lrAcc					:= 1000.0;		(* Homing acceleration in units/s^2 *)
	stSlave1Interface.stHome.stSensor.i_lrDec					:= 1000.0;		(* Homing deceleration in units/s^2 *)
	stSlave1Interface.stHome.stSensor.i_lrJerk					:= 10000.0;		(* Homing jerk in units/s^3 *)
	stSlave1Interface.stHome.stSensor.i_lrOffset				:= 0.0;			(* Offset from home signal in units *)
	stSlave1Interface.stHome.stSensor.i_lrMaxTravel				:= 720.0;		(* Max. travel for referencing by normal input *)
	stSlave1Interface.stHome.stSensor.i_xRotativeSystem			:= FALSE;		(* Rotative system true or false for referencing by normal input *)
	stSlave1Interface.stHome.stSensor.i_xSensor					:= FALSE;		(* Input for home signal. Can be a signal from a controller input. Has to be written cyclic. *)
	
	(* Possible Modes for homing mode LimitSwitch:
		PDL_ET_HomeMode.PosDirectionPosEdgeHWLimitPos		normally open contact / Closing contact
		PDL_ET_HomeMode.NegDirectionPosEdgeHWLimitNeg		normally open contact / Closing contact
		PDL_ET_HomeMode.NegDirectionNegEdgeHWLimitNeg		normally closed contact / Opening contact  
		PDL_ET_HomeMode.PosDirectionNegEdgeHWLimitPos		normally closed contact / Opening contact 
	*)
	stSlave1Interface.stHome.stLimitSwitch.i_lrHomePosition		:= 0.0;			(* Position at the end of homing in units *)
	stSlave1Interface.stHome.stLimitSwitch.i_lrVel				:= 10.0;		(* Homing ceiling velocity in units/s *)
	stSlave1Interface.stHome.stLimitSwitch.i_lrLowVel			:= 5.0;			(* Homing low ceiling velocity in units/s *)
	stSlave1Interface.stHome.stLimitSwitch.i_lrAcc				:= 1000.0;		(* Homing acceleration in units/s^2 *)
	stSlave1Interface.stHome.stLimitSwitch.i_lrDec				:= 1000.0;		(* Homing deceleration in units/s^2 *)
	stSlave1Interface.stHome.stLimitSwitch.i_lrJerk				:= 10000.0;		(* Homing jerk in units/s^3 *)
	stSlave1Interface.stHome.stLimitSwitch.i_lrOffset			:= 0.0;			(* Offset from home signal in units *)
	stSlave1Interface.stHome.stLimitSwitch.i_lrMaxTravel		:= 9999.0;		(* Max. travel for referencing normal input as a hardware limit *)
	
	(* Possible modes for homing mode MoveOnPos:
		PDL_ET_HomeMode.MoveOnPosAbs 
	*)
	stSlave1Interface.stHome.stMoveOnPos.i_lrTarget				:= 0.0;			(* Position at the end of homing in units *)
	stSlave1Interface.stHome.stMoveOnPos.i_lrVel				:= 10.0;		(* Homing ceiling velocity in units/s *)
	stSlave1Interface.stHome.stMoveOnPos.i_lrAcc				:= 1000.0;		(* Homing acceleration in units/s^2 *)
	stSlave1Interface.stHome.stMoveOnPos.i_lrDec				:= 1000.0;		(* Homing deceleration in units/s^2 *)
	stSlave1Interface.stHome.stMoveOnPos.i_lrJerk				:= 10000.0;		(* Homing jerk in units/s^3 *)
	stSlave1Interface.stHome.stMoveOnPos.i_lrPeriod				:= 0.0;			(* Period of the axis *)
	stSlave1Interface.stHome.stMoveOnPos.i_xRotativeSystem		:= FALSE;		(* Rotative system true or false *)
	
	(* Possible modes for homing mode SetPos:
		PDL_ET_HomeMode.SetPosAxisPosition 
		PDL_ET_HomeMode.SetPosLogEncoderPosition 
		PDL_ET_HomeMode.SetPosAxisAndLogEncoderPosition
		PDL_ET_HomeMode.RestorePosFromAxisEncoder 
		PDL_ET_HomeMode.RestorePosFromRetain 
	*)
	stSlave1Interface.stHome.stSetpos.i_lrHomePosition			:= 0.0;			(* Position at the end of homing in units *)
	stSlave1Interface.stHome.stSetpos.i_lrEncoderPosition		:= 0.0;			(* Encoder position in units after homing *)
	stSlave1Interface.stHome.stSetpos.i_lrAbsEncOffset			:= 100.0;		(* Distance to the jump of axis encoder in units  *)
	stSlave1Interface.stHome.stSetpos.i_lrRestoreWindow			:= 180;			(* How far can the drive be away from is correct position *)
	stSlave1Interface.stHome.stSetpos.i_lrUserPeriod			:= 360;			(* Period of the axis *)
	stSlave1Interface.stHome.stSetPos.i_xKeepPowerDisabled 		:= FALSE;		(* Keep Power disabled during SetPosHoming true or false*)
	
	(* Possible modes for homing mode Torque:
		PDL_ET_HomeMode.PosDirectionMaxTorque 
		PDL_ET_HomeMode.NegDirectionMaxTorque 
	*)
	stSlave1Interface.stHome.stTorque.i_lrHomePosition			:= 0.0;			(* Position at the end of homing in units *)
	stSlave1Interface.stHome.stTorque.i_lrVel					:= 10.0;		(* Homing ceiling velocity in units/s *)
	stSlave1Interface.stHome.stTorque.i_lrAcc					:= 1000.0;		(* Homing acceleration in units/s^2 *)
	stSlave1Interface.stHome.stTorque.i_lrDec					:= 1000.0;		(* Homing deceleration in units/s^2 *)
	stSlave1Interface.stHome.stTorque.i_lrJerk					:= 10000.0;		(* Homing jerk in units/s^3 *)
	stSlave1Interface.stHome.stTorque.i_lrOffset				:= 0.0;			(* Offset from home signal in units *)
	stSlave1Interface.stHome.stTorque.i_lrMaxTravel				:= 9999.0;		(* Max. travel for referencing by torque *)
	stSlave1Interface.stHome.stTorque.i_lrMaxTorque				:= 0.0;			(* Torque for stop in Nm / referencing by torque *)
	stSlave1Interface.stHome.stTorque.i_diTorqueTime			:= 5;			(* Time in msec to hold torque *)
	
	(* Possible modes for homing mode TouchProbe:
		PDL_ET_HomeMode.PosDirectionPosEdgeTp 
		PDL_ET_HomeMode.NegDirectionPosEdgeTp 
		PDL_ET_HomeMode.NegDirectionNegEdgeTp 
		PDL_ET_HomeMode.PosDirectionNegEdgeTp 
	*)
	stSlave1Interface.stHome.stTouchProbe.i_lrHomePosition		:= 0.0;			(* Position at the end of homing in units *)
	stSlave1Interface.stHome.stTouchProbe.i_lrVel				:= 100.0;		(* Homing ceiling velocity in units/s *)
	stSlave1Interface.stHome.stTouchProbe.i_lrAcc				:= 1000.0;		(* Homing acceleration in units/s^2 *)
	stSlave1Interface.stHome.stTouchProbe.i_lrDec				:= 1000.0;		(* Homing deceleration in units/s^2 *)
	stSlave1Interface.stHome.stTouchProbe.i_lrJerk				:= 10000.0;		(* Homing jerk in units/s^3 *)
	stSlave1Interface.stHome.stTouchProbe.i_lrOffset			:= 30.0;		(* Offset from home signal in units *)
	stSlave1Interface.stHome.stTouchProbe.i_lrMaxTravel			:= 720.0;		(* Max. travel for referencing by TP *)
	stSlave1Interface.stHome.stTouchProbe.i_xRotativeSystem		:= TRUE;		(* Rotative system true or false for referencing by TP *)
 	stSlave1Interface.stHome.stTouchProbe.i_ifTouchProbe		:= 0;		(* Input for TP *)
	
	(* Possible modes for homing mode WritePos:
		PDL_ET_HomeMode.WriteAxisEncoder 
	*)
	stSlave1Interface.stHome.stWritePos.i_lrHomePosition		:= 0.0;			(* Position at the end of homing in units *)
	stSlave1Interface.stHome.stWritePos.i_lrUserPeriod			:= 0.0;			(* Calculates Drive.Position into period ( units ) *)
	stSlave1Interface.stHome.stWritePos.i_lrAbsEncOffset		:= 100.0;		(* Distance to the jump of axis encoder in units *)


(***************************************************************************************************************************************************************************************************)
(*** Manual ***)
	stSlave1Interface.stManual.i_lrVel         := 50.0; (* Velocity in units/s *)
	stSlave1Interface.stManual.i_lrAcc         := 100.0; (* Acceleration in units/s^2 *)
	stSlave1Interface.stManual.i_lrDec         := 100.0; (* Deceleration in units/s^2 *)
	stSlave1Interface.stManual.i_lrJerk        := 1000.0; (* Jerk in units/s^3 *)
	stSlave1Interface.stManual.i_lrMaxDistance := 120.0; (* Max pathlengths for one step in units *)
	stSlave1Interface.stManual.i_xEndless      := FALSE; (* TRUE: jogging endless; Position between the periode; FALSE: jogging in steps. Position can be out of periode *)
	stSlave1Interface.stManual.i_lrPeriod      := 360.0; (* Period of the axis *)

(***************************************************************************************************************************************************************************************************)
(*** Cam ***)

	stSlave1Interface.stMultiCam.i_etCSModeSlave			:= PDL_ET_MultiCamCsModeSlave.SetSlavePositionToFirstCamPosition;		(* ColdStartMode Slave *)
	stSlave1Interface.stMultiCam.i_etCSModeMaster			:= PDL_ET_MultiCamCsModeMaster.SetMasterPositionToFirstCamPosition;		(* ColdStartMode Master *)
	stSlave1Interface.stMultiCam.i_etWSMode					:= PDL_ET_MultiCamWsMode.StoredCamMoveAlwaysNoPositionCheck;			(* WarmStartMode *)
	stSlave1Interface.stMultiCam.i_lrWSWindow				:= 5.0;											(* WarmStartWindow in Axis units *)
	stSlave1Interface.stMultiCam.i_lrWSVel					:= 10.0;										(* Velocity for WarmStart and CSModeSlave = PDL.ET_MultiCamCsModeSlave.MoveSlaveToFirstCamPosition in Units/s *)
	stSlave1Interface.stMultiCam.i_lrWSAcc					:= 1_000.0;										(* Acceleration and deceleration for Warmstart and CSModeSlave = PDL.ET_MultiCamCsModeSlave.MoveSlaveToFirstCamPosition in Units/s^2 *)
	stSlave1Interface.stMultiCam.i_lrWSJerk					:= 10_000.0;									(* Jerk for Warmstart and CSModeSlave = PDL.ET_MultiCamCsModeSlave.MoveSlaveToFirstCamPosition in units/s^3 *)
	stSlave1Interface.stMultiCam.i_diTXend	:= 2*G_diTaskIntervalInMs;	(* Time of XLowEnd and XHighEnd befor Xend or Xstart in msec*)
	stSlave1Interface.stMultiCam.i_lrInstantXLimMax			:= 180.0;											(* Switch off position at 'InstantNewCam' *)
	
	stSlave1Interface.stMultiCam.i_xEnableTabHandler		:= FALSE;										(* TRUE: TabHandler is enabled *)
	stSlave1Interface.stMultiCam.i_udiTableSelectNr			:= AXM_ET_ParId.Cont;							(* Number of table which is used in the next cycle *)								
	
// 	stSlave1Interface.stMultiCam.i_xSetEncoderParameters	:= FALSE;										(* TRUE: The parameters MasterId, FeedConstand, GearIn and GearOut will be copyed into LEnc object *)
	stSlave1Interface.stMultiCam.i_xSetEncoderPosition		:= TRUE;										(* TRUE: Manipulation of LEnc object on startup OpMode MultiCam *)
	stSlave1Interface.stMultiCam.i_lrSetEncoderOffset		:= 0.0;											(* Master encoder offset *)
	stSlave1Interface.stMultiCam.i_xCheckEncoderPeriod		:= TRUE;										(* TRUE: Check of encoder period = 0. If encoder period <> 0 -> Exception *)
	
//	stSlave1Interface.stMultiCam.iq_xNewCam					:= FALSE;										(* TRUE: A new DataStruct will be load for next cycle. Will be reset when new cycle is started in case of stMultiCam.i_xEnableTabHandler = FALSE. *)
//	stSlave1Interface.stMultiCam.iq_xInstantNewCam			:= FALSE;										(* TRUE: A new DataStruct will be load. It will be active at master position stMultiCam.i_lrInstantXLimMax. Will be reset when ne DataStruct is active *)
//	stSlave1Interface.stMultiCam.iq_xChangeMaster			:= FALSE;										(* TRUE: Switch to a new Master. Will be reset when done. *)			

// stSlave1Interface.stMultiCam.iq_stExt		;						(* Extended In of the Multicam FB, can be used if needed! *)

//--- User Profile
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].diNumberOfCamPoints := 6;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].diUserTableId := 4;
	
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[0].lrX := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[0].lrY := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[0].lrM := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[0].lrK := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[0].lrLambda := 0.5;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[0].lrC := 1;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[0].etCamType := CMT.ET_CAMTYPE.Poly5;
	
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[1].lrX := 120;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[1].lrY := 200;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[1].lrM := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[1].lrK := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[1].lrLambda := 0.5;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[1].lrC := 1;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[1].etCamType := CMT.ET_CAMTYPE.Straight;
	
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[2].lrX := 140;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[2].lrY := 200;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[2].lrM := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[2].lrK := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[2].lrLambda := 0.5;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[2].lrC := 1;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[2].etCamType := CMT.ET_CAMTYPE.Poly5;
	
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[3].lrX := 180;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[3].lrY := 400;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[3].lrM := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[3].lrK := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[3].lrLambda := 1;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[3].lrC := 1;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[3].etCamType := CMT.ET_CAMTYPE.Straight;
	
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[4].lrX := 220;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[4].lrY := 400;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[4].lrM := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[4].lrK := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[4].lrLambda := 0.5;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[4].lrC := 1;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[4].etCamType := CMT.ET_CAMTYPE.Poly5;
	
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[5].lrX := 360;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[5].lrY := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[5].lrM := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[5].lrK := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[5].lrLambda := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[5].lrC := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].astCamPoint[5].etCamType := CMT.ET_CAMTYPE.Straight;

	
//--- Cont Profile
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].diNumberOfCamPoints := 4;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].diUserTableId := 2;
	
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[0].lrX := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[0].lrY := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[0].lrM := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[0].lrK := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[0].lrLambda := 0.5;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[0].lrC := 1;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[0].etCamType := CMT.ET_CAMTYPE.Poly5;
	
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[1].lrX := 120;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[1].lrY := 200;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[1].lrM := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[1].lrK := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[1].lrLambda := 1;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[1].lrC := 1;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[1].etCamType := CMT.ET_CAMTYPE.Straight;
	
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[2].lrX := 300;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[2].lrY := 200;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[2].lrM := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[2].lrK := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[2].lrLambda := 0.5;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[2].lrC := 1;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[2].etCamType := CMT.ET_CAMTYPE.Poly5;
	
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[3].lrX := 360;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[3].lrY := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[3].lrM := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[3].lrK := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[3].lrLambda := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[3].lrC := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[3].etCamType := CMT.ET_CAMTYPE.Straight;
	
//--- Stop Profile
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Stop].diNumberOfCamPoints := 2;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Stop].diUserTableId := 3;
	
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Stop].astCamPoint[0].lrX := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Stop].astCamPoint[0].lrY := 200;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Stop].astCamPoint[0].lrM := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Stop].astCamPoint[0].lrK := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Stop].astCamPoint[0].lrLambda := 1;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Stop].astCamPoint[0].lrC := 1;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Stop].astCamPoint[0].etCamType := CMT.ET_CAMTYPE.Straight;
	
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Stop].astCamPoint[1].lrX := 360;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Stop].astCamPoint[1].lrY := 200;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Stop].astCamPoint[1].lrM := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Stop].astCamPoint[1].lrK := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Stop].astCamPoint[1].lrLambda := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Stop].astCamPoint[1].lrC := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Stop].astCamPoint[1].etCamType := CMT.ET_CAMTYPE.Straight;

	
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Idle].diUserTableId	:= UDINT_TO_DINT(AXM_ET_ParId.Idle);
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Start].diUserTableId	:= UDINT_TO_DINT(AXM_ET_ParId.Start);
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].diUserTableId	:= UDINT_TO_DINT(AXM_ET_ParId.Cont);
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Stop].diUserTableId	:= UDINT_TO_DINT(AXM_ET_ParId.Stop);
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.User].diUserTableId	:= UDINT_TO_DINT(AXM_ET_ParId.User);

(***************************************************************************************************************************************************************************************************)
(*** Endless ***)
	stSlave1Interface.stEndless.i_lrPeriod 					:= 500.0;		(* Period one cycle in units *)
	stSlave1Interface.stEndless.i_lrJerk 					:= 108000.0;	(* Jerk in units/s^3 *)
	stSlave1Interface.stEndless.i_lrStopPosition 			:= 120.0;		(* Stop position in units *)
	stSlave1Interface.stEndless.i_lrAcc  					:= 10800.0;		(* Acceleration in Units/s^2 *)
	stSlave1Interface.stEndless.i_lrDec  					:= 10800.0;		(* Deceleration in Units/s^2 *)
	stSlave1Interface.stEndless.i_lrVel 					:= 1080.0;   	(* Velocity in Units/s *)


(***************************************************************************************************************************************************************************************************)
(*** Pos ***)
	stSlave1Interface.stPos.i_etPosMode						:= PDL_ET_PosMode.Relative;		(* SYSTEMINTERFACE.ET_PosMode.Endless, SYSTEMINTERFACE.ET_PosMode.Relative, SYSTEMINTERFACE.ET_PosMode.Absolute *)
	stSlave1Interface.stPos.i_lrTarget 						:= 1440.0;		(* Target position or distance in Units *)
	stSlave1Interface.stPos.i_lrAcc 						:= 10800.0;		(* Acceleration in Units/s^2 *)
	stSlave1Interface.stPos.i_lrDec 						:= 10800.0;		(* Deceleration in Units/s^2 *)
	stSlave1Interface.stPos.i_lrJerk 						:= 108000.0;	(* Jerk in units/s^3 *)
	stSlave1Interface.stPos.i_lrVel 						:= 540.0;		(* Ceiling velocity in Units/s *)


// stSlave1Interface.stPos.i_xStop								:= FALSE;
(* End of system generated code, could be modified for your application *)
