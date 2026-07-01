__METADATA__
{
  "v3Meta": {
    "objectGuid": "43be7aca-1913-4760-a537-5d46d25a716a",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
THIS^.fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
									i_etDiag		:= q_etDiag,
									i_udiDiagExt	:= q_etDiagExt,
									i_sMessage		:= Standard.CONCAT('WarmStart with mode ', INT_TO_STRING(i_etWSMode)) );

(*--------------------------------------------------------------------------------------------------------------------------------------------*)
//set active cam -> camIn is started with this cam
IF   i_etWSMode >= PDL_ET_MultiCamWsMode.NewCamMoveAlwaysNoPositionCheck
  OR stInSyncMultiCamData.diNumberOfCamPoints < 1  
THEN 	
	(* Load new Cam *)
	IF NOT CheckCamData() THEN
		RETURN;
	END_IF
	stActiveMultiCamData 	:= iq_stMultiCamData;
ELSE
	stActiveMultiCamData 	:= stInSyncMultiCamData;	
END_IF

SetActualCamData();

(*--------------------------------------------------------------------------------------------------------------------------------------------*)
//check master position and get rated slave position on cam (lrYStart)
//-> used for all ws positioning cmds
IF    NOT (i_etWSMode = PDL_ET_MultiCamWsMode.NewCamSetMasterPositionToRelatedSlavePosition ) 
  AND NOT (i_etWSMode = PDL_ET_MultiCamWsMode.StoredCamSetMasterPositionToRelatedSlavePosition ) 
THEN
	xSuccess :=  GetCamPositionOfSlave( i_xCheckModulo 		:= NOT iq_stExt.xNoModuloMasterAtStart ,
										q_lrSlavePosition 	=> lrYStart ); 
	IF NOT xSuccess THEN
		RETURN;
	END_IF
END_IF


(*--------------------------------------------------------------------------------------------------------------------------------------------*)
CASE i_etWSMode OF
	
(*********************************************************************************************************************)
	PDL_ET_MultiCamWsMode.StoredCamMoveAlwaysNoPositionCheck, 
	PDL_ET_MultiCamWsMode.NewCamMoveAlwaysNoPositionCheck:	
		
		//set q_xInWSWindow
		SetInWsWindow( i_xCheckModulo := NOT iq_stExt.xNoModuloSlaveAtStart );
		
		etDirection		:= PLCO.MC_Direction.ShortestWay;
		etState 		:= ET_MulticamState.ws_waitForWsStart;
		
		// Shortest way
		IF    NOT iq_stExt.xNoModuloSlaveAtStart 
		  AND NOT xSlaveIsModulo
		THEN
			IF lrYPeriode > 0 THEN
				IF lrYStart > q_lrPositionY THEN
					IF lrYStart - q_lrPositionY > lrYPeriode / 2.0 THEN
						xSuccess :=  SetPosition(	i_ifAxis		:= i_ifDrive, 
													i_lrPosition	:= lrYPeriode, 
													i_xRelative		:= TRUE
													);
						q_lrPositionY := q_lrPositionY + lrYPeriode;
					END_IF
				ELSE
					IF q_lrPositionY - lrYStart > lrYPeriode / 2.0 THEN
						xSuccess :=  SetPosition(	i_ifAxis		:= i_ifDrive, 
													i_lrPosition	:= -lrYPeriode, 
													i_xRelative		:= TRUE
													);
						q_lrPositionY := q_lrPositionY - lrYPeriode;
					END_IF
				END_IF
			ELSIF lrYPeriode < 0 THEN
				IF lrYStart < q_lrPositionY THEN
					IF q_lrPositionY - lrYStart > -lrYPeriode/2.0 THEN
						xSuccess :=  SetPosition(	i_ifAxis		:= i_ifDrive, 
													i_lrPosition	:= lrYPeriode, 
													i_xRelative		:= TRUE
													);
						q_lrPositionY := q_lrPositionY + lrYPeriode;
					END_IF
				ELSE
					IF lrYStart - q_lrPositionY > -lrYPeriode/2.0 THEN
						xSuccess :=  SetPosition(	i_ifAxis		:= i_ifDrive, 
													i_lrPosition	:= -lrYPeriode, 
													i_xRelative		:= TRUE
													);
						q_lrPositionY := q_lrPositionY - lrYPeriode;
					END_IF
				END_IF
			END_IF
		
			IF NOT xSuccess THEN
				RETURN;
			END_IF
		END_IF

(*********************************************************************************************************************)
	PDL_ET_MultiCamWsMode.StoredCamMoveToCamPositonInWsWindow, 
	PDL_ET_MultiCamWsMode.NewCamMoveToCamPositonInWsWindow:	
	
		etDirection := PLCO.MC_Direction.ShortestWay;
	
		IF    NOT iq_stExt.xNoModuloSlaveAtStart 
		  AND NOT xSlaveIsModulo
		THEN
			
			etState := ET_MulticamState.ws_waitForWsStart; 
			
			IF ABS(lrYStart - q_lrPositionY) <= i_lrWSWindow THEN
				
				q_xInWSWindow	:= TRUE;
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
								i_etDiagExt := PDL_ET_DiagExt.WaitForWsStart,
								i_sMsg		:= Standard.CONCAT('WSMode: ',INT_TO_STRING(i_etWSMode)));
								
				etState := ET_MulticamState.ws_waitForWsStart; 
				
				(* shortest way *)			
				IF lrYPeriode > 0 THEN		
					IF lrYStart > q_lrPositionY THEN
						IF lrYStart - q_lrPositionY > lrYPeriode/2.0 THEN
							xSuccess :=  SetPosition(	i_ifAxis		:= i_ifDrive, 
														i_lrPosition	:= lrYPeriode, 
														i_xRelative		:= TRUE);
							q_lrPositionY := q_lrPositionY + lrYPeriode;
						END_IF
					ELSE
						IF q_lrPositionY - lrYStart > lrYPeriode/2.0 THEN
							xSuccess :=  SetPosition(	i_ifAxis		:= i_ifDrive, 
														i_lrPosition	:= -lrYPeriode, 
														i_xRelative		:= TRUE);
							q_lrPositionY := q_lrPositionY - lrYPeriode;
						END_IF
					END_IF
				ELSIF lrYPeriode < 0 THEN
					IF lrYStart < q_lrPositionY THEN
						IF q_lrPositionY - lrYStart > -lrYPeriode/2.0 THEN
							xSuccess :=  SetPosition(	i_ifAxis		:= i_ifDrive, 
														i_lrPosition	:= lrYPeriode, 
														i_xRelative		:= TRUE);
							q_lrPositionY := q_lrPositionY + lrYPeriode;
						END_IF
					ELSE
						IF lrYStart - q_lrPositionY > -lrYPeriode/2.0 THEN
							xSuccess :=  SetPosition(	i_ifAxis		:= i_ifDrive, 
														i_lrPosition	:= -lrYPeriode, 
														i_xRelative		:= TRUE);
							q_lrPositionY := q_lrPositionY - lrYPeriode;
						END_IF
					END_IF
				END_IF
	
			(* pos. Periode *)
			ELSIF lrYPeriode > 0 AND lrYStart >= q_lrPositionY AND q_lrPositionY + lrYPeriode - lrYStart <= i_lrWSWindow THEN
				q_xInWSWindow	:= TRUE;
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
								i_etDiagExt := PDL_ET_DiagExt.WaitForWsStart,
								i_sMsg		:= Standard.CONCAT('WSMode: ',INT_TO_STRING(i_etWSMode)));
				xSuccess :=  SetPosition(	i_ifAxis		:= i_ifDrive, 
											i_lrPosition	:= lrYPeriode, 
											i_xRelative		:= TRUE);
				q_lrPositionY := q_lrPositionY + lrYPeriode;										
				etState := ET_MulticamState.ws_waitForWsStart;
				
			ELSIF lrYPeriode > 0 AND lrYStart < q_lrPositionY AND lrYStart + lrYPeriode - q_lrPositionY <= i_lrWSWindow THEN
				q_xInWSWindow	:= TRUE;
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
								i_etDiagExt := PDL_ET_DiagExt.WaitForWsStart,
								i_sMsg		:= Standard.CONCAT('WSMode: ',INT_TO_STRING(i_etWSMode)));
				xSuccess :=  SetPosition(	i_ifAxis		:= i_ifDrive, 
											i_lrPosition	:= -lrYPeriode, 
											i_xRelative		:= TRUE);
				q_lrPositionY := q_lrPositionY - lrYPeriode;										
				etState := ET_MulticamState.ws_waitForWsStart;
				
			(* neg. Periode *)
			ELSIF lrYPeriode < 0 AND lrYStart <= q_lrPositionY AND lrYStart - q_lrPositionY - lrYPeriode <= i_lrWSWindow THEN
				q_xInWSWindow	:= TRUE;
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
								i_etDiagExt := PDL_ET_DiagExt.WaitForWsStart,
								i_sMsg		:= Standard.CONCAT('WSMode: ',INT_TO_STRING(i_etWSMode)));
				xSuccess :=  SetPosition(	i_ifAxis		:= i_ifDrive, 
											i_lrPosition	:= lrYPeriode, 
											i_xRelative		:= TRUE);
				q_lrPositionY := q_lrPositionY + lrYPeriode;										
				etState := ET_MulticamState.ws_waitForWsStart;
				
			ELSIF lrYPeriode < 0 AND lrYStart > q_lrPositionY AND q_lrPositionY - lrYPeriode - lrYStart <= i_lrWSWindow THEN
				q_xInWSWindow	:= TRUE;
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
								i_etDiagExt := PDL_ET_DiagExt.WaitForWsStart,
								i_sMsg		:= Standard.CONCAT('WSMode: ',INT_TO_STRING(i_etWSMode)));
				xSuccess :=  SetPosition(	i_ifAxis		:= i_ifDrive, 
											i_lrPosition	:= -lrYPeriode, 
											i_xRelative		:= TRUE);
				q_lrPositionY := q_lrPositionY - lrYPeriode;										
				etState := ET_MulticamState.ws_waitForWsStart;

			ELSE
				q_xInWSWindow	:= FALSE;
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.WarmStartConditionInvalid, 
								i_etDiagExt := PDL_ET_DiagExt.DrivePositionOutOfWsWindow,
								i_sMsg		:= sDriveName);

				etState := ET_MulticamState.idle_error;
			END_IF
			
			IF NOT xSuccess THEN
				RETURN;
			END_IF

		(* iq_stExt.xNoModuloSlaveAtStart = TRUE *)
		ELSE 	

			IF ABS(lrYStart - q_lrPositionY) <= i_lrWSWindow THEN
				q_xInWSWindow	:= TRUE;
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
								i_etDiagExt := PDL_ET_DiagExt.WaitForWsStart,
								i_sMsg		:= Standard.CONCAT('WSMode: ',INT_TO_STRING(i_etWSMode)));
				etState := ET_MulticamState.ws_waitForWsStart;
				
			ELSE
				q_xInWSWindow	:= FALSE;
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.WarmStartConditionInvalid, 
								i_etDiagExt := PDL_ET_DiagExt.DrivePositionOutOfWsWindow,
								i_sMsg		:= sDriveName);
				etState := ET_MulticamState.idle_error;
			END_IF
		END_IF
		
(*********************************************************************************************************************)
	PDL_ET_MultiCamWsMode.StoredCamMoveForwardToCamPositon,  //go shortest when in window, else only forward
	PDL_ET_MultiCamWsMode.NewCamMoveForwardToCamPositon:	
	
		//set q_xInWSWindow
		SetInWsWindow( i_xCheckModulo := iq_stExt.xInWindowCheckwithoutLimits );		
		
		//set direction
		IF q_xInWSWindow THEN
			etDirection := PLCO.MC_Direction.ShortestWay;	
		ELSE
			etDirection := PLCO.MC_Direction.PositiveDirection;
		END_IF
		
		
		IF 	  NOT iq_stExt.xNoModuloSlaveAtStart 
		  AND NOT xSlaveIsModulo
		THEN

			IF lrYPeriode > 0 THEN
				IF q_lrPositionY + lrYPeriode <= lrYStart + i_lrWSWINDOW THEN
					xSuccess :=  SetPosition(	i_ifAxis		:= i_ifDrive, 
												i_lrPosition	:= lrYPeriode, 
												i_xRelative		:= TRUE
												);
								
					q_lrPositionY := q_lrPositionY + lrYPeriode;
				ELSIF q_lrPositionY > lrYStart + i_lrWSWindow THEN
					xSuccess :=  SetPosition(	i_ifAxis		:= i_ifDrive, 
												i_lrPosition	:= -lrYPeriode, 
												i_xRelative		:= TRUE
												);
					q_lrPositionY := q_lrPositionY - lrYPeriode;
				END_IF

				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
								i_etDiagExt := PDL_ET_DiagExt.WaitForWsStart,
								i_sMsg		:= '');
				etState := ET_MulticamState.ws_waitForWsStart;
				
			ELSIF lrYPeriode < 0 THEN

				IF q_lrPositionY - lrYPeriode <= lrYStart + i_lrWSWINDOW THEN
					xSuccess :=  SetPosition(	i_ifAxis		:= i_ifDrive, 
												i_lrPosition	:= -lrYPeriode, 
												i_xRelative		:= TRUE
												);
								
					q_lrPositionY := q_lrPositionY - lrYPeriode;
				ELSIF q_lrPositionY > lrYStart + i_lrWSWindow THEN
					xSuccess :=  SetPosition(	i_ifAxis		:= i_ifDrive, 
												i_lrPosition	:= lrYPeriode, 
												i_xRelative		:= TRUE
												);
					q_lrPositionY := q_lrPositionY + lrYPeriode;
				END_IF
	
									
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
								i_etDiagExt := PDL_ET_DiagExt.WaitForWsStart,
								i_sMsg		:= Standard.CONCAT('WSMode: ',INT_TO_STRING(i_etWSMode)));								
				etState := ET_MulticamState.ws_waitForWsStart;
				
			ELSE	(* YPeriode = 0 *)
				IF q_lrPositionY > lrYStart + i_lrWSWindow THEN
					q_xInWSWindow	:= FALSE;
					SetDiagOutput(	i_etDiag	:= GD.ET_Diag.WarmStartConditionInvalid, 
									i_etDiagExt := PDL_ET_DiagExt.DrivePositionOutOfWsWindow,
									i_sMsg		:= sDriveName);
					etState := ET_MulticamState.idle_error;
				ELSE
					SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
									i_etDiagExt := PDL_ET_DiagExt.WaitForWsStart,
									i_sMsg		:= Standard.CONCAT('WSMode: ',INT_TO_STRING(i_etWSMode)));
									
					etState := ET_MulticamState.ws_waitForWsStart;
				END_IF
			END_IF
			
			//error setpoint 
			IF NOT xSuccess THEN
				RETURN;
			END_IF	
			
		ELSE //iq_stExt.xNoModuloSlaveAtStart = TRUE
			
			IF q_lrPositionY > lrYStart + i_lrWSWindow THEN
				q_xInWSWindow	:= FALSE;
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.WarmStartConditionInvalid, 
								i_etDiagExt := PDL_ET_DiagExt.DrivePositionOutOfWsWindow,
								i_sMsg		:= sDriveName);
				etState := ET_MulticamState.idle_error;
			ELSE
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
								i_etDiagExt := PDL_ET_DiagExt.WaitForWsStart,
								i_sMsg		:= Standard.CONCAT('WSMode: ',INT_TO_STRING(i_etWSMode)));
				etState := ET_MulticamState.ws_waitForWsStart;
			END_IF
		END_IF

(*********************************************************************************************************************)
	PDL_ET_MultiCamWsMode.StoredCamMoveBackwardToCamPosition,   //go shortest when in window, else only backward
	PDL_ET_MultiCamWsMode.NewCamMoveBackwardToCamPosition:	
	
		//set q_xInWSWindow
		SetInWsWindow( i_xCheckModulo := iq_stExt.xInWindowCheckwithoutLimits );
		
		//set direction
		IF q_xInWSWindow THEN
			etDirection := PLCO.MC_Direction.ShortestWay;	
		ELSE
			etDirection := PLCO.MC_Direction.NegativeDirection;
		END_IF
		
		
		IF    NOT iq_stExt.xNoModuloSlaveAtStart 
		  AND NOT xSlaveIsModulo
		THEN
			
			IF lrYPeriode > 0 THEN
				IF q_lrPositionY - lrYPeriode > lrYStart - i_lrWSWindow THEN
					xSuccess :=  SetPosition(	i_ifAxis		:= i_ifDrive, 
												i_lrPosition	:= -lrYPeriode, 
												i_xRelative		:= TRUE
												);
									
					q_lrPositionY := q_lrPositionY - lrYPeriode;
				ELSIF q_lrPositionY < lrYStart - i_lrWSWindow THEN
					xSuccess :=  SetPosition(	i_ifAxis		:= i_ifDrive, 
												i_lrPosition	:= lrYPeriode, 
												i_xRelative		:= TRUE
												);
					q_lrPositionY := q_lrPositionY + lrYPeriode;
				END_IF

				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
								i_etDiagExt := PDL_ET_DiagExt.WaitForWsStart,
								i_sMsg		:= Standard.CONCAT('WSMode: ',INT_TO_STRING(i_etWSMode)));								
				etState := ET_MulticamState.ws_waitForWsStart;
				
			ELSIF lrYPeriode < 0 THEN
				
				IF q_lrPositionY + lrYPeriode > lrYStart - i_lrWSWindow THEN
					xSuccess :=  SetPosition(	i_ifAxis		:= i_ifDrive, 
												i_lrPosition	:= lrYPeriode, 
												i_xRelative		:= TRUE
												);
					q_lrPositionY := q_lrPositionY + lrYPeriode;
				ELSIF q_lrPositionY < lrYStart - i_lrWSWindow THEN
					xSuccess :=  SetPosition(	i_ifAxis		:= i_ifDrive, 
												i_lrPosition	:= -lrYPeriode, 
												i_xRelative		:= TRUE
												);
					q_lrPositionY := q_lrPositionY - lrYPeriode;
				END_IF

				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
								i_etDiagExt := PDL_ET_DiagExt.WaitForWsStart,
								i_sMsg		:= Standard.CONCAT('WSMode: ',INT_TO_STRING(i_etWSMode)));								
				etState := ET_MulticamState.ws_waitForWsStart;
				
			ELSE	(* YPeriode = 0 *)
				IF q_lrPositionY < lrYStart - i_lrWSWindow THEN
					q_xReady		:= FALSE;
					q_xInWSWindow	:= FALSE;
					SetDiagOutput(	i_etDiag	:= GD.ET_Diag.WarmStartConditionInvalid, 
									i_etDiagExt := PDL_ET_DiagExt.DrivePositionOutOfWsWindow,
									i_sMsg		:= sDriveName);
					etState := ET_MulticamState.idle_error;
				ELSE
					SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
									i_etDiagExt := PDL_ET_DiagExt.WaitForWsStart,
									i_sMsg		:= Standard.CONCAT('WSMode: ',INT_TO_STRING(i_etWSMode)));
					etState := ET_MulticamState.ws_waitForWsStart;
				END_IF
			END_IF
									
			//error setpoint 
			IF NOT xSuccess THEN
				RETURN;
			END_IF	
			
		ELSE// iq_stExt.xNoModuloSlaveAtStart = TRUE
			IF q_lrPositionY < lrYStart - i_lrWSWindow THEN
				q_xReady		:= FALSE;
				q_xInWSWindow	:= FALSE;
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.WarmStartConditionInvalid, 
								i_etDiagExt := PDL_ET_DiagExt.DrivePositionOutOfWsWindow,
								i_sMsg		:= sDriveName);
				etState := ET_MulticamState.idle_error;
			ELSE
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
								i_etDiagExt := PDL_ET_DiagExt.WaitForWsStart,
								i_sMsg		:= Standard.CONCAT('WSMode: ',INT_TO_STRING(i_etWSMode)));
				etState := ET_MulticamState.ws_waitForWsStart;
			END_IF
		END_IF


(*********************************************************************************************************************)
	PDL_ET_MultiCamWsMode.StoredCamShowCamPosition, 
	PDL_ET_MultiCamWsMode.NewCamShowCamPosition:      //show cam position, no movement
	
		q_lrPositionY	:= lrYStart;
		InWindowMode();
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
						i_etDiagExt := PDL_ET_DiagExt.ShowCamPosition,
						i_sMsg		:= Standard.CONCAT('WSMode: ',INT_TO_STRING(i_etWSMode)));
		etState := ET_MulticamState.ws_showCamPosition;
		
(*********************************************************************************************************************)
	PDL_ET_MultiCamWsMode.StoredCamSetMasterPositionToRelatedSlavePosition, 
	PDL_ET_MultiCamWsMode.NewCamSetMasterPositionToRelatedSlavePosition:      //Set Master to refering to the actual Slave psoition
	
		//get master position on cam
		xSuccess := GetCamPositionOfMaster();
	
		IF NOT xSuccess THEN
			RETURN;
		ELSE
			//set master pos
			xSuccess :=  SetPosition(	i_ifAxis		:= iq_lencMaster, 
										i_lrPosition	:= q_lrPositionX, 
										i_xRelative		:= FALSE
										);
			IF NOT xSuccess THEN
				RETURN;
			END_IF		
	
			//start cam
			StartCam( 	i_etBufferMode 		 	:= PLCO.MC_Buffer_Mode.Aborting,
						i_stMultiCamData		:= stActiveMultiCamData,
						i_etMasterStartMode		:= PLCO.MC_Master_Start_Mode.KeepEncoderPosition  
				   		);
		
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok, 
							i_etDiagExt := PDL_ET_DiagExt.WaitUntilCamStarted,
							i_sMsg		:= Standard.CONCAT('WSMode: ',INT_TO_STRING(i_etWSMode)));
							
			q_xInWSWindow := TRUE;		
					
			etState := ET_MulticamState.start_waitForCamStarted;
		END_IF

(*********************************************************************************************************************)
ELSE
	q_xReady := FALSE;
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.UnknownWsMode,
					i_sMsg		:= '');
	etState := ET_MulticamState.idle_error;
END_CASE

lrYPeriode :=  stActiveMultiCamData.astCamPoint[stActiveMultiCamData.diNumberOfCamPoints-1].lrY (*YEnd*)
			 - stActiveMultiCamData.astCamPoint[0].lrY; (*YStart*)
			 
