__METADATA__
{
  "v3Meta": {
    "objectGuid": "7e34f24d-8579-4789-a51a-46695e3611ea",
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
	DRV_Multicam.Axis.SetAxisTypeLinearWithoutLimits( 	q_xError   => xInitError,
													q_etResult => etResult  
													);
// 	//set axis TO modulo FOR Cam 3
//  	DRV_Slave.Axis.SetAxisTypeModulo( 	i_lrPeriod := astCam[3].astCamPoint[3].lrY,
//  										q_xError   => xInitError,
//  										q_etResult => etResult);


	IF xInitError THEN
		RETURN;
	END_IF			
										
	DRV_Multicam.Axis.xIsHomed := TRUE;
	
 	//set modulo axis as master axis
	Logical_Encoder.ConnectMasterAxis( i_ifAxis 	:= DRV_Modulo.Axis, 
									q_xError	=> xInitError,
									q_etResult	=> etResult	
									);
	IF xInitError THEN
		RETURN;
	END_IF		
	
	fbDriveEnable.i_ifDrive := DRV_Multicam.Axis;
	fbDriveEnable.RegisterLoggerPoint(	i_ifParent	:= APL.G_ifApplicationLogger, 
										i_sName		:= 'SR_MultiCam.fbDriveEnable');
										
	
										
	fbMulticam.i_ifDrive 			:= DRV_Multicam.Axis;
	fbMulticam.iq_lencMaster		:= Logical_Encoder;
	fbMulticam.i_lrWsAcc   			:= 1000;
	fbMulticam.i_lrWsJerk 			:= 1000;
	fbMulticam.i_lrWsVel   			:= 100;
	fbMulticam.i_lrWsWindow 		:= 100;
	
	CamData1();
	CamData2();
	CamData3();

	iSelectedCam := 1;
	stMultiCamData 					:= astCam[iSelectedCam]; 
	
	fbMulticam.RegisterLoggerPoint(	i_ifParent	:= APL.G_ifApplicationLogger, 
									i_sName		:= 'SR_MultiCam.fbEndlessFeed');

	xInitDone := TRUE;
	
END_IF




