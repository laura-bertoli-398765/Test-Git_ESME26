__METADATA__
{
  "v3Meta": {
    "objectGuid": "652afe9a-1553-4164-a430-fba90531ddf8",
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
METHOD PRIVATE Init_Interfaces : BOOL
VAR_INPUT
END_VAR
__IMPLEMENTATION__
		Init_Interfaces := FALSE;

		IF
			i_etMode = PDL_ET_HomeSetPosMode.SetPosAxisAndLogEncoderPosition OR
			i_etMode = PDL_ET_HomeSetPosMode.RestorePosFromRetain OR
			i_etMode = PDL_ET_HomeSetPosMode.SetPosAxisPosition OR
			i_etMode = PDL_ET_HomeSetPosMode.RestorePosFromAxisencoder
		THEN
			IF i_ifDrive = 0 THEN
				SetDiagOutput(i_etDiag := GD.ET_Diag.InputParameterInvalid, i_etDiagExt := PDL_ET_DiagExt.DriveInvalid, i_sMsg := 'i_ifDrive = 0');
				diState := 0;
				RETURN;
			ELSE
				xSuccess := __QUERYINTERFACE(i_ifDrive, ifGetParentDevice);
				IF NOT xSuccess OR ifGetParentDevice = 0 THEN
					SetDiagOutput(
						i_etDiag    := GD.ET_Diag.InputParameterInvalid,
						i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
						i_sMsg      := 'i_ifDrive - IF_GetParentDevice not implemented.'
					);
					diState := 0;
					RETURN;
				END_IF
				
				ifDeviceAccess := ifGetParentDevice.GetParentDevice();
				
				xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifScalingAccess);
				IF (NOT xSuccess OR ifScalingAccess = 0) THEN
					SetDiagOutput(
						i_etDiag    := GD.ET_Diag.InputParameterInvalid,
						i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
						i_sMsg      := 'i_ifDrive - IF_Scaling not implemented.'
					);
					diState := 0;
					RETURN;
				END_IF
				ifScaling := ifScalingAccess.Scaling;
				
				xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifEncoderAccess);
				IF (NOT xSuccess OR ifEncoderAccess = 0) THEN
					SetDiagOutput(
						i_etDiag    := GD.ET_Diag.InputParameterInvalid,
						i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
						i_sMsg      := 'i_ifDrive - IF_Encoder not implemented.'
					);
					diState := 0;
					RETURN;
				END_IF
				ifEncoder := ifEncoderAccess.Encoder;
				
			END_IF
		END_IF
		
		IF i_etMode = PDL_ET_HomeSetPosMode.SetPosLogEncoderPosition OR i_etMode = PDL_ET_HomeSetPosMode.SetPosAxisAndLogEncoderPosition THEN
			IF iq_lencEncoder = 0 THEN
				SetDiagOutput(
					i_etDiag := GD.ET_Diag.InputParameterInvalid, i_etDiagExt := PDL_ET_DiagExt.LencInvalid, i_sMsg := 'iq_lencEncoder = 0'
				);
				diState := 0;
				RETURN;
			END_IF
		END_IF

		Init_Interfaces := TRUE;
		
