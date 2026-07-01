__METADATA__
{
  "v3Meta": {
    "objectGuid": "61939e1e-1430-4184-a281-8030fefba77c",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(*For Displaying the LoggerList-Visualization Vis_Logger*)
IF vpiq_udiLogDataListIndexMin < 1 THEN
	vpiq_udiLogDataListIndexMin := 1;
END_IF

IF vpiq_udiLogDataListIndexMin > TPL.Gc_udiMaxNumberOfLogData - 11 THEN
	vpiq_udiLogDataListIndexMin := TPL.Gc_udiMaxNumberOfLogData - 11;
END_IF

FOR udiIndex2 := 1 TO 12 DO
	vpq_astLogDataTableAscii[udiIndex2] := G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1];

	IF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[1]= 'Cmd come' THEN
			vpq_astLogDataTable[udiIndex2].etReason:= TPL.ET_LogDataFilter.CmdCome;
	ELSIF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[1]= 'Cmd go' THEN
			vpq_astLogDataTable[udiIndex2].etReason:= TPL.ET_LogDataFilter.CmdGo;
	ELSIF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[1]= 'StartStep come' THEN
			vpq_astLogDataTable[udiIndex2].etReason:= TPL.ET_LogDataFilter.StartStepCome;
	ELSIF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[1]= 'StartStep go' THEN
			vpq_astLogDataTable[udiIndex2].etReason:= TPL.ET_LogDataFilter.StartStepGo;
	ELSIF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[1]= 'Reaction come' THEN
			vpq_astLogDataTable[udiIndex2].etReason:= TPL.ET_LogDataFilter.ReactionCome;
	ELSIF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[1]= 'Reaction go' THEN
			vpq_astLogDataTable[udiIndex2].etReason:= TPL.ET_LogDataFilter.ReactionGo;
	ELSIF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[1]= 'Exception quit' THEN
			vpq_astLogDataTable[udiIndex2].etReason:= TPL.ET_LogDataFilter.ExceptionQuit;
	ELSIF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[1]= 'Exception come' THEN
			vpq_astLogDataTable[udiIndex2].etReason := TPL.ET_LogDataFilter.ExceptionCome;
	ELSIF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[1]= 'Exception autoquit' THEN
			vpq_astLogDataTable[udiIndex2].etReason:= TPL.ET_LogDataFilter.ExceptionAutoQuit;
	ELSIF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[1]= 'User entry' THEN
			vpq_astLogDataTable[udiIndex2].etReason:= TPL.ET_LogDataFilter.User;
	ELSE
		vpq_astLogDataTable[udiIndex2].etReason:= TPL.ET_LogDataFilter.None;
	END_IF
	vpq_astLogDataTable[udiIndex2].dateDate 		:= STRING_TO_DATE(G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[2]);
	vpq_astLogDataTable[udiIndex2].todTime			:= STRING_TO_TOD(G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[3]);
	vpq_astLogDataTable[udiIndex2].udiModuleId		:= STRING_TO_UDINT(G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[4]);
	vpq_astLogDataTable[udiIndex2].sModuleName		:= G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[5];
	vpq_astLogDataTable[udiIndex2].diCMD			:= STRING_TO_DINT(G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[6]);
	vpq_astLogDataTable[udiIndex2].diStartStep		:= STRING_TO_DINT(G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[7]);

	vpq_astLogDataTable[udiIndex2].etDiag			:= STRING_TO_UDINT(G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[8]);
	vpq_astLogDataTable[udiIndex2].udiDiagExt		:= STRING_TO_UDINT(G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[10]);
	vpq_astLogDataTable[udiIndex2].sDiagExt			:= G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[11];
	vpq_astLogDataTable[udiIndex2].sMsg				:= G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[12];
	
	FOR udiIndex3 := 1 TO TPL.Gc_udiMaxNumberOfReactions DO
		IF FIND(G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[13], UDINT_TO_STRING(udiIndex3))<>0 THEN
			vpq_astLogDataTable[udiIndex2].stReaction.axReaction[udiIndex3] := TRUE;
		ELSE
			vpq_astLogDataTable[udiIndex2].stReaction.axReaction[udiIndex3] := FALSE;
		END_IF
	END_FOR

	IF    G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[14]= '1' THEN
		vpq_astLogDataTable[udiIndex2].etSource:= TPL.ET_ExceptionSource.ModuleController;
	ELSIF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[14]= '2' THEN
		vpq_astLogDataTable[udiIndex2].etSource:= TPL.ET_ExceptionSource.ExceptionHandler;
	ELSIF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[14]= '3' THEN
		vpq_astLogDataTable[udiIndex2].etSource:= TPL.ET_ExceptionSource.Logger;
	ELSIF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[14]= '4' THEN
		vpq_astLogDataTable[udiIndex2].etSource:= TPL.ET_ExceptionSource.Main;
	ELSIF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[14]= '5' THEN
		vpq_astLogDataTable[udiIndex2].etSource:= TPL.ET_ExceptionSource.Vis;
	ELSIF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[14]= '6' THEN
		vpq_astLogDataTable[udiIndex2].etSource:= TPL.ET_ExceptionSource.User;
	ELSIF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[14]= '7' THEN
		vpq_astLogDataTable[udiIndex2].etSource:= TPL.ET_ExceptionSource.NodeModule;
	ELSIF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[14]= '8' THEN
		vpq_astLogDataTable[udiIndex2].etSource:= TPL.ET_ExceptionSource.AxisModule;
	ELSIF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[14]= '9' THEN
		vpq_astLogDataTable[udiIndex2].etSource:= TPL.ET_ExceptionSource.MultiBeltModule;
	ELSIF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[14]= '10' THEN
		vpq_astLogDataTable[udiIndex2].etSource:= TPL.ET_ExceptionSource.SmartInfeedModule;
	ELSIF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[14]= '11' THEN
		vpq_astLogDataTable[udiIndex2].etSource:= TPL.ET_ExceptionSource.RoboticModule;
	ELSIF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[14]= '12' THEN
		vpq_astLogDataTable[udiIndex2].etSource:= TPL.ET_ExceptionSource.UnwinderModule;
	ELSIF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[14]= '13' THEN
		vpq_astLogDataTable[udiIndex2].etSource:= TPL.ET_ExceptionSource.SealingModule;
	ELSIF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[14]= '14' THEN
		vpq_astLogDataTable[udiIndex2].etSource:= TPL.ET_ExceptionSource.AtvModule;
	ELSIF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[14]= '15' THEN
		vpq_astLogDataTable[udiIndex2].etSource:= TPL.ET_ExceptionSource.IlxModule;
	ELSIF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[14]= '16' THEN
		vpq_astLogDataTable[udiIndex2].etSource:= TPL.ET_ExceptionSource.CrankModule;
	ELSIF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[14]= '17' THEN
		vpq_astLogDataTable[udiIndex2].etSource:= TPL.ET_ExceptionSource.ValveModule;
	ELSIF G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[14]= '18' THEN
		vpq_astLogDataTable[udiIndex2].etSource:= TPL.ET_ExceptionSource.CapperModule;
	ELSE
		vpq_astLogDataTable[udiIndex2].etSource:= TPL.ET_ExceptionSource.None;
	END_IF
	
	vpq_astLogDataTable[udiIndex2].xAutoQuit	:= STRING_TO_BOOL(G_stLogDataListAscii.astLogData[vpiq_udiLogDataListIndexMin + udiIndex2 - 1].asAsciiData[15]);
END_FOR


vpq_udiLogDataListIndexMax := vpiq_udiLogDataListIndexMin + 11;

vpiq_udiNumberOfLogData := G_stLogDataListAscii.udiNumberOfLogData;
IF vpq_udiLogDataListIndexMax > G_stLogDataListAscii.udiNumberOfLogData - 1  THEN
	vpq_xLogDataScrollDown := TRUE;

ELSE
	vpq_xLogDataScrollDown := FALSE;
END_IF

IF vpiq_xButtonLogDataListDetails AND NOT vpq_xShowLogDataListDetails THEN
	vpq_xShowLogDataListDetails				:= TRUE;
	vpiq_xButtonLogDataListDetails			:= FALSE;
ELSIF vpiq_xButtonLogDataListDetails AND vpq_xShowLogDataListDetails THEN
	vpq_xShowLogDataListDetails				:= FALSE;
	vpiq_xButtonLogDataListDetails			:= FALSE;
END_IF
