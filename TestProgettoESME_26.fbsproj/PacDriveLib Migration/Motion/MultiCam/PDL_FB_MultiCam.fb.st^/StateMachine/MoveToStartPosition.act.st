__METADATA__
{
  "v3Meta": {
    "objectGuid": "6fffa2b1-3d4d-4861-9bc7-067841befa9d",
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
									i_sMessage		:= Standard.CONCAT('start move to position ', LREAL_TO_STRING(iq_stExt.lrStartPosition)) );


(*--------------------------------------------------------------------------------------------------------------------------------------------*)
//check input parameter
xSuccess := InputParameterCheck(i_xCheckWsParam			:= FALSE,
								i_xCheckStartPosParam	:= TRUE,
								i_xCheckStopPosParam	:= FALSE);		
IF NOT xSuccess THEN
	q_xReady := FALSE;	
	etState := ET_MulticamState.controllerStop;
	RETURN;
END_IF

SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
				i_etDiagExt := PDL_ET_DiagExt.WaitUntilStartPositionReached,
				i_sMsg		:= Standard.CONCAT('Start position: ', LREAL_TO_STRING(iq_stExt.lrStartPosition)));

(*--------------------------------------------------------------------------------------------------------------------------------------------*)
//start positioning
fbMoveAbsolute.Position			:= iq_stExt.lrStartPosition;
fbMoveAbsolute.Acceleration		:= iq_stExt.lrStartAcceleration;
fbMoveAbsolute.Deceleration		:= iq_stExt.lrStartDeceleration;
fbMoveAbsolute.Jerk				:= iq_stExt.lrStartJerk; 

//set direction
IF xSlaveIsModulo THEN
	IF i_ifDrive.lrPosition < iq_stExt.lrStartPosition THEN 
		fbMoveAbsolute.Direction		:= PLCO.MC_Direction.PositiveDirection; 
	ELSE	
		fbMoveAbsolute.Direction		:= PLCO.MC_Direction.NegativeDirection; 
	END_IF
ELSE
	fbMoveAbsolute.Direction		:= PLCO.MC_Direction.ShortestWay; 
END_IF

fbMoveAbsolute.Velocity			:= ABS(iq_stExt.lrStartVelocity);
fbMoveAbsolute.BufferMode		:= PLCO.MC_Buffer_Mode.Aborting;
fbMoveAbsolute( Execute := TRUE );


etState := ET_MulticamState.ext_moveToStartpos;
