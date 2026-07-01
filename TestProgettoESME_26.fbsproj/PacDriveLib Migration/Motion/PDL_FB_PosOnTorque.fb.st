__METADATA__
{
  "v3Meta": {
    "objectGuid": "d04f4ee3-cff8-482d-a610-8835ce64356b",
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
FUNCTION_BLOCK PDL_FB_PosOnTorque
VAR_INPUT
	i_ifDrive        : MOIN.IF_Axis;
	i_lrMaxTorque    : LREAL;
	i_diTorqueTime   : DINT;
	i_lrLowLimit     : LREAL;
	i_lrHighLimit    : LREAL;
	i_lrMaxTravel    : LREAL;
	i_lrOffset       : LREAL;
	i_lrVelocity     : LREAL;
	i_lrAcceleration : LREAL;
	i_lrDeceleration : LREAL;
	i_lrJerk         : LREAL;
	i_xStart         : BOOL;
END_VAR
VAR_OUTPUT
	q_etDiag    : GD.ET_Diag     := GD.ET_Diag.Ok;
	q_etDiagExt : PDL_ET_DiagExt := PDL_ET_DiagExt.WaitForStart;
	q_sMsg      : STRING[80];
	q_xTorqueOk : BOOL;
END_VAR
VAR
	ifGetParentDevice       : DTSI.IF_GetParentDevice;
	ifDeviceAccess          : DTSI.IF_DeviceAccess;
	ifDriveConfigAccess     : DDI.IF_DriveConfigAccess;
	ifDriveConfig           : DDI.IF_DriveConfig;
	ifDriveCurrentAccess    : DDI.IF_DriveCurrentAccess;
	ifDriveCurrent          : DDI.IF_DriveCurrent;
	ifMotorAccess           : DDI.IF_MotorAccess;
	ifMotor                 : DDI.IF_Motor;
	ifDriveAccess           : DMFI.IF_DriveAccess;
	ifDrive                 : DMFI.IF_Drive;
	xSuccess                : BOOL;
	diState                 : DINT;
	lrPosTorque             : LREAL;
	lrUserCurrentLimitTemp  : LREAL;
	lrTorqueCurrent         : LREAL;
	lrMaxCurrent            : LREAL;
	udiStartTime            : UDINT;
	udiEndTime              : UDINT;
	lrLimCurrent            : LREAL;
	lrMaxDrivePeakCurrent   : LREAL;
	lrTorqueConstant        : LREAL;
	diCurrent               : DINT;
	lrMaxPossibleTorque_loc : LREAL;
	fbStop                  : PLCO.MC_Stop;
	fbMoveAbsolute          : PLCO.MC_MoveAbsolute;
	fbMoveRelative          : PLCO.MC_MoveRelative;
	rOldUserCurrentLimit: REAL;
END_VAR
__IMPLEMENTATION__
IF i_xStart THEN (* Erstdurchlauf *)
	
	InitInterfaces();
	
	fbMoveAbsolute.Axis         := i_ifDrive;
	fbMoveAbsolute.Velocity     := i_lrVelocity;
	fbMoveAbsolute.Acceleration := i_lrAcceleration;
	fbMoveAbsolute.Deceleration := i_lrDeceleration;
	fbMoveAbsolute.Jerk         := i_lrJerk;
	fbMoveAbsolute.BufferMode   := PLCO.MC_Buffer_Mode.Aborting;
	fbMoveAbsolute.Direction    := PLCO.MC_Direction.PositiveDirection;
	
	fbMoveRelative.Axis         := i_ifDrive;
	fbMoveRelative.Velocity     := i_lrVelocity;
	fbMoveRelative.Acceleration := i_lrAcceleration;
	fbMoveRelative.Deceleration := i_lrDeceleration;
	fbMoveRelative.Jerk         := i_lrJerk;
	fbMoveRelative.BufferMode   := PLCO.MC_Buffer_Mode.Aborting;
	
	fbStop.Deceleration := i_lrDeceleration;
	fbStop.Jerk         := i_lrJerk;
	
	fbMoveAbsolute(Execute := FALSE);
	fbMoveRelative(Execute := FALSE);
	fbStop(Execute := FALSE);
	q_xTorqueOk := FALSE;
	
	rOldUserCurrentLimit  := ifDriveCurrent.UserCurrentLimit;
	lrMaxDrivePeakCurrent := DINT_TO_LREAL(ifDriveConfig.MaxDrivePeakCurrent);
	lrTorqueConstant      := ifMotor.TorqueConstant;
	
	// UserCurrentTemp:= MaxTorque / Axis.TorqueConstant * 10000000 / Axis.DrivePeakC  / Axis.LimCurrent;	 (* in % *)
	lrLimCurrent           := lrMaxDrivePeakCurrent * 100.0 / lrMaxDrivePeakCurrent;
	lrUserCurrentLimitTemp := i_lrMaxTorque / lrTorqueConstant * 10000000.0 / lrMaxDrivePeakCurrent / lrLimCurrent; (* in % *)
	
	lrMaxPossibleTorque_loc := 100.0 * lrLimCurrent * lrMaxDrivePeakCurrent / 10000000.0 * lrTorqueConstant;
	
	IF lrUserCurrentLimitTemp > 100.0 OR lrUserCurrentLimitTemp < 0.0 THEN
		q_etDiag    := GD.ET_Diag.InputParameterInvalid;
		q_etDiagExt := PDL_ET_DiagExt.MaxTorqueRange;
		q_sMsg      := '';
		diState     := 0;
	ELSE
		// Limit ist sofort aktiv wenn Wert < 100 
		ifDriveCurrent.UserCurrentLimit := LREAL_TO_REAL(lrUserCurrentLimitTemp);
		
		lrTorqueCurrent := i_lrMaxTorque * 1000.0 / ifMotor.TorqueConstant; (* Level for Stop  *)
		
		lrMaxCurrent := DINT_TO_LREAL(ifDriveConfig.MaxDrivePeakCurrent) * lrLimCurrent * 0.8 / 100.0; (* 80 % *)
		
		fbMoveRelative(Distance := i_lrMaxTravel, Execute := TRUE);
		
		q_etDiag    := GD.ET_Diag.Ok;
		q_etDiagExt := PDL_ET_DiagExt.WaitUntilMaxTorqueReached;
		q_sMsg      := '';
		diState     := 10;
	END_IF
END_IF

(*---------------------------------------------------------------------------------------------------------------------------------------*)
CASE diState OF
	0: (* Finished or Error*)
		;
		(*---------------------------------------------------------------------------------------------------------------------------------------*)
	10: (* wait until inside the Limits  *)
		
		fbMoveRelative(Execute := TRUE);
		IF fbMoveRelative.Done THEN (* MaxTravel reached and no MaxTorque *)
			q_etDiag    := GD.ET_Diag.ExecutionAborted;
			q_etDiagExt := PDL_ET_DiagExt.MaxTorqueNotFound;
			q_sMsg      := '';
			diState     := 0;
		ELSIF fbMoveRelative.Error THEN (* error in Pos parameters *)
			q_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior;
			q_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback;
			q_sMsg      := CONCAT('MC_MoveRelative.Error: ', PLCO.FC_EtResultToString(THIS^.fbMoveRelative.ErrorID));
			diState     := 0;
		ELSIF (i_lrMaxTravel > 0.0 AND ifDrive.ActualPosition > i_lrLowLimit) OR (i_lrMaxTravel < 0.0 AND ifDrive.ActualPosition < i_lrHighLimit) THEN
			ifDriveCurrent.UserCurrentLimit := TO_REAL(lrUserCurrentLimitTemp);
			q_etDiag                        := GD.ET_Diag.Ok;
			q_etDiagExt                     := PDL_ET_DiagExt.WaitUntilMaxTorqueReached;
			q_sMsg                          := '';
			diState                         := 20;
		ELSIF DINT_TO_LREAL(ABS(ifDriveCurrent.Current)) > lrMaxCurrent THEN (* If Current > 80% of Max --> Fehler *)
			
			fbStop(Execute := TRUE);
			
			ifDriveCurrent.UserCurrentLimit := TO_REAL(lrUserCurrentLimitTemp);
			
			udiStartTime := SystimeCore.SystimeGetMs();
			q_etDiag     := GD.ET_Diag.Ok;
			q_etDiagExt  := PDL_ET_DiagExt.WaitUntilMaxTorqueReached;
			q_sMsg       := '';
			
			diState := 50;
		END_IF
		(*---------------------------------------------------------------------------------------------------------------------------------------*)
	20: (* wait for cut off Current  *)
		fbMoveRelative(Execute := TRUE);
		
		diCurrent := ABS(ifDriveCurrent.Current);
		
		IF fbMoveRelative.Done THEN (* MaxTravel reached and no MaxTorque *)
			ifDriveCurrent.UserCurrentLimit := rOldUserCurrentLimit;
			q_etDiag                        := GD.ET_Diag.ExecutionAborted;
			q_etDiagExt                     := PDL_ET_DiagExt.MaxTorqueNotFound;
			q_sMsg                          := '';
			diState                         := 0;
			
		ELSIF diCurrent > lrTorqueCurrent * 9.0 / 10.0 THEN (* Check if  Overload occured *)
			udiStartTime := SystimeCore.SystimeGetMs();
			fbStop(Execute := TRUE);
			q_etDiag    := GD.ET_Diag.Ok;
			q_etDiagExt := PDL_ET_DiagExt.WaitUntilMaxTorqueReached;
			q_sMsg      := '';
			diState     := 30;
		END_IF
		(*---------------------------------------------------------------------------------------------------------------------------------------*)
	30: (* Wait TorqueTime over *)
		
		udiEndTime := SystimeCore.SystimeGetMs();
		
		i_ifDrive.xIsHomed := TRUE;
		IF TO_DINT(udiEndTime - udiStartTime) > i_diTorqueTime THEN
			
			lrPosTorque := ifDrive.ActualPosition; (* This is our Fixed Stop position *)
			
			fbStop(Execute := FALSE);
			fbMoveAbsolute(Position := lrPosTorque + i_lrOffset, Execute := TRUE);
			
			q_etDiag    := GD.ET_Diag.Ok;
			q_etDiagExt := PDL_ET_DiagExt.WaitUntilOffsetReached;
			q_sMsg      := '';
			diState     := 40;
		ELSIF ABS(ifDriveCurrent.Current) < (lrTorqueCurrent / 4) THEN (* IF it was only a short resistance *)
			
			fbStop(Execute := FALSE);
			
			fbMoveAbsolute(Position := i_lrMaxTravel, Execute := TRUE);
			
			q_etDiag    := GD.ET_Diag.Ok;
			q_etDiagExt := PDL_ET_DiagExt.WaitUntilMaxTorqueReached;
			q_sMsg      := '';
			diState     := 20;
		END_IF
		
		(*---------------------------------------------------------------------------------------------------------------------------------------*)
	40: (* Wait for Offset position reached *)
		
		fbMoveAbsolute(Execute := TRUE);
		
		IF fbMoveAbsolute.Done THEN
			q_xTorqueOk                     := TRUE;
			ifDriveCurrent.UserCurrentLimit := rOldUserCurrentLimit;
			q_etDiag                        := GD.ET_Diag.Ok;
			q_etDiagExt                     := PDL_ET_DiagExt.WaitForStart;
			q_sMsg                          := '';
			diState                         := 0;
		ELSIF fbMoveAbsolute.Error THEN
			ifDriveCurrent.UserCurrentLimit := rOldUserCurrentLimit;
			q_etDiag                        := GD.ET_Diag.UnexpectedProgramBehavior;
			q_etDiagExt                     := PDL_ET_DiagExt.UnexpectedFeedback;
			q_sMsg                          := CONCAT('MC_MoveAbsolute.Error: ', PLCO.FC_EtResultToString(THIS^.fbMoveAbsolute.ErrorID));
			diState                         := 0;
		END_IF
		
		(*---------------------------------------------------------------------------------------------------------------------------------------*)
	50: (* Wait TorqueTime over *)
		
		udiEndTime := SystimeCore.SystimeGetMs();
		
		i_ifDrive.xIsHomed := TRUE;
		IF (udiEndTime - udiStartTime) > 10 THEN (* Damit ControllerStop auch wirklich gemacht ist *)
			
			lrPosTorque := ifDrive.ActualPosition; (* This is our Fixed Stop position *)
			
			fbStop(Execute := FALSE);
			
			IF i_lrOffset < 0 THEN
				fbMoveAbsolute(Position := lrPosTorque - 1, Execute := TRUE);
			ELSE
				fbMoveAbsolute(Position := lrPosTorque + 1, Execute := TRUE);
			END_IF
			q_etDiag    := GD.ET_Diag.Ok;
			q_etDiagExt := PDL_ET_DiagExt.WaitUntilOffsetReached;
			q_sMsg      := '';
			diState     := 60;
		END_IF
		
		(*---------------------------------------------------------------------------------------------------------------------------------------*)
	60: (* Wait for Offset position reached *)
		
		fbMoveAbsolute(Execute := TRUE);
		
		IF fbMoveAbsolute.Done THEN
			fbMoveAbsolute(Execute := FALSE);
			ifDriveCurrent.UserCurrentLimit := rOldUserCurrentLimit;
			q_etDiag                        := GD.ET_Diag.Ok;
			q_etDiagExt                     := PDL_ET_DiagExt.WaitForStart;
			q_sMsg                          := '';
			diState                         := 0;
		ELSIF fbMoveAbsolute.Error THEN
			fbMoveAbsolute(Execute := FALSE);
			ifDriveCurrent.UserCurrentLimit := rOldUserCurrentLimit;
			q_etDiag                        := GD.ET_Diag.UnexpectedProgramBehavior;
			q_etDiagExt                     := PDL_ET_DiagExt.UnexpectedFeedback;
			q_sMsg                          := CONCAT('MC_MoveAbsolute.Error: ', PLCO.FC_EtResultToString(THIS^.fbMoveAbsolute.ErrorID));
			diState                         := 0;
		END_IF
		
		(*---------------------------------------------------------------------------------------------------------------------------------------*)
	ELSE (* Default of CASE *)
		q_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior;
		q_etDiagExt := PDL_ET_DiagExt.UnknownState;
		q_sMsg      := '';
		diState     := 0;
END_CASE
