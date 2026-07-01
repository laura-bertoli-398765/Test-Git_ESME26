__METADATA__
{
  "v3Meta": {
    "objectGuid": "6731f31d-de63-4578-a2e3-32cd4d802f89",
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
METHOD INTERNAL WritePosition
__IMPLEMENTATION__
CASE diWritePositionState OF

10:	
	IF i_lrUserPeriod > c_lrRealNull THEN
		lrModuloPosition := lrEncoderPeriode / 2.0 + i_ifDrive.RefPosition - lrSavePosition;
	ELSE
		lrModuloPosition := i_lrAbsEncOffset + i_ifDrive.RefPosition - lrSavePosition;
	END_IF
	
	IF ifScaling.InvertDirection = FALSE THEN // Motor direction right
		lrPositionTemp	:= lrModuloPosition;
	ELSE
		lrPositionTemp := lrEncoderPeriode - lrModuloPosition;
	END_IF
	
	// Execute after increasing cycle-time or asynchronous
	fbSetDrvEncPos.ifDeviceType					:= ifDeviceType;
	fbSetDrvEncPos.lrPosition				:= lrPositionTemp;
	
	SE_Async.G_ifAsyncMgr.Start(
		i_ifAsync    := fbSetDrvEncPos,
		q_etResult   => etResult,
		q_sResultMsg => sResultMsg,
		q_xError     => xError);
	
	IF xError THEN
		AsyncExtDiagTranslation(i_etResult := etResult);
		RETURN;
	ELSE
		diWritePositionState := 20;
	END_IF

20:
	IF fbSetDrvEncPos.xDone THEN
		diWritePositionState := 30;
	END_IF

30:	// Check Result of writing
	diResult := fbSetDrvEncPos.diResultSetDrvEncPos;
	IF diResult = 0  THEN // Ok
		tonTimeOut(IN := FALSE, PT := c_timProgramTime );
		
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok, 
						i_etDiagExt := PDL_ET_DiagExt.WaitUntilEncoderWritten,
						i_sMsg		:= '');
		diState	:= 20;
	ELSIF diResult = -3 THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
						i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
						i_sMsg		:= 'Drive must not be virtual');
		diState := 0;
	ELSIF diResult = -4 THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
						i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
						i_sMsg		:= 'Drive must not be deactivated');
		diState := 0;
	ELSE	(* Programming error *)
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
						i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
						i_sMsg		:= CONCAT('FC_DrvEncSetPosition: ', DINT_TO_STRING(diResult)));
		q_xReady := FALSE;
		diState	:= 0;
	END_IF
		
END_CASE
