__METADATA__
{
  "v3Meta": {
    "objectGuid": "f6964eea-fafb-472c-bef0-ba7e78a09260",
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
{attribute 'conditionalshow_all_locals'}
METHOD INTERNAL DiagTestHoming
VAR_IN_OUT
	iq_etDiag		: GD.ET_Diag;
	iq_etDiagExt	: PDL_ET_DiagExt;
	iq_sMsg			: STRING[80];
END_VAR
__IMPLEMENTATION__
IF (iq_etDiag <> GD.ET_Diag.Ok) THEN
	CASE iq_etDiagExt OF
	PDL_ET_DiagExt.AbsEncOffsetRange:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.AbsEncOffsetRange;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);

	PDL_ET_DiagExt.AccRange:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.AccRange;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);

	PDL_ET_DiagExt.CheckSumInvalid:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.CheckSumInvalid;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);				

	PDL_ET_DiagExt.DataNVRamInvalid:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.DataNVRamInvalid;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
		
	PDL_ET_DiagExt.DecRange:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.DecRange;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
		
	PDL_ET_DiagExt.DriveEncoderInvalid:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.DriveConditionInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.DriveEncoderInvalid;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
				
	PDL_ET_DiagExt.LencInvalid:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.LencInvalid;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
						
	PDL_ET_DiagExt.DriveIsMoving:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.DriveConditionInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.DriveIsMoving;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
								
	PDL_ET_DiagExt.DriveNotDisabled:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.DriveConditionInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.DriveNotDisabled;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
										
	PDL_ET_DiagExt.DriveNotReady:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.DriveConditionInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.DriveNotReady;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
												
	PDL_ET_DiagExt.HwLimitNegReached:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.LimitReached;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.HwLimitNegReached;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
														
	PDL_ET_DiagExt.HwLimitPosReached:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.LimitReached;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.HwLimitPosReached;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
																
	PDL_ET_DiagExt.JerkRange:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.JerkRange;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
																		
	PDL_ET_DiagExt.LowVelRange:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.LowVelRange;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
																				
	PDL_ET_DiagExt.MaxTorqueNotFound:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.HomingFailed;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.MaxTorqueNotFound;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
																						
	PDL_ET_DiagExt.MaxTorqueRange:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.MaxTorqueRange;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
		
	PDL_ET_DiagExt.MaxForceNotFound:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.HomingFailed;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.MaxForceNotFound;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
																						
	PDL_ET_DiagExt.MaxForceRange:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.MaxForceRange;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);			
																								
	PDL_ET_DiagExt.MaxTravelRange:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.MaxTravelRange;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
																										
	PDL_ET_DiagExt.NoAccessToEEPROM:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.DriveConditionInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.NoAccessToEEPROM;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
																												
	PDL_ET_DiagExt.PointerRestorePosRetainInvalid:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.PointerRestorePosRetainInvalid;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
																														
	PDL_ET_DiagExt.ProgrammingInProgress:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.DriveConditionInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.ProgrammingInProgress;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
																																
	PDL_ET_DiagExt.ProgrammingInvalidEEPROM:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.DriveConditionInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.ProgrammingInvalidEEPROM;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
																																		
	PDL_ET_DiagExt.RestoreInterrupted:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.DriveConditionInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.RestoreInterrupted;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
																																				
	PDL_ET_DiagExt.SensorNotFound:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.HomingFailed;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.SensorNotFound;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
																																								
	PDL_ET_DiagExt.SercosNotInPhaseFour:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.SercosConditionInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.SercosNotInPhaseFour;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
																																										
	PDL_ET_DiagExt.TouchProbeInvalid:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.TouchProbeInvalid;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
																																												
	PDL_ET_DiagExt.TouchProbeNotActive:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.TouchProbeNotActive;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
																																														
	PDL_ET_DiagExt.TouchProbeNotFound:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.HomingFailed;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.TouchProbeNotFound;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
																																																
	PDL_ET_DiagExt.TouchProbeVirtual:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.TouchProbeVirtual;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
																																																		
	PDL_ET_DiagExt.UserPeriodRange:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.UserPeriodRange;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
																																																				
	PDL_ET_DiagExt.VelRange:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.VelRange;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
																																																						
	PDL_ET_DiagExt.UnknownMode:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.UnknownMode;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	
			
	PDL_ET_DiagExt.HwLimitNegStillActive:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.ExecutionAborted;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.HwLimitNegStillActive;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);	

	PDL_ET_DiagExt.HwLimitPosStillActive:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.ExecutionAborted;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.HwLimitPosStillActive;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);			

	PDL_ET_DiagExt.ReducedVelocityLImit:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.LimitReached;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.ReducedVelocityLImit;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);

	PDL_ET_DiagExt.ReducedVelocityRange:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.ReducedVelocityRange;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);

	PDL_ET_DiagExt.ReducedVelocityFactorRange:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.InputParameterInvalid;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.ReducedVelocityFactorRange;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);
		
	PDL_ET_DiagExt.OutOfRestoreWindow:
		stExceptionModuleReaction2.etDiag := GD.ET_Diag.LimitReached;
		stExceptionModuleReaction2.udiDiagExt := AXM_ET_DiagExt.OutOfRestoreWindow;
		stExceptionModuleReaction2.sMsg := iq_sMsg;
		ReportException(iq_stException := stExceptionModuleReaction2);
		
	ELSE
		stExceptionUnexpected.udiDiagExt := AXM_ET_DiagExt.UnexpectedFeedback;
		stExceptionUnexpected.sMsg := SE_CTBX.FC_MultiConcat(	i_sString1 := 'FB_Home ',
															i_sString2 := PDL_FC_EtDiagExtToString(i_etDiagExt := iq_etDiagExt),
															i_sString3 := ' ',
															i_sString4 := iq_sMsg);
		ReportException(iq_stException := stExceptionUnexpected);
	END_CASE
END_IF
