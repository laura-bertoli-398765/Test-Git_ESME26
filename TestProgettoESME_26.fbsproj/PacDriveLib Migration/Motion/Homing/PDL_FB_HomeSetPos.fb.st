__METADATA__
{
  "v3Meta": {
    "objectGuid": "7f8878de-bab9-441f-b36d-5f26c9cb8348",
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
FUNCTION_BLOCK PDL_FB_HomeSetPos
VAR_INPUT
	i_xEnable             : BOOL;
	i_ifDrive             : MOIN.IF_Axis;
	i_etMode              : PDL_ET_HomeSetPosMode;
	i_lrHomePosition      : LREAL;
	i_lrEncoderPosition   : LREAL;
	i_lrAbsEncOffset      : LREAL;
	i_lrUserPeriod        : LREAL;
	i_lrRestoreWindow     : LREAL;
	i_pstRestorePosRetain : POINTER TO PDL_ST_AxisRestorePosition;
	i_xExecute            : BOOL;
	iq_lencEncoder        : MOIN.IF_LogicalEncoder;
END_VAR
VAR_OUTPUT
	q_xActive           : BOOL;
	q_xReady            : BOOL;
	q_xBusy             : BOOL;
	q_xDone             : BOOL;
	q_etDiag            : GD.ET_Diag     := GD.ET_Diag.Ok;
	q_etDiagExt         : PDL_ET_DiagExt := PDL_ET_DiagExt.Disabled;
	q_sMsg              : STRING[80];
	q_lrPosition        : LREAL;
	q_lrEncoderPosition : LREAL;
	q_xHomeOk           : BOOL;
END_VAR
VAR
	xEnableFlag                                : BOOL;
	diState                                    : DINT;
	lrEncoderPeriode                           : LREAL;
	lrTurns                                    : LREAL;
	lrModuloPosition                           : LREAL;
	lrEncPosition                              : LREAL;
	xInterfacesInitialized                     : BOOL;
	xSuccess                                   : BOOL;
	etDiagTemp                                 : GD.ET_Diag := GD.ET_Diag.Ok;
	etDiagExtTemp                              : PDL_ET_DiagExt := PDL_ET_DiagExt.Ok;
	sDummyString                               : STRING[80];
	fbLoggerPoint                              : APL.FB_LoggerPoint;
	fbSetPosAxis                               : PLCO.MC_SetPosition;
	fbSetPosLenc                               : PLCO.MC_SetPosition;
	ifScalingAccess                            : DMFI.IF_ScalingAccess;
	ifScaling                                  : DMFI.IF_Scaling;
	ifGetParentDevice                          : DTSI.IF_GetParentDevice;
	ifDeviceAccess                             : DTSI.IF_DeviceAccess;
	ifEncoderAccess                            : DDI.IF_EncoderAccess;
	ifEncoder                                  : DDI.IF_Encoder;
	etModeOld                                  : PDL_ET_HomeSetPosMode;
	lrQuotientEncPeriodToUserPeriod            : LREAL;
	diTruncFromQuotient                        : DINT;
	lrAbsDifferenceQuotientToTruncFromQuotient : LREAL;
	xUserPeriodFitsIntoEncoderPeriod           : BOOL;
END_VAR
__IMPLEMENTATION__
IF i_xEnable AND NOT xEnableFlag THEN (* Input action by rising edge of enable *)
	xEnableFlag := TRUE;
	THIS^.fbLoggerPoint.AddLogEntry(
		i_etLogLevel := APL.ET_LogLevel.UserAction, i_etDiag := q_etDiag, i_udiDiagExt := q_etDiagExt, i_sMessage := 'enable function block',
	);
	q_xActive              := TRUE;
	q_xReady               := FALSE;
	q_xBusy                := FALSE;
	q_xDone                := FALSE;
	q_xHomeOk              := FALSE;
	xInterfacesInitialized := Init_Interfaces();
	IF xInterfacesInitialized THEN
		etModeOld := i_etMode;
		q_xReady  := TRUE;
		SetDiagOutput(i_etDiag := GD.ET_Diag.OK, i_etDiagExt := PDL_ET_DiagExt.WaitForExecute, i_sMsg := '');
		diState := 10;
	END_IF
	i_ifDrive.xIsHomed := FALSE;
	
ELSIF NOT i_xEnable AND xEnableFlag THEN (* Output action by falling edge of enable *)
	xEnableFlag := FALSE;
	THIS^.fbLoggerPoint.AddLogEntry(
		i_etLogLevel := APL.ET_LogLevel.UserAction, i_etDiag := q_etDiag, i_udiDiagExt := q_etDiagExt, i_sMessage := 'disable function block',
	);
	xInterfacesInitialized := FALSE;
	q_xActive              := FALSE;
	q_xReady               := FALSE;
	q_xBusy                := FALSE;
	q_xDone                := FALSE;
	q_lrPosition           := 0.0;
	q_lrEncoderPosition    := 0.0;
	q_xHomeOk              := FALSE;
	SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.Disabled, i_sMsg := '');
	diState := 0;
ELSIF NOT q_xActive THEN
	RETURN;
END_IF

IF xInterfacesInitialized THEN
	q_lrPosition        := i_ifDrive.RefPosition;
	IF iq_lencEncoder <> 0 THEN
		q_lrEncoderPosition := iq_lencEncoder.RefPosition;
	ELSE
		q_lrEncoderPosition := 0;
	END_IF
	q_xBusy             := q_etDiag = GD.ET_Diag.Ok AND NOT q_xDone AND diState > 10;
ELSE
	diState  := 0;
	q_xReady := FALSE;
	RETURN;
END_IF

CASE diState OF
	0: (* Idle *)
		;
	10: (* wait for xExecute *)
		IF i_xExecute THEN
			IF etModeOld <> i_etMode THEN
				etModeOld              := i_etMode;
				xInterfacesInitialized := Init_Interfaces();
			END_IF
			lrEncoderPeriode := 0;
			
			THIS^.fbLoggerPoint.AddLogEntry(
				i_etLogLevel := APL.ET_LogLevel.UserAction,
				i_etDiag     := q_etDiag,
				i_udiDiagExt := q_etDiagExt,
				i_sMessage   := 'start homing',
				q_etDiag     =>,
				q_etDiagExt  =>
			);
			
			lrEncoderPeriode 			:= ifEncoder.Revolutions 
											* ifScaling.PositionResolution 
											* TO_LREAL(ifScaling.GearIn) / TO_LREAL(ifScaling.GearOut) 
											* TO_LREAL( ifEncoder.GearOut) / TO_LREAL(ifEncoder.GearIn);

						// Calculation if UserPeriod fits into EncoderPeriod										
			IF (i_lrUserPeriod > CMT.Gc_lrZeroTolerance) AND (lrEncoderPeriode > CMT.Gc_lrZeroTolerance) THEN 			
						
				lrQuotientEncPeriodToUserPeriod					:= lrEncoderPeriode/i_lrUserPeriod;
				diTruncFromQuotient 							:= TRUNC(lrQuotientEncPeriodToUserPeriod);	
				lrAbsDifferenceQuotientToTruncFromQuotient		:= ABS (lrQuotientEncPeriodToUserPeriod - TO_LREAL(diTruncFromQuotient));
				
				IF (lrAbsDifferenceQuotientToTruncFromQuotient < CMT.Gc_lrZeroTolerance)
				OR ((1 - lrAbsDifferenceQuotientToTruncFromQuotient < CMT.Gc_lrZeroTolerance) AND (lrAbsDifferenceQuotientToTruncFromQuotient <= 1)) THEN
					xUserPeriodFitsIntoEncoderPeriod	:= TRUE;			
				ELSE
					xUserPeriodFitsIntoEncoderPeriod	:= FALSE;		
				END_IF
				
			END_IF		
							
			CASE i_etMode OF
				//---------------------------------------
				PDL_ET_HomeSetPosMode.RestorePosFromRetain,
				PDL_ET_HomeSetPosMode.SetPosAxisPosition,
				PDL_ET_HomeSetPosMode.SetPosLogEncoderPosition,
				PDL_ET_HomeSetPosMode.SetPosAxisAndLogEncoderPosition,
				PDL_ET_HomeSetPosMode.RestorePosFromAxisencoder:
					//---------------------------------------

					//Input-Parameter-Checks
					IF i_etMode = PDL_ET_HomeSetPosMode.RestorePosFromAxisEncoder OR i_etMode = PDL_ET_HomeSetPosMode.RestorePosFromRetain THEN
						IF (ABS(ifEncoder.Revolutions) < 1.0E-3) THEN
							SetDiagOutput(	i_etDiag := GD.ET_Diag.DriveConditionInvalid, 
											i_etDiagExt := PDL_ET_DiagExt.DriveEncoderInvalid, 
											i_sMsg := ''
							);
							diState := 0;
							RETURN;
						END_IF
						
						IF (i_lrUserPeriod < 0.0) THEN
							SetDiagOutput(
								i_etDiag    := GD.ET_Diag.InputParameterInvalid,
								i_etDiagExt := PDL_ET_DiagExt.UserPeriodRange,
								i_sMsg      := '0.0 <= i_lrUserPeriod'
							);
							diState := 0;
							RETURN;
							// if UserPeriod = 0: Check if AbsEncOffset > 0 										
						ELSIF
							i_etMode = PDL_ET_HomeSetPosMode.RestorePosFromAxisencoder AND
							(i_lrUserPeriod = 0.0) AND
							((i_lrAbsEncOffset < 0) OR (i_lrAbsEncOffset > lrEncoderPeriode))
						THEN
							SetDiagOutput(
								i_etDiag    := GD.ET_Diag.InputParameterInvalid,
								i_etDiagExt := PDL_ET_DiagExt.AbsEncOffsetRange,
								i_sMsg      := STANDARD.CONCAT('0.0 < i_lrAbsEncOffset <= ', SE_CTBX.FC_LrealToString(i_sFormat := '#0.00', i_lrInput := lrEncoderPeriode))
							);
							diState := 0;
							RETURN;
							// Check if UserPeriode fits into EncoderPeriode  
						ELSIF i_etMode = PDL_ET_HomeSetPosMode.RestorePosFromAxisencoder AND (i_lrUserPeriod > 0.0) AND NOT xUserPeriodFitsIntoEncoderPeriod 
						THEN
							SetDiagOutput(
								i_etDiag    := GD.ET_Diag.InputParameterInvalid,
								i_etDiagExt := PDL_ET_DiagExt.UserPeriodRange,
								i_sMsg      := STANDARD.CONCAT('i_lrUserPeriod has to be a divsior of ',SE_CTBX.FC_LrealToString(i_sFormat := '#0.00', i_lrInput := lrEncoderPeriode))
							);
							diState := 0;
							RETURN;
						END_IF
					END_IF
					
					q_xHomeOk := FALSE;
					q_xBusy   := TRUE;
					q_xDone   := FALSE;
					SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitUntilHomingDone, i_sMsg := '');
					diState := 20;
				ELSE
					SetDiagOutput(i_etDiag := GD.ET_Diag.InputParameterInvalid, i_etDiagExt := PDL_ET_DiagExt.UnknownMode, i_sMsg := '');
					diState := 0;
			END_CASE
		END_IF
	20:
		CASE i_etMode OF
			//---------------------------------------
			PDL_ET_HomeSetPosMode.RestorePosFromRetain: (* Restore axis position from stored and actual Values of position and encoder position *)
				//---------------------------------------
				IF i_pstRestorePosRetain > 0 THEN
					PDL_FC_RestoreAxisPosition(
						i_ifDrive           := i_ifDrive,
						i_lrUserPeriod      := i_lrUserPeriod,
						i_lrRestoreWindow   := i_lrRestoreWindow,
						i_stRestorePosition := i_pstRestorePosRetain^,
						q_etDiag            => etDiagTemp,
						q_etDiagExt         => etDiagExtTemp,
						q_sMsg              => sDummyString
					);
					IF etDiagTemp = GD.ET_Diag.Ok THEN
						diState := 30;
					ELSE
						CASE etDiagExtTemp OF
							PDL_ET_DiagExt.CheckSumInvalid:
								SetDiagOutput(
									i_etDiag    := GD.ET_Diag.InputParameterInvalid,
									i_etDiagExt := PDL_ET_DiagExt.CheckSumInvalid,
									i_sMsg      := 'FB_HomeSetPos: FC_RestoreAxisPosition'
								);
							PDL_ET_DiagExt.DataNVRamInvalid:
								SetDiagOutput(
									i_etDiag    := GD.ET_Diag.InputParameterInvalid,
									i_etDiagExt := PDL_ET_DiagExt.DataNVRamInvalid,
									i_sMsg      := 'FB_HomeSetPos: FC_RestoreAxisPosition'
								);
							PDL_ET_DiagExt.SercosNotInPhaseFour:
								SetDiagOutput(
									i_etDiag    := GD.ET_Diag.DriveConditionInvalid,
									i_etDiagExt := PDL_ET_DiagExt.SercosNotInPhaseFour,
									i_sMsg      := 'FB_HomeSetPos: FC_RestoreAxisPosition'
								);
							PDL_ET_DiagExt.DriveEncoderInvalid:
								SetDiagOutput(
									i_etDiag    := GD.ET_Diag.DriveConditionInvalid,
									i_etDiagExt := PDL_ET_DiagExt.DriveEncoderInvalid,
									i_sMsg      := 'FB_HomeSetPos: FC_RestoreAxisPosition'
								);
							PDL_ET_DiagExt.OutOfRestoreWindow:
								SetDiagOutput(
									i_etDiag    := GD.ET_Diag.LimitReached,
									i_etDiagExt := PDL_ET_DiagExt.OutOfRestoreWindow,
									i_sMsg      := 'FB_HomeSetPos: FC_RestoreAxisPosition'
								);
							PDL_ET_DiagExt.UnexpectedFeedback:
								SetDiagOutput(
									i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
									i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
									i_sMsg      := Standard.CONCAT('FB_HomeSetPos: FC_RestoreAxisPosition: ', sDummyString)
								);
							PDL_ET_DiagExt.RestoreInterrupted:
								SetDiagOutput(
									i_etDiag    := GD.ET_Diag.DriveConditionInvalid,
									i_etDiagExt := PDL_ET_DiagExt.RestoreInterrupted,
									i_sMsg      := 'FB_HomeSetPos: FC_RestoreAxisPosition'
								);
						END_CASE
						diState := 0;
					END_IF
				ELSE
					SetDiagOutput(
						i_etDiag := GD.ET_Diag.InputParameterInvalid, i_etDiagExt := PDL_ET_DiagExt.PointerRestorePosRetainInvalid, i_sMsg := ''
					);
					diState := 0;
				END_IF
				//-------------------------------------
			PDL_ET_HomeSetPosMode.SetPosAxisPosition:
				//-------------------------------------

				THIS^.fbSetPosAxis(Axis := i_ifDrive, Execute := TRUE, Position := i_lrHomePosition, Relative := FALSE);
				
				IF THIS^.fbSetPosAxis.Done THEN
					diState := 30;
				ELSIF THIS^.fbSetPosAxis.Error THEN
					SetDiagOutput(
						i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
						i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
						i_sMsg      := CONCAT('MC_Setposition.ErrorID: ', PLCO.FC_EtResultToString(THIS^.fbSetPosAxis.ErrorId))
					);
					THIS^.fbSetPosAxis(Execute := FALSE);
					diState := 0;
				END_IF
				
				//-------------------------------------------
			PDL_ET_HomeSetPosMode.SetPosLogEncoderPosition:
				//-------------------------------------------
				THIS^.fbSetPosLenc(Axis := iq_lencEncoder, Execute := TRUE, Position := i_lrEncoderPosition, Relative := FALSE);
				
				IF THIS^.fbSetPosLenc.Done THEN
					diState := 30;
				ELSIF THIS^.fbSetPosLenc.Error THEN
					SetDiagOutput(
						i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
						i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
						i_sMsg      := CONCAT('MC_Setposition.ErrorID: ', PLCO.FC_EtResultToString(THIS^.fbSetPosLenc.ErrorId))
					);
					THIS^.fbSetPosLenc(Execute := FALSE);
					diState := 0;
				END_IF
				
				//--------------------------------------------------
			PDL_ET_HomeSetPosMode.SetPosAxisAndLogEncoderPosition:
				//--------------------------------------------------
				THIS^.fbSetPosLenc(Axis := iq_lencEncoder, Execute := TRUE, Position := i_lrEncoderPosition, Relative := FALSE);
				
				THIS^.fbSetPosAxis(Axis := i_ifDrive, Execute := TRUE, Position := i_lrHomePosition, Relative := FALSE);
				
				IF THIS^.fbSetPosAxis.Done AND THIS^.fbSetPosLenc.Done THEN
					diState := 30;
				ELSIF THIS^.fbSetPosAxis.Error THEN
					SetDiagOutput(
						i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
						i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
						i_sMsg      := CONCAT('MC_Setposition.ErrorID: ', PLCO.FC_EtResultToString(THIS^.fbSetPosAxis.ErrorId))
					);
					THIS^.fbSetPosAxis(Execute := FALSE);
					THIS^.fbSetPosLenc(Execute := FALSE);
					diState := 0;
					
				ELSIF THIS^.fbSetPosLenc.Error THEN
					SetDiagOutput(
						i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
						i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
						i_sMsg      := CONCAT('MC_Setposition.ErrorID: ', PLCO.FC_EtResultToString(THIS^.fbSetPosLenc.ErrorId))
					);
					THIS^.fbSetPosLenc(Execute := FALSE);
					THIS^.fbSetPosAxis(Execute := FALSE);
					diState := 0;
				END_IF
				
				//--------------------------------------------
			PDL_ET_HomeSetPosMode.RestorePosFromAxisencoder: (* Gebertyp feststellen und GeberPeriode berechnen *)
				//--------------------------------------------
				lrTurns          := ifEncoder.Revolutions;
				IF NOT ifScaling.InvertDirection THEN (* motor direction right *)
					lrEncPosition := ifEncoder.Position;
				ELSE
					lrEncPosition := lrEncoderPeriode - ifEncoder.Position;
				END_IF
				(* In a round axis, position is always within the user period, AbsEncOffset is not allowed *)
				IF i_lrUserPeriod > 0.0 THEN
					lrModuloPosition := lrEncPosition - TRUNC_INT(lrEncPosition / i_lrUserPeriod) * i_lrUserPeriod;
					THIS^.fbSetPosAxis(Axis := i_ifDrive, Execute := TRUE, Position := lrModuloPosition, Relative := FALSE);
				ELSE
					(* Absolute axis *)
					(*---------------*)
					(* The range of the encoder period is between 0 and encoder period *)
					(* In absolute systems it makes sense to have an Offset to have neg. positions *)
					(* Of course, the Offset reduces the upper limit of the max. travel *)

					(* without AbsEncOffset *)
					(* 		   +---------------------------------------------------------------------------------------------------+ 	                   	*)
					(*         0                                                                                                EncoderPeriode				*)

					(* with AbsEncOffset *)
					(* 		   +---------------------+-----------------------------------------------------------------------------+ 	                   	*)
					(*		-AbsEncOffset			0												                   EncoderPeriode - AbsEncOffset		*)
					IF (lrEncPosition > (lrEncoderPeriode - i_lrAbsEncOffset)) THEN
						THIS^.fbSetPosAxis(Axis := i_ifDrive, Execute := TRUE, Position := lrEncPosition - lrEncoderPeriode, Relative := FALSE);
					ELSE
						THIS^.fbSetPosAxis(Axis := i_ifDrive, Execute := TRUE, Position := lrEncPosition, Relative := FALSE);
					END_IF
				END_IF
				IF THIS^.fbSetPosAxis.Done THEN
					diState := 30;
				ELSE
					SetDiagOutput(
						i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
						i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
						i_sMsg      := CONCAT('MC_Setposition.ErrorID: ', PLCO.FC_EtResultToString(THIS^.fbSetPosAxis.ErrorId))
					);
					THIS^.fbSetPosAxis(Execute := FALSE);
					diState := 0;
				END_IF
			ELSE (* End case mode / Home.Mode unknown *)
				SetDiagOutput(i_etDiag := GD.ET_Diag.InputParameterInvalid, i_etDiagExt := PDL_ET_DiagExt.UnknownMode, i_sMsg := '');
				diState := 0;
		END_CASE
	30: (* Set Outputs for Homing Results *)
		SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.HomingDone, i_sMsg := '');
		q_xHomeOK := TRUE;
		q_xDone   := TRUE;
		THIS^.fbSetPosAxis(Execute := FALSE);
		THIS^.fbSetPosLenc(Execute := FALSE);
		diState := 40;
	40: (* Wait for NOT Execute *)
		IF NOT i_xExecute THEN
			SetDiagOutput(i_etDiag := GD.ET_Diag.Ok, i_etDiagExt := PDL_ET_DiagExt.WaitForExecute, i_sMsg := '');
			diState := 10;
		END_IF
	ELSE (* End of case *)
		SetDiagOutput(
			i_etDiag := GD.ET_Diag.UnexpectedProgramBehavior, i_etDiagExt := PDL_ET_DiagExt.UnknownState, i_sMsg := DINT_TO_STRING(diState)
		);
		diState := 0;
END_CASE
