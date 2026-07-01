__METADATA__
{
  "v3Meta": {
    "objectGuid": "6cd2ba1d-fba8-496d-b477-f0ea11eeffaf",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__


(*--------------------------------------------------------------------------------------------------------------------------------------------*)
(* pos. direction *)
IF    lrVelocityX >= 0 
  AND NOT iq_stExt.xDisableHighEnd
  AND (q_xXHighEnd OR iq_stExt.xNewCamDirectAccept) 
THEN

	THIS^.fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
										i_etDiag		:= q_etDiag,
										i_udiDiagExt	:= q_etDiagExt,
										i_sMessage		:= 'change to new CAM');

	iq_stExt.xDirectionChanged:= FALSE;

	IF iq_stExt.xYEqualCheck AND NOT YEqualCheck(	i_lrYValueOldCam := stInSyncMultiCamData.astCamPoint[stInSyncMultiCamData.diNumberOfCamPoints-1].lrY,
													i_lrYValueNewCam := iq_stMultiCamData.astCamPoint[0].lrY,
													i_lrPeriod 		 := stInSyncMultiCamData.lrYPeriod,
													i_lrAccuracy 	 := iq_stExt.lrYEqualCheckAccuracy) 
	THEN
		q_xReady := FALSE;
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
						i_etDiagExt := PDL_ET_DiagExt.YEqualCheckFailed,
						i_sMsg		:= '');
		q_xSynActive		:= FALSE;
		q_xXLowEnd			:= FALSE;
		q_xXHighEnd			:= FALSE;
		iq_xNewCam			:= FALSE;
		iq_xInstantNewCam	:= FALSE;
		etState := ET_MulticamState.controllerStop;
	ELSE
		//start new cam
		stActiveMultiCamData := iq_stMultiCamData;
		
		StartCam(  	i_etBufferMode 		 	:= PLCO.MC_Buffer_Mode.Buffered,
					i_stMultiCamData		:= stActiveMultiCamData,
					i_etMasterStartMode		:= PLCO.MC_Master_Start_Mode.KeepEncoderPosition,
					i_etSlaveStartMode		:= PLCO.MC_Slave_Start_Mode.Absolute
				   	);

		//set outputs
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok,
						i_etDiagExt	:= PDL_ET_DiagExt.WaitUntilCamStarted,
						i_sMsg		:= '');	
		
		xLowLimitActive		:= FALSE;
		xHighLimitActive	:= TRUE;
		
		lrYPeriode := stActiveMultiCamData.astCamPoint[stActiveMultiCamData.diNumberOfCamPoints-1].lrY - stActiveMultiCamData.astCamPoint[0].lrY;
		lrXPeriode := stActiveMultiCamData.astCamPoint[stActiveMultiCamData.diNumberOfCamPoints-1].lrX - stActiveMultiCamData.astCamPoint[0].lrX;
		
		etState := ET_MulticamState.waitForNewCamStarted;		

	END_IF	



(*--------------------------------------------------------------------------------------------------------------------------------------------*)
(* neg. direction *)
ELSIF   lrVelocityX < 0 
	AND NOT iq_stExt.xDisableLowEnd 
	AND	(q_xXLowEnd OR iq_stExt.xNewCamDirectAccept)  
THEN
	THIS^.fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
										i_etDiag		:= q_etDiag,
										i_udiDiagExt	:= q_etDiagExt,
										i_sMessage		:= 'change to new CAM' );

	iq_stExt.xDirectionChanged:= FALSE;

	IF iq_stExt.xYEqualCheck AND NOT YEqualCheck(	i_lrYValueOldCam := stInSyncMultiCamData.astCamPoint[0].lrY,
													i_lrYValueNewCam := iq_stMultiCamData.astCamPoint[iq_stMultiCamData.diNumberOfCamPoints-1].lrY,
													i_lrPeriod 		 := stInSyncMultiCamData.lrYPeriod,
													i_lrAccuracy 	 := iq_stExt.lrYEqualCheckAccuracy) 
	THEN												
		q_xReady := FALSE;
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
						i_etDiagExt := PDL_ET_DiagExt.YEqualCheckFailed,
						i_sMsg		:= '');
		q_xSynActive		:= FALSE;
		q_xXLowEnd			:= FALSE;
		q_xXHighEnd			:= FALSE;
		iq_xNewCam			:= FALSE;
		iq_xInstantNewCam	:= FALSE;
		etState := ET_MulticamState.controllerStop;
	ELSE
		//start new cam
		stActiveMultiCamData := iq_stMultiCamData;
		
		StartCam(  	i_etBufferMode 		 	:= PLCO.MC_Buffer_Mode.Buffered,
					i_stMultiCamData		:= stActiveMultiCamData,
					i_etMasterStartMode		:= PLCO.MC_Master_Start_Mode.KeepEncoderPosition,
					i_etSlaveStartMode		:= PLCO.MC_Slave_Start_Mode.Absolute
				   	);
					
		//set outputs
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok,
						i_etDiagExt	:= PDL_ET_DiagExt.WaitUntilCamStarted,
						i_sMsg		:= '');	
		
		xLowLimitActive		:= TRUE;
		xHighLimitActive	:= FALSE;
		
		lrYPeriode := stActiveMultiCamData.astCamPoint[stActiveMultiCamData.diNumberOfCamPoints-1].lrY - stActiveMultiCamData.astCamPoint[0].lrY;
		lrXPeriode := stActiveMultiCamData.astCamPoint[stActiveMultiCamData.diNumberOfCamPoints-1].lrX - stActiveMultiCamData.astCamPoint[0].lrX;
		
		etState := ET_MulticamState.waitForNewCamStarted;		
	END_IF


END_IF














