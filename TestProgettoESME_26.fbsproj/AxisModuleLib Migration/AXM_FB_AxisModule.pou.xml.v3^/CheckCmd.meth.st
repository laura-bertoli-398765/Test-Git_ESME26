__METADATA__
{
  "v3Meta": {
    "objectGuid": "6805a09e-d6aa-4d56-8282-f7423e633afd",
    "objectTypeGuid": "f8a58466-d7f6-439f-bbb8-d4600e41d099",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__DECLARATION__
{attribute 'conditionalshow_all_locals'}
METHOD INTERNAL CheckCmd
VAR_INPUT
END_VAR
__IMPLEMENTATION__
(*--------------------------------------------------------------------------------------------------*)
(* CheckCMD is checking if CMD is supported by this module *)
(*--------------------------------------------------------------------------------------------------*)
xOpModeCmd:= FALSE;
xCheckCMDError:= FALSE;

IF iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.Homing OR
	iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.Manual OR
	iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.CamCs OR
	iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.CamWs OR
	iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.Endless OR
	iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.Positioning OR
	iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.BrakeRelease OR
	iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.AdditionalCs OR
	iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.AdditionalWs OR
	iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.DriveEnableOff OR
	iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.Stop THEN
	
	xOpModeCmd := TRUE;
	
ELSIF  iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.Start OR
		iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.StartTrig OR
		iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.StartTrigWaitInPos OR
		iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.Hold OR
		iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.WsStart OR
		iq_stStandardModuleItf.iq_diCmd = AXM_ET_Cmd.DriveEnableOn THEN
		
		xOpModeCmd:= FALSE;
ELSE
	xCheckCMDError := TRUE;
END_IF
