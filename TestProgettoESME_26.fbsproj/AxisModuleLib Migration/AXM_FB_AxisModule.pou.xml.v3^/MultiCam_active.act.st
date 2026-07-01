__METADATA__
{
  "v3Meta": {
    "objectGuid": "5e85057d-b7e3-4f89-8b75-5d4e0717c30c",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
iq_stAxisModuleItf.stMain.q_etOpMode := AXM_ET_OpMode.MultiCam;

xEnableMultiCamFb := xCamEnable;

fbTabSwitch(	i_xEnable				:= (xCamEnable AND iq_stAxisModuleItf.stMultiCam.i_xEnableTabHandler),
				i_xLowEnd				:= iq_stAxisModuleItf.stMultiCam.q_xXLowEnd,
				i_xHighEnd				:= iq_stAxisModuleItf.stMultiCam.q_xXHighEnd,
				i_udiTableSelectNr		:= iq_stAxisModuleItf.stMultiCam.i_udiTableSelectNr,
				iq_xTakeNewCam			:= iq_stAxisModuleItf.stMultiCam.iq_xNewCam,
				iq_xTakeInstantNewCam	:= iq_stAxisModuleItf.stMultiCam.iq_xInstantNewCam,
				iq_xNewCam				:= xNewCam,
				iq_xInstantNewCam		:= xInstantNewCam,
				iq_astMotionPar			:= iq_stAxisModuleItf.stMultiCam.iq_astMotionPar,
				iq_stOutTab				:= stCamTab,
				q_xActive				=> ,
				q_xReady				=> ,
				q_etDiag				=> ,
				q_etDiagExt				=> ,
				q_sMsg					=> ,
				q_udiTableNumber		=> );
				
IF (iq_stAxisModuleItf.stMultiCam.i_udiTableSelectNr < 0) OR (iq_stAxisModuleItf.stMultiCam.i_udiTableSelectNr > AXM_GPL.Gc_udiMaxNumberOfCamTables) THEN
	iq_stAxisModuleItf.stMultiCam.i_udiTableSelectNr := 0;
ELSE
	iq_stAxisModuleItf.stMultiCam.i_udiTableSelectNr := iq_stAxisModuleItf.stMultiCam.i_udiTableSelectNr;
END_IF

IF NOT iq_stAxisModuleItf.stMultiCam.i_xEnableTabHandler THEN
	xNewCam 		:= iq_stAxisModuleItf.stMultiCam.iq_xNewCam;
	xInstantNewCam 	:= iq_stAxisModuleItf.stMultiCam.iq_xInstantNewCam;
	stCamTab 		:= iq_stAxisModuleItf.stMultiCam.iq_astMotionPar[iq_stAxisModuleItf.stMultiCam.i_udiTableSelectNr];
END_IF
	
fbMultiCam(	i_xEnable			:= xEnableMultiCamFb AND fbDriveEnable.q_xDriveEnabled,
			i_ifDrive			:= iq_stAxisModuleItf.stMain.i_ifDrive,
			i_xStart			:= (xStartFlag OR iq_stAxisModuleItf.stMain.i_xStart),
			i_xWsSelect			:= xWsSelect,
			i_etCsModeSlave		:= iq_stAxisModuleItf.stMultiCam.i_etCsModeSlave,
			i_etCsModeMaster	:= iq_stAxisModuleItf.stMultiCam.i_etCsModeMaster,
			i_etWsMode			:= iq_stAxisModuleItf.stMultiCam.i_etWsMode,
			i_lrWsWindow		:= iq_stAxisModuleItf.stMultiCam.i_lrWsWindow,
			i_lrWsVel			:= iq_stAxisModuleItf.stMultiCam.i_lrWsVel,
			i_lrWsAcc			:= iq_stAxisModuleItf.stMultiCam.i_lrWsAcc,
			i_lrWsJerk			:= iq_stAxisModuleItf.stMultiCam.i_lrWsJerk,
			i_xWsStart			:= xWsStartFlag,
			i_diTxEnd			:= iq_stAxisModuleItf.stMultiCam.i_diTXend,
			i_lrInstantXLimMax	:= iq_stAxisModuleItf.stMultiCam.i_lrInstantXLimMax,
 			iq_lencMaster		:= iq_stAxisModuleItf.stMain.iq_lencEncoder,
			iq_stExt			:= iq_stAxisModuleItf.stMultiCam.iq_stExt,
			iq_xNewCam			:= xNewCam,
			iq_xInstantNewCam	:= xInstantNewCam,
			iq_stMultiCamData	:= stCamTab,
			q_xActive			=> ,
			q_xReady			=> ,
			q_etDiag			=> etDiagBuffer,
			q_etDiagExt			=> etDiagExtBufferPDL,
			q_sMsg				=> sDiagMsgBuffer,
			q_xInWsWindow		=> iq_stAxisModuleItf.stMultiCam.q_xInWsWindow,
			q_xSynActive		=> iq_stAxisModuleItf.stMain.q_xSynchron,
			q_lrPositionY		=> lrCamPositionY,
			q_xXLowEnd			=> iq_stAxisModuleItf.stMultiCam.q_xXLowEnd,
			q_xXHighEnd			=> iq_stAxisModuleItf.stMultiCam.q_xXHighEnd,
			q_stActualCamData	=> iq_stAxisModuleItf.stMultiCam.q_stActualCamData);
	
DiagTestMultiCam(	iq_etDiag		:= fbMultiCam.q_etDiag,
					iq_etDiagExt	:= fbMultiCam.q_etDiagExt,
					iq_sMsg			:= fbMultiCam.q_sMsg);

IF (fbMultiCam.q_etDiagExt = PDL_ET_DiagExt.ShowCamPosition) THEN
	iq_stAxisModuleItf.stMultiCam.q_lrCalculatedCamPosition := lrCamPositionY;
ELSE
	iq_stAxisModuleItf.stMultiCam.q_lrCalculatedCamPosition := 0;
END_IF

IF NOT iq_stAxisModuleItf.stMultiCam.i_xEnableTabHandler THEN  
	iq_stAxisModuleItf.stMultiCam.iq_xInstantNewCam := xInstantNewCam;
	iq_stAxisModuleItf.stMultiCam.iq_xNewCam 		:= xNewCam;
END_IF	

IF iq_stAxisModuleItf.stMultiCam.i_xEnableTabHandler THEN
	iq_stAxisModuleItf.stMultiCam.q_diActTable := UDINT_TO_DINT(fbTabSwitch.q_udiTableNumber);
ELSE
	iq_stAxisModuleItf.stMultiCam.q_diActTable := iq_stAxisModuleItf.stMultiCam.q_stActualCamData.diUserTableId;
END_IF

IF iq_stAxisModuleItf.stMultiCam.iq_xChangeMaster THEN

	IF (iq_stAxisModuleItf.stMain.i_ifMaster = 0) THEN
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := PDL_ET_DiagExt.MasterInvalid;
		stExceptionModuleReaction2.sMsg := 'no master given';
		ReportException(iq_stException := stExceptionModuleReaction2);
	END_IF
	
	iq_stAxisModuleItf.stMain.iq_lencEncoder.ConnectMasterAxis(
		i_ifAxis   := iq_stAxisModuleItf.stMain.i_ifMaster,
		q_xError   => xError,
		q_etResult => etResultMoin);

	IF (iq_stAxisModuleItf.stMultiCam.i_xSetEncoderPosition) THEN
		(* set the lenc to the position of the master *)
		(* read the position of the master *)
		lrMasterPos := GetMasterPosition();
		
		THIS^.fbSetPos(
			Axis     := iq_stAxisModuleItf.stMain.iq_lencEncoder,
			Execute  := TRUE,
			Position := (lrMasterPos + iq_stAxisModuleItf.stMultiCam.i_lrSetEncoderOffset),
			Relative := FALSE,
			Done     =>,
			Busy     =>,
			Error    => xError,
			ErrorId  => etResultPlco);
		
		IF xError THEN
			stExceptionUnexpected.udiDiagExt := AXM_ET_DiagExt.UnknownFeedback;
			stExceptionUnexpected.sMsg       := Standard.CONCAT('SetEncoderPosition: ', TO_STRING(etResultPlco));
			ReportException(iq_stException := stExceptionUnexpected);
		END_IF
		THIS^.fbSetPos(Execute := FALSE);
	END_IF
	
	iq_stAxisModuleItf.stMultiCam.iq_xChangeMaster := FALSE;
END_IF

iq_stAxisModuleItf.stMain.q_lrPositionX := iq_stAxisModuleItf.stMain.iq_lencEncoder.lrPosition;
iq_stAxisModuleItf.stMain.q_lrPositionX := iq_stAxisModuleItf.stMain.i_ifDrive.stMotionOfMaster.lrPosition;

IF fbMultiCam.q_xReady AND NOT fbMultiCam.i_xStart 
	AND NOT (fbMultiCam.q_etDiagExt = PDL_ET_DiagExt.WaitUntilStopPositionReached)
	AND NOT (fbMultiCam.q_etDiagExt = PDL_ET_DiagExt.WaitUntilCamFinished) THEN
	iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.MultiCamWaitForStart;
ELSIF fbMultiCam.q_xReady AND fbMultiCam.i_xStart AND fbMultiCam.i_xWsSelect AND NOT fbMultiCam.i_xWsStart AND NOT fbMultiCam.q_xSynActive
	AND NOT (fbMultiCam.q_etDiagExt = PDL_ET_DiagExt.ShowCamPosition) THEN
	iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.MultiCamWaitForWsStart;
ELSIF fbMultiCam.q_xReady AND fbMultiCam.i_xStart AND fbMultiCam.i_xWsSelect AND fbMultiCam.i_xWsStart AND NOT fbMultiCam.q_xSynActive THEN
	iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.MultiCamWsExecuting;
ELSIF fbMultiCam.q_xSynActive 
	OR (fbMultiCam.q_etDiagExt = PDL_ET_DiagExt.ShowCamPosition)
	OR (fbMultiCam.q_etDiagExt = PDL_ET_DiagExt.WaitUntilCamStarted)
	OR (fbMultiCam.q_etDiagExt = PDL_ET_DiagExt.WaitUntilFirstCamStarted)
	OR (fbMultiCam.q_etDiagExt = PDL_ET_DiagExt.WaitForNewCam)
	OR (fbMultiCam.q_etDiagExt = PDL_ET_DiagExt.WaitUntilStopPositionReached)
	OR (fbMultiCam.q_etDiagExt = PDL_ET_DiagExt.WaitUntilCamFinished) THEN
	iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.MultiCamRunning;
ELSE
	IF xCamEnable THEN
		iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.MultiCamInit;
	ELSE
		iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.MultiCamExit;
	END_IF
END_IF

IF NOT xCamEnable AND NOT fbMultiCam.q_xActive THEN
	xCamActive := FALSE;
END_IF
