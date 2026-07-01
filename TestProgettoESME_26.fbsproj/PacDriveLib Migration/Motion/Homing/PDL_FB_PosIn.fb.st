__METADATA__
{
  "v3Meta": {
    "objectGuid": "1571c8c7-ba42-4c83-9c4a-a4e3533b5c1d",
    "objectTypeGuid": "6f9dac99-8de1-4efc-8465-68ac443b7d08",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__DECLARATION__
FUNCTION_BLOCK PDL_FB_PosIn
VAR_INPUT
	i_ifDrive        : Moin.IF_Axis;
	i_xSensor        : BOOL;
	i_xPosEdge       : BOOL;
	i_lrMaxTravel    : LREAL;
	i_lrOffset       : LREAL;
	i_lrVelocity     : LREAL;
	i_lrAcceleration : LREAL;
	i_lrDeceleration : LREAL;
	i_lrJerk         : LREAL;
	i_xStart         : BOOL;
END_VAR
VAR_OUTPUT
	q_xError          : BOOL;
	q_diErrorId       : PLCO.ET_Result;
	q_xInOk           : BOOL;
	q_xSensorNotFound : BOOL;
	q_xMoveToHomePosition: BOOL;

END_VAR
VAR
	diState        : DINT;
	xPosEdgeFlag   : BOOL;
	xNegEdgeFlag   : BOOL;
	xTPFlag        : BOOL;
	fbMoveRelative : PLCO.MC_MoveRelative;
	fbMoveRelativeOffset : PLCO.MC_MoveRelative;
END_VAR
__IMPLEMENTATION__
IF i_xStart = TRUE THEN
	q_xINOk           := FALSE;
	q_xSensorNotFound := FALSE;
	q_xError          := FALSE;
	q_diErrorId       := PLCO.ET_Result.Ok;
	q_xMoveToHomePosition := FALSE;
	xPosEdgeFlag      := FALSE;
	xNegEdgeFlag      := FALSE;
	xTPFlag           := i_xSensor;
	diState           := 10;
	THIS^.fbMoveRelative(Execute := FALSE);
	THIS^.fbMoveRelativeOffset(Execute := FALSE);
END_IF

IF i_xSensor AND NOT xTPFlag THEN
	xTPFlag      := TRUE;
	xPosEdgeFlag := TRUE;
ELSIF NOT i_xSensor AND xTPFlag THEN
	xTPFlag      := FALSE;
	xNegEdgeFlag := TRUE;
END_IF

CASE diState OF
	
	0: (*Fertig *)
		THIS^.fbMoveRelative(Execute := FALSE);
		THIS^.fbMoveRelativeOffset(Execute := FALSE);
		
	10: (* PosStart *)
		THIS^.fbMoveRelative(
			Axis         := i_ifDrive,
			Execute      := TRUE,
			Distance     := i_lrMaxTravel,
			Velocity     := i_lrVelocity,
			Acceleration := i_lrAcceleration,
			Deceleration := i_lrDeceleration,
			Jerk         := i_lrJerk,
			BufferMode   := PLCO.MC_Buffer_Mode.Aborting);
		
		IF THIS^.fbMoveRelative.Error THEN
			q_xError    := TRUE;
			q_diErrorId := THIS^.fbMoveRelative.ErrorId;
			diState := 0;
		ELSE
			diState := 30;
		END_IF
		
	30: (* Warten bis TP gesehen *)
		THIS^.fbMoveRelative();
		
		IF THIS^.fbMoveRelative.Error THEN
			q_xError    := TRUE;
			q_diErrorId := THIS^.fbMoveRelative.ErrorId;
			diState := 0;
			
		ELSIF (i_xPosEdge AND xPosEdgeFlag) OR (NOT i_xPosEdge AND xNegEdgeFlag) THEN
			THIS^.fbMoveRelative(Execute := FALSE);
			
			THIS^.fbMoveRelativeOffset(
				Axis         := i_ifDrive,
				Execute      := TRUE,
				Distance     := i_lrOffset,
				Velocity     := i_lrVelocity,
				Acceleration := i_lrAcceleration,
				Deceleration := i_lrDeceleration,
				Jerk         := i_lrJerk,
				BufferMode   := PLCO.MC_Buffer_Mode.Aborting);
			
			IF THIS^.fbMoveRelativeOffset.Error THEN
				q_xError    := TRUE;
				q_diErrorId := THIS^.fbMoveRelativeOffset.ErrorId;
				diState := 0;
			ELSE
				q_xMoveToHomePosition := TRUE;
				diState := 50;
			END_IF
			
		ELSIF THIS^.fbMoveRelative.Error THEN
			q_xError    := TRUE;
			q_diErrorId := THIS^.fbMoveRelative.ErrorId;
			diState := 0;
			
		ELSIF THIS^.fbMoveRelative.Done THEN (* maxTravel zu Ende *)
			q_xSensorNotFound := TRUE;
			diState           := 0;
		END_IF
		
	50: (* Warten bis steht *)
		THIS^.fbMoveRelativeOffset();
		IF THIS^.fbMoveRelativeOffset.Done THEN
			q_xINOk    := TRUE;
			diState    := 0;
			
		ELSIF THIS^.fbMoveRelativeOffset.Error THEN
			q_xError    := TRUE;
			q_diErrorId := THIS^.fbMoveRelativeOffset.ErrorId;
			diState := 0;
		END_IF

END_CASE
