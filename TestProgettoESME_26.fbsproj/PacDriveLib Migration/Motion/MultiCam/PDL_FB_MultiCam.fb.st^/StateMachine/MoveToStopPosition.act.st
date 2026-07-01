__METADATA__
{
  "v3Meta": {
    "objectGuid": "f27cbe71-4ad5-4c95-92b3-f5865d3381be",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
q_xXHighEnd		:= FALSE;
q_xXLowEnd		:= FALSE;
q_xSynActive	:= FALSE;

fbCamIn.Execute := FALSE;
fbCamIn2.Execute := FALSE;	

(*--------------------------------------------------------------------------------------------------------------------------------------------*)
//check input parameter
xSuccess := InputParameterCheck(i_xCheckWsParam			:= FALSE,
								i_xCheckStartPosParam	:= FALSE,
								i_xCheckStopPosParam	:= TRUE);
IF NOT xSuccess THEN
	q_xReady := FALSE;
	etState := ET_MulticamState.controllerStop;
	RETURN;
END_IF

SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok,
				i_etDiagExt	:= PDL_ET_DiagExt.WaitUntilStopPositionReached,
				i_sMsg		:= '');
	
(*--------------------------------------------------------------------------------------------------------------------------------------------*)
//start positioning
fbMoveAbsolute.Position			:= iq_stExt.lrStopPosition;
fbMoveAbsolute.Acceleration		:= iq_stExt.lrStopAcceleration; 
fbMoveAbsolute.Deceleration		:= iq_stExt.lrStopDeceleration; 
fbMoveAbsolute.Jerk				:= iq_stExt.lrStopJerk; 

//set direction
IF xSlaveIsModulo THEN
	IF i_ifDrive.lrPosition < iq_stExt.lrStopPosition THEN
		fbMoveAbsolute.Direction		:= PLCO.MC_Direction.PositiveDirection; 
	ELSE	
		fbMoveAbsolute.Direction		:= PLCO.MC_Direction.NegativeDirection; 
	END_IF
ELSE
	fbMoveAbsolute.Direction		:= PLCO.MC_Direction.ShortestWay; 
END_IF

fbMoveAbsolute.Velocity			:= ABS(iq_stExt.lrStopVelocity);
fbMoveAbsolute.BufferMode		:= PLCO.MC_Buffer_Mode.Aborting;
fbMoveAbsolute( Execute := TRUE );
				

etState := ET_MulticamState.ext_moveToStopPos;



