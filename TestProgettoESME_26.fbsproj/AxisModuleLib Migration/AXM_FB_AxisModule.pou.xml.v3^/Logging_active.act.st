__METADATA__
{
  "v3Meta": {
    "objectGuid": "20ce76ab-1f0b-407f-9e41-8519cd1cefc9",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* System generated code, do not change without consulting Schneider Electric - otherwise you risk instability!!!*)

fbLogger(		i_xEnable			:= iq_stStandardModuleItf.i_xLogEnable,
				i_wLogDataFilter	:= iq_stStandardModuleItf.i_wLogDataFilter,
				i_sModuleName		:= iq_stStandardModuleItf.i_sModuleName,
				i_udiModuleId		:= iq_stStandardModuleItf.i_udiModuleId,
				i_diCmd				:= iq_stStandardModuleItf.iq_diCmd,
				i_diStartStep		:= 0,
				i_stReaction		:= iq_stStandardModuleItf.i_stReaction,
				iq_stExceptionList	:= iq_stExceptionList,
				iq_stLogDataList	:= iq_stLogDataList,
				q_xActive			=> xLogger_Active,
				q_xReady			=> ,
				q_etDiag			=> ,
				q_etDiagExt			=> );

IF iq_stAxisModuleItf.stMain.stReducedVelocity.i_xEnableReducedVelocity AND NOT xReducedEnableFlag THEN
	xReducedEnableFlag:=TRUE;
	xOnlyLimitCheckFlag:=NOT iq_stAxisModuleItf.stMain.stReducedVelocity.i_xOnlyLimitCheck;
ELSIF NOT iq_stAxisModuleItf.stMain.stReducedVelocity.i_xEnableReducedVelocity AND  xReducedEnableFlag THEN
	xReducedEnableFlag:=FALSE;
		TPL.FC_GetTimeStamp(	q_etDiag	=> ,
								q_etDiagExt	=> ,
								q_sMsg		=> ,
								q_dateDate	=> dateNow,
								q_todTime	=> todNow);
		TPL.FC_SingleLoggerEntry(		i_etReason		:= TPL.ET_LogDataFilter.User,
										i_dateDate		:= dateNow,
										i_todTime		:= todNow,
										i_udiModuleId	:= iq_stStandardModuleItf.i_udiModuleId,
										i_sModuleName	:= iq_stStandardModuleItf.i_sModuleName,
										i_diCmd			:= 0,
										i_diStartStep	:= 0,
										i_stReaction	:= stEmptyReaction,
										i_etDiag		:= 0,
										i_udiDiagExt	:= 0,
										i_sDiagExt		:= '',
										i_sMsg			:= 'Reduced Velocity Off',
										i_etSource		:= TPL.ET_ExceptionSource.AxisModule,
										i_xAutoQuit		:= FALSE,
										iq_stLogDataList:= iq_stLogDataList,
										q_etDiag		=> ,
										q_etDiagExt		=> );
END_IF

IF xReducedEnableFlag THEN
	IF iq_stAxisModuleItf.stMain.stReducedVelocity.i_xOnlyLimitCheck  AND NOT xOnlyLimitCheckFlag THEN
		xOnlyLimitCheckFlag:=TRUE;
		TPL.FC_GetTimeStamp(	q_etDiag	=> ,
								q_etDiagExt	=> ,
								q_sMsg		=> ,
								q_dateDate	=> dateNow,
								q_todTime	=> todNow);
		TPL.FC_SingleLoggerEntry(		i_etReason		:= TPL.ET_LogDataFilter.User,
										i_dateDate		:= dateNow,
										i_todTime		:= todNow,
										i_udiModuleId	:= iq_stStandardModuleItf.i_udiModuleId,
										i_sModuleName	:= iq_stStandardModuleItf.i_sModuleName,
										i_diCmd			:= 0,
										i_diStartStep	:= 0,
										i_stReaction	:= stEmptyReaction,
										i_etDiag		:= 0,
										i_udiDiagExt	:= 0,
										i_sDiagExt		:= '',
										i_sMsg			:= 'Reduced Velocity On; only Limit check',
										i_etSource		:= TPL.ET_ExceptionSource.AxisModule,
										i_xAutoQuit		:= FALSE,
										iq_stLogDataList:= iq_stLogDataList,
										q_etDiag		=> ,
										q_etDiagExt		=> );
	ELSIF NOT iq_stAxisModuleItf.stMain.stReducedVelocity.i_xOnlyLimitCheck  AND  xOnlyLimitCheckFlag THEN
		xOnlyLimitCheckFlag:=FALSE;
		TPL.FC_GetTimeStamp(	q_etDiag	=> ,
								q_etDiagExt	=> ,
								q_sMsg		=> ,
								q_dateDate	=> dateNow,
								q_todTime	=> todNow);
		TPL.FC_SingleLoggerEntry(		i_etReason		:= TPL.ET_LogDataFilter.User,
										i_dateDate		:= dateNow,
										i_todTime		:= todNow,
										i_udiModuleId	:= iq_stStandardModuleItf.i_udiModuleId,
										i_sModuleName	:= iq_stStandardModuleItf.i_sModuleName,
										i_diCmd			:= 0,
										i_diStartStep	:= 0,
										i_stReaction	:= stEmptyReaction,
										i_etDiag		:= 0,
										i_udiDiagExt	:= 0,
										i_sDiagExt		:= '',
										i_sMsg			:= 'Reduced Velocity On; with limitation',
										i_etSource		:= TPL.ET_ExceptionSource.AxisModule,
										i_xAutoQuit		:= FALSE,
										iq_stLogDataList:= iq_stLogDataList,
										q_etDiag		=> ,
										q_etDiagExt		=> );
	END_IF
END_IF

(* End of system generated code, do not change without consulting Schneider Electric - otherwise you risk instability!!!*)
