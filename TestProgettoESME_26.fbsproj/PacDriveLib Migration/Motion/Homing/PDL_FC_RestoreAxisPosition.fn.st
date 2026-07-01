__METADATA__
{
  "v3Meta": {
    "objectGuid": "6d54f8ee-a39a-4488-91ce-8e65f97c6a12",
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
FUNCTION PDL_FC_RestoreAxisPosition : BOOL
VAR_INPUT
	i_ifDrive           : MOIN.IF_Axis;
	i_lrUserPeriod      : LREAL;
	i_lrRestoreWindow   : LREAL;
	i_stRestorePosition : PDL_ST_AxisRestorePosition;
END_VAR
VAR_OUTPUT
	q_etDiag    : GD.ET_Diag     := GD.ET_Diag.OK;
	q_etDiagExt : PDL_ET_DiagExt := PDL_ET_DiagExt.OK;
	q_sMsg      : STRING[80];
END_VAR
VAR
	xSuccess            : BOOL;
	lrEncMaxPos         : LREAL;
	lrEncDiff           : LREAL;
	lrCalcAxisPos       : LREAL;
	dinPeriode          : DINT;
	diSercosState       : DINT;
	lrEncPos            : LREAL;
	lrAxisPosition      : LREAL;
	lrEncPosition       : LREAL;
	lrCheckSum          : LREAL;
	lrAxisEncPosition   : LREAL;
	lrAxisEncPosition2  : LREAL;
	diAxisGearIn        : DINT;
	diAxisGearOut       : DINT;
	lrAxisFeedConstant  : LREAL;
	diCount             : DINT;
	lrEncoderRange      : LREAL;
	ifScalingAccess     : DMFI.IF_ScalingAccess;
	ifScaling           : DMFI.IF_Scaling;
	ifGetParentDevice   : DTSI.IF_GetParentDevice;
	ifDeviceAccess      : DTSI.IF_DeviceAccess;
	ifEncoderAccess     : DDI.IF_EncoderAccess;
	ifEncoder           : DDI.IF_Encoder;
	fbSetPos            : PLCO.MC_SetPosition;
	xAxisDirection      : BOOL;
	
END_VAR
VAR CONSTANT
	c_lrDelta : LREAL := 0.01;
END_VAR
__IMPLEMENTATION__

IF i_ifDrive = 0 THEN
	q_etDiag	:= GD.ET_Diag.InputParameterInvalid; 
	q_etDiagExt := PDL_ET_DiagExt.DriveInvalid;
	q_sMsg		:= 'i_ifDrive - Invalid Interface';
	RETURN;	
END_IF

xSuccess := __QUERYINTERFACE(i_ifDrive, ifGetParentDevice);
IF NOT xSuccess OR ifGetParentDevice = 0 THEN
	q_etDiag	:= GD.ET_Diag.InputParameterInvalid; 
	q_etDiagExt := PDL_ET_DiagExt.DriveInvalid;
	q_sMsg		:= 'i_ifDrive - IF_GetParentDevice not implemented.';
	RETURN;
END_IF

ifDeviceAccess := ifGetParentDevice.GetParentDevice();

xSuccess := __QUERYINTERFACE(ifDeviceAccess,ifScalingAccess ); 
IF (NOT xSuccess OR ifScalingAccess = 0) THEN
	q_etDiag	:= GD.ET_Diag.InputParameterInvalid; 
	q_etDiagExt := PDL_ET_DiagExt.DriveInvalid;
	q_sMsg		:= 'i_ifDrive - IF_Scaling not implemented.';
	RETURN;
END_IF
ifScaling := ifScalingAccess.Scaling;

xSuccess := __QUERYINTERFACE(ifDeviceAccess,ifEncoderAccess ); 
IF (NOT xSuccess OR ifEncoderAccess = 0) THEN
	q_etDiag	:= GD.ET_Diag.InputParameterInvalid; 
	q_etDiagExt := PDL_ET_DiagExt.DriveInvalid;
	q_sMsg		:= 'i_ifDrive - IF_Encoder not implemented.';
	RETURN;
END_IF
ifEncoder := ifEncoderAccess.Encoder;
	
(*--------------------------------------------------------------------------------------------------------------------------------------------------*)
(* read values *)
(*--------------------------------------------------------------------------------------------------------------------------------------------------*)
	lrAxisPosition := i_stRestorePosition.lrAxisPosition;
	lrEncPosition := i_stRestorePosition.lrEncPosition;
	lrCheckSum := i_stRestorePosition.lrCheckSum;

	IF (((lrAxisPosition + lrEncPosition + c_lrDelta) < lrCheckSum) OR
		((lrAxisPosition + lrEncPosition - c_lrDelta) > lrCheckSum)) THEN
		
		q_etDiag	:= GD.ET_Diag.InputParameterInvalid; 
		q_etDiagExt := PDL_ET_DiagExt.CheckSumInvalid;
		q_sMsg		:= '';
		RETURN;
	END_IF

(*--------------------------------------------------------------------------------------------------------------------------------------------------*)
(* Check Sercos state and read values *)
(*--------------------------------------------------------------------------------------------------------------------------------------------------*)
FOR diCount := 1 TO 3 DO

	diSercosState := FC_GetSercosState();
	IF diSercosState = 4 THEN
		lrAxisEncPosition := ifEncoder.Position;
		diAxisGearIn := TO_DINT(ifScaling.GearIn);
		diAxisGearOut := TO_DINT(ifScaling.GearOut);
		lrAxisFeedConstant := ifScaling.PositionResolution;
		xAxisDirection := NOT ifScaling.InvertDirection;
	ELSE
		q_etDiag	:= GD.ET_Diag.SercosConditionInvalid;
		q_etDiagExt := PDL_ET_DiagExt.SercosNotInPhaseFour;
		q_sMsg		:= '';
		RETURN;
	END_IF

(*--------------------------------------------------------------------------------------------------------------------------------------------------*)
(* Berechnung der maximale Encoder Position *)
(*--------------------------------------------------------------------------------------------------------------------------------------------------*)

	// Allgemeine Berechnung ohne Unterscheidung des Gebertyps				
	lrEncoderRange := ifEncoder.Revolutions;
	IF (ABS(lrEncoderRange) < 1.0E-3) THEN
		q_etDiag	:= GD.ET_Diag.DriveConditionInvalid;
		q_etDiagExt := PDL_ET_DiagExt.DriveEncoderInvalid;
		q_sMsg		:= '';
		RETURN;
	ELSE	
		lrEncMaxPos := lrEncoderRange * lrAxisFeedConstant * TO_LREAL(diAxisGearIn) / TO_LREAL(diAxisGearOut);
	END_IF
	
	
(*--------------------------------------------------------------------------------------------------------------------------------------------------*)
(* Differenz der Geberposition *)
(*--------------------------------------------------------------------------------------------------------------------------------------------------*)
	IF xAxisDirection THEN		(* +++ Rechtslauf +++ *)
		lrEncDiff := lrAxisEncPosition - lrEncPosition;
		IF lrEncDiff > lrEncMaxPos/2 THEN
			lrEncPos := lrAxisEncPosition - lrEncMaxPos;
			lrEncDiff := lrEncDiff - lrEncMaxPos;
		ELSIF lrEncDiff < -lrEncMaxPos/2 THEN
			lrEncPos := lrAxisEncPosition + lrEncMaxPos;
			lrEncDiff := lrEncDiff + lrEncMaxPos ;
		ELSE
			lrEncPos := lrAxisEncPosition;
		END_IF
		lrCalcAxisPos := lrEncPos - lrEncPosition + lrAxisPosition;

	ELSE						(* +++ Linkslauf +++ *)
		lrEncDiff:=  lrEncPosition - lrAxisEncPosition;	(*  lrEncMaxPos - lrAxisEncPosition
																 - (lrEncMaxPos- lrEncPos_Retain) *)
		IF lrEncDiff > lrEncMaxPos/2 THEN
			lrEncPos :=  - lrAxisEncPosition;				(* lrEncMaxPos - lrAxisEncPosition - lrEncMaxPos *)
			lrEncDiff := lrEncDiff - lrEncMaxPos;
		ELSIF lrEncDiff < -lrEncMaxPos/2 THEN
			lrEncPos := 2*lrEncMaxPos - lrAxisEncPosition;	(* lrEncMaxPos - lrAxisEncPosition + lrEncMaxPos *)
			lrEncDiff := lrEncDiff + lrEncMaxPos ;
		ELSE
			lrEncPos := lrEncMaxPos - lrAxisEncPosition;
		END_IF
		lrCalcAxisPos := lrEncPos -  (lrEncMaxPos - lrEncPosition) + lrAxisPosition;
	END_IF

(*--------------------------------------------------------------------------------------------------------------------------------------------------*)
(* check if in Window *)
(*--------------------------------------------------------------------------------------------------------------------------------------------------*)
	IF ABS(lrEncDiff) > ABS(i_lrRestoreWindow) THEN	(* Maximale Abweichung prüfen *)
		q_etDiag	:= GD.ET_Diag.DriveConditionInvalid;
		q_etDiagExt := PDL_ET_DiagExt.OutOfRestoreWindow;
		q_sMsg		:= '';
		RETURN;

(*--------------------------------------------------------------------------------------------------------------------------------------------------*)
(* Set axis position *)
(*--------------------------------------------------------------------------------------------------------------------------------------------------*)
	ELSE
		IF i_lrUserPeriod > 0 THEN
			dinPeriode:=TRUNC_INT(lrCalcAxisPos / i_lrUserPeriod );
			IF lrCalcAxisPos < 0.0 THEN
				dinPeriode:= dinPeriode - 1;
			END_IF
			lrCalcAxisPos:= lrCalcAxisPos - (dinPeriode * i_lrUserPeriod);
		END_IF

		fbSetPos(Axis := i_ifDrive, Position := lrCalcAxisPos, Relative := FALSE, Execute := TRUE);
		IF fbSetPos.Error THEN
			q_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior; 
			q_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback;
			q_sMsg		:= CONCAT('Setpos: ', PLCO.FC_EtResultToString(fbSetPos.ErrorId));
		END_IF 

	END_IF

	(* read again to make shure, that there was no interrupt through the Sercos *)
	lrAxisEncPosition2 :=  ifEncoder.Position;
	IF ABS(	lrAxisEncPosition - lrAxisEncPosition2) < c_lrDelta THEN
		RETURN;
	END_IF
END_FOR

q_etDiag	:= GD.ET_Diag.DriveConditionInvalid;
q_etDiagExt := PDL_ET_DiagExt.RestoreInterrupted;
q_sMsg		:= '';

