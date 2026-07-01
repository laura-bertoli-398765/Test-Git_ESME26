__METADATA__
{
  "v3Meta": {
    "objectGuid": "ba285e07-1dd5-4f64-9232-a53e8cf533fd",
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
METHOD PRIVATE GetCamPositionOfSlave : BOOL
VAR_INPUT
	i_xCheckModulo			: BOOL;
END_VAR

VAR_OUTPUT
	q_lrSlavePosition		: LREAL;
END_VAR

VAR
	etMoinResult				: MOIN.ET_Result;
	etSetPosResult				: PLCO.ET_Result;
END_VAR	
__IMPLEMENTATION__
GetCamPositionOfSlave := TRUE;


IF i_xCheckModulo THEN
	IF   q_lrPositionX > stActiveMultiCamData.astCamPoint[0].lrX + lrXPeriode 
	  OR q_lrPositionX < stActiveMultiCamData.astCamPoint[0].lrX 
	THEN
		//adjust logic encoder position if position is not within period...
		lrModCount := TRUNC_INT((q_lrPositionX - stActiveMultiCamData.astCamPoint[0].lrX) / lrXPeriode);
		IF q_lrPositionX < stActiveMultiCamData.astCamPoint[0].lrX THEN
			lrModCount := lrModCount - 1;
		END_IF
		q_lrPositionX := q_lrPositionX - lrModCount * lrXPeriode;

		fbSetPos( Execute		:= FALSE );
		fbSetPos(	Axis		:= iq_lencMaster, 
					Execute		:= TRUE, 
					Position	:= - lrModCount * lrXPeriode, 
					Relative	:= TRUE,
					ErrorId		=> etSetPosResult );

		IF etSetPosResult <> PLCO.ET_Result.Ok THEN
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
							i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
							i_sMsg		:= CONCAT('MC_SetPosition: ', TO_STRING(etSetPosResult)));
							
			
			GetCamPositionOfSlave := FALSE;
			etState := ET_MulticamState.idle_error;
			RETURN;
		END_IF

	END_IF
END_IF

//... then get slave cam position
etMoinResult := MOIN.FC_EvaluateMultiCam( 	i_stMultiCam 		:= stActiveMultiCamData, 
											i_lrMasterPosition	:= iq_lencMaster.lrPosition, 
											q_lrCamPosition		=> q_lrSlavePosition  
											);

IF etMoinResult <> MOIN.ET_Result.Ok THEN

	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior,
					i_etDiagExt	:= PDL_ET_DiagExt.UnexpectedFeedback,
					i_sMsg		:= CONCAT('MOIN.FC_EvaluateMultiCam: ', TO_STRING(etMoinResult)));								

	GetCamPositionOfSlave := FALSE;
	etState := ET_MulticamState.idle_error;		
	RETURN;
END_IF
