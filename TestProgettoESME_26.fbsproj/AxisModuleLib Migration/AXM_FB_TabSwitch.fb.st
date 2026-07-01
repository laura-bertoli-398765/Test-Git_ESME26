__METADATA__
{
  "v3Meta": {
    "objectGuid": "64232306-bc8c-478b-9090-baa28a135a50",
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
FUNCTION_BLOCK AXM_FB_TabSwitch
VAR_INPUT
	i_xEnable				: BOOL;
	i_xLowEnd				: BOOL;
	i_xHighEnd				: BOOL;
	i_udiTableSelectNr		: UDINT;
END_VAR
VAR_IN_OUT
	iq_xTakeNewCam			: BOOL;
	iq_xTakeInstantNewCam	: BOOL;
	iq_xNewCam				: BOOL;
	iq_xInstantNewCam		: BOOL;
	iq_astMotionPar			: ARRAY [0..AXM_GPL.Gc_udiMaxNumberOfCamTables] OF CMT.ST_MultiCam;
	iq_stOutTab				: CMT.ST_MultiCam;
END_VAR
VAR_OUTPUT
	q_xActive				: BOOL;
	q_xReady				: BOOL;
	q_etDiag				: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt				: AXM_ET_DiagExt := AXM_ET_DiagExt.Disabled;
	q_sMsg					: STRING[80] := '';
	q_udiTableNumber		: UDINT;
END_VAR
VAR
	xEnableFlag				: BOOL;
	diState					: DINT;
	udiTableSelectNr_old	: UDINT := AXM_GPL.Gc_udiMaxNumberOfCamTables +1; 
	xWaitNewCamAccept		: BOOL;
END_VAR
__IMPLEMENTATION__
IF i_xEnable AND NOT xEnableFlag AND (diState = 0) THEN
	xEnableFlag := TRUE;
	q_xActive := TRUE;
	q_xReady := TRUE;
	q_etDiag := GD.ET_Diag.Ok;
	q_etDiagExt := AXM_ET_DiagExt.Working;
	q_sMsg := AXM_FC_EtDiagExtToString(i_etDiagExt := AXM_ET_DiagExt.Working);
	iq_xTakeNewCam := FALSE;
	iq_xTakeInstantNewCam := FALSE;
	iq_xNewCam := FALSE;
	iq_xInstantNewCam := FALSE;
	IF (i_udiTableSelectNr <= AXM_GPL.Gc_udiMaxNumberOfCamTables) THEN
		iq_stOutTab := iq_astMotionPar[i_udiTableSelectNr];
		q_udiTableNumber := i_udiTableSelectNr;
		IF udiTableSelectNr_old = AXM_GPL.Gc_udiMaxNumberOfCamTables +1 THEN
			// on very first call after controller boot FB_MultiCam has not seen any new cam, therefore set of iq_xNewCam in state 10 would cause that a non cyclic cam is executed twice
			udiTableSelectNr_old := i_udiTableSelectNr;
		END_IF
	ELSE
		iq_stOutTab := iq_astMotionPar[0];
		q_udiTableNumber := 0;
	END_IF
	//udiTableSelectNr_old := i_udiTableSelectNr;
	IF(xWaitNewCamAccept) THEN
		(* we did send a newcam, but the multicam has been disabled bevore he did compute it
			and beeing activated (or inactive) he resets the newcam so the signal is lost, 
			but we do keep track ==> send it again *)
		diState := 1; (* special startup state *)
	ELSE
		diState:=10;
	END_IF	
ELSIF NOT i_xEnable AND xEnableFlag THEN
	xEnableFlag := FALSE;
	q_xReady := FALSE;
	q_xActive := FALSE;
	q_etDiag := GD.ET_Diag.Ok;
	q_etDiagExt := AXM_ET_DiagExt.Disabled;
	q_sMsg := AXM_FC_EtDiagExtToString(i_etDiagExt := AXM_ET_DiagExt.Disabled);
	diState := 0;
END_IF

CASE diState OF
	0: (* Disabled *)
		; (* Do nothing *)
		
	1:
		(* send xNewCam in seccond cycle, because multicam does set iq_xNewCam to false when he is enabled *)
		iq_xNewCam := TRUE; (* if the fb was disabled before the multicam did compute the newcam,
			send a newCam signal to the multicam one cycle after he has been activated *)
		diState := 10;
				
	10: (* working *)
		IF iq_xTakeInstantNewCam THEN
			IF (i_udiTableSelectNr <= AXM_GPL.Gc_udiMaxNumberOfCamTables) THEN
				iq_stOutTab := iq_astMotionPar[i_udiTableSelectNr];
				q_udiTableNumber := i_udiTableSelectNr;
				udiTableSelectNr_old := i_udiTableSelectNr;
			ELSE
				iq_stOutTab := iq_astMotionPar[0];
				q_udiTableNumber := 0;
				udiTableSelectNr_old := 0;
			END_IF
			iq_xInstantNewCam := TRUE;
			diState := 30;
		ELSIF (i_xLowEnd OR i_xHighEnd) AND iq_xNewCam THEN
			diState :=20;
			iq_xTakeNewCam:= FALSE;
		ELSIF ((i_udiTableSelectNr <> udiTableSelectNr_old) OR iq_xTakeNewCam) AND NOT i_xLowEnd AND NOT i_xHighEnd THEN
			IF (i_udiTableSelectNr <= AXM_GPL.Gc_udiMaxNumberOfCamTables) THEN
				iq_stOutTab := iq_astMotionPar[i_udiTableSelectNr];
				q_udiTableNumber := i_udiTableSelectNr;
				udiTableSelectNr_old := i_udiTableSelectNr;
			ELSE
				iq_stOutTab := iq_astMotionPar[0];
				q_udiTableNumber := 0;
				udiTableSelectNr_old := 0;
			END_IF
			iq_xNewCam := TRUE;
			xWaitNewCamAccept := TRUE;
		END_IF
		IF (NOT iq_xNewCam) THEN
			xWaitNewCamAccept := FALSE;
		END_IF
		
	20: (* wait new cam accept *)
		IF NOT i_xLowEnd AND NOT i_xHighEnd  THEN
			diState:=10;
		END_IF
		IF(NOT iq_xNewCam) THEN
			xWaitNewCamAccept := FALSE;
		END_IF
		
	30: (* wait InstantNewCam accepted *)
		IF NOT iq_xInstantNewCam THEN
			iq_xTakeInstantNewCam := FALSE;
			diState := 10;
		END_IF
END_CASE
