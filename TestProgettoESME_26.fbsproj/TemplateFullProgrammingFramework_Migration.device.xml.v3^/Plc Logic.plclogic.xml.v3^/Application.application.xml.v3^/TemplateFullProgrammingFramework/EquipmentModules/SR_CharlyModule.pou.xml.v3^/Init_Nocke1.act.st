__METADATA__
{
  "v3Meta": {
    "objectGuid": "e7552e69-a98c-4454-88b9-83b9fe46e0ed",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* Standard interface *)
astSubModuleInterface[c_udiNocke1].i_sModuleName		:= CONCAT(STR1 := iq_stStandardModuleItf.i_sModuleName, STR2 := ': Nocke1');

astSubModuleInterface[c_udiNocke1].i_xLogEnable			:= TRUE;
astSubModuleInterface[c_udiNocke1].i_wLogDataFilter		:= UDINT_TO_WORD(TPL.ET_LogDataFilter.ModuleDefault);

fbSlave3Module.RegisterLoggerPoint(	i_ifParent	:= fbLoggerPoint,
									i_sName		:= 'Nocke1',
									q_etDiag	:= ,
									q_etDiagExt	:= );

(* ExampleLeafModule specific interface *)
stNocke1Interface.i_ifDrive				:= i_ifMaster;
stNocke1Interface.i_lrPosMin			:= 120.0;
stNocke1Interface.i_lrPosMax			:= 250.0;
stNocke1Interface.i_xInitHoming			:= TRUE;
