__METADATA__
{
  "v3Meta": {
    "objectGuid": "e36afd94-3a16-439b-bc9a-ac26ee91c596",
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
METHOD PRIVATE StartCam : BOOL
VAR_INPUT
	i_etBufferMode 			: PLCO.MC_Buffer_Mode;
	i_stMultiCamData		: PDL_ST_MultiCam;
	i_lrMasterStartPosition	: LREAL := 0;
	i_xPeriodic 			: BOOL := TRUE;
	i_etMasterStartMode		: PLCO.MC_Master_Start_Mode := PLCO.MC_Master_Start_Mode.Absolute;
	i_etSlaveStartMode		: PLCO.MC_Slave_Start_Mode := PLCO.MC_Slave_Start_Mode.RampIn;
	i_xInputVelocity		: BOOL := FALSE;
	i_etDirection			: PLCO.MC_Direction := PLCO.MC_Direction.ShortestWay;
END_VAR
__IMPLEMENTATION__




IF xCamIn2Active THEN
	
	//camIn1
	//***********************************************************************************
	xCamIn2Active := FALSE;
	fbCamIn2( Execute := FALSE );
	
	IF i_xInputVelocity THEN
		fbCamIn.VelocityOffsetRampIn		:= i_lrWSVel;
		fbCamIn.AccelerationOffsetRampIn	:= i_lrWSAcc;
		fbCamIn.DecelerationOffsetRampIn	:= i_lrWSAcc;
		fbCamIn.JerkOffsetRampIn			:= i_lrWsJerk;
	ELSE
		IF ifDriveConfig <> 0 THEN
			IF ifDriveConfig.MaxVel <> 0 THEN
				fbCamIn.VelocityOffsetRampIn		:= ifDriveConfig.MaxVel;
			ELSE
				fbCamIn.VelocityOffsetRampIn		:= lrLimitMaxVel;
			END_IF
		
			IF ifDriveConfig.MaxAcc <> 0 THEN
				fbCamIn.AccelerationOffsetRampIn	:= ifDriveConfig.MaxAcc;
				fbCamIn.DecelerationOffsetRampIn	:= ifDriveConfig.MaxAcc;
			ELSE
				fbCamIn.AccelerationOffsetRampIn	:= lrLimitMaxAccDec;
				fbCamIn.DecelerationOffsetRampIn	:= lrLimitMaxAccDec;
			END_IF
		ELSE
			fbCamIn.VelocityOffsetRampIn		:= lrLimitMaxVel;	
			fbCamIn.AccelerationOffsetRampIn	:= lrLimitMaxAccDec;
			fbCamIn.DecelerationOffsetRampIn	:= lrLimitMaxAccDec;
		END_IF
		fbCamIn.JerkOffsetRampIn			:= 0;
	END_IF

	fbCamIn(	Execute						:= TRUE, 
				CamTableID					:= i_stMultiCamData, 
				BufferMode					:= i_etBufferMode, 
				Periodic					:= i_xPeriodic, 
				MasterOffset				:= 0, 
				SlaveOffset					:= 0, 
				MasterScaling				:= 1, 
				SlaveScaling				:= 1, 
				MasterStartMode				:= i_etMasterStartMode,
				SlaveStartMode				:= i_etSlaveStartMode,
				RampInDirection				:= i_etDirection,
				MasterStartPosition			:= i_lrMasterStartPosition);

ELSE
	//camIn2
	//***********************************************************************************
	xCamIn2Active := TRUE;
	fbCamIn( Execute := FALSE );
	
	IF i_xInputVelocity THEN
		fbCamIn2.VelocityOffsetRampIn		:= i_lrWSVel;
		fbCamIn2.AccelerationOffsetRampIn	:= i_lrWSAcc;
		fbCamIn2.DecelerationOffsetRampIn	:= i_lrWSAcc;
		fbCamIn2.JerkOffsetRampIn			:= i_lrWsJerk;
	ELSE
		IF ifDriveConfig <> 0 THEN
			IF ifDriveConfig.MaxVel <> 0 THEN
				fbCamIn2.VelocityOffsetRampIn		:= ifDriveConfig.MaxVel;
			ELSE
				fbCamIn2.VelocityOffsetRampIn		:= lrLimitMaxVel;
			END_IF
			IF ifDriveConfig.MaxAcc <> 0 THEN
				fbCamIn2.AccelerationOffsetRampIn	:= ifDriveConfig.MaxAcc;
				fbCamIn2.DecelerationOffsetRampIn	:= ifDriveConfig.MaxAcc;
			ELSE
				fbCamIn2.AccelerationOffsetRampIn	:= lrLimitMaxAccDec;
				fbCamIn2.DecelerationOffsetRampIn	:= lrLimitMaxAccDec;
			END_IF		
		ELSE
			fbCamIn.VelocityOffsetRampIn		:= lrLimitMaxVel;	
			fbCamIn.AccelerationOffsetRampIn	:= lrLimitMaxAccDec;
			fbCamIn.DecelerationOffsetRampIn	:= lrLimitMaxAccDec;
		END_IF
		fbCamIn2.JerkOffsetRampIn			:= 0;
	END_IF

	
	fbCamIn2(	Execute						:= TRUE, 
				CamTableID					:= i_stMultiCamData, 
				BufferMode					:= i_etBufferMode, 
				Periodic					:= i_xPeriodic, 
				MasterOffset				:= 0, 
				SlaveOffset					:= 0, 
				MasterScaling				:= 1, 
				SlaveScaling				:= 1, 
				MasterStartMode				:= i_etMasterStartMode, 
				SlaveStartMode				:= i_etSlaveStartMode, 
				RampInDirection				:= i_etDirection, 
				MasterStartPosition			:= i_lrMasterStartPosition);


END_IF












