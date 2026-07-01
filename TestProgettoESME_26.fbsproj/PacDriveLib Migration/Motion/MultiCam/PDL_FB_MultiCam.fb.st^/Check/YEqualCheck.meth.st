__METADATA__
{
  "v3Meta": {
    "objectGuid": "33519a38-339b-4adc-a5a1-9e0e144cfb82",
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
METHOD INTERNAL YEqualCheck : BOOL

VAR_INPUT
	i_lrYValueOldCam	: LREAL;	
	i_lrYValueNewCam	: LREAL;
	i_lrPeriod			: LREAL;
	i_lrAccuracy		: LREAL;
END_VAR

VAR
	lrDiff				: LREAL;
	lrPeriode			: LREAL;
END_VAR
__IMPLEMENTATION__
YEqualCheck := TRUE;

lrDiff:=	ABS(i_lrYValueOldCam - i_lrYValueNewCam);
lrPeriode:= ABS(i_lrPeriod);

IF lrPeriode > CMT.GCL.Gc_lrZeroTolerance THEN
	lrDiff:= MATH.fmod(lrX:= lrDiff, lrM:= lrPeriode);
END_IF

IF 	lrDiff > i_lrAccuracy THEN
	YEqualCheck:= FALSE;
END_IF
