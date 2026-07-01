__METADATA__
{
  "v3Meta": {
    "objectGuid": "7f796cea-ba9d-4d4a-90bb-c004940813ac",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__

IF SR_Sercos.q_xSercosRun THEN

	APL.G_ifApplicationLogger.RegisterCommunicationService( );
	
	//set axis to linear
	DRV_Positioning.Axis.SetAxisTypeLinearWithoutLimits( );
	DRV_Positioning.Axis.xIsHomed := TRUE;
	
	
	fbDriveEnable.i_ifDrive := DRV_Positioning.Axis;
	fbDriveEnable.RegisterLoggerPoint(	i_ifParent	:= APL.G_ifApplicationLogger, 
										i_sName		:= 'SR_AxisLinear.fbDriveEnable', 
										q_etDiag	=> , 
										q_etDiagExt=> );
	
	fbEndlessFeed.i_ifDrive 		:= DRV_Positioning.Axis;
	fbEndlessFeed.i_lrAcc  			:= 1000;
	fbEndlessFeed.i_lrDec  			:= 10;
	fbEndlessFeed.i_lrJerk 			:= 1000;
	fbEndlessFeed.i_lrPeriod 		:= 360;
	fbEndlessFeed.i_lrStopPosition 	:= 200;
	fbEndlessFeed.i_lrVel 			:= 100;
	fbEndlessFeed.RegisterLoggerPoint(	i_ifParent	:= APL.G_ifApplicationLogger, 
										i_sName		:= 'SR_AxisLinear.fbEndlessFeed', 
										q_etDiag	=> , 
										q_etDiagExt=> );
	
	fbVarioPosJerk.i_ifDrive 	:= DRV_Positioning.Axis;
	fbVarioPosJerk.i_lrAcc  	:= 1000;
	fbVarioPosJerk.i_lrDec  	:= 1000;
	fbVarioPosJerk.i_lrJerk 	:= 1000;
	fbVarioPosJerk.i_lrTarget	:= 200;
	fbVarioPosJerk.i_lrVel		:= 50;
	fbVarioPosJerk.RegisterLoggerPoint(	i_ifParent	:= APL.G_ifApplicationLogger, 
										i_sName		:= 'SR_AxisLinear.fbVarioPosJerk', 
										q_etDiag	=> , 
										q_etDiagExt=> );
										
	fbJogging.i_ifDrive 		:= DRV_Positioning.Axis;
	fbJogging.i_lrVel 			:= 50;
	fbJogging.i_lrAcc  			:= 100;
	fbJogging.i_lrDec  			:= 1000;
	fbJogging.i_lrJerk 			:= 1000;
	fbJogging.i_lrPeriod 		:= 360;
	fbJogging.i_lrMaxDistance 	:= 200;
	fbJogging.i_xEndless 	    := FALSE;
	fbJogging.RegisterLoggerPoint(	i_ifParent	:= APL.G_ifApplicationLogger, 
										i_sName		:= 'SR_AxisLinear.fbJogging', 
										q_etDiag	=> , 
										q_etDiagExt=> );


	xInitdone := TRUE;									

END_IF
