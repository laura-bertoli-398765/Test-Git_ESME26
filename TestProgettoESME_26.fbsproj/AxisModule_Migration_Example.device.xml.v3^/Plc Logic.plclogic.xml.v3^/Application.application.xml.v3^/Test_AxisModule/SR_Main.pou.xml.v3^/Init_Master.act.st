__METADATA__
{
  "v3Meta": {
    "objectGuid": "8274b26c-c205-4b8e-8fda-1e0d810ff83b",
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
	astModuleInterface[c_udiMaster].i_sModuleName 		:= 'Master';
				// Assigning the drive to the AxisModule dedicated to DRV_Master
	stMasterInterface.stMain.i_ifMaster					:= 0; 		
	stMasterInterface.stMain.i_ifDrive					:= DRV_Master.Axis;
	stMasterInterface.stMain.iq_lencEncoder				:= LE_Master;
	DRV_Master.Axis.SetAxisTypeModulo(i_lrPeriod	:= 360.0);




	// Parameterising the movements of the OpModes of DRV_Master ...
(***************************************************************************************************************************************************************************************************)
//OpMode Homing
	stMasterInterface.stHome.i_etMode := PDL_ET_HomeMode.SetPosAxisPosition;			(* Homing Mode  in case of virtual axis *)

	(* Possible modes for homing mode SetPos:
		PDL_ET_HomeMode.SetPosAxisPosition 
		PDL_ET_HomeMode.SetPosLogEncoderPosition 
		PDL_ET_HomeMode.SetPosAxisAndLogEncoderPosition
	*)
	stMasterInterface.stHome.stSetpos.i_lrHomePosition			:= 10.0;			(* Position at the end of homing in units *)
	stMasterInterface.stHome.stSetpos.i_lrEncoderPosition		:= 0.0;			(* Encoder position in units after homing *)

(***************************************************************************************************************************************************************************************************)
(*** Manual ***)
	stMasterInterface.stManual.i_lrVel					:= 50.0;			(* Velocity in units/s *)
	stMasterInterface.stManual.i_lrAcc					:= 100.0;			(* Acceleration in units/s^2 *)
	stMasterInterface.stManual.i_lrDec					:= 100.0;			(* Deceleration in units/s^2 *)
	stMasterInterface.stManual.i_lrJerk					:= 1000.0;			(* Jerk in units/s^3 *)
	stMasterInterface.stManual.i_lrMaxDistance			:= 120.0;			(* Max pathlengths for one step in units *)
	stMasterInterface.stManual.i_xEndless				:= FALSE;			(* TRUE: jogging endless; Position between the periode; FALSE: jogging in steps. Position can be out of periode *)
	stMasterInterface.stManual.i_lrPeriod				:= 360.0;			(* Period of the axis *)


(***************************************************************************************************************************************************************************************************)
// OpMode 'EndlessFeed'
	stMasterInterface.stEndless.i_lrPeriod 				:= 360.0;		(* Period one cycle in units *)
	stMasterInterface.stEndless.i_lrJerk 				:= 108000.0;	(* Jerk in units/s^3 *)
	stMasterInterface.stEndless.i_lrStopPosition 		:= 120.0;		(* Stop position in units *)
	stMasterInterface.stEndless.i_lrAcc  				:= 10800.0;		(* Acceleration in Units/s^2 *)
	stMasterInterface.stEndless.i_lrDec  				:= 10800.0;		(* Deceleration in Units/s^2 *)
	stMasterInterface.stEndless.i_lrVel 				:= 100.0;   	(* Velocity in Units/s *)

(***************************************************************************************************************************************************************************************************)
// OpMode 'Positioning'
	stMasterInterface.stPos.i_etPosMode					:= PDL_ET_PosMode.Relative;		(* SYSTEMINTERFACE.ET_PosMode.Endless, SYSTEMINTERFACE.ET_PosMode.Relative, SYSTEMINTERFACE.ET_PosMode.Absolute *)
	stMasterInterface.stPos.i_lrTarget 					:= 1440.0;		(* Target position or distance in Units *)
	stMasterInterface.stPos.i_lrAcc 					:= 10800.0;		(* Acceleration in Units/s^2 *)
	stMasterInterface.stPos.i_lrDec 					:= 10800.0;		(* Deceleration in Units/s^2 *)
	stMasterInterface.stPos.i_lrJerk 					:= 108000.0;	(* Jerk in units/s^3 *)
	stMasterInterface.stPos.i_lrVel 					:= 540.0;		(* Ceiling velocity in Units/s *)
	

