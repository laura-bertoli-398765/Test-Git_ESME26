__METADATA__
{
  "v3Meta": {
    "objectGuid": "81e67ae0-20fe-4673-96d8-0d09adc7bd1d",
    "objectTypeGuid": "6f9dac99-8de1-4efc-8465-68ac443b7d08",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__DECLARATION__
FUNCTION_BLOCK PDL_FB_MultiCam
VAR_INPUT
	i_xEnable			: BOOL;
	i_ifDrive			: MOIN.IF_Axis;
	i_xStart			: BOOL;
	i_xWsSelect			: BOOL;
	i_etCsModeSlave		: PDL_ET_MultiCamCsModeSlave;
	i_etCsModeMaster	: PDL_ET_MultiCamCsModeMaster;
	i_etWsMode			: PDL_ET_MultiCamWsMode;
	i_lrWsWindow		: LREAL; //	WarmStartWindow in [Unit]
	i_lrWsVel			: LREAL; // Velocity for WarmStart and CSModeAxis = 2 [Unit/sec]
	i_lrWsAcc			: LREAL; // Acceleration and deceleration for Warmstart  and CSModeAxis = 2 [Unit/s^2]
	i_lrWsJerk			: LREAL; // Jerk for warmstart
	i_xWsStart			: BOOL;
	i_diTXEnd			: DINT; // Time of XLowEnd and XHighEnd before Xend or Xstart in [ms]
	i_lrInstantXLimMax	: LREAL;
	iq_lencMaster		: MOIN.IF_LogicalEncoder;
END_VAR
VAR_IN_OUT
	iq_stExt			: PDL_ST_MultiCamExt;
	iq_xNewCam			: BOOL;
	iq_xInstantNewCam	: BOOL;
	iq_stMultiCamData	: PDL_ST_MultiCam;
END_VAR
VAR_OUTPUT
	q_xActive			: BOOL;
	q_xReady			: BOOL;
	q_etDiag			: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt			: PDL_ET_DiagExt := PDL_ET_DiagExt.Disabled;
	q_sMsg				: STRING[80];
	q_xInWsWindow		: BOOL;
	q_xSynActive		: BOOL;
	q_lrPositionX		: LREAL;
	q_lrPositionY		: LREAL;
	q_xXLowEnd			: BOOL;
	q_xXHighEnd			: BOOL;
	q_stActualCamData	: PDL_ST_ActualCamData;
END_VAR

VAR
	xSuccess					: BOOL;
	xInterfacesInitialised		: BOOL;
	xEnableFlag					: BOOL;
	etState						: ET_MulticamState;
	fbLoggerPoint				: APL.FB_LoggerPoint;
	pstTaskInfo					: POINTER TO CmpIecTask.Task_Info2;

	stActiveMultiCamData		: PDL_ST_MultiCam; //set when camin is called
	stInSyncMultiCamData		: PDL_ST_MultiCam; //set when camin is insync
	lrYStart					: LREAL;
	lrYStart2					: LREAL;//for comparing after start
	lrModCount					: LREAL;
	lrVelocityX					: LREAL;
	lrXPeriode					: LREAL;
	lrYPeriode					: LREAL;
	lrTSwitch					: LREAL;
	lrOwnPlcTaskInterval		: LREAL;
	lrMasterMovementInOneCycle 	: LREAL;
	lrPositionY2				: LREAL;

	xHighLimitActive			: BOOL;
	xLowLimitActive				: BOOL;
	lrXHighEndWidth				: LREAL;
	lrXLowEndWidth				: LREAL;
	                    		
	//
	fbStop						: PLCO.MC_Stop;
	xCamIn2Active				: BOOL; //for switching camIn fbs
	etMasterStartMode			: PLCO.MC_Master_Start_Mode;
	etSlaveStartMode			: PLCO.MC_Slave_Start_Mode;
	fbCamIn						: PLCO.MC_CamIn;
	fbCamIn2					: PLCO.MC_CamIn;
	xCamInInSync				: BOOL;
	xCamInEndOfProfile			: BOOL;
	fbMoveAbsolute				: PLCO.MC_MoveAbsolute;
	fbHalt						: PLCO.MC_Halt;
	fbSetPos					: PLCO.MC_SetPosition;
	xSlaveIsModulo				: BOOL;	
	xStartedInWarmstart			: BOOL;
	etDirection					: PLCO.MC_Direction;
	
	ifGetParentDevice   		: DTSI.IF_GetParentDevice;
	ifDeviceAccess      		: DTSI.IF_DeviceAccess;
	ifDriveConfigAccess			: DDI.IF_DriveConfigAccess;
	ifDriveConfig				: DDI.IF_DriveConfig;
	lrLimitMaxAccDec			: LREAL := 3642805; 
	lrLimitMaxVel				: LREAL := 1800000; 	
	
	ifDeviceTreeObjectAccess      : UFMPLCI.IF_DeviceTreeObjectAccess;
	sDriveName                    : STRING(80);
	
END_VAR
VAR CONSTANT
	c_lrZero : LREAL := 0.00001;
END_VAR
__IMPLEMENTATION__
(*--------------------------------------------------------------------------------------------------------------------------------------------*)
//enable
{region "enable"}
IF i_xEnable AND NOT xEnableFlag THEN
	xEnableFlag := TRUE;
	fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
								i_etDiag		:= q_etDiag,
								i_udiDiagExt	:= q_etDiagExt,
								i_sMessage		:= 'enable function block');
										
	q_xActive			:= TRUE;
	q_xReady			:= FALSE;
	q_xSynActive		:= FALSE;
	q_xXLowEnd			:= FALSE;
	q_xXHighEnd			:= FALSE;
	q_xInWSWindow		:= FALSE;
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
					i_etDiagExt := PDL_ET_DiagExt.Initializing,
					i_sMsg		:= '');

	xInterfacesInitialised := Init();
	IF NOT xInterfacesInitialised THEN
		RETURN;
	END_IF
	
	IF NOT InputParameterCheck(i_xCheckWsParam	:= TRUE, i_xCheckStartPosParam	:= TRUE, i_xCheckStopPosParam	:= TRUE) THEN
		etState := ET_MulticamState.idle_error;
		RETURN;
	END_IF

	q_xReady := TRUE;
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
					i_etDiagExt := PDL_ET_DiagExt.WaitForStart,
					i_sMsg		:= '');
	etState := ET_MulticamState.waitForStart;
{endregion}

(*--------------------------------------------------------------------------------------------------------------------------------------------*)
//disable
{region "disable"}	
ELSIF NOT i_xEnable AND xEnableFlag THEN
	fbCamIn.Execute := FALSE;
	fbCamIn2.Execute := FALSE;
	fbHalt.Execute := FALSE;
	fbMoveAbsolute.Execute := FALSE;

	xEnableFlag	:= FALSE;
	fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
								i_etDiag		:= q_etDiag,
								i_udiDiagExt	:= q_etDiagExt,
								i_sMessage		:= 'disable function block');

	IF xInterfacesInitialised THEN 
		fbCamIn.Execute := FALSE;		
		fbCamIn2.Execute := FALSE;		
		fbMoveAbsolute.Execute := FALSE;		
		fbHalt.Execute := FALSE;
							
		q_xReady		:= FALSE;
		q_xSynActive	:= FALSE;
		q_xXLowEnd		:= FALSE;
		q_xXHighEnd		:= FALSE;
		q_xInWSWindow	:= FALSE;
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
						i_etDiagExt := PDL_ET_DiagExt.WaitUntilDisabled,
						i_sMsg		:= '');
		etState := ET_MulticamState.controllerStop;
	ELSE
		q_xActive		:= FALSE;
		q_xReady		:= FALSE;
		q_xSynActive	:= FALSE;
		q_xInWSWindow	:= FALSE;
		q_lrPositionX	:= 0.0;					
		q_lrPositionY	:= 0.0;
		q_xXLowEnd		:= FALSE;
		q_xXHighEnd		:= FALSE;
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
						i_etDiagExt := PDL_ET_DiagExt.Disabled,
						i_sMsg		:= '');	
		etState := ET_MulticamState.idle_error;
	END_IF
END_IF
{endregion}

(*--------------------------------------------------------------------------------------------------------------------------------------------*)
// Cyclic when enabled
{region "cyclic"}
IF xInterfacesInitialised AND q_xActive THEN
	
	//error
	IF  (	i_ifDrive.etAxisState = MOIN.ET_AxisState.ErrorStop
	  	OR  i_ifDrive.etAxisState = MOIN.ET_AxisState.Disabled
		)
		AND etState > 0 
		AND etState < 100 
	THEN
		IF i_ifDrive.etAxisState = MOIN.ET_AxisState.Disabled THEN
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.DriveConditionInvalid, 
							i_etDiagExt := PDL_ET_DiagExt.DriveNotReady,
							i_sMsg		:= STANDARD.CONCAT(sDriveName,' is DISABLED'));
		END_IF		
		IF i_ifDrive.etAxisState = MOIN.ET_AxisState.ErrorStop THEN				
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.DriveConditionInvalid, 
							i_etDiagExt := PDL_ET_DiagExt.DriveNotReady,
							i_sMsg		:= STANDARD.CONCAT(sDriveName,' is ERRORSTOP'));
		END_IF		
		etState := ET_MulticamState.idle_error;
	END_IF


	IF   NOT i_xWSSelect 
	  OR (    i_xWSSelect 
		  AND i_etWSMode <> PDL_ET_MultiCamWsMode.StoredCamShowCamPosition 
		  AND i_etWSMode <> PDL_ET_MultiCamWsMode.NewCamShowCamPosition
		  ) 
	THEN
		q_lrPositionY := i_ifDrive.lrPosition;
	END_IF
	q_lrPositionX	:= iq_lencMaster.lrPosition;
	lrVelocityX		:= iq_lencMaster.lrVelocity;
END_IF
{endregion}

(*--------------------------------------------------------------------------------------------------------------------------------------------*)
//cyclic call of plc open FBs
CallPLCopenFBs();

(*--------------------------------------------------------------------------------------------------------------------------------------------*)
// State machine 
CASE etState OF

	(*********************************************************************************************************************)
	ET_MulticamState.idle_error:	// Error or No Enable Case
		;
		
	(*********************************************************************************************************************)
	ET_MulticamState.waitForStart:
{region "waitForStart"}	
		IF i_xStart THEN
			//--> positioning to startpos with "iq_stExt"
			IF iq_stExt.xStartPositionSelect THEN
				MoveToStartPosition();
				
			ELSE
				//--> Warmstart 
				IF i_xWSSelect THEN	
					xStartedInWarmstart := TRUE;
					SelectWarmstart(); 
					
				//--> ColdStart
				ELSE	
					xStartedInWarmstart := FALSE;	
					SelectColdstart(); 
									
				END_IF	
			END_IF	
		END_IF
{endregion}

(*********************************************************************************************************************)
	ET_MulticamState.ws_showCamPosition: //only in ws  __CamShowCamPosition -> show cam position of slave
{region "showCamPosition"}

		//back to waitForStart
		IF NOT i_xStart THEN
			fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
										i_etDiag		:= q_etDiag,
										i_udiDiagExt	:= q_etDiagExt,
										i_sMessage		:= 'hold function block');
												
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
							i_etDiagExt := PDL_ET_DiagExt.WaitForStart,
							i_sMsg		:= '');
							
			etState := ET_MulticamState.waitForStart;
		
		//show position	
		ELSE
			xSuccess :=  GetCamPositionOfSlave( i_xCheckModulo    := NOT iq_stExt.xNoModuloMasterAtStart,
												q_lrSlavePosition => lrYStart ); 
			IF NOT xSuccess THEN 
				RETURN;
			END_IF
			q_lrPositionY := lrYStart;
			
			InWindowMode();
		END_IF
{endregion}

(*********************************************************************************************************************)
	ET_MulticamState.ws_waitForWsStart:	 // warmstart only: wait for WSStart first 
{region "ws_waitForWsStart"}	
	
		//back to waitForStart
		IF NOT i_xStart THEN
			fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
										i_etDiag		:= q_etDiag,
										i_udiDiagExt	:= q_etDiagExt,
										i_sMessage		:= 'hold function block');
												
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
							i_etDiagExt := PDL_ET_DiagExt.WaitForStart,
							i_sMsg		:= '');
							
			etState := ET_MulticamState.waitForStart;

		//wait for warm start cmd
		ELSIF i_xWSStart  THEN
			fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
										i_etDiag		:= q_etDiag,
										i_udiDiagExt	:= q_etDiagExt,
										i_sMessage		:= 'start warmstart');
			
			//start positioning cmd			
			fbMoveAbsolute.Position			:= lrYStart;
			fbMoveAbsolute.Velocity			:= i_lrWSVel;
			fbMoveAbsolute.Acceleration		:= i_lrWSAcc; 
			fbMoveAbsolute.Deceleration		:= i_lrWSAcc; 
			fbMoveAbsolute.Jerk				:= i_lrWsJerk; 
			fbMoveAbsolute.Direction		:= etDirection; 
			fbMoveAbsolute.BufferMode		:= PLCO.MC_Buffer_Mode.Aborting;
			fbMoveAbsolute( Execute := TRUE );
			
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
							i_etDiagExt := PDL_ET_DiagExt.WaitForWsStart,
							i_sMsg		:= Standard.CONCAT('WSMode: ',INT_TO_STRING(i_etWSMode)));
	
			etState := ET_MulticamState.start_positioning;
		END_IF
{endregion}

(*********************************************************************************************************************)
	ET_MulticamState.start_positioning: // wait unitl positioning is finished at start -> then start cam
{region "start_positioning"}

			//wait until positioning finished 
			IF fbMoveAbsolute.Done
			THEN	
				fbMoveAbsolute.Execute := FALSE;
				
				//--> warmstart
				IF xStartedInWarmstart THEN
					
					IF MasterMovedCheck() THEN//check that master has not moved
						
						StartCam( 	i_etBufferMode 		 	:= PLCO.MC_Buffer_Mode.Aborting,
									i_stMultiCamData		:= stActiveMultiCamData
									);
						
						SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok, 
										i_etDiagExt := PDL_ET_DiagExt.WaitUntilCamStarted,
										i_sMsg		:= Standard.CONCAT('UserTableId: ', DINT_TO_STRING(stActiveMultiCamData.diUserTableId)));		
										
						etState := ET_MulticamState.start_waitForCamStarted;
					END_IF
	
				//--> coldstart 				
				ELSE
					StartCam( 	i_etBufferMode 		 	:= PLCO.MC_Buffer_Mode.Aborting,
								i_stMultiCamData		:= stActiveMultiCamData,
								i_etMasterStartMode		:= etMasterStartMode,
								i_etSlaveStartMode		:= etSlaveStartMode	
								);
					
					SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok,
									i_etDiagExt	:= PDL_ET_DiagExt.WaitUntilFirstCamStarted,
									i_sMsg		:= '');
									
					IF  i_etCsModeMaster = PDL_ET_MultiCamCsModeMaster.SetMasterPositionToMinusInfinite (*2*) 
 				     OR iq_stExt.xFirstCamNoXLimMin 	
					THEN
						etState := ET_MulticamState.start_waitForCamStarted_minusInfinite;	
					ELSE
						etState := ET_MulticamState.start_waitForCamStarted;
					END_IF 
				END_IF

			END_IF
{endregion}

(*********************************************************************************************************************)
	ET_MulticamState.start_waitForCamStarted_minusInfinite:  //only in cs SetMasterPositionToMinusInfinite
{region "start_waitForCamStarted_minusInfinite"}
			//if first Cam started 
			IF  q_lrPositionX >= stActiveMultiCamData.astCamPoint[0].lrX THEN 	
				q_xSynActive := TRUE;
				xHighLimitActive	:= FALSE;
				xLowLimitActive		:= FALSE;

				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok,
								i_etDiagExt	:= PDL_ET_DiagExt.WaitForNewCam,
								i_sMsg		:= '');
				etState := ET_MulticamState.camRunning;
			END_IF
{endregion}

(*********************************************************************************************************************)
	ET_MulticamState.start_waitForCamStarted: //wait until first cam at start is inSync
{region "start_waitForCamStarted"}
			IF xStartedInWarmstart THEN	
				SetXHighEnd_XLowEnd();
			END_IF

	
			IF xCamInInSync 
			THEN 				
				stInSyncMultiCamData := stActiveMultiCamData;
			
				//set periodic to false
				IF iq_stExt.xNoCyclicCams THEN
					StartCam( 	i_etBufferMode 		 	:= PLCO.MC_Buffer_Mode.Aborting,
								i_xPeriodic				:= FALSE,
								i_stMultiCamData		:= stActiveMultiCamData,
								i_etMasterStartMode		:= PLCO.MC_Master_Start_Mode.KeepEncoderPosition,
								i_etSlaveStartMode		:= PLCO.MC_Slave_Start_Mode.RampIn
								);
				END_IF
			
				IF xStartedInWarmstart THEN
					q_xInWSWindow		:= FALSE;
					q_xXHighEnd			:= FALSE;
					q_xXLowEnd			:= FALSE;
				END_IF	
			
				q_xSynActive		:= TRUE;
				xHighLimitActive	:= FALSE;
				xLowLimitActive		:= FALSE;
				
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok,
								i_etDiagExt	:= PDL_ET_DiagExt.WaitForNewCam,
								i_sMsg		:= '');
				etState := ET_MulticamState.camRunning;
			END_IF
{endregion}

(*********************************************************************************************************************)
	ET_MulticamState.camRunning:	//cam running: wait for new cam or Stop
{region "camRunning"}
		SetXHighEnd_XLowEnd();
		
		//stop
		IF NOT i_xStart THEN	
			StopCam();
		
		//instant new cam	
		ELSIF iq_xInstantNewCam THEN 
			IF NOT CheckCamData() THEN
				RETURN;
			END_IF			
			StartInstantNewCam(); //-->ET_MulticamState.waitForNewCamStarted
	
		//new cam
		ELSIF iq_xNewCam THEN
			IF NOT CheckCamData() THEN
				RETURN;
			END_IF			
			StartNewCam(); //-->ET_MulticamState.waitForNewCamStarted 
		
		END_IF	
{endregion}

(*********************************************************************************************************************)
	ET_MulticamState.waitForNewCamStarted: //new cam or instant new cam
{region "waitForNewCamStarted"}
		
		SetXHighEnd_XLowEnd();
		
		//cam started
		IF xCamInInSync  THEN 
			stInSyncMultiCamData := stActiveMultiCamData;
		
			IF iq_stExt.xNoCyclicCams THEN
				StartCam( 	i_etBufferMode 		 	:= PLCO.MC_Buffer_Mode.Aborting,
							i_xPeriodic				:= FALSE,
							i_stMultiCamData		:= stActiveMultiCamData,
							i_etMasterStartMode		:= PLCO.MC_Master_Start_Mode.KeepEncoderPosition,
							i_etSlaveStartMode		:= PLCO.MC_Slave_Start_Mode.RampIn
							);
			END_IF
 			q_xSynActive		:= TRUE;
 			q_xXHighEnd			:= FALSE;
 			q_xXLowEnd			:= FALSE;
 			iq_xNewCam			:= FALSE;
 			iq_xInstantNewCam	:= FALSE;
 			xHighLimitActive	:= FALSE;
 			xLowLimitActive		:= FALSE;
			
			SetActualCamData();
			
 			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok,
 							i_etDiagExt	:= PDL_ET_DiagExt.WaitForNewCam,
 							i_sMsg		:= '');

 			etState			:= ET_MulticamState.camRunning;
			
		//direction changed
		ELSIF   ( xHighLimitActive AND NOT (q_xXHighEnd OR iq_stExt.xNewCamDirectAccept) )
			OR  ( xLowLimitActive  AND NOT (q_xXLowEnd  OR iq_stExt.xNewCamDirectAccept) )
		THEN
			iq_stExt.xDirectionChanged := TRUE;
			
			//recall camIn with active cam to delete buffered cam			
			StartCam( 	i_etBufferMode 		 	:= PLCO.MC_Buffer_Mode.Aborting,
						i_xPeriodic				:= FALSE,
						i_stMultiCamData		:= stInSyncMultiCamData,
						i_etMasterStartMode		:= PLCO.MC_Master_Start_Mode.KeepEncoderPosition,
						i_etSlaveStartMode		:= PLCO.MC_Slave_Start_Mode.RampIn
						);
			
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok,
							i_etDiagExt	:= PDL_ET_DiagExt.WaitForNewCam,
							i_sMsg		:= '');
			etState			:= ET_MulticamState.camRunning;
		
		//stop
		ELSIF NOT i_xStart THEN		
			fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.UserAction,
										i_etDiag		:= q_etDiag,
										i_udiDiagExt	:= q_etDiagExt,
										i_sMessage		:= 'hold function block');
												
			IF iq_stExt.xStopPositionSelect THEN
				MoveToStopPosition();
				
			ELSE				
				StopCam(); //--> ET_MulticamState.waitForCamFinished
				
			END_IF
		END_IF
		

{endregion}

(*********************************************************************************************************************)
	ET_MulticamState.waitForCamFinished: // Wait until Cam finished (when i_xStart = FALSE)
{region "waitForCamFinished"}	
		SetXHighEnd_XLowEnd();
		lrMasterMovementInOneCycle := lrOwnPlcTaskInterval * lrVelocityX; //movement of one plc cycle
		
		IF    (    lrVelocityX >= 0 
			  AND q_lrPositionX > stActiveMultiCamData.astCamPoint[stActiveMultiCamData.diNumberOfCamPoints-1].lrX (*XEnd*) - lrMasterMovementInOneCycle 
			  ) 
		  OR  (    lrVelocityX < 0 
			  AND q_lrPositionX < stActiveMultiCamData.astCamPoint[0].lrX (*XStart*) - lrMasterMovementInOneCycle
			  ) 
		  OR  xCamInEndOfProfile
		THEN
			fbCamIn.Execute := FALSE;
			fbCamIn2.Execute := FALSE;		
		
			q_xSynActive	:= FALSE;
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok, 
							i_etDiagExt := PDL_ET_DiagExt.WaitUntilStopped,
							i_sMsg		:= '');

			fbHalt(	Execute	:= FALSE );
			etState			:= ET_MulticamState.waitUntilStopped;
		END_IF
{endregion}

(*********************************************************************************************************************)
	ET_MulticamState.waitUntilStopped: // Wait until stopped  (when i_xStart = FALSE)
{region "waitUntilStopped"}	
		SetXHighEnd_XLowEnd();

		q_xXHighEnd	:= ( q_xXHighEnd AND (q_lrPositionX < stActiveMultiCamData.astCamPoint[stActiveMultiCamData.diNumberOfCamPoints-1].lrX (*XEnd*) )  );
		q_xXLowEnd	:= ( q_xXLowEnd  AND (q_lrPositionX > stActiveMultiCamData.astCamPoint[0].lrX (*XStart*) ) );
		
		//set axis to standstill when cam is finished
		fbHalt(	Execute			:= TRUE,
				BufferMode		:= PLCO.MC_Buffer_Mode.Buffered,		
				Deceleration	:= i_lrWsAcc, 
				Jerk			:= i_lrWsJerk
				);
	
		IF 	  i_ifDrive.etAxisState = MOIN.ET_AxisState.Standstill
		  OR  fbHalt.Done 
		THEN
			fbHalt( Execute := FALSE );
			
			q_xSynActive		:= FALSE;
			q_xXHighEnd			:= FALSE;
			q_xXLowEnd			:= FALSE;
			iq_xNewCam			:= FALSE;
			iq_xInstantNewCam	:= FALSE;

			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
							i_etDiagExt := PDL_ET_DiagExt.WaitForStart,
							i_sMsg		:= '');
							
			etState := ET_MulticamState.waitForStart;
		END_IF
	
		//error
		IF fbHalt.Error THEN
			
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
							i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
							i_sMsg		:= CONCAT('MC_Halt.ErrorID: ', PLCO.FC_EtResultToString(fbHalt.ErrorID) ));
			fbHalt( Execute  := FALSE);
			
			q_xSynActive	:= FALSE;
			q_xXLowEnd		:= FALSE;
			q_xXHighEnd		:= FALSE;
			q_xInWSWindow	:= FALSE;				
			etState := ET_MulticamState.controllerStop;
		END_IF
		
{endregion}

(*********************************************************************************************************************)
	ET_MulticamState.ext_moveToStopPos: //positioning with extended structure iq_stExt
{region "ext_moveToStopPos"}	
		IF  fbMoveAbsolute.Done THEN
			fbMoveAbsolute.Execute := FALSE;
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
							i_etDiagExt := PDL_ET_DiagExt.WaitForStart,
							i_sMsg		:= '');
			
			etState := ET_MulticamState.waitForStart;
		END_IF
{endregion}

(*********************************************************************************************************************)
	ET_MulticamState.ext_moveToStartpos: //positioning with extended structure iq_stExt
{region "ext_moveToStartpos"}		
		IF    fbMoveAbsolute.Done 
		  AND NOT i_xStart
		THEN
			fbMoveAbsolute.Execute := FALSE;
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
							i_etDiagExt := PDL_ET_DiagExt.WaitForStart,
							i_sMsg		:= '');
			
			etState := ET_MulticamState.waitForStart;
		END_IF
{endregion}

(*********************************************************************************************************************)
	ET_MulticamState.controllerStop: //EStop
{region "controllerStop"}
		fbCamIn.Execute := FALSE;
		fbCamIn2.Execute := FALSE;
		fbMoveAbsolute.Execute := FALSE;
		
		IF 	  i_ifDrive.etAxisState <> MOIN.ET_AxisState.Disabled
		  AND i_ifDrive.etAxisState <> MOIN.ET_AxisState.ErrorStop
		  AND i_ifDrive.etAxisState <> MOIN.ET_AxisState.Standstill
		  AND i_ifDrive.etAxisState <> MOIN.ET_AxisState.Stopping
		THEN
			fbStop.Execute 			:= TRUE; 
			fbStop.Deceleration 	:= i_ifDrive.lrErrorStopDec; 
			fbStop.Jerk 			:= i_ifDrive.lrErrorStopJerk; 
		END_IF
		
		fbStop();

		//stopping done
		IF 	  i_ifDrive.etAxisState = MOIN.ET_AxisState.Disabled
		  OR  i_ifDrive.etAxisState = MOIN.ET_AxisState.ErrorStop
		  OR  i_ifDrive.etAxisState = MOIN.ET_AxisState.Standstill
		  OR  fbStop.Done
		THEN
			IF NOT i_xEnable THEN
				xInterfacesInitialised := FALSE;
			
				q_xActive		:= FALSE;
				q_lrPositionX	:= 0.0;					
				q_lrPositionY	:= 0.0;
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
								i_etDiagExt := PDL_ET_DiagExt.Disabled,
								i_sMsg		:= '');	
			END_IF	
			fbStop( Execute  := FALSE);						
			etState := ET_MulticamState.idle_error;
		END_IF
		
		//error
		IF fbStop.Error AND fbStop.ErrorId <> PLCO.ET_Result.StoppingInterrupted THEN
			
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
							i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
							i_sMsg		:= CONCAT('MC_Stop.ErrorID: ', PLCO.FC_EtResultToString(fbStop.ErrorID) ));
		
			fbStop( Execute  := FALSE);
			q_xReady		:= FALSE;
			q_xSynActive	:= FALSE;
			q_xXLowEnd		:= FALSE;
			q_xXHighEnd		:= FALSE;
			q_xInWSWindow	:= FALSE;				
		END_IF
		
{endregion}


END_CASE

(*--------------------------------------------------------------------------------------------------------------------------------------------*)






