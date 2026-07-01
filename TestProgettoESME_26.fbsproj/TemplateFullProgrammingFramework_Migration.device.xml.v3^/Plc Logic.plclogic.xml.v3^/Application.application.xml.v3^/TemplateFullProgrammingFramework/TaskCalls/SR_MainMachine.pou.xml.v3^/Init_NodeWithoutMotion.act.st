__METADATA__
{
  "v3Meta": {
    "objectGuid": "39dfeb60-9d58-49e9-a7e5-386870a131e5",
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

(* Module NodeWithoutMotion *)
astSubModuleInterface[c_udiNodeWithoutMotion].i_sModuleName		:= STANDARD.CONCAT(STR1 := stMachineInterface.i_sModuleName, STR2 := ': NodeWithoutMotion');
astSubModuleInterface[c_udiNodeWithoutMotion].i_xLogEnable		:= TRUE;
astSubModuleInterface[c_udiNodeWithoutMotion].i_wLogDataFilter	:= UDINT_TO_WORD(TPL.ET_LogDataFilter.ModuleDefault);

SR_NodeWithoutMotionModule.RegisterLoggerPoint(	i_ifParent	:= fbLoggerPoint,
												i_sName		:= 'NodeWithoutMotion',
												q_etDiag	=> ,
												q_etDiagExt	=> );

(* End of system generated code, could be modified for your application *)
