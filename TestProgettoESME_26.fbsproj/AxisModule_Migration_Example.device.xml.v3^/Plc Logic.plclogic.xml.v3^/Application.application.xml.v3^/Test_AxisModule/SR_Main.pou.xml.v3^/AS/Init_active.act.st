__METADATA__
{
  "v3Meta": {
    "objectGuid": "74672997-c1bd-448c-aa0a-4881648a2483",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
SR_Sercos();

IF sr_sercos.q_xSercosRun THEN

	// Init Data variables of Axis
	Init_Master();	
	Init_Slave1();
	Init_Slave2();

	// Activating AxisModules	
	astModuleInterface[c_udiMaster].i_xEnable	:= TRUE;	
	astModuleInterface[c_udiSlave1].i_xEnable	:= TRUE;
	astModuleInterface[c_udiSlave2].i_xEnable	:= TRUE;

	xInitDone									:= TRUE;
END_IF
