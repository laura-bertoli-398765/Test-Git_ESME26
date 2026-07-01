__METADATA__
{
  "v3Meta": {
    "objectGuid": "61561b81-6e46-47b7-b302-ee9f18f8c31f",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
IF iq_stAxisModuleItf.stHome.i_xResetHomeOk THEN
	iq_stAxisModuleItf.stMain.q_xHomeOk := FALSE;
	
	IF fbHome.q_xHomeOk = TRUE THEN
		xResetHomeOkActive := TRUE;
	END_IF
END_IF

(* -----------------------------------------------------------------------------------------------*)
(* Check DiagQuit *)
(* -----------------------------------------------------------------------------------------------*)
THIS^.DiagQuit();

(* -----------------------------------------------------------------------------------------------*)
(* Check external Reaction *)
(* -----------------------------------------------------------------------------------------------*)

stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop] := stLocalReaction.axReaction[TPL.ET_Reaction.AsyncStop] OR iq_stStandardModuleItf.i_stReaction.axReaction[TPL.ET_Reaction.AsyncStop];
stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL] := stLocalReaction.axReaction[TPL.ET_Reaction.SyncStopEL] OR iq_stStandardModuleItf.i_stReaction.axReaction[TPL.ET_Reaction.SyncStopEL];
stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH] := stLocalReaction.axReaction[TPL.ET_Reaction.SyncStopEH] OR iq_stStandardModuleItf.i_stReaction.axReaction[TPL.ET_Reaction.SyncStopEH];
stModuleReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle] := stLocalReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle] OR iq_stStandardModuleItf.i_stReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle];
stModuleReaction.axReaction[TPL.ET_Reaction.MainsContactorOff] := stLocalReaction.axReaction[TPL.ET_Reaction.MainsContactorOff] OR iq_stStandardModuleItf.i_stReaction.axReaction[TPL.ET_Reaction.MainsContactorOff];

(* -----------------------------------------------------------------------------------------------*)
(* save axis pos in case of restore position *)
(* -----------------------------------------------------------------------------------------------*)
IF (iq_stAxisModuleItf.stMain.i_ifDrive = 0) THEN
	stExceptionModuleReaction1.etDiag		:= GD.ET_Diag.InputParameterInvalid;
	stExceptionModuleReaction1.udiDiagExt	:= AXM_ET_DiagExt.DriveInvalid;
	stExceptionModuleReaction1.sMsg			:= 'No drive given';
	ReportException(iq_stException := stExceptionModuleReaction1);
	
	etPowerState					:= AXM_ET_PowerState.PowerOff;
	xCMDPowerOn						:= FALSE;

(*** save axis pos in case of restore position ***)
ELSIF iq_stAxisModuleItf.stHome.i_xEnableInitAbsReadPos AND
	iq_stAxisModuleItf.stHome.i_etMode <> PDL_ET_HomeMode.RestorePosFromAxisencoder AND
	iq_stAxisModuleItf.stHome.i_etMode <> PDL_ET_HomeMode.WriteAxisEncoder AND
	iq_stAxisModuleItf.stMain.q_xHomeOk THEN
	
	IF (iq_stAxisModuleItf.stHome.stSetPos.iq_pstRestorePosRetain <= 0) THEN
		stExceptionModuleReaction3.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction3.udiDiagExt := PDL_ET_DiagExt.PointerRestorePosRetainInvalid;
		stExceptionModuleReaction3.sMsg := 'pointer is zero';
		ReportException(iq_stException := stExceptionModuleReaction3);
		
		etPowerState					:= AXM_ET_PowerState.PowerOff;
		xCMDPowerOn						:= FALSE;
	ELSIF (FC_GetSercosState() = SMI.ET_SercosState.Phase4) THEN 
		PDL_FC_SaveAxisPosition(	i_etPosType				:= PDL_ET_PosType.MechPosition,
									i_ifDrive				:= iq_stAxisModuleItf.stMain.i_ifDrive,
									iq_stRestorePosition	:= iq_stAxisModuleItf.stHome.stSetPos.iq_pstRestorePosRetain^,
									q_etDiag				=> etDiagBuffer,
									q_etDiagExt				=> etDiagExtBufferPDL,
									q_sMsg					=> sDiagMsgBuffer);
		IF (etDiagBuffer <> GD.ET_Diag.Ok) THEN
			stExceptionUnexpected.udiDiagExt := AXM_ET_DiagExt.UnexpectedFeedback;
			stExceptionUnexpected.sMsg := SE_CTBX.FC_MultiConcat(	i_sString1 := 'FC_SaveAxisPosition ',
																i_sString2 := PDL_FC_EtDiagExtToString(i_etDiagExt := etDiagExtBufferPDL),
																i_sString3 := ' ',
																i_sString4 := sDiagMsgBuffer);
			ReportException(iq_stException := stExceptionUnexpected);
		END_IF
	END_IF
END_IF
