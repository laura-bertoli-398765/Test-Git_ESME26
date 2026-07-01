__METADATA__
{
  "v3Meta": {
    "objectGuid": "bdaab79e-6781-4046-8b9c-48a2ac7513e2",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
	// Mapping the structure of the 'Machine' under consideration 
	// on the Automation System PacDrive3
	
					// Assigning a userspecific name to the Drive under consideration
	astModuleInterface[c_udiSlave1].i_sModuleName 			:= 'Slave1';
				// Assigning the drive to the AxisModule dedicated to DRV_Slave1
	stSlave1Interface.stMain.i_ifMaster						:= DRV_Master.Axis; 	
	stSlave1Interface.stMain.iq_lencEncoder					:= LE_Slave1;
	stSlave1Interface.stMain.i_ifDrive						:= DRV_Slave1.Axis;
	
	xDriveIsVirtual :=	(DRV_Slave1.WorkingMode.DesiredMode = CFDI.ET_WorkingMode.Virtual);

	// Parameterising the movements of the OpModes of DRV_Slave1 ...
(***************************************************************************************************************************************************************************************************)
//OpMode Homing
	IF xDriveIsVirtual THEN
		stSlave1Interface.stHome.i_etMode := PDL_ET_HomeMode.SetPosAxisAndLogEncoderPosition;			(* Homing Mode  in case of virtual axis *)
	ELSE
		stSlave1Interface.stHome.i_etMode := PDL_ET_HomeMode.SetPosAxisAndLogEncoderPosition;						(* Homing Mode in case of real axis *)
	END_IF

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

	(* Possible modes for homing mode SetPos:
		PDL_ET_HomeMode.SetPosAxisPosition 
		PDL_ET_HomeMode.SetPosLogEncoderPosition 
		PDL_ET_HomeMode.SetPosAxisAndLogEncoderPosition
	*)
	stSlave1Interface.stHome.stSetpos.i_lrHomePosition			:= 0.0;			(* Position at the end of homing in units *)
	stSlave1Interface.stHome.stSetpos.i_lrEncoderPosition		:= 0.0;			(* Encoder position in units after homing *)



(***************************************************************************************************************************************************************************************************)
(*** Manual ***)
	stSlave1Interface.stManual.i_lrVel						:= 50.0;			(* Velocity in units/s *)
	stSlave1Interface.stManual.i_lrAcc						:= 100.0;			(* Acceleration in units/s^2 *)
	stSlave1Interface.stManual.i_lrDec						:= 100.0;			(* Deceleration in units/s^2 *)
	stSlave1Interface.stManual.i_lrJerk						:= 1000.0;			(* Jerk in units/s^3 *)
	stSlave1Interface.stManual.i_lrMaxDistance				:= 120.0;			(* Max pathlengths for one step in units *)
	stSlave1Interface.stManual.i_xEndless					:= FALSE;			(* TRUE: jogging endless; Position between the periode; FALSE: jogging in steps. Position can be out of periode *)
	stSlave1Interface.stManual.i_lrPeriod					:= 360.0;			(* Period of the axis *)


(***************************************************************************************************************************************************************************************************)
// OpMode 'EndlessFeed'
	stSlave1Interface.stEndless.i_lrPeriod 					:= 500.0;		(* Period one cycle in units *)
	stSlave1Interface.stEndless.i_lrJerk 					:= 108000.0;	(* Jerk in units/s^3 *)
	stSlave1Interface.stEndless.i_lrStopPosition 			:= 120.0;		(* Stop position in units *)
	stSlave1Interface.stEndless.i_lrAcc  					:= 10800.0;		(* Acceleration in Units/s^2 *)
	stSlave1Interface.stEndless.i_lrDec  					:= 10800.0;		(* Deceleration in Units/s^2 *)
	stSlave1Interface.stEndless.i_lrVel 					:= 1080.0;   	(* Velocity in Units/s *)

(***************************************************************************************************************************************************************************************************)
// OpMode 'Positioning'
	stSlave1Interface.stPos.i_etPosMode						:= PDL_ET_PosMode.Relative;		(* SYSTEMINTERFACE.ET_PosMode.Endless, SYSTEMINTERFACE.ET_PosMode.Relative, SYSTEMINTERFACE.ET_PosMode.Absolute *)
	stSlave1Interface.stPos.i_lrTarget 						:= 1440.0;		(* Target position or distance in Units *)
	stSlave1Interface.stPos.i_lrAcc 						:= 10800.0;		(* Acceleration in Units/s^2 *)
	stSlave1Interface.stPos.i_lrDec 						:= 10800.0;		(* Deceleration in Units/s^2 *)
	stSlave1Interface.stPos.i_lrJerk 						:= 108000.0;	(* Jerk in units/s^3 *)
	stSlave1Interface.stPos.i_lrVel 						:= 540.0;		(* Ceiling velocity in Units/s *)
	
(***************************************************************************************************************************************************************************************************)
// OpMode 'Cam'
	stSlave1Interface.stMultiCam.i_etCSModeSlave			:= PDL_ET_MultiCamCsModeSlave.SetSlavePositionToFirstCamPosition;		(* ColdStartMode Slave *)
	stSlave1Interface.stMultiCam.i_etCSModeMaster			:= PDL_ET_MultiCamCsModeMaster.SetMasterPositionToFirstCamPosition;		(* ColdStartMode Master *)
	stSlave1Interface.stMultiCam.i_etWSMode					:= PDL_ET_MultiCamWsMode.StoredCamMoveAlwaysNoPositionCheck;			(* WarmStartMode *)
	stSlave1Interface.stMultiCam.i_lrWSWindow				:= 5.0;											(* WarmStartWindow in Axis units *)
	stSlave1Interface.stMultiCam.i_lrWSVel					:= 10.0;										(* Velocity for WarmStart and CSModeSlave = PDL.ET_MultiCamCsModeSlave.MoveSlaveToFirstCamPosition in Units/s *)
	stSlave1Interface.stMultiCam.i_lrWSAcc					:= 1_000.0;										(* Acceleration and deceleration for Warmstart and CSModeSlave = PDL.ET_MultiCamCsModeSlave.MoveSlaveToFirstCamPosition in Units/s^2 *)
	stSlave1Interface.stMultiCam.i_lrWSJerk					:= 10_000.0;									(* Jerk for Warmstart and CSModeSlave = PDL.ET_MultiCamCsModeSlave.MoveSlaveToFirstCamPosition in units/s^3 *)
	stSlave1Interface.stMultiCam.i_diTXend					:= 2*20;	(* Time of XLowEnd and XHighEnd befor Xend or Xstart in msec*)
	stSlave1Interface.stMultiCam.i_lrInstantXLimMax			:= 180.0;											(* Switch off position at 'InstantNewCam' *)
	
	stSlave1Interface.stMultiCam.i_xEnableTabHandler		:= FALSE;										(* TRUE: TabHandler is enabled *)
	stSlave1Interface.stMultiCam.i_udiTableSelectNr			:= AXM_ET_ParId.Cont;							(* Number of table which is used in the next cycle *)								
	
// 	stSlave1Interface.stMultiCam.i_xSetEncoderParameters	:= FALSE;										(* TRUE: The parameters MasterId, FeedConstand, GearIn and GearOut will be copyed into LEnc object *)
	stSlave1Interface.stMultiCam.i_xSetEncoderPosition		:= TRUE;										(* TRUE: Manipulation of LEnc object on startup OpMode MultiCam *)
	stSlave1Interface.stMultiCam.i_lrSetEncoderOffset		:= 0.0;											(* Master encoder offset *)
	stSlave1Interface.stMultiCam.i_xCheckEncoderPeriod		:= TRUE;										(* TRUE: Check of encoder period = 0. If encoder period <> 0 -> Exception *)

	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].diNumberOfCamPoints := 5;
	
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[0].lrX := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[0].lrY := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[0].lrM := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[0].lrK := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[0].lrLambda := 0.5;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[0].lrC := 1;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[0].etCamType := CMT.ET_CAMTYPE.Poly5;
	
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[1].lrX := 100;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[1].lrY := 120;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[1].lrM := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[1].lrK := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[1].lrLambda := 1;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[1].lrC := 1;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[1].etCamType := CMT.ET_CAMTYPE.Straight;
	
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[2].lrX := 200;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[2].lrY := 120;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[2].lrM := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[2].lrK := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[2].lrLambda := 0.5;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[2].lrC := 1;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[2].etCamType := CMT.ET_CAMTYPE.Poly5;
	
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[3].lrX := 260;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[3].lrY := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[3].lrM := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[3].lrK := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[3].lrLambda := 1;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[3].lrC := 1;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[3].etCamType := CMT.ET_CAMTYPE.Straight;
	
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[4].lrX := 360;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[4].lrY := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[4].lrM := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[4].lrK := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[4].lrLambda := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[4].lrC := 0;
	stSlave1Interface.stMultiCam.iq_astMotionPar[AXM_ET_ParId.Cont].astCamPoint[4].etCamType := CMT.ET_CAMTYPE.Straight;




	
//	stSlave1Interface.stMultiCam.iq_xNewCam					:= FALSE;										(* TRUE: A new DataStruct will be load for next cycle. Will be reset when new cycle is started in case of stMultiCam.i_xEnableTabHandler = FALSE. *)
//	stSlave1Interface.stMultiCam.iq_xInstantNewCam			:= FALSE;										(* TRUE: A new DataStruct will be load. It will be active at master position stMultiCam.i_lrInstantXLimMax. Will be reset when ne DataStruct is active *)
//	stSlave1Interface.stMultiCam.iq_xChangeMaster			:= FALSE;										(* TRUE: Switch to a new Master. Will be reset when done. *)			

