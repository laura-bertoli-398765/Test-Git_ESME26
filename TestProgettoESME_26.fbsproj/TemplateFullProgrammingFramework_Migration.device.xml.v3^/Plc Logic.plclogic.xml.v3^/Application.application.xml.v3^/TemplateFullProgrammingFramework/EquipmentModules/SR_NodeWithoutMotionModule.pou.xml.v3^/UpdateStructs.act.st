__METADATA__
{
  "v3Meta": {
    "objectGuid": "5da60626-84e4-425a-b5c8-446c48d0de93",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* System generated code, do not change without consulting 'Schneider Electric Automation GmbH' - otherwise you risk instability!!!*)
fbDetectOnlineChange(	i_xEnable	:= TRUE, 
						i_xDetect	:= TRUE, 
						q_xActive	=> xDetectOnlineChangeActive, 
						q_xReady	=> xDetectOnlineChangeReady, 
						q_etDiag	=> etDetectOnlineChangeDiag, 
						q_etDiagExt	=> etDetectOnlineChangeDiagExt, 
						q_sMsg		=> sDetectOnlineChangeMsg, 
						q_xChange	=> );
						
IF(NOT fbDetectOnlineChange.q_xChange) THEN
	RETURN;
END_IF

iq_stStandardModuleItf.iq_stExt.udiNumberOfSubModules 		:= c_udiNumberOfSubModules;
iq_stStandardModuleItf.iq_stExt.dwSubModulesItf		 		:= ADR(astSubModuleInterface);
iq_stStandardModuleItf.iq_stExt.pdwSubModulesAddItf		 	:= ADR(adwSubModuleAddInterfaces);
iq_stStandardModuleItf.iq_stExt.pstListofCMDTables			:= ADR(astListOfCMDTables);
iq_stStandardModuleItf.iq_stExt.udiNumberOfCmdTables		:= c_udiNumberOfCMDTables;
(* End of system generated code, do not change without consulting 'Schneider Electric Automation GmbH' - otherwise you risk instability!!!*)

(* System generated code, could be modified for your application *)
xUpdateStructsException := FALSE;

(*****************************************************************************************************************************************************)
(* Update CmdTable - Prepare *)

TPL.FC_UpdateCmdTableListElement(	i_pstListofCMDTables	:= ADR(astListofCMDTables),
									i_udiNumberOfCMDTables	:= c_udiNumberOfCMDTables,
									i_diCMD					:= ET_Cmd.Prepare,
									i_pstCMDTable			:= ADR(astPrepareTable),
									q_etDiag				=> etDiag,
									q_etDiagExt				=> etDiagExtTPL);
									
IF etDiag <> GD.ET_Diag.Ok AND NOT xUpdateStructsException THEN
	xUpdateStructsException := TRUE;
	
	stUpdateStructsException.sMsg := SE_CTBX.FC_MultiConcat(i_sString1 := 'Update CmdTable: Prepare - ', 
														i_sString2 := GD.FC_EtDiagToString(i_etDiag := etDiag), 
														i_sString3 := ' - ', 
														i_sString4 := TPL.FC_EtDiagExtToString(i_etDiagExt := etDiagExtTPL));
END_IF										

(*****************************************************************************************************************************************************)
(* Update CmdTable - Auto *)

TPL.FC_UpdateCmdTableListElement(	i_pstListofCMDTables	:= ADR(astListofCMDTables),
									i_udiNumberOfCMDTables	:= c_udiNumberOfCMDTables,
									i_diCMD					:= ET_Cmd.Auto,
									i_pstCMDTable			:= ADR(astAutoTable),
									q_etDiag				=> etDiag,
									q_etDiagExt				=> etDiagExtTPL);
									
IF etDiag <> GD.ET_Diag.Ok AND NOT xUpdateStructsException THEN
	xUpdateStructsException := TRUE;
	
	stUpdateStructsException.sMsg := SE_CTBX.FC_MultiConcat(i_sString1 := 'Update CmdTable: Auto - ', 
														i_sString2 := GD.FC_EtDiagToString(i_etDiag := etDiag), 
														i_sString3 := ' - ', 
														i_sString4 := TPL.FC_EtDiagExtToString(i_etDiagExt := etDiagExtTPL));
END_IF		

(*****************************************************************************************************************************************************)
(* Update CmdTable - Manual *)

TPL.FC_UpdateCmdTableListElement(	i_pstListofCMDTables	:= ADR(astListofCMDTables),
									i_udiNumberOfCMDTables	:= c_udiNumberOfCMDTables,
									i_diCMD					:= ET_Cmd.Manual,
									i_pstCMDTable			:= ADR(astManualTable),
									q_etDiag				=> etDiag,
									q_etDiagExt				=> etDiagExtTPL);
									
IF etDiag <> GD.ET_Diag.Ok AND NOT xUpdateStructsException THEN
	xUpdateStructsException := TRUE;
	
	stUpdateStructsException.sMsg := SE_CTBX.FC_MultiConcat(i_sString1 := 'Update CmdTable: Manual - ', 
														i_sString2 := GD.FC_EtDiagToString(i_etDiag := etDiag), 
														i_sString3 := ' - ', 
														i_sString4 := TPL.FC_EtDiagExtToString(i_etDiagExt := etDiagExtTPL));
END_IF		

(*****************************************************************************************************************************************************)
(* Update CmdTable - Stop *)

TPL.FC_UpdateCmdTableListElement(	i_pstListofCMDTables	:= ADR(astListofCMDTables),
									i_udiNumberOfCMDTables	:= c_udiNumberOfCMDTables,
									i_diCMD					:= ET_Cmd.Stop,
									i_pstCMDTable			:= ADR(astStopTable),
									q_etDiag				=> etDiag,
									q_etDiagExt				=> etDiagExtTPL);
									
IF etDiag <> GD.ET_Diag.Ok AND NOT xUpdateStructsException THEN
	xUpdateStructsException := TRUE;
	
	stUpdateStructsException.sMsg := SE_CTBX.FC_MultiConcat(i_sString1 := 'Update CmdTable: Stop - ', 
														i_sString2 := GD.FC_EtDiagToString(i_etDiag := etDiag), 
														i_sString3 := ' - ', 
														i_sString4 := TPL.FC_EtDiagExtToString(i_etDiagExt := etDiagExtTPL));
END_IF		

(*****************************************************************************************************************************************************)
(* Update CmdTable - Start *)

TPL.FC_UpdateCmdTableListElement(	i_pstListofCMDTables	:= ADR(astListofCMDTables),
									i_udiNumberOfCMDTables	:= c_udiNumberOfCMDTables,
									i_diCMD					:= ET_Cmd.Start,
									i_pstCMDTable			:= ADR(astStartTable),
									q_etDiag				=> etDiag,
									q_etDiagExt				=> etDiagExtTPL);
									
IF etDiag <> GD.ET_Diag.Ok AND NOT xUpdateStructsException THEN
	xUpdateStructsException := TRUE;
	
	stUpdateStructsException.sMsg := SE_CTBX.FC_MultiConcat(i_sString1 := 'Update CmdTable: Start - ', 
														i_sString2 := GD.FC_EtDiagToString(i_etDiag := etDiag), 
														i_sString3 := ' - ', 
														i_sString4 := TPL.FC_EtDiagExtToString(i_etDiagExt := etDiagExtTPL));
END_IF		

(*****************************************************************************************************************************************************)
(* Update CmdTable - Abort *)

TPL.FC_UpdateCmdTableListElement(	i_pstListofCMDTables	:= ADR(astListofCMDTables),
									i_udiNumberOfCMDTables	:= c_udiNumberOfCMDTables,
									i_diCMD					:= ET_Cmd.Abort,
									i_pstCMDTable			:= ADR(astAbortTable),
									q_etDiag				=> etDiag,
									q_etDiagExt				=> etDiagExtTPL);
									
IF etDiag <> GD.ET_Diag.Ok AND NOT xUpdateStructsException THEN
	xUpdateStructsException := TRUE;
	
	stUpdateStructsException.sMsg := SE_CTBX.FC_MultiConcat(i_sString1 := 'Update CmdTable: Abort - ', 
														i_sString2 := GD.FC_EtDiagToString(i_etDiag := etDiag), 
														i_sString3 := ' - ', 
														i_sString4 := TPL.FC_EtDiagExtToString(i_etDiagExt := etDiagExtTPL));
END_IF		

(*****************************************************************************************************************************************************)
(* Update CmdTable - Hold *)

TPL.FC_UpdateCmdTableListElement(	i_pstListofCMDTables	:= ADR(astListofCMDTables),
									i_udiNumberOfCMDTables	:= c_udiNumberOfCMDTables,
									i_diCMD					:= ET_Cmd.Hold,
									i_pstCMDTable			:= ADR(astHoldTable),
									q_etDiag				=> etDiag,
									q_etDiagExt				=> etDiagExtTPL);
									
IF etDiag <> GD.ET_Diag.Ok AND NOT xUpdateStructsException THEN
	xUpdateStructsException := TRUE;
	
	stUpdateStructsException.sMsg := SE_CTBX.FC_MultiConcat(i_sString1 := 'Update CmdTable: Hold - ', 
														i_sString2 := GD.FC_EtDiagToString(i_etDiag := etDiag), 
														i_sString3 := ' - ', 
														i_sString4 := TPL.FC_EtDiagExtToString(i_etDiagExt := etDiagExtTPL));
END_IF		

(*****************************************************************************************************************************************************)
(* Update CmdTable - BrakeRelease *)

TPL.FC_UpdateCmdTableListElement(	i_pstListofCMDTables	:= ADR(astListofCMDTables),
									i_udiNumberOfCMDTables	:= c_udiNumberOfCMDTables,
									i_diCMD					:= ET_Cmd.BrakeRelease,
									i_pstCMDTable			:= ADR(astBrakeReleaseTable),
									q_etDiag				=> etDiag,
									q_etDiagExt				=> etDiagExtTPL);
									
IF etDiag <> GD.ET_Diag.Ok AND NOT xUpdateStructsException THEN
	xUpdateStructsException := TRUE;
	
	stUpdateStructsException.sMsg := SE_CTBX.FC_MultiConcat(i_sString1 := 'Update CmdTable: BrakeRelease - ', 
														i_sString2 := GD.FC_EtDiagToString(i_etDiag := etDiag), 
														i_sString3 := ' - ', 
														i_sString4 := TPL.FC_EtDiagExtToString(i_etDiagExt := etDiagExtTPL));
END_IF		

(*****************************************************************************************************************************************************)
(* Set exception if any exception occurred *)

fbExceptionHandler.SetException(i_xExceptionActive	:= xUpdateStructsException, 
								iq_stException		:= stUpdateStructsException, 
								iq_stExceptionList	:= iq_stExceptionList);
					
xInitSuccessful := xInitSuccessful AND NOT xUpdateStructsException;

etDiag := GD.ET_Diag.Ok;
(* End of system generated code, could be modified for your application *)
