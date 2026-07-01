__METADATA__
{
  "v3Meta": {
    "objectGuid": "14208a92-0a95-4e24-8249-dff0cae740e6",
    "objectTypeGuid": "6f9dac99-8de1-4efc-8465-68ac443b7d08",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__DECLARATION__
FUNCTION FC_EtDiagExtExampleLeafModuleToString : STRING[80]

VAR_INPUT
	i_etDiagExt : ET_DiagExtExampleLeafModule;
END_VAR

VAR_OUTPUT
	q_etDiag	: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt	: ET_DiagExtExampleLeafModule := ET_DiagExtExampleLeafModule.Ok;
END_VAR

VAR
END_VAR
__IMPLEMENTATION__
CASE i_etDiagExt OF
	ET_DiagExtExampleLeafModule.Ok:										FC_EtDiagExtExampleLeafModuleToString := 'Ok';
	ET_DiagExtExampleLeafModule.Disabled:								FC_EtDiagExtExampleLeafModuleToString := 'Disabled';
	ET_DiagExtExampleLeafModule.Initializing:							FC_EtDiagExtExampleLeafModuleToString := 'Initializing';
	ET_DiagExtExampleLeafModule.NoOp:									FC_EtDiagExtExampleLeafModuleToString := 'NoOp';
	ET_DiagExtExampleLeafModule.HomingWaitForStart:						FC_EtDiagExtExampleLeafModuleToString := 'HomingWaitForStart';
	ET_DiagExtExampleLeafModule.HomingExecuting:						FC_EtDiagExtExampleLeafModuleToString := 'HomingExecuting';
	ET_DiagExtExampleLeafModule.HomingDone:								FC_EtDiagExtExampleLeafModuleToString := 'HomingDone';
	ET_DiagExtExampleLeafModule.AutoWaitForStart:						FC_EtDiagExtExampleLeafModuleToString := 'AutoWaitForStart';
	ET_DiagExtExampleLeafModule.AutoRunning:							FC_EtDiagExtExampleLeafModuleToString := 'AutoRunning';
	ET_DiagExtExampleLeafModule.Working:								FC_EtDiagExtExampleLeafModuleToString := 'Working';

	ET_DiagExtExampleLeafModule.UnknownDiagExtExampleLeafModule:		FC_EtDiagExtExampleLeafModuleToString := 'UnknownDiagExtExampleLeafModule';
	ET_DiagExtExampleLeafModule.SubModuleAddInterfacesInvalidPointer:	FC_EtDiagExtExampleLeafModuleToString := 'SubModuleAddInterfacesInvalidPointer';
	ET_DiagExtExampleLeafModule.SubModuleConstantRange:					FC_EtDiagExtExampleLeafModuleToString := 'SubModuleConstantRange';
	ET_DiagExtExampleLeafModule.MissingExtInit:							FC_EtDiagExtExampleLeafModuleToString := 'MissingExtInit';
	ET_DiagExtExampleLeafModule.ReactionOffsetRange:					FC_EtDiagExtExampleLeafModuleToString := 'ReactionOffsetRange';
	ET_DiagExtExampleLeafModule.DriveInvalid:							FC_EtDiagExtExampleLeafModuleToString := 'DriveInvalid';
	
	ET_DiagExtExampleLeafModule.CmdUnknown:								FC_EtDiagExtExampleLeafModuleToString := 'CmdUnknown';
	ET_DiagExtExampleLeafModule.CmdImpossibleOverwrite:					FC_EtDiagExtExampleLeafModuleToString := 'CmdImpossibleOverwrite';
	ET_DiagExtExampleLeafModule.CmdImpossibleState:						FC_EtDiagExtExampleLeafModuleToString := 'CmdImpossibleState';
	ET_DiagExtExampleLeafModule.CmdImpossibleReaction:					FC_EtDiagExtExampleLeafModuleToString := 'CmdImpossibleReaction';
	
	ET_DiagExtExampleLeafModule.AsyncStop:								FC_EtDiagExtExampleLeafModuleToString := 'AsyncStop';
	ET_DiagExtExampleLeafModule.SyncStopEL:								FC_EtDiagExtExampleLeafModuleToString := 'SyncStopEL';
	ET_DiagExtExampleLeafModule.SyncStopEH:								FC_EtDiagExtExampleLeafModuleToString := 'SyncStopEH';
	ET_DiagExtExampleLeafModule.StopEndOfCycle:							FC_EtDiagExtExampleLeafModuleToString := 'StopEndOfCycle';
	
	ET_DiagExtExampleLeafModule.DriveFatalException:					FC_EtDiagExtExampleLeafModuleToString := 'DriveFatalException';
	ET_DiagExtExampleLeafModule.DriveException:							FC_EtDiagExtExampleLeafModuleToString := 'DriveException';
	ET_DiagExtExampleLeafModule.DriveWarning:							FC_EtDiagExtExampleLeafModuleToString := 'DriveWarning';
	
	ET_DiagExtExampleLeafModule.UnknownState:							FC_EtDiagExtExampleLeafModuleToString := 'UnknownState';
	ET_DiagExtExampleLeafModule.UnknownCmd:								FC_EtDiagExtExampleLeafModuleToString := 'UnknownCmd';
	ET_DiagExtExampleLeafModule.RandomException:						FC_EtDiagExtExampleLeafModuleToString := 'RandomException';

	ET_DiagExtExampleLeafModule.CurrentStandardItfInvalidPointer:		FC_EtDiagExtExampleLeafModuleToString := 'CurrentStandardItfInvalidPointer';
	ET_DiagExtExampleLeafModule.CurrentAddItfInvalidPointer:			FC_EtDiagExtExampleLeafModuleToString := 'CurrentAddItfInvalidPointer';
	
	ET_DiagExtExampleLeafModule.ParentInvalid:							FC_EtDiagExtExampleLeafModuleToString := 'ParentInvalid';
	ET_DiagExtExampleLeafModule.ParentNotRegistered:					FC_EtDiagExtExampleLeafModuleToString := 'ParentNotRegistered';
	ET_DiagExtExampleLeafModule.MaxNumberOfLoggerPointsExeeded:			FC_EtDiagExtExampleLeafModuleToString := 'MaxNumberOfLoggerPointsExeeded';
	ET_DiagExtExampleLeafModule.UnexpectedDiagExt:						FC_EtDiagExtExampleLeafModuleToString := 'UnexpectedDiagExt';
	
	ELSE
		FC_EtDiagExtExampleLeafModuleToString := Standard.CONCAT('Unkown ET_DiagExtExampleLeafModule ', UDINT_TO_STRING(i_etDiagExt));
		
		q_etDiag	:= GD.ET_Diag.InputParameterInvalid;
		q_etDiagExt	:= ET_DiagExtExampleLeafModule.UnknownDiagExtExampleLeafModule;
END_CASE
