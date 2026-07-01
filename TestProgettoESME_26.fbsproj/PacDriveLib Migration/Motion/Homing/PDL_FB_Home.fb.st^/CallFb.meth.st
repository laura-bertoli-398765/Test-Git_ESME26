__METADATA__
{
  "v3Meta": {
    "objectGuid": "874fe27d-054a-48eb-b50d-8e118b791053",
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
METHOD PRIVATE CallFb
VAR_INPUT
END_VAR
__IMPLEMENTATION__
CASE etHomeOpMode OF
	PDL_ET_HomeOpMode.TouchProbe:	(* HomeTP *)
		IF (stReducedVelocity_loc.i_xEnableReducedVelocity AND NOT stReducedVelocity_loc.i_xOnlyLimitCheck) THEN
			lrUsedVelocity := MIN(stReducedVelocity_loc.i_lrMaxReducedVelocity, stTouchProbe_loc.i_lrVel);
		ELSE
			lrUsedVelocity := stTouchProbe_loc.i_lrVel;
		END_IF
		fbHomeTP(	i_xEnable			:= xFbEnable,
					i_ifDrive			:= i_ifDrive,
					i_ifTouchProbe		:= stTouchProbe_loc.i_ifTouchProbe,
					i_etMode			:= etHomeTpMode,
					i_lrOffset			:= stTouchProbe_loc.i_lrOffset,
					i_lrMaxTravel		:= stTouchProbe_loc.i_lrMaxTravel,
					i_lrHomePosition	:= stTouchProbe_loc.i_lrHomePosition,
					i_lrVel				:= lrUsedVelocity,
					i_lrAcc				:= stTouchProbe_loc.i_lrAcc,
					i_lrDec				:= stTouchProbe_loc.i_lrDec,
					i_lrJerk			:= stTouchProbe_loc.i_lrJerk,
					i_xHwLimitNeg		:= i_xHwLimitNeg,
					i_xHwLimitPos		:= i_xHwLimitPos,
					i_xRotativeSystem	:= stTouchProbe_loc.i_xRotativeSystem,
					i_xStart			:= TRUE,
					q_xActive			=> xFbActive,
					q_xReady			=> ,
					q_etDiag			=> THIS^.etDiagBuffer,
					q_etDiagExt			=> ,
					q_sMsg				=> ,
					q_xMotionInstructionActive => ,
					q_lrPosition		=> ,
					q_xHomeOk			=> xFbHomeOk); 
		THIS^.HomeTpDiagTranslation();

	PDL_ET_HomeOpMode.Sensor:	(* HomeIN *)
		IF (stReducedVelocity_loc.i_xEnableReducedVelocity AND NOT stReducedVelocity_loc.i_xOnlyLimitCheck) THEN
			lrUsedVelocity := MIN(stReducedVelocity_loc.i_lrMaxReducedVelocity, stSensor_loc.i_lrVel);
		ELSE
			lrUsedVelocity := stSensor_loc.i_lrVel;
		END_IF
		THIS^.fbHomeIn(	i_xEnable			:= xFbEnable,
					i_ifDrive			:= i_ifDrive,
					i_xSensor			:= stSensor_loc.i_xSensor,
					i_etMode			:= etHomeInMode,
					i_lrOffset			:= stSensor_loc.i_lrOffset,
					i_lrMaxTravel		:= stSensor_loc.i_lrMaxTravel,
					i_lrHomePosition	:= stSensor_loc.i_lrHomePosition,
					i_lrVel				:= lrUsedVelocity,
					i_lrAcc				:= stSensor_loc.i_lrAcc,
					i_lrDec				:= stSensor_loc.i_lrDec,
					i_lrJerk			:= stSensor_loc.i_lrJerk,
					i_xHwLimitNeg		:= i_xHwLimitNeg,
					i_xHwLimitPos		:= i_xHwLimitPos,
					i_xRotativeSystem	:= stSensor_loc.i_xRotativeSystem,
					i_xStart			:= xStartHomeIn,
					q_xActive			=> xFbActive,
					q_xReady			=> ,
					q_etDiag			=> THIS^.etDiagBuffer,
					q_etDiagExt			=> ,
					q_sMsg				=> ,
					q_xMotionInstructionActive => ,
					q_lrPosition		=> ,
					q_xHomeOk			=> xFbHomeOk);
		THIS^.HomeInDiagTranslation();

	PDL_ET_HomeOpMode.LimitSwitch:	(* HomeLS *)
		IF (stReducedVelocity_loc.i_xEnableReducedVelocity AND NOT stReducedVelocity_loc.i_xOnlyLimitCheck) THEN
			lrUsedVelocity := MIN(stReducedVelocity_loc.i_lrMaxReducedVelocity, stLimitSwitch_loc.i_lrVel);
		ELSE
			lrUsedVelocity := stLimitSwitch_loc.i_lrVel;
		END_IF
		IF (stLimitSwitch_loc.i_lrLowVel = 0.0) THEN
			lrLowVelocity := lrUsedVelocity;
		ELSE
			IF (stReducedVelocity_loc.i_xEnableReducedVelocity AND NOT stReducedVelocity_loc.i_xOnlyLimitCheck) THEN
				lrLowVelocity := MIN(stReducedVelocity_loc.i_lrMaxReducedVelocity, stLimitSwitch_loc.i_lrLowVel);
			ELSE
				lrLowVelocity := stLimitSwitch_loc.i_lrLowVel;
			END_IF
		END_IF
		fbHomeLS(	i_xEnable			:= xFbEnable,
					i_ifDrive			:= i_ifDrive,
					i_etMode			:= etHomeLimitSwitchMode,
					i_lrOffset			:= stLimitSwitch_loc.i_lrOffset,
					i_lrMaxTravel		:= stLimitSwitch_loc.i_lrMaxTravel,
					i_lrHomePosition	:= stLimitSwitch_loc.i_lrHomePosition,
					i_lrVel				:= lrUsedVelocity,
					i_lrLowVel			:= lrLowVelocity,
					i_lrAcc				:= stLimitSwitch_loc.i_lrAcc,
					i_lrDec				:= stLimitSwitch_loc.i_lrDec,
					i_lrJerk			:= stLimitSwitch_loc.i_lrJerk,
					i_xHwLimitNeg		:= i_xHwLimitNeg,
					i_xHwLimitPos		:= i_xHwLimitPos,
					i_xStart			:= TRUE,
					q_xActive			=> xFbActive,
					q_xReady			=> ,
					q_etDiag			=> THIS^.etDiagBuffer,
					q_etDiagExt			=> ,
					q_sMsg				=> ,
					q_xMotionInstructionActive => ,
					q_lrPosition		=> ,
					q_xHomeOk			=> xFbHomeOk);
		THIS^.HomeLSDiagTranslation();


	PDL_ET_HomeOpMode.Torque:	(* HomeTorque *)
		IF (stReducedVelocity_loc.i_xEnableReducedVelocity AND NOT stReducedVelocity_loc.i_xOnlyLimitCheck) THEN
			lrUsedVelocity := MIN(stReducedVelocity_loc.i_lrMaxReducedVelocity, stTorque_loc.i_lrVel);
		ELSE
			lrUsedVelocity := stTorque_loc.i_lrVel;
		END_IF
		fbHomeTorque(	i_xEnable			:= xFbEnable,
						i_ifDrive			:= i_ifDrive,
						i_lrMaxTorque		:= stTorque_loc.i_lrMaxTorque,
						i_diTorqueTime		:= stTorque_loc.i_diTorqueTime,
						i_lrLowLimit		:= -2147483648.0,
						i_lrHighLimit		:= 2147483648.0,
						i_etMode			:= etHomeTorqueMode,
						i_lrOffset			:= stTorque_loc.i_lrOffset,
						i_lrMaxTravel		:= stTorque_loc.i_lrMaxTravel,
						i_lrHomePosition	:= stTorque_loc.i_lrHomePosition,
						i_lrVel				:= lrUsedVelocity,
						i_lrAcc				:= stTorque_loc.i_lrAcc,
						i_lrDec				:= stTorque_loc.i_lrDec,
						i_lrJerk			:= stTorque_loc.i_lrJerk,
						i_xStart			:= TRUE,
						q_xActive			=> xFbActive,
						q_xReady			=> ,
						q_etDiag			=> THIS^.etDiagBuffer,
						q_etDiagExt			=> ,
						q_sMsg				=> ,
						q_xMotionInstructionActive => ,
						q_lrPosition		=> ,
						q_xHomeOk			=> xFbHomeOk);
		THIS^.HomeTorqueDiagTranslation(); 
		
	PDL_ET_HomeOpMode.Force:	(* HomeForce *)
			;

	PDL_ET_HomeOpMode.MoveOnPos:	(* Home to a Position *)
		IF (stReducedVelocity_loc.i_xEnableReducedVelocity AND NOT stReducedVelocity_loc.i_xOnlyLimitCheck) THEN
			lrUsedVelocity := MIN(stReducedVelocity_loc.i_lrMaxReducedVelocity, stMoveOnPos_loc.i_lrVel);
		ELSE
			lrUsedVelocity := stMoveOnPos_loc.i_lrVel;
		END_IF

		THIS^.fbVarioPosJerk(	i_xEnable			:= xFbEnable,
						i_ifDrive			:= i_ifDrive,
						i_xStart			:= fbVarioPosJerk.q_xActive AND TRUE,
						i_xStop				:= FALSE,
						i_lrTarget			:= lrPositionOpmMoveOnPos,
						i_lrVel				:= lrUsedVelocity,
						i_lrAcc				:= stMoveOnPos_loc.i_lrAcc,
						i_lrDec				:= stMoveOnPos_loc.i_lrDec,
						i_lrJerk			:= stMoveOnPos_loc.i_lrJerk,
						i_etPosMode			:= SEL(stMoveOnPos_loc.i_xRotativeSystem, PDL_ET_PosMode.Absolute, PDL_ET_PosMode.Relative),
						q_xActive			=> xFbActive,
						q_xReady			=> ,
						q_etDiag			=> THIS^.etDiagBuffer,
						q_etDiagExt			=> ,
						q_sMsg				=> ,
						q_xMotionInstructionActive => ,
						q_lrPosition		=> ,
						q_xInPosition		=> xFbHomeOk);
	
		THIS^.HomeMoveOnPosDiagTranslation();
		
		fbTrigStop(CLK:= xFbEnable AND (i_ifDrive.etAxisState = MOIN.ET_AxisState.Stopping));
		IF fbTrigStop.Q THEN
			xControllerStop :=  TRUE;
			xFbEnable := FALSE;
		END_IF
		
		// Clean up as soon as VarioPos is finished
		IF NOT xFbActive THEN
			// check, if VarioPos was aborted by MC_Stop OR MC_Halt
			IF xControllerStop THEN
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.HomingFailed, 
								i_etDiagExt := PDL_ET_DiagExt.OutsideExecutionOfControllerStopSet,
								i_sMsg		:= 'MC_Stop OR MC_Halt was executed during homing active');					
			ELSE		
				IF stMoveOnPos_loc.i_lrPeriod > 0 AND stMoveOnPos_loc.i_xRotativeSystem THEN
					THIS^.fbSetPosIntern(
						Axis     := i_ifDrive,
						Position := stMoveOnPos_loc.i_lrTarget,
						Relative := FALSE,
						Execute  := TRUE);
					
					IF THIS^.fbSetPosIntern.Error THEN
							SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
											i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
											i_sMsg      := CONCAT('FB_Home error: MC_Setposition.ErrorID: ', PLCO.FC_EtResultToString(THIS^.fbSetPosIntern.ErrorID)));
					END_IF
					THIS^.fbSetPosIntern(Execute  := FALSE);
				END_IF	
			END_IF		
		END_IF

	PDL_ET_HomeOpMode.WritePos:	(* HomeAbs *)
		fbHomeAbs(	i_xEnable			:= xFbEnable,
					i_xExecute			:= TRUE,
					i_ifDrive			:= i_ifDrive,
					i_lrHomePosition	:= stWritePos_loc.i_lrHomePosition,
					i_lrAbsEncOffset	:= stWritePos_loc.i_lrAbsEncOffset,
					i_lrUserPeriod		:= stWritePos_loc.i_lrUserPeriod,
					q_xActive			=> xFbActive,
					q_xReady			=> ,
					q_xBusy				=> ,
					q_xDone				=> ,
					q_etDiag			=> THIS^.etDiagBuffer,
					q_etDiagExt			=> ,
					q_sMsg				=> ,
					q_xDisableDrive		=> q_xDisableDrive,
					q_lrPosition		=> ,
					q_xHomeOk			=> xFbHomeOk);
		THIS^.HomeWritePosDiagTranslation();

	PDL_ET_HomeOpMode.SetPos:	(* HomeSetPos *)
		THIS^.fbSetpos(	i_xEnable				:= xFbEnable,
					i_xExecute				:= TRUE,
					i_ifDrive				:= i_ifDrive,
					i_etMode				:= etHomeSetPosMode,
					i_lrHomePosition		:= stSetPos_loc.i_lrHomePosition,
					i_lrEncoderPosition		:= stSetPos_loc.i_lrEncoderPosition,
					i_lrAbsEncOffset		:= stSetPos_loc.i_lrAbsEncOffset,
					i_lrUserPeriod			:= stSetPos_loc.i_lrUserPeriod,
					i_lrRestoreWindow		:= stSetPos_loc.i_lrRestoreWindow,
					i_pstRestorePosRetain	:= stSetPos_loc.iq_pstRestorePosRetain,
					iq_lencEncoder			:= stSetPos_loc.iq_lencAxis,
					q_xActive				=> xFbActive,
					q_xReady				=> ,
					q_xBusy					=> ,
					q_xDone					=> ,
					q_etDiag				=> THIS^.etDiagBuffer,
					q_etDiagExt				=> ,
					q_sMsg					=> ,
					q_lrPosition			=> ,
					q_lrEncoderPosition		=> ,
					q_xHomeOk				=> xFbHomeOk);
		THIS^.HomeSetPosDiagTranslation();
END_CASE
IF NOT xFbActive THEN
	THIS^.etHomeOpMode := PDL_ET_HomeOpMode.NoOp;
END_IF
