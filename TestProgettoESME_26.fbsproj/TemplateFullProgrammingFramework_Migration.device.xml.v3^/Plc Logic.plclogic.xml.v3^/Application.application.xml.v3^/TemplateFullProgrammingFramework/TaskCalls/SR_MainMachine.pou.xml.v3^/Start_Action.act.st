__METADATA__
{
  "v3Meta": {
    "objectGuid": "70c9a6de-85b5-4dfe-a9c8-6868fa43c94f",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* This step is active until the machine is being enabled *)

(* System generated code, do not change without consulting 'Schneider Electric Automation GmbH' - otherwise you risk instability!!!*)
xVirtualSystem := TPL.FC_GetVirtualSystem();

stMachineInterface.q_sModuleTypeName  := c_sModuleTypeName;
stMachineInterface.q_dwModuleType     := c_dwModuleType;
stMachineInterface.q_udiModuleVersion := c_udiModuleVersion;
(* End of system generated code, do not change without consulting 'Schneider Electric Automation GmbH' - otherwise you risk instability!!!*)

(* System generated code, could be modified for your application *)
stMachineInterface.q_etDiag     := GD.ET_Diag.Ok;
stMachineInterface.q_udiDiagExt := ET_DiagExt.WaitUntilSercosState4;
stMachineInterface.q_sDiagExt   := FC_EtDiagExtToString(stMachineInterface.q_udiDiagExt);
stMachineInterface.q_sMsg       := '';

SR_Sercos();

IF SR_Sercos.q_xSercosRun THEN
	APL.G_ifApplicationLogger.RegisterCommunicationService(q_etDiag =>, q_etDiagExt => );
	stMachineInterface.i_xEnable := TRUE;
	
	pTaskInfo            := __CURRENTTASK.pTaskInfo;
	G_diTaskIntervalInMs := TO_DINT(pTaskInfo^.dwInterval / 1_000);
	
	ifController := DED.GetRoot();
	xSuccess     := __QUERYINTERFACE(ifController, ifControllerDiagnosticAccess);
	IF xSuccess THEN
		ifControllerDiagnostic := ifControllerDiagnosticAccess.Diagnostic;
	END_IF
	
END_IF
(* End of system generated code, could be modified for your application *)

(* Application specific code *)
(* ToDo: Add your application specific code here *)
;
(* End of application specific code *)
