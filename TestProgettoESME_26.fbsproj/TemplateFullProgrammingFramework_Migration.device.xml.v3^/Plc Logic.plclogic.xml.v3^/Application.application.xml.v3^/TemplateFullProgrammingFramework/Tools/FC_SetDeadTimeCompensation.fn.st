__METADATA__
{
  "v3Meta": {
    "objectGuid": "9372adb5-a030-4172-bd11-76663d588fd4",
    "objectTypeGuid": "6f9dac99-8de1-4efc-8465-68ac443b7d08",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {
      "_3S.CoDeSys.LanguageModelManager.BuildProperty": "<?xml version=\"1.0\" encoding=\"utf-8\"?><Single xml:space=\"preserve\" Type=\"{24568a24-c491-472c-a21f-ee5d33859fab}\" Method=\"IArchivable\"><Single Name=\"MemoryReserveForOnlineChange\" Type=\"int\">0</Single><Single Name=\"ExcludeFromBuild\" Type=\"bool\">False</Single><Single Name=\"External\" Type=\"bool\">False</Single><Single Name=\"EnableSystemCall\" Type=\"bool\">False</Single><Single Name=\"CompilerDefines\" Type=\"string\"></Single><Single Name=\"LinkAlways\" Type=\"bool\">False</Single><Array Name=\"Undefines\" Type=\"string\" /></Single>"
    },
    "subObjects": {}
  }
}
__DECLARATION__
FUNCTION FC_SetDeadTimeCompensation : BOOL
VAR_INPUT
	i_stSubModuleInterfaceMain		: AXM_ST_Main;
END_VAR
VAR
(* Init related variables *)	
	//stLogicalAddressMaster			: SystemConfigurationItf.ST_LogicalAddress;
	lrShaftRefDelay					: LREAL;
	lrPositionDelay					: LREAL; 
	diResult						: DINT;	

END_VAR
__IMPLEMENTATION__
(*
IF i_stSubModuleInterfaceMain.i_ifMaster <> 0 AND i_stSubModuleInterfaceMain.i_ifDrive <> 0 THEN	
	stLogicalAddressMaster := i_stSubModuleInterfaceMain.i_ifMaster.stLogicalAddress;
	IF (stLogicalAddressMaster.udiType = SYSTEMINTERFACE.P_ENC_TYPE.udiType) OR			(* Physical encoder *)
		(stLogicalAddressMaster.udiType = SYSTEMINTERFACE.INC_IN_TYPE.udiType) OR		(* Incremental	encoder *)
		(stLogicalAddressMaster.udiType = SYSTEMINTERFACE.V_ENC_TYPE.udiType) THEN		(* Virtual master encoder *)
		
		stLogicalAddressMaster := i_stSubModuleInterfaceMain.i_ifDrive.stLogicalAddress;
		stLogicalAddressMaster.udiParameterId := 16#00A2;
		diResult := SYSTEMINTERFACE.FC_GetParameter(i_stLogAdr	:= stLogicalAddressMaster,
													i_dwBuffer	:= ADR(lrShaftRefDelay),
													i_diSize	:= SIZEOF(lrShaftRefDelay));
		IF diResult = 0 THEN
			i_stSubModuleInterfaceMain.iq_lencEncoder.Delay := -lrShaftRefDelay;
		END_IF
	ELSIF (stLogicalAddressMaster.udiType = SYSTEMINTERFACE.INC_IN3_TYPE.udiType) THEN  (* IncIn via TM5 TM5SE1IC20005 *)
		stLogicalAddressMaster := i_stSubModuleInterfaceMain.i_ifDrive.stLogicalAddress;
		stLogicalAddressMaster.udiParameterId := 16#00A2;
		diResult := SYSTEMINTERFACE.FC_GetParameter(i_stLogAdr	:= stLogicalAddressMaster,
													i_dwBuffer	:= ADR(lrShaftRefDelay),
													i_diSize	:= SIZEOF(lrShaftRefDelay));
		IF diResult = 0 THEN
			i_stSubModuleInterfaceMain.iq_lencEncoder.Delay := -lrShaftRefDelay;
			stLogicalAddressMaster := i_stSubModuleInterfaceMain.i_ifMaster.stLogicalAddress;
			stLogicalAddressMaster.udiParameterId := 16#008E; 					(* Parameter PositionDelay of TM5SE1IC20005 *)
			diResult := SYSTEMINTERFACE.FC_GetParameter(i_stLogAdr	:= stLogicalAddressMaster,
														i_dwBuffer	:= ADR(lrPositionDelay),
														i_diSize	:= SIZEOF(lrPositionDelay));		
			IF diResult = 0 THEN
				i_stSubModuleInterfaceMain.iq_lencEncoder.Delay := -(lrShaftRefDelay + (-lrPositionDelay)) ;
			END_IF
		END_IF
	END_IF
END_IF
*)
IF diResult = 0 THEN
	FC_SetDeadTimeCompensation := TRUE;
END_IF
