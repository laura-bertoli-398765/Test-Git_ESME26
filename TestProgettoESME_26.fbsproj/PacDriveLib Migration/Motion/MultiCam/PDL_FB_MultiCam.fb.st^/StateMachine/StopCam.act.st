__METADATA__
{
  "v3Meta": {
    "objectGuid": "8f54a0df-565c-4ccb-9edc-6a9f2dd28842",
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
									i_sMessage		:= 'hold function block');
(*--------------------------------------------------------------------------------------------------------------------------------------------*)

IF iq_stExt.xStopPositionSelect THEN
	MoveToStopPosition();
	
ELSE
	//recall camIn with "i_xPeriodic = FALSE" to end cam at the end of cycle 

	StartCam( 	i_etBufferMode 		 	:= PLCO.MC_Buffer_Mode.Aborting,
				i_xPeriodic				:= FALSE,
				i_stMultiCamData		:= stInSyncMultiCamData,
				i_etMasterStartMode		:= PLCO.MC_Master_Start_Mode.KeepEncoderPosition,
				i_etSlaveStartMode		:= PLCO.MC_Slave_Start_Mode.Relative
				);

	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok,
					i_etDiagExt	:= PDL_ET_DiagExt.WaitUntilCamFinished,
					i_sMsg		:= '');
		
	etState			:= ET_MulticamState.waitForCamFinished;

END_IF
