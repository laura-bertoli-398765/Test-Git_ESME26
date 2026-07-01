__METADATA__
{
  "v3Meta": {
    "objectGuid": "626be8a7-779b-4119-9337-7bcfcc7277ff",
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

(* System generated code, could be modified for your application *)
xInitSuccessful := TRUE;

Init_Exceptions();
(* End of system generated code, could be modified for your application *)

(* System generated code, do not change without consulting 'Schneider Electric Automation GmbH' - otherwise you risk instability!!!*)
iq_stStandardModuleItf.q_xActive		:= TRUE;
iq_stStandardModuleItf.q_xReady			:= FALSE;
iq_stStandardModuleItf.q_etDiag			:= GD.ET_Diag.Ok;
iq_stStandardModuleItf.q_udiDiagExt		:= ET_DiagExt.Initializing;
iq_stStandardModuleItf.q_sDiagExt		:= FC_EtDiagExtToString(i_etDiagExt := ET_DiagExt.Initializing);
iq_stStandardModuleItf.q_sMsg			:= '';

Init_SubModules();
Init_CmdTables();
Init_Reactions();
UpdateStructs();
(* End of system generated code, do not change without consulting 'Schneider Electric Automation GmbH' - otherwise you risk instability!!!*)
fbModuleController.RegisterLoggerPoint(	i_ifParent	:= fbLoggerPoint,
										i_sName		:= 'ModuleController',
										q_etDiag	=> ,
										q_etDiagExt	=> );
fbExceptionHandler.RegisterLoggerPoint(	i_ifParent	:= fbLoggerPoint,
										i_sName		:= 'ExceptionHandler',
										q_etDiag	=> ,
										q_etDiagExt	=> );
(* Application specific code *)
(* ToDo: Add your application specific code here *)
;
(* End of application specific code *)
