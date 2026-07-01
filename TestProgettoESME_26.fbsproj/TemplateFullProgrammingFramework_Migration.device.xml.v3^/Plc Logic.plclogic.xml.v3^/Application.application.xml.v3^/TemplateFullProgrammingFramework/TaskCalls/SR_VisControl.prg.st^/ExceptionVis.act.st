__METADATA__
{
  "v3Meta": {
    "objectGuid": "46a6cd33-7204-41e4-9cf3-efd2d4bcbc50",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
stActiveReactions := vpq_stMachineInterface.i_stReaction;

fbCopyExceptionList(i_xEnable					:= TRUE,
					i_xCopy						:= TRUE,
					i_timElapsedTimeUpdate		:= T#1S, (* update todElapsedTime every seccond, is fast enough for user interface *)
					iq_stExceptionList			:= G_stExceptionList,
					iq_astException				:= astExceptionListCopy,
					iq_udiNumberOfExceptions	:= vpq_udiNumberOfExceptions,
					q_xActive					=> ,
					q_xReady					=> ,
					q_etDiag					=> ,
					q_etDiagExt					=> );

IF vpiq_xReactionUp THEN
	vpq_udiReactionIndexMin := vpq_udiReactionIndexMin + 1;
	vpiq_xReactionUp:=FALSE;
ELSIF vpiq_xReactionDown THEN
	vpq_udiReactionIndexMin := vpq_udiReactionIndexMin - 1;
	vpiq_xReactionDown:=FALSE;
END_IF

IF vpq_udiReactionIndexMin <> udiReactionIndexOld THEN
														(*More than 10 steps ??*)
	IF (vpq_udiReactionIndexMin + 9 < TPL.Gc_udiMaxNumberOfReactions) THEN
		udiReactionIndexMax := vpq_udiReactionIndexMin + 9;
	ELSE
		udiReactionIndexMax := TPL.Gc_udiMaxNumberOfReactions;
	END_IF
														(*Additional safety check*)
	IF (vpq_udiReactionIndexMin < 1) THEN
		vpq_udiReactionIndexMin := 1;
		udiReactionIndexMax := 10;
	ELSIF (vpq_udiReactionIndexMin > TPL.Gc_udiMaxNumberOfReactions - 9) THEN
		vpq_udiReactionIndexMin := TPL.Gc_udiMaxNumberOfReactions - 9;
		udiReactionIndexMax := 10;
	END_IF

	udiReactionIndexOld := vpq_udiReactionIndexMin;
END_IF

IF TPL.Gc_udiMaxNumberOfReactions < 10 THEN
	udiMaxValue := TPL.Gc_udiMaxNumberOfReactions;
ELSE
	udiMaxValue := 10;
END_IF

FOR udiCount := 1 TO udiMaxValue  DO
	vpq_axReaction[udiCount] := stActiveReactions.axReaction[vpq_udiReactionIndexMin + udiCount - 1];
END_FOR

(*For Displaying the ErrorList-Visualization Vis_ActiveErrorList*)
IF vpiq_udiExceptionListIndexMin < 1 THEN
	vpiq_udiExceptionListIndexMin := 1;
END_IF

IF vpiq_udiExceptionListIndexMin > TPL.Gc_udiMaxNumberOfExceptions - 9 THEN
	vpiq_udiExceptionListIndexMin := TPL.Gc_udiMaxNumberOfExceptions - 9;
END_IF


FOR udiIndex := 1 TO 10 DO
	vpq_astExceptionListTable[udiIndex] := astExceptionListCopy[vpiq_udiExceptionListIndexMin + udiIndex - 1];
	vpq_asReaction [udiIndex] := TPL.FC_ReactionToString(astExceptionListCopy[vpiq_udiExceptionListIndexMin + udiIndex - 1].stReaction);
END_FOR

vpq_udiExceptionListIndexMax := vpiq_udiExceptionListIndexMin + 9;

IF vpq_udiExceptionListIndexMax > vpq_udiNumberOfExceptions - 1  THEN
	vpq_xDisplayScrollDown := TRUE;
ELSE
	vpq_xDisplayScrollDown := FALSE;
END_IF


vpq_sAllActiveReactions:= TPL.FC_ReactionToString(stActiveReactions);
CallTestErrors();

FOR udiCount := 1 TO TPL.Gc_udiMaxNumberOfReactions DO
	IF stActiveReactions.axReaction[udiCount] THEN
		xRedColor	:= TRUE;
		EXIT;
	ELSE
		xRedColor	:= FALSE;
	END_IF
END_FOR

IF xRedColor THEN
	vpq_dwDiagQuitColor := 16#FF0000;
ELSE
	vpq_dwDiagQuitColor := 16#FFFF00;
END_IF

IF vpiq_xButtonShowExtendedTimes AND NOT vpq_xShowExtendedTimes THEN
	vpq_xShowExtendedTimes		:= TRUE;
	vpq_xShowExtended2			:= FALSE;
	vpiq_xButtonShowExtendedTimes := FALSE;
	vpiq_xButtonShowExtended2		:= FALSE;
ELSIF vpiq_xButtonShowExtendedTimes  AND vpq_xShowExtendedTimes THEN
	vpq_xShowExtendedTimes		:= FALSE;
	vpq_xShowExtended2			:= FALSE;
	vpiq_xButtonShowExtendedTimes := FALSE;
	vpiq_xButtonShowExtended2		:= FALSE;
END_IF

IF vpiq_xButtonShowExtended2 AND NOT vpq_xShowExtended2 THEN
	vpq_xShowExtendedTimes		:= FALSE;
	vpq_xShowExtended2			:= TRUE;
	vpiq_xButtonShowExtendedTimes := FALSE;
	vpiq_xButtonShowExtended2		:= FALSE;
ELSIF vpiq_xButtonShowExtended2 AND vpq_xShowExtended2 THEN
	vpq_xShowExtendedTimes		:= FALSE;
	vpq_xShowExtended2			:= FALSE;
	vpiq_xButtonShowExtendedTimes := FALSE;
	vpiq_xButtonShowExtended2		:= FALSE;
END_IF
