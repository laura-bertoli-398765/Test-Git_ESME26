__METADATA__
{
  "v3Meta": {
    "objectGuid": "0e680fa5-f239-4ec3-a11c-23d88a6f9490",
    "objectTypeGuid": "6f9dac99-8de1-4efc-8465-68ac443b7d08",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__DECLARATION__
FUNCTION FC_GetSercosState : SMI.ET_SercosState
VAR
	ifControllerNode           : DED.INode;
	ifCommDeviceNode           : DED.INode;
	ifEthernetNode             : DED.INode;
	uxiChildObjs               : __UXINT;
	ifCommDeviceType           : DeviceTypeInterfaces.IF_CommDevice_Type;
	ifEthernetType             : DeviceTypeInterfaces.IF_Ethernet_Type;
	ifSercosMasterType         : DeviceTypeInterfaces.IF_SercosMaster_Type;
	ifNode                     : DED.INode;
	uiCount                    : UINT;
	xSuccess                   : BOOL;
	ifSercosPhaseChangerAccess : SMI.IF_SercosPhaseChangerAccess;
	
END_VAR
__IMPLEMENTATION__
FC_GetSercosState := SMI.ET_SercosState.Error;

IF G_ifSercosPhaseChanger <> 0 THEN
	FC_GetSercosState := G_ifSercosPhaseChanger.ActualState;
ELSE
	(* find SERCOS *)
	ifControllerNode := DED.GetRoot();
	uxiChildObjs     := ifControllerNode.ChildNodeCount;
	
	ifNode := ifControllerNode.FirstChildNode;
	
	(* find CommDevice *)
	FOR uiCount := 1 TO TO_UINT(uxiChildObjs) DO
		xSuccess := __QUERYINTERFACE(ifNode, ifCommDeviceType);
		//--- found CommDevice -----------
		IF xSuccess THEN
			ifCommDeviceNode := ifNode;
			uxiChildObjs     := ifCommDeviceNode.ChildNodeCount;
			EXIT;
		END_IF
		
		IF uiCount < TO_UINT(uxiChildObjs) THEN
			ifNode := ifNode.NextSiblingNode;
		END_IF
	END_FOR
	
	IF ifCommDeviceNode = 0 THEN
		RETURN;
	END_IF
	
	(* find Ethernet *)
	ifNode := ifCommDeviceNode.FirstChildNode;
	FOR uiCount := 1 TO TO_UINT(uxiChildObjs) DO
		xSuccess := __QUERYINTERFACE(ifNode, ifEthernetType);
		//--- found Ethernet -----------
		IF xSuccess THEN
			ifEthernetNode := ifNode;
			uxiChildObjs     := ifEthernetNode.ChildNodeCount;
			EXIT;
		END_IF
		
		IF uiCount < TO_UINT(uxiChildObjs) THEN
			ifNode := ifNode.NextSiblingNode;
		END_IF
	END_FOR
	
	IF ifEthernetNode = 0 THEN
		RETURN;
	END_IF
	
	(* find SERCOS *)
	ifNode := ifEthernetNode.FirstChildNode;
	FOR uiCount := 1 TO TO_UINT(uxiChildObjs) DO
		xSuccess := __QUERYINTERFACE(ifNode, ifSercosMasterType);
		//--- found sercos -----------
		IF xSuccess THEN
			xSuccess := __QUERYINTERFACE(ifNode, ifSercosPhaseChangerAccess);
			IF xSuccess THEN
				G_ifSercosPhaseChanger := ifSercosPhaseChangerAccess.SercosPhaseChanger;
				FC_GetSercosState      := G_ifSercosPhaseChanger.ActualState;
			END_IF
			EXIT;
		END_IF
		
		IF uiCount < TO_UINT(uxiChildObjs) THEN
			ifNode := ifNode.NextSiblingNode;
		END_IF
	END_FOR
END_IF
