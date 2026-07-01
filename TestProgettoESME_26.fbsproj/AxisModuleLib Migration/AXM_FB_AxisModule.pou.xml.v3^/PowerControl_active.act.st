__METADATA__
{
  "v3Meta": {
    "objectGuid": "3ace14da-dde1-48a4-ba04-45999c630589",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* ------------------------------------------------------------------------------------------------------------------------------------------------------*)
(* Controller State Machine *)
(* ------------------------------------------------------------------------------------------------------------------------------------------------------*)

CASE etPowerState OF

	AXM_ET_PowerState.Disabled:	(* Error or Disabled *)
		;

(* ------------------------------------------------------------------------------------------------------------------------------------------------------*)
	AXM_ET_PowerState.PowerOff:	(* Controller State: Axis disabled, wait for PowerOn *)
(* ------------------------------------------------------------------------------------------------------------------------------------------------------*)
		fbDriveEnable(	i_xEnable		:= TRUE,
						i_ifDrive		:= iq_stAxisModuleItf.stMain.i_ifDrive,
						i_xEnableDrive	:= xCMDPowerOn AND NOT fbHome.q_xDisableDrive,
						i_xDiagQuit		:= iq_stStandardModuleItf.i_xDiagQuit,
						q_xActive		=> ,
						q_xReady		=> ,
						q_etDiag		=> etDiagBuffer,
						q_etDiagExt		=> etDiagExtBufferPDL,
						q_sMsg			=> sDiagMsgBuffer,
						q_xDriveEnabled	=> );
		IF (etDiagBuffer <> GD.ET_Diag.Ok) THEN
			DiagTestDriveEnable(	iq_etDiag		:= fbDriveEnable.q_etDiag,
									iq_etDiagExt	:= fbDriveEnable.q_etDiagExt,
									iq_sMsg			:= fbDriveEnable.q_sMsg);
		ELSIF fbDriveEnable.q_xDriveEnabled THEN
			etPowerState := AXM_ET_PowerState.PowerOn;
		END_IF

(* ------------------------------------------------------------------------------------------------------------------------------------------------------*)
	AXM_ET_PowerState.PowerOn:	(* Controller State: AxisEnabled, wait for PowerOff  *)
(* ------------------------------------------------------------------------------------------------------------------------------------------------------*)
		fbDriveEnable(	i_xEnable		:= TRUE,
						i_ifDrive		:= iq_stAxisModuleItf.stMain.i_ifDrive,
						i_xEnableDrive	:= xCMDPowerOn AND NOT fbHome.q_xDisableDrive,
						i_xDiagQuit		:= iq_stStandardModuleItf.i_xDiagQuit,
						q_xActive		=> ,
						q_xReady		=> ,
						q_etDiag		=> etDiagBuffer,
						q_etDiagExt		=> etDiagExtBufferPDL,
						q_sMsg			=> sDiagMsgBuffer,
						q_xDriveEnabled	=> );
		IF (etDiagBuffer <> GD.ET_Diag.Ok) THEN
			DiagTestDriveEnable(	iq_etDiag		:= fbDriveEnable.q_etDiag,
									iq_etDiagExt	:= fbDriveEnable.q_etDiagExt,
									iq_sMsg			:= fbDriveEnable.q_sMsg);
		ELSIF NOT fbDriveEnable.q_xDriveEnabled THEN
			etPowerState := AXM_ET_PowerState.PowerOff;
		END_IF

(* ------------------------------------------------------------------------------------------------------------------------------------------------------*)
	AXM_ET_PowerState.WaitForDisabled:   (* Controller State: wait for FB_Axis_Enable  not active  *)
(* ------------------------------------------------------------------------------------------------------------------------------------------------------*)
		fbDriveEnable(	i_xEnable		:= FALSE,
						i_ifDrive		:= iq_stAxisModuleItf.stMain.i_ifDrive,
						i_xEnableDrive	:= FALSE,
						i_xDiagQuit		:= FALSE,
						q_xActive		=> ,
						q_xReady		=> ,
						q_etDiag		=> etDiagBuffer,
						q_etDiagExt		=> etDiagExtBufferPDL,
						q_sMsg			=> sDiagMsgBuffer,
						q_xDriveEnabled	=> );
		
		IF (etDiagBuffer <> GD.ET_Diag.Ok) THEN
			DiagTestDriveEnable(	iq_etDiag		:= fbDriveEnable.q_etDiag,
									iq_etDiagExt	:= fbDriveEnable.q_etDiagExt,
									iq_sMsg			:= fbDriveEnable.q_sMsg);
		ELSIF NOT fbDriveEnable.q_xActive THEN
			etPowerState := AXM_ET_PowerState.Disabled;
			iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.NoOpDriveDisabled;
		END_IF
END_CASE

IF	(iq_stAxisModuleItf.stMain.i_ifDrive.etAxisState > MOIN.ET_AxisState.Disabled) THEN
	iq_stAxisModuleItf.stMain.q_xDriveActive := TRUE;
ELSE
	iq_stAxisModuleItf.stMain.q_xDriveActive := FALSE;
END_IF

(********************** xMotionActive ************************)
IF (iq_stAxisModuleItf.stMain.i_lrMotionActiveVelLimit < 0) THEN
	stExceptionModuleReaction3.etDiag := GD.ET_Diag.InputParameterInvalid;
	stExceptionModuleReaction3.udiDiagExt := AXM_ET_DiagExt.MotionActiveVelLimitRange;
	stExceptionModuleReaction3.sMsg := 'has to be >= 0';
	ReportException(iq_stException := stExceptionModuleReaction3);
ELSE
	GetInterfaces();
	IF iq_stAxisModuleItf.stMain.i_etMotionActiveVelType = AXM_ET_MotionActiveVelType.RefVelocity 
		OR iq_stAxisModuleItf.stMain.i_etMotionActiveVelType = AXM_ET_MotionActiveVelType.MechRefVelocity
	THEN
		iq_stAxisModuleItf.stMain.q_xMotionActive := ( ABS(iq_stAxisModuleItf.stMain.i_ifDrive.RefVelocity) > iq_stAxisModuleItf.stMain.i_lrMotionActiveVelLimit);
		
	ELSIF iq_stAxisModuleItf.stMain.i_etMotionActiveVelType = AXM_ET_MotionActiveVelType.MechVelocity 
		OR iq_stAxisModuleItf.stMain.i_etMotionActiveVelType = AXM_ET_MotionActiveVelType.Velocity
	THEN
		iq_stAxisModuleItf.stMain.q_xMotionActive := ( ABS(ifDrive.ActualVelocity) > iq_stAxisModuleItf.stMain.i_lrMotionActiveVelLimit);
	END_IF

END_IF

