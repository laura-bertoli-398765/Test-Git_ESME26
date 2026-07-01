__METADATA__
{
  "v3Meta": {
    "objectGuid": "5574ec2d-49c3-48c6-a56e-0dfb45767c89",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
fbEndless.RegisterLoggerPoint(	i_ifParent	:= fbLoggerPoint,
								i_sName		:= 'EndlessFeed',
								q_etDiag	=> ,
								q_etDiagExt => );
xEndlessActive := TRUE;
