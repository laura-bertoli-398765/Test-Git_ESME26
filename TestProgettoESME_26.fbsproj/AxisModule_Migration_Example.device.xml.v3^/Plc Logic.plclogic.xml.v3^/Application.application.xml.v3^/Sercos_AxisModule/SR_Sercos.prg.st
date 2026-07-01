__METADATA__
{
  "v3Meta": {
    "objectGuid": "95dac237-2487-46ea-8c8d-1ce1255997f8",
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
PROGRAM SR_Sercos

VAR_OUTPUT
	q_xSercosRun: BOOL;
END_VAR
// configuration
VAR
	fbSet230VModeAsync	: FB_Set230VModeAsync;	
 	etMainsVoltageMode : ET_MainsVoltageMode := ET_MainsVoltageMode._230V;
END_VAR

VAR	
	xInit : BOOL := TRUE;
	xResetSercos: BOOL;	
	bDiagQuit :BOOL := FALSE;
    diState :DINT:=0;		
	xError: BOOL;
	etResult: MOIN.ET_Result;
	xError2: BOOL;
	etResult2: MOIN.ET_Result;
	
	diResult : DINT;
	sDiagMsg : STRING[255];	

END_VAR

__IMPLEMENTATION__
CASE diState OF
	0:
		IF xInit THEN
			IF PSM_Lexium62.WorkingMode.DesiredMode = CFDI.ET_WorkingMode.Virtual THEN
				diState := 70;
			ELSE
				diState := 20;
			END_IF
		END_IF
	20:
		SE_Async.G_ifAsyncMgr.Init();
		IF SE_Async.G_ifAsyncMgr.xInitDone THEN
			// go to CP2
			SercosMaster.SercosPhaseChanger.DesiredPhase := SMI.ET_SercosPhase.Phase2;
			diState                                      := diState + 10;
		END_IF

	30:
		// wait for CP2
		IF SercosMaster.SercosPhaseChanger.ActualState = SMI.ET_SercosState.Phase2 THEN
			diState := diState + 10;
		END_IF
		
	40:
		// configure 230V mode on PowerSupply
		IF etMainsVoltageMode = ET_MainsVoltageMode._230V THEN
			fbSet230VModeAsync(i_ifSercosIdentificationAccess := PSM_Lexium62);
			fbSet230VModeAsync.xDone := FALSE;
			SE_Async.G_ifAsyncMgr.Start(fbSet230VModeAsync);
			diState := diState + 10;
		ELSE
			diState := 70;
		END_IF

	50: 
		// configure 230V mode on DRV_Slave1	
		IF fbSet230VModeAsync.xDone THEN
			fbSet230VModeAsync(i_ifSercosIdentificationAccess := DRV_Slave1);
			fbSet230VModeAsync.xDone := FALSE;
			SE_Async.G_ifAsyncMgr.Start(fbSet230VModeAsync);
			diState := diState + 10;
		ELSIF fbSet230VModeAsync.q_diResult <> 0 THEN
			sDiagMsg := fbSet230VModeAsync.q_sDiagMsg;
			diState  := 500;
			RETURN;
		END_IF
			
	60: 
		// configure 230V mode on DRV_Slave2	
		IF fbSet230VModeAsync.xDone THEN
			fbSet230VModeAsync(i_ifSercosIdentificationAccess := DRV_Slave2);
			fbSet230VModeAsync.xDone := FALSE;
			SE_Async.G_ifAsyncMgr.Start(fbSet230VModeAsync);
			diState := diState + 10;
		ELSIF fbSet230VModeAsync.q_diResult <> 0 THEN
			sDiagMsg := fbSet230VModeAsync.q_sDiagMsg;
			diState  := 500;
			RETURN;
		END_IF
			
	70:
		// go to CP4
		SercosMaster.SercosPhaseChanger.DesiredPhase := SMI.ET_SercosPhase.Phase4;
		diState                                      := diState + 10;
	80:
		// wait for CP4
		IF SercosMaster.SercosPhaseChanger.ActualState = SMI.ET_SercosState.Phase4 THEN
			diState      := diState + 10;
			q_xSercosRun := TRUE;
		END_IF
	90:
		IF xResetSercos THEN
			xResetSercos 								 := FALSE;
			q_xSercosRun                                 := FALSE;
			SercosMaster.SercosPhaseChanger.DesiredPhase := SMI.ET_SercosPhase.NRT;
			diState                                      := 0;
		END_IF
END_CASE

IF bDiagQuit THEN
	bDiagQuit := FALSE;
	SEC.FC_DiagAcknowledge();
END_IF
