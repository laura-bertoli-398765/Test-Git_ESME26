__METADATA__
{
  "v3Meta": {
    "objectGuid": "274acd60-8994-4902-99cd-bfb23d1cd6e0",
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
METHOD PRIVATE CallPLCopenFBs : BOOL
VAR_INPUT
END_VAR
__IMPLEMENTATION__

(*********************************************************************************************************************)
fbMoveAbsolute();

IF fbMoveAbsolute.Error THEN
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
					i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
					i_sMsg		:= CONCAT('MC_MoveAbsolute.ErrorID: ', PLCO.FC_EtResultToString(fbMoveAbsolute.ErrorID) ));	
	fbMoveAbsolute.Execute := FALSE;
					
	q_xReady		:= FALSE;
	q_xSynActive	:= FALSE;
	q_xXLowEnd		:= FALSE;
	q_xXHighEnd		:= FALSE;
	q_xInWSWindow	:= FALSE;				
	etState := ET_MulticamState.controllerStop;
END_IF

(*********************************************************************************************************************)
fbCamIn();
	
IF fbCamIn.Error THEN
	
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
					i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
					i_sMsg		:= CONCAT('MC_CamIn.ErrorID: ', PLCO.FC_EtResultToString(fbCamIn.ErrorID) ));	
					
	fbCamIn.Execute := FALSE;		
	q_xReady		:= FALSE;
	q_xSynActive	:= FALSE;
	q_xXLowEnd		:= FALSE;
	q_xXHighEnd		:= FALSE;
	q_xInWSWindow	:= FALSE;				
	etState := ET_MulticamState.controllerStop;
END_IF


(*********************************************************************************************************************)
fbCamIn2();
	
IF fbCamIn2.Error THEN
	
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
					i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
					i_sMsg		:= CONCAT('MC_CamIn.ErrorID: ', PLCO.FC_EtResultToString(fbCamIn2.ErrorID) ));	
					
	fbCamIn2.Execute := FALSE;		
	q_xReady		:= FALSE;
	q_xSynActive	:= FALSE;
	q_xXLowEnd		:= FALSE;
	q_xXHighEnd		:= FALSE;
	q_xInWSWindow	:= FALSE;				
	etState := ET_MulticamState.controllerStop;
END_IF

(*********************************************************************************************************************)

xCamInInSync :=    fbCamIn.InSync
			   AND NOT xCamIn2Active
			   OR  fbCamIn2.InSync
			   AND xCamIn2Active;
			   
xCamInEndOfProfile :=      fbCamIn.EndOfProfile
					   AND NOT xCamIn2Active
					   OR  fbCamIn2.EndOfProfile
					   AND xCamIn2Active;
			   
