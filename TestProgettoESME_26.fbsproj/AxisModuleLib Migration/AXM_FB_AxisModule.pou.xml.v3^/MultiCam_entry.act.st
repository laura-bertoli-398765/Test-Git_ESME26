__METADATA__
{
  "v3Meta": {
    "objectGuid": "13a0f2e5-3dc3-4c49-bfa3-1e59ad4bbaa9",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
fbMultiCam.RegisterLoggerPoint(
	i_ifParent  := fbLoggerPoint,
	i_sName     := 'MultiCam',
	q_etDiag    =>,
	q_etDiagExt => );
	
xCamActive                          := TRUE;
iq_stAxisModuleItf.stMain.q_etState := AXM_ET_State.MultiCamInit;

IF iq_stAxisModuleItf.stMain.iq_lencEncoder = 0 THEN
	stExceptionModuleReaction2.etDiag     := GD.ET_Diag.InputParameterInvalid;
	stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.LencInvalid;
	stExceptionModuleReaction2.sMsg       := 'No logical Encoder connected on input iq_lencEncoder';
	ReportException(iq_stException := stExceptionModuleReaction2);
ELSIF iq_stAxisModuleItf.stMain.iq_lencEncoder.xIsModulo AND iq_stAxisModuleItf.stMultiCam.i_xCheckEncoderPeriod THEN
	stExceptionModuleReaction2.etDiag     := GD.ET_Diag.InputParameterInvalid;
	stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.PeriodRange;
	stExceptionModuleReaction2.sMsg       := 'Lenc is set to Modulo';
	ReportException(iq_stException := stExceptionModuleReaction2);
ELSIF (iq_stAxisModuleItf.stMain.i_ifMaster = 0) THEN
	stExceptionModuleReaction2.etDiag     := GD.ET_Diag.InputParameterInvalid;
	stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.MasterInvalid;
	stExceptionModuleReaction2.sMsg       := 'no master given';
	ReportException(iq_stException := stExceptionModuleReaction2);
ELSE
	//replace of FC_SetMasterEncoder	
	iq_stAxisModuleItf.stMain.iq_lencEncoder.ConnectMasterAxis(
		i_ifAxis   := iq_stAxisModuleItf.stMain.i_ifMaster,
		q_xError   => xError,
		q_etResult => etResultMoin);
	
	IF xError THEN
		stExceptionUnexpected.udiDiagExt := AXM_ET_DiagExt.MasterInvalid;
		stExceptionUnexpected.sMsg       := TO_STRING(etResultMoin);
		ReportException(iq_stException := stExceptionUnexpected);
	END_IF
	
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
	END_IF
END_IF

THIS^.fbSetPos(Execute := FALSE);
iq_stAxisModuleItf.stMain.q_lrPositionX := iq_stAxisModuleItf.stMain.i_ifDrive.stMotionOfMaster.lrPosition;
