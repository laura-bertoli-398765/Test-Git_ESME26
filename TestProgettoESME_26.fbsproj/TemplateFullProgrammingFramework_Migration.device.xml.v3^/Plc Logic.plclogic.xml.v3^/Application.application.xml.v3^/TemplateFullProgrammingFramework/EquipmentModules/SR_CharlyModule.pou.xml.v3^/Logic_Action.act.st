__METADATA__
{
  "v3Meta": {
    "objectGuid": "4c63c3c9-7ae7-4f6a-8a63-3a1de13a49a1",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* This is an example of how to use the Positioning mode *)

IF stSlave4Interface.stMain.q_etOpMode = AXM_ET_OpMode.Positioning THEN
	IF stSlave4Interface.stMain.q_xMotionActive THEN
		(* There must be a rising edge at the xStart bit for initializing new Pos values, therefore it have to be reset. *)
		 stSlave4Interface.stMain.i_xStart := FALSE;
	END_IF

	CASE iPosState OF
		1: (* moving back *)
			(* Wait until the InPosition signal *)
			IF stSlave4Interface.stPos.q_xInPosition THEN
				(*Initialize new Pos values*)
				stSlave4Interface.stPos.i_lrTarget	:= -360.0;
				stSlave4Interface.stPos.i_etPosMode	:= PDL_ET_PosMode.Relative;
				
				IF fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.StatusMessage THEN
					fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.StatusMessage,
												i_etDiag		:= GD.ET_Diag.Ok,
												i_udiDiagExt	:= ET_DiagExt.Ok,
												i_sMessage		:= 'Logic: move axis in negative direction',
												q_etDiag		:= ,
												q_etDiagExt		:= );
				END_IF
				
				iPosState := 2;
			END_IF
			
		2: (* moving forward *)
			(* Wait until the InPosition signal *)
			IF stSlave4Interface.stPos.q_xInPosition THEN
				(* Initialize new Pos values *)
				stSlave4Interface.stPos.i_lrTarget	:= 360.0;
				stSlave4Interface.stPos.i_etPosMode	:= PDL_ET_PosMode.Relative;
				
				IF fbLoggerPoint.etLogLevel >= APL.ET_LogLevel.StatusMessage THEN
					fbLoggerPoint.AddLogEntry(	i_etLogLevel	:= APL.ET_LogLevel.StatusMessage,
												i_etDiag		:= GD.ET_Diag.Ok,
												i_udiDiagExt	:= ET_DiagExt.Ok,
												i_sMessage		:= 'Logic: move axis in positive direction',
												q_etDiag		:= ,
												q_etDiagExt		:= );
				END_IF
				
				iPosState := 1;
			END_IF
	END_CASE
	
	(* Start movement again and set new initialized values *)
	IF xFirstCall THEN
		xFirstCall := FALSE;
		
		stSlave4Interface.stMain.i_xStart := TRUE;
		
	ELSIF NOT stSlave4Interface.stMain.q_xMotionActive AND stSlave4Interface.stPos.q_xInPosition THEN
		stSlave4Interface.stMain.i_xStart := TRUE;
	END_IF
ELSE
	(* Set the SYSTEMINTERFACE.ET_PosMode.Absolute mode that the movement will start later at the last position. *)
	stSlave4Interface.stPos.i_etPosMode := PDL_ET_PosMode.Absolute;
	
	IF stSlave4Interface.stMain.q_etOpMode = AXM_ET_OpMode.Homing THEN
		(* Start with moving forward after homing *)
		stSlave4Interface.stPos.i_lrTarget := 360.0;
		
		iPosState := 1; (* next moving back *)
	END_IF
END_IF
