__METADATA__
{
  "v3Meta": {
    "objectGuid": "bbdc9bcf-c2b8-4007-8f83-8c9df0a66e4c",
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
FUNCTION FC_EtDiagExtToString : STRING[80]
VAR_INPUT
	i_etDiagExt : ET_DiagExt;
END_VAR
VAR_OUTPUT
	q_etDiag	: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt	: ET_DiagExt := ET_DiagExt.Ok;
END_VAR
__IMPLEMENTATION__
CASE i_etDiagExt OF
	ET_DiagExt.Ok:								FC_EtDiagExtToString := 'Ok';
	ET_DiagExt.Disabled:						FC_EtDiagExtToString := 'Disabled';
	ET_DiagExt.WaitUntilControllerFinishedBoot:	FC_EtDiagExtToString := 'WaitUntilControllerFinishedBoot';
	ET_DiagExt.Initializing:					FC_EtDiagExtToString := 'Initializing';
	ET_DiagExt.DeactivatingSubModules:			FC_EtDiagExtToString := 'DeactivatingSubModules';
	ET_DiagExt.ExecuteStep:						FC_EtDiagExtToString := 'ExecuteStep';
	ET_DiagExt.WaitAtNegativeStep:				FC_EtDiagExtToString := 'WaitAtNegativeStep';
	ET_DiagExt.WaitCmdsDone:					FC_EtDiagExtToString := 'WaitCmdsDone';
	ET_DiagExt.WaitForCmd:						FC_EtDiagExtToString := 'WaitForCmd';
	ET_DiagExt.SubModuleInException:			FC_EtDiagExtToString := 'SubModuleInException';
	ET_DiagExt.ModuleControllerException:		FC_EtDiagExtToString := 'ModuleControllerException';
	ET_DiagExt.UnknownStateModuleController:	FC_EtDiagExtToString := 'UnknownStateModuleController';
	
	ET_DiagExt.SystemFatalException:			FC_EtDiagExtToString := 'SystemFatalException';
	ET_DiagExt.SystemException:					FC_EtDiagExtToString := 'SystemException';
	ET_DiagExt.SystemWarning:					FC_EtDiagExtToString := 'SystemWarning';
	ET_DiagExt.MainSystemEmergencyStop:			FC_EtDiagExtToString := 'MainSystemEmergencyStop';
	ET_DiagExt.InvalidPointer:					FC_EtDiagExtToString := 'InvalidPointer';
	ET_DiagExt.UpdateStructsException:			FC_EtDiagExtToString := 'UpdateStructsException';
	ET_DiagExt.InitReactionsException:			FC_EtDiagExtToString := 'InitReactionsException';
	ET_DiagExt.InitSubModulesException:			FC_EtDiagExtToString := 'InitSubModulesException';
	ET_DiagExt.DriveInvalid:					FC_EtDiagExtToString := 'DriveInvalid';
	ET_DiagExt.UnknownDiagExt:					FC_EtDiagExtToString := 'UnknownDiagExt';

	ET_DiagExt.Exception1FromVis:				FC_EtDiagExtToString := 'Exception1FromVis';
	ET_DiagExt.Exception2FromVis:				FC_EtDiagExtToString := 'Exception2FromVis';
	ET_DiagExt.Exception3FromVis:				FC_EtDiagExtToString := 'Exception3FromVis';
	ET_DiagExt.Exception4FromVis:				FC_EtDiagExtToString := 'Exception4FromVis';
	ET_DiagExt.Exception5FromVis:				FC_EtDiagExtToString := 'Exception5FromVis';
	
	ET_DiagExt.DiagnosticsWarning:				FC_EtDiagExtToString := 'DiagnosticsWarning';
	ET_DiagExt.WaitUntilDiagnosticsManagerReady:FC_EtDiagExtToString := 'WaitUntilDiagnosticsManagerReady';
	ET_DiagExt.WaitUntilDisabled:				FC_EtDiagExtToString := 'WaitUntilDisabled';
	ET_DiagExt.WaitUntilDiagSourceRegistered:	FC_EtDiagExtToString := 'WaitUntilDiagSourceRegistered';
	ET_DiagExt.WaitForCommunication:			FC_EtDiagExtToString := 'WaitForCommunication';
	ET_DiagExt.DataSuccessfullyWritten:			FC_EtDiagExtToString := 'DataSuccessfullyWritten';
	ET_DiagExt.WritingToFile:					FC_EtDiagExtToString := 'WritingToFile';
	ET_DiagExt.FileIdInvalid:					FC_EtDiagExtToString := 'FileIdInvalid';
	ET_DiagExt.CmdUnknown:						FC_EtDiagExtToString := 'CmdUnknown';
	ET_DiagExt.WaitUntilSercosState4:			FC_EtDiagExtToString := 'WaitUntilSercosState4';
	ET_DiagExt.UnexpectedFeedback:				FC_EtDiagExtToString := 'UnexpectedFeedback';
	ET_DiagExt.UnknownDiagExtUser:				FC_EtDiagExtToString := 'UnknownDiagExtUser';
ELSE
	FC_EtDiagExtToString := CONCAT('Unkown ET_DiagExt ', UDINT_TO_STRING(i_etDiagExt));
		
	q_etDiag	:= GD.ET_Diag.InputParameterInvalid;
	q_etDiagExt	:= ET_DiagExt.UnknownDiagExt;
END_CASE
