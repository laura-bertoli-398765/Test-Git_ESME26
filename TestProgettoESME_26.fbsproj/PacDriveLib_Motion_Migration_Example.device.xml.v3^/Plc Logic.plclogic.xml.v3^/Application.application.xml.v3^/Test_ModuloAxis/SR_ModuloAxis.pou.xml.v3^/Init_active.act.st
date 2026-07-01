__METADATA__
{
  "v3Meta": {
    "objectGuid": "af0f5940-9cfb-45af-a9a1-97642bf12ef5",
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
	DRV_Modulo.Axis.SetAxisTypeModulo( i_lrPeriod := 360 );
	DRV_Modulo.Axis.xIsHomed := TRUE;
	
	
	fbDriveEnable.i_ifDrive := DRV_Modulo.Axis;
	fbDriveEnable.RegisterLoggerPoint(	i_ifParent	:= APL.G_ifApplicationLogger, 
										i_sName		:= 'SR_AxisModulo.fbDriveEnable', 
										q_etDiag	=> , 
										q_etDiagExt=> );
	
	fbEndlessFeed.i_ifDrive 		:= DRV_Modulo.Axis;
	fbEndlessFeed.i_lrAcc  			:= 1000;
	fbEndlessFeed.i_lrDec  			:= 10;
	fbEndlessFeed.i_lrJerk 			:= 1000;
	fbEndlessFeed.i_lrPeriod 		:= 360;
	fbEndlessFeed.i_lrStopPosition 	:= 200;
	fbEndlessFeed.i_lrVel 			:= 100;
	fbEndlessFeed.RegisterLoggerPoint(	i_ifParent	:= APL.G_ifApplicationLogger, 
										i_sName		:= 'SR_AxisModulo.fbEndlessFeed', 
										q_etDiag	=> , 
										q_etDiagExt=> );
	
	fbVarioPosJerk.i_ifDrive 	:= DRV_Modulo.Axis;
	fbVarioPosJerk.i_lrAcc  	:= 1000;
	fbVarioPosJerk.i_lrDec  	:= 1000;
	fbVarioPosJerk.i_lrJerk 	:= 1000;
	fbVarioPosJerk.i_lrTarget	:= 200;
	fbVarioPosJerk.i_lrVel		:= 50;
	fbVarioPosJerk.RegisterLoggerPoint(	i_ifParent	:= APL.G_ifApplicationLogger, 
										i_sName		:= 'SR_AxisModulo.fbVarioPosJerk', 
										q_etDiag	=> , 
										q_etDiagExt=> );
										
	xInitdone := TRUE;	
								
END_IF
