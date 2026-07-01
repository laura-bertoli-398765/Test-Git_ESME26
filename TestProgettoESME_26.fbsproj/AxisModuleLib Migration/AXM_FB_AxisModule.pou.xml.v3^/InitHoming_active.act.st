__METADATA__
{
  "v3Meta": {
    "objectGuid": "dae82e5a-5072-46fa-9bd0-11e67c638b29",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
InactiveCMDExecution();

fbHome.stReducedVelocity := iq_stAxisModuleItf.stMain.stReducedVelocity;
IF iq_stAxisModuleItf.stHome.i_etMode = PDL_ET_HomeMode.RestorePosFromAxisEncoder 
	OR iq_stAxisModuleItf.stHome.i_etMode = PDL_ET_HomeMode.WriteAxisEncoder THEN	
	etHomeModeTemp := PDL_ET_HomeMode.RestorePosFromAxisEncoder;
ELSE
	etHomeModeTemp := PDL_ET_HomeMode.RestorePosFromRetain;
END_IF
IF iq_stAxisModuleItf.stHome.i_xEnableInitAbsReadPos AND ( (etHomeModeTemp = PDL_ET_HomeMode.RestorePosFromAxisEncoder) OR
															(etHomeModeTemp = PDL_ET_HomeMode.RestorePosFromRetain) ) THEN
	stFbHomeSetPosProperty.i_lrAbsEncOffset			:= iq_stAxisModuleItf.stHome.stSetPos.i_lrAbsEncOffset;
	stFbHomeSetPosProperty.i_lrEncoderPosition		:= iq_stAxisModuleItf.stHome.stSetPos.i_lrEncoderPosition;
	stFbHomeSetPosProperty.i_lrHomePosition			:= iq_stAxisModuleItf.stHome.stSetPos.i_lrHomePosition;
	stFbHomeSetPosProperty.i_lrRestoreWindow		:= iq_stAxisModuleItf.stHome.stSetPos.i_lrRestoreWindow;
	stFbHomeSetPosProperty.i_lrUserPeriod			:= iq_stAxisModuleItf.stHome.stSetPos.i_lrUserPeriod;
	stFbHomeSetPosProperty.iq_pstRestorePosRetain	:= iq_stAxisModuleItf.stHome.stSetPos.iq_pstRestorePosRetain;
	stFbHomeSetPosProperty.iq_lencAxis				:= iq_stAxisModuleItf.stMain.iq_lencEncoder;
	fbHome.stSetPos := stFbHomeSetPosProperty;

	IF NOT iq_stAxisModuleItf.stHome.stSetPos.i_xKeepPowerDisabled AND
			udiInitHoming = 0 AND
			iq_stAxisModuleItf.stMain.i_ifDrive.etAxisState >= MOIN.ET_AxisState.Standstill THEN
		//Create LoggerEnty
		ReadTrackingDeviation(q_sLrealConversion => sLrealConversion);

		fbLoggerPoint.AddLogEntry (
				i_etLogLevel 	:= APL.ET_LogLevel.StatusMessage,
				i_etDiag		:= GD.ET_Diag.Ok,
				i_udiDiagExt	:= 0,
				i_sMessage		:= Standard.CONCAT('SetPos-Homing in Init:  Axis-State >= Standstill; TrackingDeviation: ',sLrealConversion)
			);
			udiInitHoming := 30;
	ELSIF udiInitHoming = 0 THEN
		IF 	iq_stAxisModuleItf.stMain.i_ifDrive.etAxisState >= MOIN.ET_AxisState.Standstill THEN
			udiInitHoming := 10;
		ELSE		
			udiInitHoming := 30;
		END_IF
	END_IF

	CASE udiInitHoming OF
	0:
		udiInitHoming := 30;
		;
	10: (* Disable Power if i_xKeepPowerDisabled is set*)
		IF iq_stAxisModuleItf.stHome.stSetPos.i_xKeepPowerDisabled THEN
			fbDriveEnable(	i_xEnable		:= TRUE,
							i_ifDrive		:= iq_stAxisModuleItf.stMain.i_ifDrive,
							i_xEnableDrive	:= FALSE,
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
				udiInitHoming := 30;
			END_IF
			
			IF fbDriveEnable.q_xActive AND NOT fbDriveEnable.q_xDriveEnabled THEN
				fbDriveEnable(	i_xEnable		:= FALSE);
				udiInitHoming := 20;
			END_IF
		ELSE
			udiInitHoming := 30;
		END_IF
		
	20: (* Check FB_DriveEnable disabled *)	
		IF NOT fbDriveEnable.q_xActive THEN
			udiInitHoming := 30;
		END_IF


	30: (* Do initial homing *)
		fbHome(	i_xEnable				:= TRUE,
				i_etMode				:= etHomeModeTemp,
				i_ifDrive	 			:= iq_stAxisModuleItf.stMain.i_ifDrive,
				i_xHwLimitNeg			:= FALSE,
				i_xHwLimitPos			:= FALSE,
				i_xStart				:= TRUE,
				q_xActive				=> ,
				q_xReady				=> ,
				q_etDiag				=> etDiagBuffer,
				q_etDiagExt				=> etDiagExtBufferPDL,
				q_sMsg					=> sDiagMsgBuffer,
				q_xDisableDrive			=> ,
				q_xMotionInstructionActive	=> ,
				q_lrPosition			=> ,
				q_lrEncoderPosition		=> ,
				q_xHomeOk				=> );
		IF (fbHome.q_etDiag <> GD.ET_Diag.Ok) THEN
			DiagTestHoming(	iq_etDiag		:= fbHome.q_etDiag,
							iq_etDiagExt	:= fbHome.q_etDiagExt,
							iq_sMsg			:= fbHome.q_sMsg);
			udiInitHoming := 40;
		END_IF
		
		IF fbHome.q_xHomeOk THEN
			iq_stAxisModuleItf.stMain.q_xHomeOk := TRUE;
			IF fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.StatusMessage THEN
				IF (etHomeModeTemp = PDL_ET_HomeMode.RestorePosFromAxisEncoder) THEN
					fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.StatusMessage,
												i_etDiag		:= GD.ET_Diag.Ok,
												i_udiDiagExt	:= AXM_ET_DiagExt.Ok,
												i_sMessage		:= 'InitAbsReadPos done from AxisEncoder',
												q_etDiag		:= ,
												q_etDiagExt		:= );
				ELSE
					fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.StatusMessage,
												i_etDiag		:= GD.ET_Diag.Ok,
												i_udiDiagExt	:= AXM_ET_DiagExt.Ok,
												i_sMessage		:= 'InitAbsReadPos done from Retain',
												q_etDiag		:= ,
												q_etDiagExt		:= );
				END_IF
			END_IF
			udiInitHoming := 40;
		END_IF
		
	40: (* clean up initial Homing *)
		fbHome(	i_xEnable				:= FALSE,
				i_etMode				:= etHomeModeTemp,
				i_ifDrive	 			:= iq_stAxisModuleItf.stMain.i_ifDrive,
				i_xHwLimitNeg			:= FALSE,
				i_xHwLimitPos			:= FALSE,
				i_xStart				:= FALSE,
				q_xActive				=> ,
				q_xReady				=> ,
				q_etDiag				=> etDiagBuffer,
				q_etDiagExt				=> etDiagExtBufferPDL,
				q_sMsg					=> sDiagMsgBuffer,
				q_xDisableDrive			=> ,
				q_xMotionInstructionActive	=> ,
				q_lrPosition			=> ,
				q_lrEncoderPosition		=> ,
				q_xHomeOk				=> );
		IF (fbHome.q_etDiag <> GD.ET_Diag.Ok) THEN
			DiagTestHoming(	iq_etDiag		:= fbHome.q_etDiag,
							iq_etDiagExt	:= fbHome.q_etDiagExt,
							iq_sMsg			:= fbHome.q_sMsg);
			xInitHomingDone := TRUE;
		END_IF
		IF NOT fbHome.q_xActive THEN
			xInitHomingDone := TRUE;
		END_IF
		
	END_CASE

ELSE
	xInitHomingDone := TRUE;
END_IF
THIS^.Output_active();

