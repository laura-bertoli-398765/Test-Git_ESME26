__METADATA__
{
  "v3Meta": {
    "objectGuid": "5de7a2f5-7513-47c8-ac44-01f3827a8c65",
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
astSubModuleInterface[c_udiMaster].i_sModuleName	:= STANDARD.CONCAT(STR1 := iq_stStandardModuleItf.i_sModuleName, STR2 := ': Master');

astSubModuleInterface[c_udiMaster].i_xLogEnable		:= TRUE;
astSubModuleInterface[c_udiMaster].i_wLogDataFilter	:= UDINT_TO_WORD(TPL.ET_LogDataFilter.ModuleDefault);

fbMasterModule.RegisterLoggerPoint(	i_ifParent	:= fbLoggerPoint,
									i_sName		:= 'Master',
									q_etDiag	:= ,
									q_etDiagExt	:= );


(* AxisModule specific interface *)
stMasterInterface.stMain.i_ifMaster		:= i_ifMaster; 		(* Master *)
stMasterInterface.stMain.i_ifDrive		:= DRV_Master.Axis;
stMasterInterface.stMain.iq_lencEncoder	      := LE_Master.Axis;
DRV_Master.Axis.SetAxisTypeModulo(i_lrPeriod := 360.0); 
DRV_Master.Axis.SetErrorStopRamp(i_lrDeceleration  := 50_000.0,
						  		 i_lrJerk		   := 500_000.0);

xDriveIsVirtual := FC_IsDriveVirtual(	i_ifDrive	:= stMasterInterface.stMain.i_ifDrive,
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

stMasterInterface.stMain.i_lrMotionActiveVelLimit						:= 15.0;		(* Limit for max. velocity of astAxisModuleInterface to switch output AxisMove in Units/s *)
stMasterInterface.stMain.i_etMotionActiveVelType  						:= AXM_ET_MotionActiveVelType.RefVelocity;

stMasterInterface.stMain.i_timMasterStop								:= T#1S;
stMasterInterface.stMain.i_xHwLimitPos									:= FALSE;
stMasterInterface.stMain.i_xHwLimitNeg									:= FALSE;

stMasterInterface.stMain.stReducedVelocity.i_xEnableReducedVelocity		:= FALSE;
stMasterInterface.stMain.stReducedVelocity.i_xOnlyLimitCheck			:= FALSE;
stMasterInterface.stMain.stReducedVelocity.i_lrMaxReducedVelocity		:= 50.0;


stMasterInterface.stMain.i_xStart										:= FALSE;

(***************************************************************************************************************************************************************************************************)
(*** Homing ***)		
	IF xDriveIsVirtual THEN
		stMasterInterface.stHome.i_etMode := PDL_ET_HomeMode.SetPosAxisPosition;			(* Homing Mode  in case of virtual axis *)
	ELSE
		stMasterInterface.stHome.i_etMode := PDL_ET_HomeMode.PosDirectionPosEdgeSensor;						(* Homing Mode in case of real axis *)
	END_IF
	
	stMasterInterface.stHome.i_xEnableInitAbsReadPos := FALSE;		(* TRUE : Restores the AxisPosition depending on the stHome.etMode
																			  If stHome.i_etMode is equal to PDL_ET_HomeMode.RestorePosFromAxisEncoder or 
																			  to PDL_ET_HomeMode.WriteAxisEncoder, the encoder of the axis is read,
																			  or else the position will be restored from the retain area *)
																			  
 	stMasterInterface.stHome.stSetpos.iq_pstRestorePosRetain := ADR(Grp_stRestorePositionAxis1);
	
	stMasterInterface.stHome.i_xResetHomeOk := FALSE;
	
	(* Possible modes for homing mode Sensor:
		PDL_ET_HomeMode.PosDirectionPosEdgeSensor
		PDL_ET_HomeMode.NegDirectionPosEdgeSensor
		PDL_ET_HomeMode.NegDirectionNegEdgeSensor
		PDL_ET_HomeMode.PosDirectionNegEdgeSensor
	*)
	stMasterInterface.stHome.stSensor.i_lrHomePosition			:= 0.0;			(* Position at the end of homing in units *)
	stMasterInterface.stHome.stSensor.i_lrVel					:= 10.0;		(* Homing ceiling velocity in units/s *)
	stMasterInterface.stHome.stSensor.i_lrAcc					:= 1000.0;		(* Homing acceleration in units/s^2 *)
	stMasterInterface.stHome.stSensor.i_lrDec					:= 1000.0;		(* Homing deceleration in units/s^2 *)
	stMasterInterface.stHome.stSensor.i_lrJerk					:= 10000.0;		(* Homing jerk in units/s^3 *)
	stMasterInterface.stHome.stSensor.i_lrOffset				:= 0.0;			(* Offset from home signal in units *)
	stMasterInterface.stHome.stSensor.i_lrMaxTravel				:= 720.0;		(* Max. travel for referencing by normal input *)
	stMasterInterface.stHome.stSensor.i_xRotativeSystem			:= FALSE;		(* Rotative system true or false for referencing by normal input *)
	stMasterInterface.stHome.stSensor.i_xSensor					:= FALSE;		(* Input for home signal. Can be a signal from a controller input. Has to be written cyclic. *)
	
	(* Possible Modes for homing mode LimitSwitch:
		PDL_ET_HomeMode.PosDirectionPosEdgeHWLimitPos		normally open contact / Closing contact
		PDL_ET_HomeMode.NegDirectionPosEdgeHWLimitNeg		normally open contact / Closing contact
		PDL_ET_HomeMode.NegDirectionNegEdgeHWLimitNeg		normally closed contact / Opening contact  
		PDL_ET_HomeMode.PosDirectionNegEdgeHWLimitPos		normally closed contact / Opening contact 
	*)
	stMasterInterface.stHome.stLimitSwitch.i_lrHomePosition		:= 0.0;			(* Position at the end of homing in units *)
	stMasterInterface.stHome.stLimitSwitch.i_lrVel				:= 10.0;		(* Homing ceiling velocity in units/s *)
	stMasterInterface.stHome.stLimitSwitch.i_lrLowVel			:= 5.0;			(* Homing low ceiling velocity in units/s *)
	stMasterInterface.stHome.stLimitSwitch.i_lrAcc				:= 1000.0;		(* Homing acceleration in units/s^2 *)
	stMasterInterface.stHome.stLimitSwitch.i_lrDec				:= 1000.0;		(* Homing deceleration in units/s^2 *)
	stMasterInterface.stHome.stLimitSwitch.i_lrJerk				:= 10000.0;		(* Homing jerk in units/s^3 *)
	stMasterInterface.stHome.stLimitSwitch.i_lrOffset			:= 0.0;			(* Offset from home signal in units *)
	stMasterInterface.stHome.stLimitSwitch.i_lrMaxTravel		:= 9999.0;		(* Max. travel for referencing normal input as a hardware limit *)
	
	(* Possible modes for homing mode MoveOnPos:
		PDL_ET_HomeMode.MoveOnPosAbs 
	*)
	stMasterInterface.stHome.stMoveOnPos.i_lrTarget				:= 0.0;			(* Position at the end of homing in units *)
	stMasterInterface.stHome.stMoveOnPos.i_lrVel				:= 10.0;		(* Homing ceiling velocity in units/s *)
	stMasterInterface.stHome.stMoveOnPos.i_lrAcc				:= 1000.0;		(* Homing acceleration in units/s^2 *)
	stMasterInterface.stHome.stMoveOnPos.i_lrDec				:= 1000.0;		(* Homing deceleration in units/s^2 *)
	stMasterInterface.stHome.stMoveOnPos.i_lrJerk				:= 10000.0;		(* Homing jerk in units/s^3 *)
	stMasterInterface.stHome.stMoveOnPos.i_lrPeriod				:= 0.0;			(* Period of the axis *)
	stMasterInterface.stHome.stMoveOnPos.i_xRotativeSystem		:= FALSE;		(* Rotative system true or false *)
	
	(* Possible modes for homing mode SetPos:
		PDL_ET_HomeMode.SetPosAxisPosition 
		PDL_ET_HomeMode.SetPosLogEncoderPosition 
		PDL_ET_HomeMode.SetPosAxisAndLogEncoderPosition
		PDL_ET_HomeMode.RestorePosFromAxisEncoder 
		PDL_ET_HomeMode.RestorePosFromRetain 
	*)
	stMasterInterface.stHome.stSetpos.i_lrHomePosition			:= 0.0;			(* Position at the end of homing in units *)
	stMasterInterface.stHome.stSetpos.i_lrEncoderPosition		:= 0.0;			(* Encoder position in units after homing *)
	stMasterInterface.stHome.stSetpos.i_lrAbsEncOffset			:= 100.0;		(* Distance to the jump of axis encoder in units  *)
	stMasterInterface.stHome.stSetpos.i_lrRestoreWindow			:= 180;			(* How far can the drive be away from is correct position *)
	stMasterInterface.stHome.stSetpos.i_lrUserPeriod			:= 360;			(* Period of the axis *)
	stMasterInterface.stHome.stSetPos.i_xKeepPowerDisabled 		:= FALSE;		(* Keep Power disabled during SetPosHoming true or false*)
	
	(* Possible modes for homing mode Torque:
		PDL_ET_HomeMode.PosDirectionMaxTorque 
		PDL_ET_HomeMode.NegDirectionMaxTorque 
	*)
	stMasterInterface.stHome.stTorque.i_lrHomePosition			:= 0.0;			(* Position at the end of homing in units *)
	stMasterInterface.stHome.stTorque.i_lrVel					:= 10.0;		(* Homing ceiling velocity in units/s *)
	stMasterInterface.stHome.stTorque.i_lrAcc					:= 1000.0;		(* Homing acceleration in units/s^2 *)
	stMasterInterface.stHome.stTorque.i_lrDec					:= 1000.0;		(* Homing deceleration in units/s^2 *)
	stMasterInterface.stHome.stTorque.i_lrJerk					:= 10000.0;		(* Homing jerk in units/s^3 *)
	stMasterInterface.stHome.stTorque.i_lrOffset				:= 0.0;			(* Offset from home signal in units *)
	stMasterInterface.stHome.stTorque.i_lrMaxTravel				:= 9999.0;		(* Max. travel for referencing by torque *)
	stMasterInterface.stHome.stTorque.i_lrMaxTorque				:= 0.0;			(* Torque for stop in Nm / referencing by torque *)
	stMasterInterface.stHome.stTorque.i_diTorqueTime			:= 5;			(* Time in msec to hold torque *)
	
	(* Possible modes for homing mode TouchProbe:
		PDL_ET_HomeMode.PosDirectionPosEdgeTp 
		PDL_ET_HomeMode.NegDirectionPosEdgeTp 
		PDL_ET_HomeMode.NegDirectionNegEdgeTp 
		PDL_ET_HomeMode.PosDirectionNegEdgeTp 
	*)
	stMasterInterface.stHome.stTouchProbe.i_lrHomePosition		:= 0.0;			(* Position at the end of homing in units *)
	stMasterInterface.stHome.stTouchProbe.i_lrVel				:= 100.0;		(* Homing ceiling velocity in units/s *)
	stMasterInterface.stHome.stTouchProbe.i_lrAcc				:= 1000.0;		(* Homing acceleration in units/s^2 *)
	stMasterInterface.stHome.stTouchProbe.i_lrDec				:= 1000.0;		(* Homing deceleration in units/s^2 *)
	stMasterInterface.stHome.stTouchProbe.i_lrJerk				:= 10000.0;		(* Homing jerk in units/s^3 *)
	stMasterInterface.stHome.stTouchProbe.i_lrOffset			:= 30.0;		(* Offset from home signal in units *)
	stMasterInterface.stHome.stTouchProbe.i_lrMaxTravel			:= 720.0;		(* Max. travel for referencing by TP *)
	stMasterInterface.stHome.stTouchProbe.i_xRotativeSystem		:= TRUE;		(* Rotative system true or false for referencing by TP *)
 	stMasterInterface.stHome.stTouchProbe.i_ifTouchProbe		:= 0;		(* Input for TP *)
	
	(* Possible modes for homing mode WritePos:
		PDL_ET_HomeMode.WriteAxisEncoder 
	*)
	stMasterInterface.stHome.stWritePos.i_lrHomePosition		:= 0.0;			(* Position at the end of homing in units *)
	stMasterInterface.stHome.stWritePos.i_lrUserPeriod			:= 0.0;			(* Calculates Drive.Position into period ( units ) *)
	stMasterInterface.stHome.stWritePos.i_lrAbsEncOffset		:= 100.0;		(* Distance to the jump of axis encoder in units *)
(***************************************************************************************************************************************************************************************************)
(*** Manual ***)
	stMasterInterface.stManual.i_lrVel								:= 50.0;			(* Velocity in units/s *)
	stMasterInterface.stManual.i_lrAcc								:= 100.0;			(* Acceleration in units/s^2 *)
	stMasterInterface.stManual.i_lrDec								:= 100.0;			(* Deceleration in units/s^2 *)
	stMasterInterface.stManual.i_lrJerk								:= 1000.0;			(* Jerk in units/s^3 *)
	stMasterInterface.stManual.i_lrMaxDistance						:= 120.0;			(* Max pathlengths for one step in units *)
	stMasterInterface.stManual.i_xEndless							:= FALSE;			(* TRUE: jogging endless; Position between the periode; FALSE: jogging in steps. Position can be out of periode *)
	stMasterInterface.stManual.i_lrPeriod							:= 360.0;			(* Period of the axis *)

(***************************************************************************************************************************************************************************************************)
(*** Endless ***)
	stMasterInterface.stEndless.i_lrPeriod 				:= 360.0;		(* Period one cycle in units *)
	stMasterInterface.stEndless.i_lrJerk 				:= 108000.0;	(* Jerk in units/s^3 *)
	stMasterInterface.stEndless.i_lrStopPosition 		:= 120.0;		(* Stop position in units *)
	stMasterInterface.stEndless.i_lrAcc  				:= 10800.0;		(* Acceleration in Units/s^2 *)
	stMasterInterface.stEndless.i_lrDec  				:= 10800.0;		(* Deceleration in Units/s^2 *)
	stMasterInterface.stEndless.i_lrVel 				:= 180.0;   	(* Velocity in Units/s *)

(***************************************************************************************************************************************************************************************************)
(*** Pos ***)
	stMasterInterface.stPos.i_etPosMode					:= PDL_ET_PosMode.Relative;		(* SYSTEMINTERFACE.ET_PosMode.Endless, SYSTEMINTERFACE.ET_PosMode.Relative, SYSTEMINTERFACE.ET_PosMode.Absolute *)
	stMasterInterface.stPos.i_lrTarget 					:= 1440.0;		(* Target position or distance in Units *)
	stMasterInterface.stPos.i_lrAcc 					:= 10800.0;		(* Acceleration in Units/s^2 *)
	stMasterInterface.stPos.i_lrDec 					:= 10800.0;		(* Deceleration in Units/s^2 *)
	stMasterInterface.stPos.i_lrJerk 					:= 108000.0;	(* Jerk in units/s^3 *)
	stMasterInterface.stPos.i_lrVel 					:= 540.0;		(* Ceiling velocity in Units/s *)

// stMasterInterface.stPos.i_xStop								:= FALSE;
(* End of system generated code, could be modified for your application *)
