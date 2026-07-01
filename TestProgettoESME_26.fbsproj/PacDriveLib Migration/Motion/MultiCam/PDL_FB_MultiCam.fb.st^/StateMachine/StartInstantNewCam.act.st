__METADATA__
{
  "v3Meta": {
    "objectGuid": "985e13b3-68d6-42b6-bd16-19f61baf729f",
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
(* pos. direction  *)
IF    lrVelocityX >= 0 
  AND NOT iq_stExt.xDisableHighEnd 
THEN
	
	THIS^.fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
										i_etDiag		:= q_etDiag,
										i_udiDiagExt	:= q_etDiagExt,
										i_sMessage		:= 'instand change to new CAM' );
										
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
	
		IF i_lrInstantXLimMax = 0 THEN //start cam immediatelly
			StartCam( 	i_etBufferMode 		 	:= PLCO.MC_Buffer_Mode.Aborting,
						i_lrMasterStartPosition := i_lrInstantXLimMax,
						i_stMultiCamData		:= stActiveMultiCamData,
						i_etMasterStartMode		:= PLCO.MC_Master_Start_Mode.KeepEncoderPosition,
						i_etSlaveStartMode		:= PLCO.MC_Slave_Start_Mode.Absolute
						);
		ELSE
			StartCam( 	i_etBufferMode 		 	:= PLCO.MC_Buffer_Mode.StartAtMasterposition,
						i_lrMasterStartPosition := i_lrInstantXLimMax,
						i_stMultiCamData		:= stActiveMultiCamData,
						i_etMasterStartMode		:= PLCO.MC_Master_Start_Mode.KeepEncoderPosition,
						i_etSlaveStartMode		:= PLCO.MC_Slave_Start_Mode.Absolute
						);
		END_IF
		
		//set outputs
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok,
						i_etDiagExt	:= PDL_ET_DiagExt.WaitUntilCamStarted,
						i_sMsg		:= '');
		
		xHighLimitActive	:= FALSE;
		xLowLimitActive		:= FALSE;	
		
		lrYPeriode := iq_stMultiCamData.astCamPoint[stActiveMultiCamData.diNumberOfCamPoints-1].lrY - iq_stMultiCamData.astCamPoint[0].lrY;
		lrXPeriode := iq_stMultiCamData.astCamPoint[stActiveMultiCamData.diNumberOfCamPoints-1].lrX - iq_stMultiCamData.astCamPoint[0].lrX;
					
		etState := ET_MulticamState.waitForNewCamStarted;
	END_IF



(*--------------------------------------------------------------------------------------------------------------------------------------------*)
(* neg. direction  *)
ELSIF  	lrVelocityX < 0 
 	AND NOT iq_stExt.xDisableLowEnd 
THEN

	THIS^.fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
										i_etDiag		:= q_etDiag,
										i_udiDiagExt	:= q_etDiagExt,
										i_sMessage		:= 'instand change to new CAM' );
										
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

		IF i_lrInstantXLimMax = 0 THEN //start cam immediatelly
			StartCam( 	i_etBufferMode 		 	:= PLCO.MC_Buffer_Mode.Aborting,
						i_lrMasterStartPosition := i_lrInstantXLimMax,
						i_stMultiCamData		:= stActiveMultiCamData,
						i_etMasterStartMode		:= PLCO.MC_Master_Start_Mode.KeepEncoderPosition,
						i_etSlaveStartMode		:= PLCO.MC_Slave_Start_Mode.Absolute
						);
		ELSE
			StartCam( 	i_etBufferMode 		 	:= PLCO.MC_Buffer_Mode.StartAtMasterposition,
						i_lrMasterStartPosition := i_lrInstantXLimMax,
						i_stMultiCamData		:= stActiveMultiCamData,
						i_etMasterStartMode		:= PLCO.MC_Master_Start_Mode.KeepEncoderPosition,
						i_etSlaveStartMode		:= PLCO.MC_Slave_Start_Mode.Absolute
						);
		END_IF

		//set outputs
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok,
						i_etDiagExt	:= PDL_ET_DiagExt.WaitUntilCamStarted,
						i_sMsg		:= Standard.CONCAT('UserTableId: ',DINT_TO_STRING(stActiveMultiCamData.diUserTableId)));
		
		xHighLimitActive	:= FALSE;
		xLowLimitActive		:= FALSE;	
		
		lrYPeriode := stActiveMultiCamData.astCamPoint[stActiveMultiCamData.diNumberOfCamPoints-1].lrY - stActiveMultiCamData.astCamPoint[0].lrY;
		lrXPeriode := stActiveMultiCamData.astCamPoint[stActiveMultiCamData.diNumberOfCamPoints-1].lrX - stActiveMultiCamData.astCamPoint[0].lrX;
	
		etState := ET_MulticamState.waitForNewCamStarted;
	END_IF

END_IF














