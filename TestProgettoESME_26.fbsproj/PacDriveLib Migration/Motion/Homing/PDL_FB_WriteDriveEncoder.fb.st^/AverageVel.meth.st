__METADATA__
{
  "v3Meta": {
    "objectGuid": "30ca2339-8f06-4b97-a3ed-e96c2042c877",
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
{attribute 'hide'}
METHOD AverageVel : BOOL
VAR_INPUT
END_VAR
VAR
END_VAR
__IMPLEMENTATION__
AverageVel := TRUE;

lrSum		:= lrSum + i_ifDrive.RefVelocity - alrA[uiI];	(* lrSum = lrSum + New Value - Oldest Value *)
alrA[uiI]	:= i_ifDrive.RefVelocity ;
uiI			:= uiI + 1;
lrAverage	:= lrSum / 16;

IF uiI > 16 THEN
	uiI		:= 1;
	xValid	:= TRUE;
END_IF
