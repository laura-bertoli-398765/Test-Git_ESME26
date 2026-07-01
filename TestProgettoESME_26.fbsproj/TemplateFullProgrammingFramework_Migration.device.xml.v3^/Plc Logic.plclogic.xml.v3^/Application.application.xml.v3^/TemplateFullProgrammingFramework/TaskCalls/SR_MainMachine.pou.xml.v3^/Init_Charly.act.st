__METADATA__
{
  "v3Meta": {
    "objectGuid": "a2f20d14-e6c1-46c7-9528-4beac7a6ae0d",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* System generated code, could be modified for your application *)

(* CharlyModule *)
astSubModuleInterface[c_udiCharly].i_sModuleName	:= STANDARD.CONCAT(STR1 := stMachineInterface.i_sModuleName, STR2 := ': Charly');
astSubModuleInterface[c_udiCharly].i_xLogEnable		:= TRUE;
astSubModuleInterface[c_udiCharly].i_wLogDataFilter	:= UDINT_TO_WORD(TPL.ET_LogDataFilter.ModuleDefault);

SR_CharlyModuleExtItf.RegisterLoggerPoint(	i_ifParent	:= fbLoggerPoint,
											i_sName		:= 'Charly',
											q_etDiag	=> ,
											q_etDiagExt	=> );

(* End of system generated code, could be modified for your application *)
