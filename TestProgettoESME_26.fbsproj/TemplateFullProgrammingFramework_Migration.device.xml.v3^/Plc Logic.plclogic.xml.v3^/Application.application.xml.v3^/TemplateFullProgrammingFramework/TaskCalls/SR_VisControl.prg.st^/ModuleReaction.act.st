__METADATA__
{
  "v3Meta": {
    "objectGuid": "3179843a-6325-4ba0-a2f4-b620797a79ff",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
stModuleReactions		:=pstCurrent^.i_stReaction;

IF vpiq_xModuleReactionUp THEN
	vpq_udiModuleReactionIndexMin := vpq_udiModuleReactionIndexMin + 1;
	vpiq_xModuleReactionUp := FALSE;
ELSIF vpiq_xModuleReactionDown THEN
	vpq_udiModuleReactionIndexMin := vpq_udiModuleReactionIndexMin - 1;
	vpiq_xModuleReactionDown := FALSE;
END_IF

IF vpq_udiModuleReactionIndexMin <> udiModuleReactionIndexOld THEN
														(*More than 10 steps ??*)
	IF (vpq_udiModuleReactionIndexMin + 9 < TPL.Gc_udiMaxNumberOfReactions) THEN
		udiModuleReactionIndexMax := vpq_udiModuleReactionIndexMin + 9;
	ELSE
		udiModuleReactionIndexMax := TPL.Gc_udiMaxNumberOfReactions;
	END_IF
														(*Additional safety check*)
	IF (vpq_udiModuleReactionIndexMin < 1) THEN
		vpq_udiModuleReactionIndexMin :=1;
		udiModuleReactionIndexMax := 10;
 	ELSIF (vpq_udiModuleReactionIndexMin > TPL.Gc_udiMaxNumberOfReactions-9)THEN
		vpq_udiModuleReactionIndexMin :=TPL.Gc_udiMaxNumberOfReactions-9;
		udiModuleReactionIndexMax := 10;
	END_IF

	udiModuleReactionIndexOld := vpq_udiModuleReactionIndexMin;
END_IF

IF TPL.Gc_udiMaxNumberOfReactions<10 THEN
	udiMaxValue := TPL.Gc_udiMaxNumberOfReactions;
ELSE
	udiMaxValue := 10;
END_IF

FOR udiCount2 := 1 TO udiMaxValue  DO
	vpq_axModuleReaction[udiCount2] := stModuleReactions.axReaction[vpq_udiModuleReactionIndexMin + udiCount2 - 1];
END_FOR
