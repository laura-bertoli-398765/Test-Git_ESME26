__METADATA__
{
  "v3Meta": {
    "objectGuid": "c4c468b5-b439-41ed-9746-0136a72f5e89",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
fbBrake.RegisterLoggerPoint(	i_ifParent		:= THIS^.fbLoggerPoint,
								i_sName			:= 'BrakeRelease',
								q_etDiag		=> ,
								q_etDiagExt		=> );
								
xBrakeActive := TRUE;
