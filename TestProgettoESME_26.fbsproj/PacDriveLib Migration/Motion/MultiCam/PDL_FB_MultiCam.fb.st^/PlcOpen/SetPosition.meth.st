__METADATA__
{
  "v3Meta": {
    "objectGuid": "95dd76da-d592-47c5-bea2-13dab5a7d216",
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
METHOD PRIVATE SetPosition : BOOL
VAR_INPUT
	i_ifAxis		: MOIN.IF_Axis;
	i_lrPosition	: LREAL;
	i_xRelative		: BOOL;
END_VAR


VAR
	etSetPosResult				: PLCO.ET_Result;
END_VAR	
__IMPLEMENTATION__
SetPosition := TRUE; 



fbSetPos( Execute		:= FALSE );
fbSetPos(	Axis		:= i_ifAxis, 
			Execute		:= TRUE, 
			Position	:= i_lrPosition, 
			Relative	:= i_xRelative,
			ErrorId		=> etSetPosResult );


IF etSetPosResult <> PLCO.ET_Result.Ok THEN
	
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
					i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
					i_sMsg		:= CONCAT('MC_SetPosition: ', TO_STRING(etSetPosResult)));


	SetPosition := FALSE;//no success
	
	etState := ET_MulticamState.controllerStop;
END_IF	






