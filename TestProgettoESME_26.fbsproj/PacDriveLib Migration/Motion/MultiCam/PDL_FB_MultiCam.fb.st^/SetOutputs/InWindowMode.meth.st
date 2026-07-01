__METADATA__
{
  "v3Meta": {
    "objectGuid": "36341c7f-2764-4e04-aab5-7ea440a4131c",
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
METHOD PRIVATE InWindowMode : BOOL
//only in ws mode ___CamShowCamPosition
//sets output q_xInWSWindow
VAR_INPUT
END_VAR
VAR
END_VAR
__IMPLEMENTATION__

InWindowMode := TRUE;

lrPositionY2:= i_ifDrive.lrPosition;


IF stActiveMultiCamData.lrYPeriod <> 0 THEN	
	lrYPeriode := stActiveMultiCamData.lrYPeriod;
END_IF

CASE iq_stExt.etInWindowMode OF

	PDL_ET_MultiCamWsMode.StoredCamMoveAlwaysNoPositionCheck, 
	PDL_ET_MultiCamWsMode.StoredCamMoveToCamPositonInWsWindow, 
	PDL_ET_MultiCamWsMode.NewCamMoveAlwaysNoPositionCheck, 
	PDL_ET_MultiCamWsMode.NewCamMoveToCamPositonInWsWindow:
	
		IF NOT iq_stExt.xNoModuloSlaveAtStart THEN
			IF ABS(lrYStart - lrPositionY2) <= i_lrWSWindow THEN
				q_xInWSWindow := TRUE;
				
			(* pos. Periode *)
			ELSIF lrYPeriode > 0 AND lrYStart >= lrPositionY2 AND ABS(lrPositionY2 + lrYPeriode - lrYStart) <= i_lrWSWindow THEN		
				q_xInWSWindow := TRUE;
			ELSIF lrYPeriode > 0 AND lrYStart < lrPositionY2 AND ABS(lrYStart + lrYPeriode - lrPositionY2) <= i_lrWSWindow THEN
				q_xInWSWindow := TRUE;
				
			(* neg. Periode *)
			ELSIF lrYPeriode < 0 AND lrYStart <= lrPositionY2 AND ABS(lrYStart - lrPositionY2 - lrYPeriode) <= i_lrWSWindow THEN			
				q_xInWSWindow:= TRUE;
			ELSIF lrYPeriode < 0 AND lrYStart > lrPositionY2 AND ABS(lrPositionY2 - lrYPeriode - lrYStart) <= i_lrWSWindow THEN
				q_xInWSWindow := TRUE;
			ELSE
				q_xInWSWindow := FALSE;
			END_IF
		ELSE
			IF ABS(lrYStart - lrPositionY2) <= i_lrWSWindow THEN
				q_xInWSWindow := TRUE;
			ELSE
				q_xInWSWindow := FALSE;
			END_IF
		END_IF


	PDL_ET_MultiCamWsMode.StoredCamMoveForwardToCamPositon, 
	PDL_ET_MultiCamWsMode.StoredCamMoveBackwardToCamPosition, 
	PDL_ET_MultiCamWsMode.NewCamMoveForwardToCamPositon, 
	PDL_ET_MultiCamWsMode.NewCamMoveBackwardToCamPosition:
	
		IF  iq_stExt.xInWindowCheckwithoutLimits THEN
			IF ABS(lrYStart - lrPositionY2) <= i_lrWSWindow THEN
				q_xInWSWindow := TRUE;
				
			(* pos. Periode *)
			ELSIF lrYPeriode > 0 AND lrYStart >= lrPositionY2 AND ABS(lrPositionY2 + lrYPeriode - lrYStart) <= i_lrWSWindow THEN
				q_xInWSWindow := TRUE;
			ELSIF lrYPeriode > 0 AND lrYStart < lrPositionY2 AND ABS(lrYStart + lrYPeriode - lrPositionY2) <= i_lrWSWindow THEN
				q_xInWSWindow := TRUE;
				
			(* neg. Periode *)
			ELSIF lrYPeriode < 0 AND lrYStart <= lrPositionY2 AND ABS(lrYStart - lrPositionY2 - lrYPeriode) <= i_lrWSWindow THEN
				q_xInWSWindow := TRUE;
			ELSIF lrYPeriode < 0 AND lrYStart > lrPositionY2 AND ABS(lrPositionY2 - lrYPeriode - lrYStart) <= i_lrWSWindow THEN
				q_xInWSWindow := TRUE;
			ELSE
				q_xInWSWindow := FALSE;
			END_IF
		ELSE
			IF ABS(lrYStart - lrPositionY2) <= i_lrWSWindow THEN
				q_xInWSWindow := TRUE;
			ELSE
				q_xInWSWindow := FALSE;
			END_IF
		END_IF

ELSE
	q_xInWSWindow := FALSE;
END_CASE
