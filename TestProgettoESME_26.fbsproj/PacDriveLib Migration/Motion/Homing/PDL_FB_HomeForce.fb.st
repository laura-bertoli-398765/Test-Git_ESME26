__METADATA__
{
  "v3Meta": {
    "objectGuid": "70f5fe97-e24a-4859-915e-763037432fb2",
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
FUNCTION_BLOCK PDL_FB_HomeForce
VAR_INPUT
	i_xEnable					: BOOL;
	i_ifDrive					: MOIN.IF_Axis;
	i_lrMaxForce				: LREAL;								
	i_diForceTime				: DINT;									
	i_lrLowLimit				: LREAL;				
	i_etMode					: PDL_ET_HomeForceMode;	
	i_lrOffset					: LREAL;								
	i_lrMaxTravel				: LREAL;								
	i_lrHomePosition			: LREAL;								
	i_lrVel						: LREAL;			
	i_lrAcc						: LREAL;			
	i_lrDec						: LREAL;	
	i_lrJerk					: LREAL;	
	i_xStart					: BOOL;
END_VAR
VAR_OUTPUT
	q_xActive					: BOOL;			
	q_xReady					: BOOL;
	q_etDiag					: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt					: PDL_ET_DiagExt := PDL_ET_DiagExt.Disabled;
	q_sMsg						: STRING[80];
	q_xMotionInstructionActive	: BOOL;						
	q_lrPosition				: LREAL;					
	q_xHomeOk					: BOOL;			
END_VAR
VAR

END_VAR
__IMPLEMENTATION__

