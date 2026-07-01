__METADATA__
{
  "v3Meta": {
    "objectGuid": "b0dff754-d2a1-46fc-bb4e-48a721cf973b",
    "objectTypeGuid": "f8a58466-d7f6-439f-bbb8-d4600e41d099",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__DECLARATION__
METHOD PRIVATE StartPositioningAndTPEdge : BOOL
VAR_INPUT
	i_xOppositeDirection	: BOOL;
END_VAR
VAR
	lrDistance_loc		: LREAL;
END_VAR
__IMPLEMENTATION__
IF
	(NOT i_xOppositeDirection AND (i_etMode = PDL_ET_HomeTpMode.PosDirectionNegEdgeTp OR i_etMode = PDL_ET_HomeTpMode.PosDirectionPosEdgeTp)) OR
	(i_xOppositeDirection AND (i_etMode = PDL_ET_HomeTpMode.NegDirectionNegEdgeTp OR i_etMode = PDL_ET_HomeTpMode.NegDirectionPosEdgeTp))
THEN
	lrDistance_loc := lrDistance;
ELSE
	lrDistance_loc := -lrDistance;
END_IF

xMotionJobStarted := FALSE;
fbMoveRelative(Execute := TRUE, Distance := lrDistance_loc);

IF fbMoveRelative.Error THEN
	SetDiagOutput(
		i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
		i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
		i_sMsg      := CONCAT('MC_MoveRelative.ErrorID: ', PLCO.FC_EtResultToString(THIS^.fbMoveRelative.ErrorID))
	);
	THIS^.fbMoveRelative(Execute := FALSE);
	
ELSE
	q_xMotionInstructionActive := TRUE;
	fbTouchProbe(
		Execute       := TRUE,
		WindowOnly    := TRUE,
		FirstPosition := q_lrPosition - ABS(i_lrMaxTravel),
		LastPosition  := q_lrPosition + ABS(i_lrMaxTravel),
		PositionType  := PLCO.MC_PositionType.ActualPosition
	);
	
	IF fbTouchProbe.Error THEN
		SetDiagOutput(
			i_etDiag    := GD.ET_Diag.UnexpectedProgramBehavior,
			i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
			i_sMsg      := CONCAT('MC_TouchProbe: ', PLCO.FC_EtResultToString(fbTouchProbe.ErrorId))
		);
		fbTouchProbe(Execute := FALSE);
	END_IF
	StartPositioningAndTPEdge := TRUE;
END_IF
