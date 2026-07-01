__METADATA__
{
  "v3Meta": {
    "objectGuid": "57246d94-94e7-4a10-9639-79a0c6f56403",
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
{attribute 'no_assign'}
FUNCTION_BLOCK PDL_FB_YOffsetCorrection

VAR_INPUT
	i_xEnable				: BOOL;								(* Enables the FB *)
	i_ifDrive				: MOIN.IF_Axis;						(* Slave Axis *)
	i_lencMaster			: MOIN.IF_LogicalEncoder;			(* Master *)
	i_xStart				: BOOL;								(* Starts Correction *)
	i_lrCorrection			: LREAL;							(* Value of Correction *)
	i_lrXStartPos			: LREAL;							(* Start position of correction *)
	i_lrXFactor				: LREAL;							(* Distance covered by the master within which the correction is to be executed *)
	i_lrMaxCorrVel			: LREAL;							(* max velocity for correction *)
	i_lrMaxCorrAcc			: LREAL;							(* max acc/dec for correction *)
END_VAR

VAR_OUTPUT
	q_xActive				: BOOL;
	q_xReady				: BOOL;
	q_xCorrectionActive		: BOOL;
	q_etDiag				: GD.ET_Diag := GD.ET_Diag.OK;
	q_etDiagExt				: PDL_ET_DiagExt := PDL_ET_DiagExt.Disabled;
	q_sMsg					: STRING[80];
END_VAR

VAR
	xEnableFlag				: BOOL;
	diState					: DINT;
	xInterfacesInitialised	: BOOL;
		
	lrCorrVel				: LREAL;
	lrCorrAcc				: LREAL;
	lrCorrTime				: LREAL;
	diResult				: DINT;
	
	//superimposed movement
	fbMoveSuperimposed		: PLCO.MC_MoveSuperimposed;
	fbHalt					: PLCO.MC_Halt;
	
	//channels
	fbReadAxisInfo			: PLCO.MC_ReadAxisInfo;
	fbMultiComb				: MLTCMB.FB_MultiCombine<2>;
	fbPowerControlAxis		: PLCO.MC_Power;
	fbPowerOffsetAxis		: PLCO.MC_Power;
	fbSetPos				: PLCO.MC_SetPosition;
	ifControlChannel		: MOIN.IF_Axis;
	ifOffsetChannel			: MOIN.IF_Axis;
END_VAR
__IMPLEMENTATION__
(*--------------------------------------------------------------------------------------------------------------------------------------------*)
//enable
{region "enable"}	
IF i_xEnable AND NOT xEnableFlag THEN
	xEnableFlag := TRUE;
	
	q_xActive			:= TRUE;
	q_xReady			:= FALSE;
	q_xCorrectionActive := FALSE;
	
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.OK, 
					i_etDiagExt := PDL_ET_DiagExt.Initializing,
					i_sMsg		:= '');
					
	xInterfacesInitialised := Init();
	IF NOT xInterfacesInitialised THEN
		RETURN;
	END_IF

	//set control channel to axis pos
	fbSetPos( Execute := FALSE );
	fbSetPos(	Axis		:= fbMultiComb.Channels[0], 
				Execute		:= TRUE, 
				Relative	:= FALSE,
				Position	:= i_ifDrive.lrPosition);
				
	IF fbSetPos.Error THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
						i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
						i_sMsg		:= CONCAT('MC_SetPosition.ErrorId: ', PLCO.FC_EtResultToString(fbSetPos.ErrorId) ) );
		fbSetPos( Execute := FALSE );		
		diState := 0;
		RETURN;					
	END_IF


	//set offset to 0							
	fbSetPos( Execute := FALSE );
	fbSetPos(	Axis		:= fbMultiComb.Channels[1], 
				Execute		:= TRUE, 
				Relative	:= FALSE,
				Position	:= 0);

	IF fbSetPos.Error THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
						i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
						i_sMsg		:= CONCAT('MC_SetPosition.ErrorId: ', PLCO.FC_EtResultToString(fbSetPos.ErrorId) ) );
		fbSetPos( Execute := FALSE );		
		diState := 0;
		RETURN;							
	END_IF

	q_xReady := TRUE;
	
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok, 
					i_etDiagExt := PDL_ET_DiagExt.WaitForStart,
					i_sMsg		:= '');
	diState	:= 10;
{endregion}

(*--------------------------------------------------------------------------------------------------------------------------------------------*)
//disable
{region "disable"}	
ELSIF NOT i_xEnable AND xEnableFlag THEN
	xEnableFlag := FALSE;
	xInterfacesInitialised := FALSE;

	q_xCorrectionActive					:= FALSE;
	q_xActive							:= FALSE;
	q_xReady							:= FALSE;

	//set axis relative							
	fbSetPos( Execute := FALSE );
	fbSetPos(	Axis		:= i_ifDrive, 
				Execute		:= TRUE, 
				Relative	:= TRUE,
				Position	:= -fbMultiComb.Channels[1].lrPosition );
				
	IF fbSetPos.Error THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
						i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
						i_sMsg		:= CONCAT('MC_SetPosition.ErrorId: ', PLCO.FC_EtResultToString(fbSetPos.ErrorId) ) );
		fbSetPos( Execute := FALSE );	
		diState := 0;
		RETURN;							
	END_IF
	
	//set offset to 0							
	fbSetPos( Execute := FALSE );
	fbSetPos(	Axis		:= fbMultiComb.Channels[1], 
				Execute		:= TRUE, 
				Relative	:= FALSE,
				Position	:= 0);

	IF fbSetPos.Error THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
						i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
						i_sMsg		:= CONCAT('MC_SetPosition.ErrorId: ', PLCO.FC_EtResultToString(fbSetPos.ErrorId) ) );
		fbSetPos( Execute := FALSE );		
		diState := 0;
		RETURN;						
	END_IF
	
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok, 
					i_etDiagExt := PDL_ET_DiagExt.Disabled,
					i_sMsg		:= '');
	diState := 0;
END_IF
{endregion}

(*--------------------------------------------------------------------------------------------------------------------------------------------*)
// Cyclic 
{region "cyclic"}
IF i_ifDrive <> 0 THEN
	
	//read power on state...
	fbReadAxisInfo( Axis				:= i_ifDrive, 
					Enable				:= TRUE);
					
	IF fbReadAxisInfo.Error THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
						i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
						i_sMsg		:= CONCAT('MC_ReadAxisInfo.ErrorId: ', PLCO.FC_EtResultToString(fbReadAxisInfo.ErrorId) ) );
		fbReadAxisInfo( Enable := FALSE );			
		fbMoveSuperimposed( Execute := FALSE );
		diState := 0;
	END_IF
	
	//... and switch on power at channels
	fbPowerControlAxis(	Axis   := fbMultiComb.Channels[0], 
						Enable := fbReadAxisInfo.PowerOn);

	IF fbPowerControlAxis.Error THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
						i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
						i_sMsg		:= CONCAT('MC_Power.ErrorId: ', PLCO.FC_EtResultToString(fbPowerControlAxis.ErrorId) ) );
		fbPowerControlAxis( Enable := FALSE );			
		fbMoveSuperimposed( Execute := FALSE );
		diState := 0;					
	END_IF
	
	
	fbPowerOffsetAxis(	Axis:= fbMultiComb.Channels[1], 
						Enable:= fbReadAxisInfo.PowerOn);

	IF fbPowerOffsetAxis.Error THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
						i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
						i_sMsg		:= CONCAT('MC_Power.ErrorId: ', PLCO.FC_EtResultToString(fbPowerOffsetAxis.ErrorId) ) );
		fbPowerOffsetAxis( Enable := FALSE );			
		fbMoveSuperimposed( Execute := FALSE );
		diState := 0;					
	END_IF
	
	//muticombine
	fbMultiComb(Slave			:= i_ifDrive, 
				Execute			:=    fbReadAxisInfo.PowerOn
								  AND fbPowerControlAxis.Status
								  AND fbPowerOffsetAxis.Status												  
				);			
				
	IF fbMultiComb.Error THEN
		SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
						i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
						i_sMsg		:= CONCAT('FB_MultiCombine.ErrorId: ', TO_STRING(fbMultiComb.ErrorId) ) );
		fbMultiComb( Execute := FALSE );		
		fbMoveSuperimposed( Execute := FALSE );
		diState := 0;
	END_IF
	
ELSE	
	SetDiagOutput(	i_etDiag	:= GD.ET_Diag.InputParameterInvalid, 
					i_etDiagExt := PDL_ET_DiagExt.DriveInvalid,
					i_sMsg		:= 'i_ifDrive - Invalid Interface');
END_IF

ifControlChannel := fbMultiComb.Channels[0];	
ifOffsetChannel  := fbMultiComb.Channels[1];
{endregion}

(*--------------------------------------------------------------------------------------------------------------------------------------------*)
// State machine 
CASE diState OF

(*********************************************************************************************************************)
	0:	// error or disabled 
		;

(*********************************************************************************************************************)	
	10:	// Wait for Start 
{region "waitForStartCmd"}		
		IF i_xStart AND i_lencMaster.lrPosition < i_lrXStartPos THEN
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok, 
							i_etDiagExt := PDL_ET_DiagExt.WaitUntilMasterPositionGreaterXStartPosition,
							i_sMsg		:= '');

			diState	:= 20;
		END_IF
		
		//call fbHalt until finished (started in step 30)
		fbHalt(	Axis := ifOffsetChannel );
		IF fbHalt.Done THEN
			fbHalt( Execute := FALSE );
		END_IF
	
		IF fbHalt.Error THEN				
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
							i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
							i_sMsg		:= CONCAT('MC_Halt.ErrorId: ', PLCO.FC_EtResultToString(fbHalt.ErrorId) ));				
			fbHalt( Execute := FALSE );		
			diState := 0;
			RETURN;	
		END_IF		
		
{endregion}

(*********************************************************************************************************************)	
	20:	// wait  XPosition > XStart  
{region "waitForStartPosition"}	
		IF i_lencMaster.lrPosition >= i_lrXStartPos THEN
			lrCorrTime := ABS(i_lrXFactor / MAX(i_lencMaster.lrVelocity, 1.0));
						
			//calculate correction velocity
			lrCorrVel :=  ABS(i_lrCorrection / lrCorrTime * 1.5 );
			IF lrCorrVel > i_lrMaxCorrVel THEN
				lrCorrVel := i_lrMaxCorrVel;
			ELSIF lrCorrVel < i_lrMaxCorrVel / 1000.0 THEN
				lrCorrVel := i_lrMaxCorrVel / 1000.0;
			END_IF
	
			lrCorrAcc := lrCorrVel / lrCorrTime * 3.0;
			IF lrCorrAcc > i_lrMaxCorrAcc THEN
				lrCorrAcc := i_lrMaxCorrAcc;
			END_IF

			//start movement cmd...
			fbMoveSuperimposed( Execute := FALSE );
			fbMoveSuperimposed(	Axis			:= ifOffsetChannel, 
								Execute			:= TRUE, 
								Distance		:= i_lrCorrection, 
								VelocityDiff	:= lrCorrVel, 
								Acceleration	:= lrCorrAcc, 
								Deceleration	:= lrCorrAcc );

		
			//...error
			IF fbMoveSuperimposed.Error THEN
				q_xCorrectionActive := FALSE;
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
								i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
								i_sMsg		:= CONCAT('MC_MoveSuperimposed.ErrorId: ', TO_STRING(fbMoveSuperimposed.ErrorId)));
				fbMoveSuperimposed( Execute := FALSE ); 	
				diState := 0;
			
			ELSE
			//...success -> wait until finshed	
				q_xCorrectionActive := TRUE;
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok, 
								i_etDiagExt := PDL_ET_DiagExt.WaitUntilYOffsetCorrectionFinished,
								i_sMsg		:= '');
				diState	:= 30;
			END_IF

		//user interrupt -> back to waiting
		ELSIF NOT i_xStart THEN
			q_xCorrectionActive := FALSE;
			
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok, 
							i_etDiagExt := PDL_ET_DiagExt.WaitForStart,
							i_sMsg		:= '');							
			diState	:= 10;
		END_IF
{endregion}

(*********************************************************************************************************************)
	30:	// wait until finished 
{region "waitUntilFinished"}		
		fbMoveSuperimposed();
	
		//movement done
		IF fbMoveSuperimposed.Done 
		THEN
			fbMoveSuperimposed( Execute := FALSE );	
			q_xCorrectionActive	:= FALSE;
			
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok, 
							i_etDiagExt := PDL_ET_DiagExt.WaitForStart,
							i_sMsg		:= '');	
			diState	:= 10;
	
		//user interrupt -> stop and go back to waiting
		ELSIF NOT i_xStart THEN
			fbMoveSuperimposed( Execute := FALSE );	
			fbHalt( Execute := FALSE );	
			fbHalt(	Axis			:= ifOffsetChannel, 
					Execute			:= TRUE, 
					BufferMode		:= PLCO.MC_Buffer_Mode.Aborting,
					Deceleration	:= lrCorrAcc );

			q_xCorrectionActive	:= FALSE;			
			IF fbHalt.Error THEN				
				SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
								i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
								i_sMsg		:= CONCAT('MC_Halt.ErrorId: ', PLCO.FC_EtResultToString(fbHalt.ErrorId) ));				
				fbHalt( Execute := FALSE );		
				diState := 0;
				RETURN;	
			END_IF				
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.Ok, 
							i_etDiagExt := PDL_ET_DiagExt.WaitForStart,
							i_sMsg		:= '');	
			diState	:= 10;
		END_IF

		//error
		IF fbMoveSuperimposed.Error THEN
			q_xCorrectionActive := FALSE;
			SetDiagOutput(	i_etDiag	:= GD.ET_Diag.UnexpectedProgramBehavior, 
							i_etDiagExt := PDL_ET_DiagExt.UnexpectedFeedback,
							i_sMsg		:= CONCAT('MC_MoveSuperimposed.ErrorId: ', TO_STRING(fbMoveSuperimposed.ErrorId)));
			fbMoveSuperimposed( Execute := FALSE ); 	
			diState := 0;
		END_IF
{endregion}

END_CASE

(*--------------------------------------------------------------------------------------------------------------------------------------------*)




