__METADATA__
{
  "v3Meta": {
    "objectGuid": "516cc20d-6417-457e-b7d2-a6a47d863bea",
    "objectTypeGuid": "6f9dac99-8de1-4efc-8465-68ac443b7d08",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {
      "_3S.CoDeSys.LanguageModelManager.BuildProperty": "<?xml version=\"1.0\" encoding=\"utf-8\"?><Single xml:space=\"preserve\" Type=\"{24568a24-c491-472c-a21f-ee5d33859fab}\" Method=\"IArchivable\"><Single Name=\"MemoryReserveForOnlineChange\" Type=\"int\">0</Single><Single Name=\"ExcludeFromBuild\" Type=\"bool\">False</Single><Single Name=\"External\" Type=\"bool\">False</Single><Single Name=\"EnableSystemCall\" Type=\"bool\">False</Single><Single Name=\"CompilerDefines\" Type=\"string\"></Single><Single Name=\"LinkAlways\" Type=\"bool\">True</Single><Array Name=\"Undefines\" Type=\"string\" /></Single>"
    },
    "subObjects": {}
  },
  "linkAlways": true
}
__DECLARATION__
FUNCTION PDL_FC_ReadDriveEncoder: BOOL 
VAR_INPUT
	i_ifDrive			: MOIN.IF_Axis;				
	i_lrHomePos			: LREAL;			
	i_lrAbsEncOffset	: LREAL;			
	i_lrUserPeriod		: LREAL;			
END_VAR
VAR_OUTPUT	
	q_etDiag			: GD.ET_Diag := GD.ET_Diag.OK;
	q_etDiagExt			: PDL_ET_DiagExt := PDL_ET_DiagExt.OK;
	q_sMsg				: STRING[80];
END_VAR
VAR
	ifGetParentDevice   : DTSI.IF_GetParentDevice;
	ifDeviceAccess		: DTSI.IF_DeviceAccess;	
	ifEncoderAccess		: DDI.IF_EncoderAccess;
	ifEncoder			: DDI.IF_Encoder;	
	ifScalingAccess     : DMFI.IF_ScalingAccess;
	ifScaling		    : DMFI.IF_Scaling;
	xSuccess			: BOOL;
	lrEncoderPeriode:	LREAL;
	lrEncPosition:		LREAL;
	lrModuloPosition:	LREAL;
	lrHomePosition:		LREAL;
	lrTurns:			LREAL;
	lrEncoderRange:		LREAL;
	fbSetPos			: PLCO.MC_SetPosition;
END_VAR
VAR CONSTANT
	c_lrRealNull				: LREAL := 10E-12;
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

xSuccess := __QUERYINTERFACE(ifDeviceAccess,ifEncoderAccess ); 
IF (NOT xSuccess OR ifEncoderAccess = 0) THEN
	q_etDiag	:= GD.ET_Diag.InputParameterInvalid; 
	q_etDiagExt := PDL_ET_DiagExt.DriveInvalid;
	q_sMsg		:= 'i_ifDrive - IF_Encoder not implemented.';
	RETURN;
END_IF
ifEncoder := ifEncoderAccess.Encoder;

xSuccess := __QUERYINTERFACE(ifDeviceAccess,ifScalingAccess ); 
IF (NOT xSuccess OR ifScalingAccess = 0) THEN
	q_etDiag	:= GD.ET_Diag.InputParameterInvalid; 
	q_etDiagExt := PDL_ET_DiagExt.DriveInvalid;
	q_sMsg		:= 'i_ifDrive - IF_Scaling not implemented.';
	RETURN;
END_IF
ifScaling := ifScalingAccess.Scaling;
// Allgemeine Berehcnung ohne unterscheidung des Gebertyps			30.09.2009/ck
lrEncoderRange := ifEncoder.Revolutions;
IF (ABS(lrEncoderRange) < 1.0E-3) THEN
	q_etDiag	:= GD.ET_Diag.DriveConditionInvalid;
	q_etDiagExt := PDL_ET_DiagExt.DriveEncoderInvalid;
	q_sMsg		:= '';
	RETURN;
ELSE
	lrEncoderPeriode := lrEncoderRange * ifScaling.PositionResolution * TO_LREAL(ifScaling.GearIn) / TO_LREAL(ifScaling.GearOut);
END_IF

IF (i_lrUserPeriod < 0.0) THEN
	q_etDiag	:= GD.ET_Diag.InputParameterInvalid; 
	q_etDiagExt := PDL_ET_DiagExt.UserPeriodRange;
	q_sMsg		:= '0.0 <= i_lrUserPeriod';	 

ELSIF (i_lrUserPeriod < c_lrRealNull) AND 
	( (i_lrAbsEncOffset < c_lrRealNull) OR (i_lrAbsEncOffset > (lrEncoderPeriode - c_lrRealNull)) ) THEN
	q_etDiag	:= GD.ET_Diag.InputParameterInvalid;
	q_etDiagExt := PDL_ET_DiagExt.AbsEncOffsetRange;
	q_sMsg		:= STANDARD.CONCAT('0.0 < i_lrAbsEncOffset <= ', SE_CTBX.FC_LrealToString(i_sFormat := '#0.00', i_lrInput := lrEncoderPeriode - c_lrRealNull));

(* Check if UserPeriode fits into EncoderPeriode *)
ELSIF(i_lrUserPeriod > c_lrRealNull) AND 
		(ABS(lrEncoderPeriode/i_lrUserPeriod - TRUNC_INT(lrEncoderPeriode / i_lrUserPeriod)) > c_lrRealNull ) THEN
	q_etDiag	:= GD.ET_Diag.InputParameterInvalid; 
	q_etDiagExt := PDL_ET_DiagExt.UserPeriodRange;
	q_sMsg		:= STANDARD.CONCAT('i_lrUserPeriod has to be a divsior of ', SE_CTBX.FC_LrealToString(i_sFormat := '#0.00', i_lrInput := lrEncoderPeriode));
 
ELSE

	IF NOT ifScaling.InvertDirection THEN				(* motor direction right (true) *)
		lrEncPosition := ifEncoder.Position;
	ELSE
		lrEncPosition := lrEncoderPeriode - ifEncoder.Position;
	END_IF

(* In a round axis, position is always within the user period *)
	IF i_lrUserPeriod > c_lrRealNull THEN
		lrHomePosition := i_lrHomePos + lrEncPosition - lrEncoderPeriode/2.0;

		lrTurns :=  TRUNC_INT(lrHomePosition / i_lrUserPeriod);
		IF lrHomePosition < 0 THEN
			lrTurns := lrTurns - 1;
		END_IF
		
		lrModuloPosition := lrHomePosition - lrTurns * i_lrUserPeriod;

	ELSE
		lrModuloPosition := i_lrHomePos + lrEncPosition - i_lrAbsEncOffset;
	END_IF

	fbSetPos(Axis := i_ifDrive, Position := lrModuloPosition, Relative := FALSE, Execute := TRUE);
												
	IF fbSetPos.Error THEN				
		q_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior;
		q_etDiagExt := PDL_ET_DiagExt.UnexpectedDiagExt;
		q_sMsg		:= CONCAT('Setpos: ', TO_STRING(fbSetPos.ErrorId));
	END_IF
END_IF

