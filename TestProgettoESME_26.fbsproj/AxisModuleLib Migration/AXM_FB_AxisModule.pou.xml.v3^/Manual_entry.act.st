__METADATA__
{
  "v3Meta": {
    "objectGuid": "a6b56049-7c72-49e3-bfe5-e008d0055a3b",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
fbJogging.RegisterLoggerPoint(	i_ifParent	:= fbLoggerPoint,
								i_sName		:= 'Manual',
								q_etDiag	=> ,
								q_etDiagExt => );

xManActive := TRUE;
