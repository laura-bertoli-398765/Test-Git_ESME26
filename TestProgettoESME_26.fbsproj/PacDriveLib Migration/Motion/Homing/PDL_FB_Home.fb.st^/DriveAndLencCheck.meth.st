__METADATA__
{
  "v3Meta": {
    "objectGuid": "338eb71a-58a2-4952-9c54-56ace7017578",
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
METHOD Private DriveAndLencCheck : BOOL
VAR_INPUT
END_VAR
__IMPLEMENTATION__
//Check if used Axis and/or Logical Encoder are valid Elements of PLC-Configuration
		//Mode with Axis
	IF		THIS^.i_etMode = PDL_ET_HomeMode.PosDirectionPosEdgeTp
		OR	THIS^.i_etMode = PDL_ET_HomeMode.NegDirectionPosEdgeTp
		OR	THIS^.i_etMode = PDL_ET_HomeMode.NegDirectionNegEdgeTp
		OR	THIS^.i_etMode = PDL_ET_HomeMode.PosDirectionNegEdgeTp
		OR	THIS^.i_etMode = PDL_ET_HomeMode.PosDirectionPosEdgeSensor
		OR	THIS^.i_etMode = PDL_ET_HomeMode.NegDirectionPosEdgeSensor
		OR	THIS^.i_etMode = PDL_ET_HomeMode.NegDirectionNegEdgeSensor
		OR	THIS^.i_etMode = PDL_ET_HomeMode.PosDirectionNegEdgeSensor
		OR	THIS^.i_etMode = PDL_ET_HomeMode.PosDirectionPosEdgeHWLimitPos
		OR	THIS^.i_etMode = PDL_ET_HomeMode.NegDirectionPosEdgeHWLimitNeg
		OR	THIS^.i_etMode = PDL_ET_HomeMode.NegDirectionNegEdgeHWLimitNeg
		OR	THIS^.i_etMode = PDL_ET_HomeMode.PosDirectionNegEdgeHWLimitPos
		OR	THIS^.i_etMode = PDL_ET_HomeMode.PosDirectionMaxTorque
		OR	THIS^.i_etMode = PDL_ET_HomeMode.NegDirectionMaxTorque
		OR	THIS^.i_etMode = PDL_ET_HomeMode.MoveOnPosAbs
		OR	THIS^.i_etMode = PDL_ET_HomeMode.SetPosAxisPosition
		OR	THIS^.i_etMode = PDL_ET_HomeMode.RestorePosFromAxisEncoder
		OR	THIS^.i_etMode = PDL_ET_HomeMode.RestorePosFromRetain
		OR	THIS^.i_etMode = PDL_ET_HomeMode.WriteAxisEncoder THEN
					
			IF i_ifDrive = 0 THEN
					SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
									i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
									i_sMsg		:= 'i_ifDrive = 0');
			END_IF		

				//Mode with Lenc
	ELSIF THIS^.i_etMode = PDL_ET_HomeMode.SetPosLogEncoderPosition THEN
			IF THIS^.stSetPos_loc.iq_lencAxis = 0 THEN
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
								i_etDiagExt := PDL_ET_DiagExt.LencInvalid,
								i_sMsg		:= 'iq_lencAxis = 0');
			END_IF 
	
		//Mode with Axis and Lenc
	ELSIF THIS^.i_etMode = PDL_ET_HomeMode.SetPosAxisAndLogEncoderPosition THEN
			IF i_ifDrive = 0 THEN
					SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
									i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
									i_sMsg		:= 'i_ifDrive = 0');
			
			ELSIF THIS^.stSetPos_loc.iq_lencAxis = 0 THEN
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
								i_etDiagExt := PDL_ET_DiagExt.LencInvalid,
								i_sMsg		:= 'iq_lencAxis = 0');
			END_IF 
	END_IF	

