__METADATA__
{
  "v3Meta": {
    "objectGuid": "9f32a2c7-c404-4c45-8b81-9d37508aa755",
    "objectTypeGuid": "6f9dac99-8de1-4efc-8465-68ac443b7d08",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {
      "_3S.CoDeSys.LanguageModelManager.BuildProperty": "<?xml version=\"1.0\" encoding=\"utf-8\"?><Single xml:space=\"preserve\" Type=\"{24568a24-c491-472c-a21f-ee5d33859fab}\" Method=\"IArchivable\"><Single Name=\"MemoryReserveForOnlineChange\" Type=\"int\">0</Single><Single Name=\"ExcludeFromBuild\" Type=\"bool\">False</Single><Single Name=\"External\" Type=\"bool\">False</Single><Single Name=\"EnableSystemCall\" Type=\"bool\">False</Single><Single Name=\"CompilerDefines\" Type=\"string\"></Single><Single Name=\"LinkAlways\" Type=\"bool\">True</Single><Array Name=\"Undefines\" Type=\"string\" /></Single>"
    },
    "subObjects": {}
  },
  "linkAlways": true
}
__DECLARATION__
FUNCTION PDL_FC_SaveAxisPosition : BOOL
VAR_INPUT
	i_etPosType : PDL_ET_PosType;
	i_ifDrive   : MOIN.IF_Axis;
END_VAR

VAR_IN_OUT
	iq_stRestorePosition : PDL_ST_AxisRestorePosition;
END_VAR

VAR_OUTPUT
	q_etDiag    : GD.ET_Diag     := GD.ET_Diag.OK;
	q_etDiagExt : PDL_ET_DiagExt := PDL_ET_DiagExt.OK;
	q_sMsg      : STRING[80];
END_VAR

VAR
	etSercosState       : SMI.ET_SercosState;
	xSuccess            : BOOL;
	lrAxisPosition      : LREAL;
	lrEncPosition       : LREAL;
	lrAxisPosition2     : LREAL;
	lrEncPosition2      : LREAL;
	diCount             : DINT;
	ifDriveAccess       : DMFI.IF_DriveAccess;
	ifDrive             : DMFI.IF_Drive;
	ifEncoderAccess     : DDI.IF_EncoderAccess;
	ifEncoder           : DDI.IF_Encoder;
	ifGetParentDevice   : DTSI.IF_GetParentDevice;
	ifDeviceAccess      : DTSI.IF_DeviceAccess;
	
END_VAR

VAR CONSTANT
	c_lrDelta : LREAL := 0.01;
	
END_VAR
__IMPLEMENTATION__
IF i_ifDrive = 0 THEN
	q_etDiag    := GD.ET_Diag.InputParameterInvalid;
	q_etDiagExt := PDL_ET_DiagExt.DriveInvalid;
	q_sMsg      := 'i_ifDrive - Invalid Interface';
	RETURN;
END_IF

xSuccess := __QUERYINTERFACE(i_ifDrive, ifGetParentDevice);
IF NOT xSuccess OR ifGetParentDevice = 0 THEN
	q_etDiag    := GD.ET_Diag.InputParameterInvalid;
	q_etDiagExt := PDL_ET_DiagExt.DriveInvalid;
	q_sMsg      := 'i_ifDrive - IF_GetParentDevice not implemented.';
	RETURN;
END_IF
ifDeviceAccess := ifGetParentDevice.GetParentDevice();

xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifDriveAccess);
IF (NOT xSuccess OR ifDriveAccess = 0) THEN
	q_etDiag    := GD.ET_Diag.InputParameterInvalid;
	q_etDiagExt := PDL_ET_DiagExt.DriveInvalid;
	q_sMsg      := 'i_ifDrive - IF_Drive not implemented.';
	RETURN;
END_IF
ifDrive := ifDriveAccess.Drive;


xSuccess := __QUERYINTERFACE(ifDeviceAccess, ifEncoderAccess);
IF (NOT xSuccess OR ifEncoderAccess = 0) THEN
	q_etDiag    := GD.ET_Diag.InputParameterInvalid;
	q_etDiagExt := PDL_ET_DiagExt.DriveInvalid;
	q_sMsg      := 'i_ifDrive - IF_Encoder not implemented.';
	RETURN;
END_IF
ifEncoder := ifEncoderAccess.Encoder;

FOR diCount := 1 TO 3 DO
	
	etSercosState := FC_GetSercosState();
	IF etSercosState = SMI.ET_SercosState.Phase4 THEN
		
		(* first read of AxisPos and EncoderPos *)
		CASE i_etPosType OF
			PDL_ET_PosType.Position:
				lrAxisPosition := ifDrive.ActualPosition;
			PDL_ET_PosType.RefPosition:
				lrAxisPosition := i_ifDrive.RefPosition;
			PDL_ET_PosType.MechPosition:
				lrAxisPosition := ifDrive.ActualPosition;
			PDL_ET_PosType.MechRefPosition:
				lrAxisPosition := i_ifDrive.RefPosition;
			ELSE
				lrAxisPosition := i_ifDrive.RefPosition;
		END_CASE
		
		lrEncPosition := ifEncoder.Position;
		
		(* second read of AxisPos and EncoderPos *)
		CASE i_etPosType OF
			PDL_ET_PosType.Position:
				lrAxisPosition2 := ifDrive.ActualPosition;
			PDL_ET_PosType.RefPosition:
				lrAxisPosition2 := i_ifDrive.RefPosition;
			PDL_ET_PosType.MechPosition:
				lrAxisPosition2 := ifDrive.ActualPosition;
			PDL_ET_PosType.MechRefPosition:
				lrAxisPosition2 := i_ifDrive.RefPosition;
			ELSE
				lrAxisPosition2 := i_ifDrive.RefPosition;
		END_CASE
		
		lrEncPosition2 := ifEncoder.Position;
		
	ELSE
		q_etDiag    := GD.ET_Diag.SercosConditionInvalid;
		q_etDiagExt := PDL_ET_DiagExt.SercosNotInPhaseFour;
		q_sMsg      := '';
		RETURN;
	END_IF
	
	IF (ABS(lrEncPosition - lrEncPosition2) < c_lrDelta) AND (ABS(lrAxisPosition - lrAxisPosition2) < c_lrDelta) THEN
		EXIT;
	END_IF
END_FOR

etSercosState := FC_GetSercosState();
IF (etSercosState = SMI.ET_SercosState.Phase4) AND (diCount <= 3) THEN
	iq_stRestorePosition.lrAxisPosition := lrAxisPosition2;
	iq_stRestorePosition.lrEncPosition  := lrEncPosition2;
	iq_stRestorePosition.lrCheckSum     := lrAxisPosition2 + lrEncPosition2;
ELSE
	q_etDiag    := GD.ET_Diag.SercosConditionInvalid;
	q_etDiagExt := PDL_ET_DiagExt.SercosNotInPhaseFour;
	q_sMsg      := '';
END_IF
