__METADATA__
{
  "v3Meta": {
    "objectGuid": "305eb0f1-303e-44e0-9dc2-610d9cef9a6a",
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
METHOD ReportException
VAR_IN_OUT
	iq_stException	: TPL.ST_Exception;
END_VAR
VAR CONSTANT
	c_diMaxReaction	: DINT := 4;
END_VAR
__IMPLEMENTATION__
IF (fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.CriticalException) AND (iq_stException.etDiag = GD.ET_Diag.UnexpectedProgramBehavior) THEN
	IF NOT TPL.FC_CheckExceptionIsInList( iq_stException := iq_stException, iq_stExceptionList := THIS^.iq_stExceptionList) THEN
		fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.CriticalException,
									i_etDiag		:= GD.ET_Diag.Ok,
									i_udiDiagExt	:= AXM_ET_DiagExt.Ok,
									i_sMessage		:= Standard.CONCAT(Standard.CONCAT(Standard.CONCAT(Standard.CONCAT(Standard.CONCAT(Standard.CONCAT('Exception ET_Diag: ',GD.FC_EtDiagToString(i_etDiag := iq_stException.etDiag)),' ET_DiagExt: '),AXM_FC_EtDiagExtToString(i_etDiagExt := iq_stException.udiDiagExt)),' sMsg: '),iq_stException.sMsg),TPL.FC_GetStandardReactionName(iq_stReaction := iq_stException.stReaction)),
									q_etDiag		:= ,
									q_etDiagExt		:= );
	END_IF
ELSIF (fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.Exception) THEN
	IF NOT TPL.FC_CheckExceptionIsInList( iq_stException := iq_stException, iq_stExceptionList := THIS^.iq_stExceptionList) THEN
		fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.Exception,
									i_etDiag		:= GD.ET_Diag.Ok,
									i_udiDiagExt	:= AXM_ET_DiagExt.Ok,
									i_sMessage		:= Standard.CONCAT(Standard.CONCAT(Standard.CONCAT(Standard.CONCAT(Standard.CONCAT(Standard.CONCAT('Exception ET_Diag: ',GD.FC_EtDiagToString(i_etDiag := iq_stException.etDiag)),' ET_DiagExt: '),AXM_FC_EtDiagExtToString(i_etDiagExt := iq_stException.udiDiagExt)),' sMsg: '),iq_stException.sMsg),TPL.FC_GetStandardReactionName(iq_stReaction := iq_stException.stReaction)),
									q_etDiag		:= ,
									q_etDiagExt		:= );
	END_IF
END_IF

iq_stException.sDiagExt := AXM_FC_EtDiagExtToString(i_etDiagExt := iq_stException.udiDiagExt);
TPL.FC_SetException(	i_xExceptionActive	:= TRUE,
						iq_stException		:= iq_stException,
						iq_stExceptionList	:= iq_stExceptionList,
						iq_stLogDataList	:= iq_stLogDataList,
						q_etDiag 			=> etDiagBuffer,
						q_etDiagExt 		=> etDiagExtBufferTPL,
						q_sMsg 				=> sDiagMsgBuffer);
IF (etDiagBuffer <> GD.ET_Diag.Ok) THEN
	(* if exception could not be reported, show exception on outputs *)
	xNotAbleToSetException := TRUE;
	iq_stStandardModuleItf.q_etDiag := iq_stException.etDiag;
	iq_stStandardModuleItf.q_udiDiagExt := iq_stException.udiDiagExt;
	iq_stStandardModuleItf.q_sDiagExt := iq_stException.sDiagExt;
	iq_stStandardModuleItf.q_sMsg := iq_stException.sMsg;
END_IF

iq_stStandardModuleItf.q_xException := TRUE;

stLocalReaction.axReaction[TPL.ET_Reaction.MainsContactorOff] := stLocalReaction.axReaction[TPL.ET_Reaction.MainsContactorOff] OR iq_stException.stReaction.axReaction[iq_stStandardModuleItf.iq_stExt.udiReactionOffset + TPL.ET_Reaction.MainsContactorOff];
stLocalReaction.axReaction[TPL.ET_Reaction.AsyncStop] := stLocalReaction.axReaction[TPL.ET_Reaction.AsyncStop] OR iq_stException.stReaction.axReaction[iq_stStandardModuleItf.iq_stExt.udiReactionOffset + TPL.ET_Reaction.AsyncStop];
stLocalReaction.axReaction[TPL.ET_Reaction.SyncStopEH] := stLocalReaction.axReaction[TPL.ET_Reaction.SyncStopEH] OR iq_stException.stReaction.axReaction[iq_stStandardModuleItf.iq_stExt.udiReactionOffset + TPL.ET_Reaction.SyncStopEH];
stLocalReaction.axReaction[TPL.ET_Reaction.SyncStopEL] := stLocalReaction.axReaction[TPL.ET_Reaction.SyncStopEL] OR iq_stException.stReaction.axReaction[iq_stStandardModuleItf.iq_stExt.udiReactionOffset + TPL.ET_Reaction.SyncStopEL];
(* special handling for StopEndOfCycle. Wait till reaction feedback from machine. User can transform this reaction and make own reaction.
stLocalReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle] := stLocalReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle] OR iq_stException.stReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle];
*)


stModuleReaction.axReaction[TPL.ET_Reaction.MainsContactorOff] := stModuleReaction.axReaction[TPL.ET_Reaction.MainsContactorOff] OR iq_stException.stReaction.axReaction[iq_stStandardModuleItf.iq_stExt.udiReactionOffset + TPL.ET_Reaction.MainsContactorOff];
stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop] := stModuleReaction.axReaction[TPL.ET_Reaction.AsyncStop] OR iq_stException.stReaction.axReaction[iq_stStandardModuleItf.iq_stExt.udiReactionOffset + TPL.ET_Reaction.AsyncStop];
stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH] := stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEH]OR iq_stException.stReaction.axReaction[iq_stStandardModuleItf.iq_stExt.udiReactionOffset + TPL.ET_Reaction.SyncStopEH];
stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL] := stModuleReaction.axReaction[TPL.ET_Reaction.SyncStopEL] OR iq_stException.stReaction.axReaction[iq_stStandardModuleItf.iq_stExt.udiReactionOffset + TPL.ET_Reaction.SyncStopEL];
(* special handling for StopEndOfCycle. Wait till reaction feedback from machine. User can transform this reaction and make own reaction.
stModuleReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle] := stModuleReaction.axReaction[TPL.ET_Reaction.StopEndOfCycle] OR iq_stException.stReaction.axReaction[iq_stStandardModuleItf.iq_stExt.udiReactionOffset + TPL.ET_Reaction.StopEndOfCycle];
*)
