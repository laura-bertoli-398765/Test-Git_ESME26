__METADATA__
{
  "v3Meta": {
    "objectGuid": "ba673072-bd85-4e00-b391-31caa43cc68e",
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
METHOD INTERNAL WriteInterfaceMain : BOOL
VAR_INPUT
END_VAR
VAR_OUTPUT
	q_etDiag		: GD.ET_Diag;
	q_etDiagExt	: TPL.ET_DiagExt;
	q_sMsg			: STRING[80];
END_VAR
__IMPLEMENTATION__
THIS^.fbTreeWriter.NodeStart(	i_sName		:= 'stMain',
								q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);
								
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF

// 	(* get drive name for variables i_ifDrive *)
// 	IF (THIS^.pstInterface^.stMain.i_ifDrive <> 0) THEN
// 		THIS^.sTmp := THIS^.pstInterface^.stMain.i_ifDrive.Name;
// 	ELSE
// 		THIS^.sTmp := 'not configured';
// 	END_IF
// 	
// 	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_ifDrive', 
// 									i_sValue	:= THIS^.sTmp,
// 									q_etDiag	=> q_etDiag,
// 									q_etDiagExt	=> q_etDiagExt,
// 									q_sMsg		=> q_sMsg);
// 							
// 	IF q_etDiag <> GD.ET_Diag.Ok THEN
// 		RETURN;
// 	END_IF
	
// 	(* get master name for variables i_ifMaster *)
// 	IF (THIS^.pstInterface^.stMain.i_ifMaster <> 0) THEN
// 		THIS^.sTmp := THIS^.pstInterface^.stMain.i_ifMaster.Name;
// 	ELSE
// 		THIS^.sTmp := 'not configured';
// 	END_IF
// 	
// 	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_ifMaster', 
// 									i_sValue	:= THIS^.sTmp,
// 									q_etDiag	=> q_etDiag,
// 									q_etDiagExt	=> q_etDiagExt,
// 									q_sMsg		=> q_sMsg);
// 							
// 	IF q_etDiag <> GD.ET_Diag.Ok THEN
// 		RETURN;
// 	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_timMasterStop', 
									i_sValue	:= TIME_TO_STRING(THIS^.pstInterface^.stMain.i_timMasterStop),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_xHwLimitPos', 
									i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMain.i_xHwLimitPos),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_xHwLimitNeg', 
									i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMain.i_xHwLimitNeg),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_xStart', 
									i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMain.i_xStart),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_lrMotionActiveVelLimit', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMain.i_lrMotionActiveVelLimit),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_etMotionActiveVelType', 
									i_sValue	:= AXM_FC_EtMotionActiveVelTypeToString(THIS^.pstInterface^.stMain.i_etMotionActiveVelType),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
// 	(* get lenc name for variables iq_lencEncoder *)
// 	stLogicalAddress := THIS^.pstInterface^.stMain.iq_lencEncoder.stLogicalAddress;
// 	IF (stLogicalAddress.udiInstance <> 0) THEN
// 		THIS^.sTmp := THIS^.pstInterface^.stMain.iq_lencEncoder.Name;
// 	ELSE
// 		THIS^.sTmp := 'not configured';
// 	END_IF
// 	
// 	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'iq_lencEncoder', 
// 									i_sValue	:= THIS^.sTmp,
// 									q_etDiag	=> q_etDiag,
// 									q_etDiagExt	=> q_etDiagExt,
// 									q_sMsg		=> q_sMsg);
// 							
// 	IF q_etDiag <> GD.ET_Diag.Ok THEN
// 		RETURN;
// 	END_IF
	
	THIS^.fbTreeWriter.NodeStart(	i_sName		:= 'stReducedVelocity',
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
									
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
		THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_xEnableReducedVelocity', 
										i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMain.stReducedVelocity.i_xEnableReducedVelocity),
										q_etDiag	=> q_etDiag,
										q_etDiagExt	=> q_etDiagExt,
										q_sMsg		=> q_sMsg);
								
		IF q_etDiag <> GD.ET_Diag.Ok THEN
			RETURN;
		END_IF

		THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_lrMaxReducedVelocity', 
										i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMain.stReducedVelocity.i_lrMaxReducedVelocity),
										q_etDiag	=> q_etDiag,
										q_etDiagExt	=> q_etDiagExt,
										q_sMsg		=> q_sMsg);
								
		IF q_etDiag <> GD.ET_Diag.Ok THEN
			RETURN;
		END_IF		
		
		THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_xOnlyLimitCheck', 
										i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMain.stReducedVelocity.i_xOnlyLimitCheck),
										q_etDiag	=> q_etDiag,
										q_etDiagExt	=> q_etDiagExt,
										q_sMsg		=> q_sMsg);
								
		IF q_etDiag <> GD.ET_Diag.Ok THEN
			RETURN;
		END_IF		
		
		THIS^.fbTreeWriter.Parameter(	i_sName		:= 'i_lrReducedVelocityCheckFactor', 
										i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMain.stReducedVelocity.i_lrReducedVelocityCheckFactor),
										q_etDiag	=> q_etDiag,
										q_etDiagExt	=> q_etDiagExt,
										q_sMsg		=> q_sMsg);
								
		IF q_etDiag <> GD.ET_Diag.Ok THEN
			RETURN;
		END_IF		

		

	THIS^.fbTreeWriter.NodeEnd(	q_etDiag	=> q_etDiag,
								q_etDiagExt	=> q_etDiagExt,
								q_sMsg		=> q_sMsg);		
			
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'q_xDriveActive', 
									i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMain.q_xDriveActive),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF		
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'q_etOpMode', 
									i_sValue	:= AXM_FC_EtOpModeToString(THIS^.pstInterface^.stMain.q_etOpMode),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF	
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'q_etState', 
									i_sValue	:= AXM_FC_EtStateToString(THIS^.pstInterface^.stMain.q_etState),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF	
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'q_xHomeOk', 
									i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMain.q_xHomeOk),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF	
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'q_xSynchron', 
									i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMain.q_xSynchron),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF	
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'q_lrPosition', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMain.q_lrPosition),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF	
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'q_lrPositionX', 
									i_sValue	:= LREAL_TO_STRING(THIS^.pstInterface^.stMain.q_lrPositionX),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF	
	
// 	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'q_sDriveName', 
// 									i_sValue	:= THIS^.pstInterface^.stMain.q_sDriveName,
// 									q_etDiag	=> q_etDiag,
// 									q_etDiagExt	=> q_etDiagExt,
// 									q_sMsg		=> q_sMsg);
// 							
// 	IF q_etDiag <> GD.ET_Diag.Ok THEN
// 		RETURN;
// 	END_IF	
	
	THIS^.fbTreeWriter.Parameter(	i_sName		:= 'q_xMotionActive', 
									i_sValue	:= BOOL_TO_STRING(THIS^.pstInterface^.stMain.q_xMotionActive),
									q_etDiag	=> q_etDiag,
									q_etDiagExt	=> q_etDiagExt,
									q_sMsg		=> q_sMsg);
							
	IF q_etDiag <> GD.ET_Diag.Ok THEN
		RETURN;
	END_IF	
								
THIS^.fbTreeWriter.NodeEnd(	q_etDiag	=> q_etDiag,
							q_etDiagExt	=> q_etDiagExt,
							q_sMsg		=> q_sMsg);		
		
IF q_etDiag <> GD.ET_Diag.Ok THEN
	RETURN;
END_IF
