__METADATA__
{
  "v3Meta": {
    "objectGuid": "45d9d449-2f61-48c2-97b8-6ad7e3410f81",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* This step is used for initialisations after being enabled *)

(* System generated code, do not change without consulting 'Schneider Electric Automation GmbH' - otherwise you risk instability!!!*)
xInitSuccessful := TRUE;

stMachineInterface.q_xActive		:= TRUE;
stMachineInterface.q_xReady			:= FALSE;
stMachineInterface.q_etDiag			:= GD.ET_Diag.Ok;
stMachineInterface.q_udiDiagExt		:= ET_DiagExt.Initializing;
stMachineInterface.q_sDiagExt		:= FC_EtDiagExtToString(i_etDiagExt := ET_DiagExt.Initializing);
stMachineInterface.q_sMsg			:= '';

stMachineInterface.i_sModuleName		:= 'MainMachine';
stMachineInterface.i_udiModuleId		:= c_udiMainModuleId;
stMachineInterface.i_xLogEnable			:= TRUE;
stMachineInterface.i_wLogDataFilter		:= UDINT_TO_WORD(TPL.ET_LogDataFilter.ModuleDefault);

fbLoggerPoint.RegisterLoggerPoint(	i_ifParent		:= APL.G_ifApplicationLogger,
									i_sName			:= stMachineInterface.i_sModuleName,
									i_sType			:= 'MainMachine',
									i_sSource		:= 'Project',
									q_etDiag		=> ,
									q_etDiagExt		=> );
fbModuleController.RegisterLoggerPoint(	i_ifParent	:= fbLoggerPoint,
										i_sName		:= 'ModuleController',
										q_etDiag	=> ,
										q_etDiagExt	=> );
fbExceptionHandler.RegisterLoggerPoint(	i_ifParent	:= fbLoggerPoint,
										i_sName		:= 'ExceptionHandler',
										q_etDiag	=> ,
										q_etDiagExt	=> );

//SYSTEMINTERFACE.FC_DiagNoQuitSet(i_diDiagCode := 8316);
(* End of system generated code, do not change without consulting 'Schneider Electric Automation GmbH' - otherwise you risk instability!!!*)

(* System generated code, could be modified for your application *)
Init_Exceptions();
(* End of system generated code, could be modified for your application *)

(* System generated code, do not change without consulting 'Schneider Electric Automation GmbH' - otherwise you risk instability!!!*)
Init_SubModules();
Init_CmdTables();
Init_Reactions();
UpdateStructs();
(* End of system generated code, do not change without consulting 'Schneider Electric Automation GmbH' - otherwise you risk instability!!!*)

(* System generated code, could be modified for your application *)
Init_Alpha();
Init_Bravo();
Init_Charly();
Init_NodeWithoutMotion();
(* End of system generated code, could be modified for your application *)

(* Application specific code *)
(* ToDo: Add your application specific code here *)
;
(* End of application specific code *)
