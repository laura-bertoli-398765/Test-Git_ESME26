__METADATA__
{
  "v3Meta": {
    "objectGuid": "483826da-a3c3-434f-aade-4068f11b1833",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
fbVarioPos.RegisterLoggerPoint(	i_ifParent		:= THIS^.fbLoggerPoint,
								i_sName			:= 'Positioning',
								q_etDiag		=> ,
								q_etDiagExt		=> );
								
xPosActive := TRUE;

xMotionActiveOld := FALSE;
