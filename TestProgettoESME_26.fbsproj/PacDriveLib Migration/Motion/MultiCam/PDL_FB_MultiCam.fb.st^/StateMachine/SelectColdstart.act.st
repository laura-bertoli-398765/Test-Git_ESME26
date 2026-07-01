__METADATA__
{
  "v3Meta": {
    "objectGuid": "aafc4dcf-4cf2-4ecd-aa45-79247bd00d4f",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
THIS^.fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
									i_etDiag		:= q_etDiag,
									i_udiDiagExt	:= q_etDiagExt,
									i_sMessage		:= SE_CTBX.FC_MultiConcat(	'ColdStart with mode slave ', 
																				INT_TO_STRING(i_etCsModeSlave),
																				' mode master ',
																				INT_TO_STRING(i_etCsModeMaster)) );
									
(*--------------------------------------------------------------------------------------------------------------------------------------------*)
//set active cam -> camIn is started with this cam
IF NOT CheckCamData() THEN
	RETURN;
END_IF
stActiveMultiCamData := iq_stMultiCamData;


SetActualCamData();

(*--------------------------------------------------------------------------------------------------------------------------------------------*)
//options for MASTER
CASE  i_etCsModeMaster OF	
	
(*********************************************************************************************************************)
	PDL_ET_MultiCamCsModeMaster.NoChangeOfMasterPosition:	
		etMasterStartMode  	:= PLCO.MC_Master_Start_Mode.KeepEncoderPosition;
		
(*********************************************************************************************************************)
	PDL_ET_MultiCamCsModeMaster.SetMasterPositionToFirstCamPosition:	
		etMasterStartMode   := PLCO.MC_Master_Start_Mode.Relative;
		
(*********************************************************************************************************************)
	PDL_ET_MultiCamCsModeMaster.SetMasterPositionToMinusInfinite:
		IF i_etCsModeSlave <> PDL_ET_MultiCamCsModeSlave.MoveSlaveToFirstCamPosition THEN
			q_lrPositionX 			:= -1474200;
			
			xSuccess :=  SetPosition(	i_ifAxis		:= iq_lencMaster, 
										i_lrPosition	:= q_lrPositionX, 
										i_xRelative		:= FALSE
										);
			IF NOT xSuccess THEN
				RETURN;
			END_IF
		END_IF	
		etMasterStartMode  	:= PLCO.MC_Master_Start_Mode.KeepEncoderPosition;

(*********************************************************************************************************************)
	PDL_ET_MultiCamCsModeMaster.SetMasterPositionToExtCsMasterPosition: 
		q_lrPositionX 			:= iq_stExt.lrCSMasterPosition;
		
		xSuccess :=  SetPosition(	i_ifAxis		:= iq_lencMaster, 
									i_lrPosition	:= q_lrPositionX, 
									i_xRelative		:= FALSE
									);
		IF NOT xSuccess THEN
			RETURN;
		END_IF
		etMasterStartMode  	:= PLCO.MC_Master_Start_Mode.KeepEncoderPosition;

ELSE
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.UnknownCsModeMaster,
					i_sMsg		:= '');
	etState := ET_MulticamState.idle_error;
	RETURN;
END_CASE

(*--------------------------------------------------------------------------------------------------------------------------------------------*)
//options for SLAVE
CASE  i_etCsModeSlave OF	
	
(*********************************************************************************************************************)
	PDL_ET_MultiCamCsModeSlave.NoChangeOfSlavePosition:
		etSlaveStartMode 	:= PLCO.MC_Slave_Start_Mode.RampIn;

(*********************************************************************************************************************)	
	PDL_ET_MultiCamCsModeSlave.SetSlavePositionToFirstCamPosition:

		IF i_etCsModeMaster = PDL_ET_MultiCamCsModeMaster.NoChangeOfMasterPosition THEN 
			//--> master is also set to 0 if nothing is selected
			etMasterStartMode  	:= PLCO.MC_Master_Start_Mode.Absolute;
			etSlaveStartMode	:= PLCO.MC_Slave_Start_Mode.Absolute;
		ELSE
			xSuccess :=  SetPosition(	i_ifAxis		:= i_ifDrive, 
										i_lrPosition	:= stActiveMultiCamData.astCamPoint[0].lrY, 
										i_xRelative		:= FALSE
										);
			IF NOT xSuccess THEN
				RETURN;
			END_IF
			etSlaveStartMode 	:= PLCO.MC_Slave_Start_Mode.RampIn;
		END_IF	

(*********************************************************************************************************************)
	PDL_ET_MultiCamCsModeSlave.MoveSlaveToFirstCamPosition: 
	
		lrYStart := stActiveMultiCamData.astCamPoint[0].lrY;	
		
		xSuccess := InputParameterCheck(i_xCheckWsParam			:= TRUE,
										i_xCheckStartPosParam	:= FALSE,
										i_xCheckStopPosParam	:= FALSE);		
		IF NOT xSuccess THEN
			etState := ET_MulticamState.idle_error;
			RETURN;
		END_IF
		
		fbMoveAbsolute.Position			:= lrYStart;
		fbMoveAbsolute.Velocity			:= i_lrWSVel;
		fbMoveAbsolute.Acceleration		:= i_lrWSAcc; 
		fbMoveAbsolute.Deceleration		:= i_lrWSAcc; 
		fbMoveAbsolute.Jerk				:= i_lrWsJerk; 
		fbMoveAbsolute.Direction		:= PLCO.MC_Direction.ShortestWay; 
		fbMoveAbsolute.BufferMode		:= PLCO.MC_Buffer_Mode.Aborting;
		fbMoveAbsolute( Execute := TRUE );

		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok,
						i_etDiagExt	:= PDL_ET_DiagExt.WaitUntilStartPositionReached,
						i_sMsg		:= Standard.CONCAT('StartPosition: ',LREAL_TO_STRING(lrYStart)));
						
		etSlaveStartMode := PLCO.MC_Slave_Start_Mode.RampIn;
		etState := ET_MulticamState.start_positioning;

(*********************************************************************************************************************)
	PDL_ET_MultiCamCsModeSlave.SetSlavePositionToCamPosition: 
		etSlaveStartMode := PLCO.MC_Slave_Start_Mode.Absolute;

ELSE
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.UnknownCsModeSlave,
					i_sMsg		:= '');
	etState := ET_MulticamState.idle_error;
	RETURN;
END_CASE




(*--------------------------------------------------------------------------------------------------------------------------------------------*)
//start cam if no positioning is required
IF i_etCsModeSlave <> PDL_ET_MultiCamCsModeSlave.MoveSlaveToFirstCamPosition  THEN

	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok,
					i_etDiagExt	:= PDL_ET_DiagExt.WaitUntilFirstCamStarted,
					i_sMsg		:= '');	

	//start cam
	StartCam( 	i_etBufferMode 		 	:= PLCO.MC_Buffer_Mode.Aborting,
				i_stMultiCamData		:= stActiveMultiCamData,
				i_etMasterStartMode		:= etMasterStartMode,
				i_etSlaveStartMode		:= etSlaveStartMode	
				);

	IF   i_etCsModeMaster = PDL_ET_MultiCamCsModeMaster.SetMasterPositionToMinusInfinite
	  OR iq_stExt.xFirstCamNoXLimMin 
	THEN
		etState := ET_MulticamState.start_waitForCamStarted_minusInfinite;
	ELSE
		etState := ET_MulticamState.start_waitForCamStarted;
	END_IF
	
END_IF



			
