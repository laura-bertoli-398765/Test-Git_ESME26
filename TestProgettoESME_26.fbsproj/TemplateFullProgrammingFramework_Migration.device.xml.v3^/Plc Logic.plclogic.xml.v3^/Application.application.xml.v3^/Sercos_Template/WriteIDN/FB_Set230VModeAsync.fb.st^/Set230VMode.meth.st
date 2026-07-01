__METADATA__
{
  "v3Meta": {
    "objectGuid": "81cf24cb-65d7-42bb-ae6c-fc1d70ded9a4",
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
METHOD Set230VMode : dint
VAR_INPUT
	i_ifSercosIdentificationAccess : SDI.IF_SercosIdentificationAccess;
END_VAR
VAR_OUTPUT
	//q_diResult : DINT;
	q_sDiagMsg : STRING[255];	
END_VAR
VAR
	diResult : DINT;
	ifLxm62PowerSupplyAccess : LXM62SI.IF_Lxm62PowerSupplyAccess;
END_VAR
__IMPLEMENTATION__
// Check if we have a Lexium62 PowerSupply
IF __QUERYINTERFACE(i_ifSercosIdentificationAccess, ifLxm62PowerSupplyAccess) THEN
	// Set 'PhaseCheckMode' (P-0-0638) to 1 phase (1)
	diResult := FC_SercosWriteIDN(
		i_uiTopoAddr := i_ifSercosIdentificationAccess.SercosIdentification.ConfiguredTopologyAddress,
		i_etSercosParameterType := ET_SercosParameterType.P_Parameter,
		i_uiIDN := 638,
		i_etWriteIDNType := ET_SercosWriteIDNType.WriteUserData,
		i_dwValue := 1);
	
	IF diResult <> 0 THEN
		q_sDiagMsg := 'Set $'PhaseCheckMode$' to $'230 V / 1$' on PowerSupply failed.';
		Set230VMode := diResult;
		RETURN;
	END_IF
END_IF

// Set 'MainsVoltageMode' (P-0-1021) to 230V (1) - for PowerSupply and Drives
diResult := FC_SercosWriteIDN(
	i_uiTopoAddr := i_ifSercosIdentificationAccess.SercosIdentification.ConfiguredTopologyAddress,
	i_etSercosParameterType := ET_SercosParameterType.P_Parameter,
	i_uiIDN := 1021,
	i_etWriteIDNType := ET_SercosWriteIDNType.WriteUserData,
	i_dwValue := 1);
	
IF diResult <> 0 THEN
	q_sDiagMsg := 'Set $'MainsVoltageMode$' to $'230 V / 1$' on Sercos device failed.';
	Set230VMode := diResult;
	RETURN;
END_IF
