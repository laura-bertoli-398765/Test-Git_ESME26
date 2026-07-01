__METADATA__
{
  "v3Meta": {
    "objectGuid": "4a9690d1-2fce-4d09-9573-eea73c8ebc09",
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
METHOD PRIVATE SetXHighEnd_XLowEnd : BOOL
VAR_INPUT
END_VAR
VAR
END_VAR
__IMPLEMENTATION__
SetXHighEnd_XLowEnd := TRUE;

IF iq_stExt.lrXEndWidth > 0 THEN
	q_xXHighEnd:= (q_lrPositionX >= stActiveMultiCamData.astCamPoint[stActiveMultiCamData.diNumberOfCamPoints-1].lrX   -  iq_stExt.lrXEndWidth);
	q_xXLowEnd:= (q_lrPositionX <= stActiveMultiCamData.astCamPoint[0].lrX +  iq_stExt.lrXEndWidth);

ELSE
(* Set q_xXHighEnd *)
	IF NOT q_xXHighEnd AND lrVelocityX > LREAL#0.0 THEN	
		lrXHighEndWidth := lrTSwitch * ABS(lrVelocityX);
		q_xXHighEnd	:= (q_lrPositionX >= stActiveMultiCamData.astCamPoint[stActiveMultiCamData.diNumberOfCamPoints-1].lrX   - lrXHighEndWidth);
	END_IF
	
(* Set q_xXLowEnd *)
	IF NOT q_xXLowEnd AND lrVelocityX < LREAL#0.0 THEN
		lrXLowEndWidth := lrTSwitch * ABS(lrVelocityX);
		q_xXLowEnd	:= (q_lrPositionX <= stActiveMultiCamData.astCamPoint[0].lrX + lrXLowEndWidth);
	END_IF
	
	
(* Reset q_xXHighEnd pos. direction *)
	IF    q_lrPositionX < (stActiveMultiCamData.astCamPoint[stActiveMultiCamData.diNumberOfCamPoints-1].lrX   - lrXHighEndWidth) 
	  AND lrVelocityX > LREAL#0.0 
	THEN
		q_xXHighEnd := FALSE;
	END_IF
	
(* Reset q_xXHighEnd neg. direction *)
	IF q_xXLowEnd AND lrVelocityX < LREAL#0.0 
	THEN
		q_xXHighEnd := FALSE;
	END_IF
	
(* Reset q_xXLowEnd neg. direction *)
	IF    q_lrPositionX > (stActiveMultiCamData.astCamPoint[0].lrX + lrXLowEndWidth) 
	  AND lrVelocityX < LREAL#0.0 
	THEN
		q_xXLowEnd := FALSE;
	END_IF
	
(* Reset q_xXLowEnd pos. direction *)
	IF    q_xXHighEnd 
	  AND lrVelocityX > LREAL#0.0 
	THEN
		q_xXLowEnd := FALSE;
	END_IF
END_IF
