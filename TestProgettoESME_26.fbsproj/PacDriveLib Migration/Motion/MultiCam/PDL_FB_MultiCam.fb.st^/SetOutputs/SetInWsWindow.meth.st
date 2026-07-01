__METADATA__
{
  "v3Meta": {
    "objectGuid": "45fdf98d-8c3d-4d29-9838-eac91fdab02d",
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
METHOD PRIVATE SetInWsWindow : BOOL
VAR_INPUT
	i_xCheckModulo			: BOOL;
END_VAR
__IMPLEMENTATION__

IF 	i_xCheckModulo 
THEN
	IF ABS(lrYStart - q_lrPositionY) <= i_lrWSWindow THEN
		q_xInWSWindow := TRUE;
	(* pos. Periode *)
	ELSIF lrYPeriode > 0 AND lrYStart >= q_lrPositionY AND q_lrPositionY + lrYPeriode - lrYStart <= i_lrWSWindow THEN
		q_xInWSWindow := TRUE;
	ELSIF lrYPeriode > 0 AND lrYStart < q_lrPositionY AND lrYStart + lrYPeriode - q_lrPositionY <= i_lrWSWindow THEN
		q_xInWSWindow := TRUE;
	(* neg. Periode *)
	ELSIF lrYPeriode < 0 AND lrYStart <= q_lrPositionY AND lrYStart - q_lrPositionY - lrYPeriode <= i_lrWSWindow THEN
		q_xInWSWindow := TRUE;
	ELSIF lrYPeriode < 0 AND lrYStart > q_lrPositionY AND q_lrPositionY - lrYPeriode - lrYStart <= i_lrWSWindow THEN
		q_xInWSWindow := TRUE;
	ELSE
		q_xInWSWindow := FALSE;
	END_IF
ELSE
	IF ABS(lrYStart - q_lrPositionY) <= i_lrWSWindow THEN
		q_xInWSWindow := TRUE;
	ELSE
		q_xInWSWindow := FALSE;
	END_IF
END_IF
