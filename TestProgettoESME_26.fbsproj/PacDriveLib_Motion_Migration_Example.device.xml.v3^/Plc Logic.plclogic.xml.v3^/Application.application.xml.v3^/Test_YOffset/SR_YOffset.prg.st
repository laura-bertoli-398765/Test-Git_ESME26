__METADATA__
{
  "v3Meta": {
    "objectGuid": "4e8642a0-2391-42ec-bb7b-f1d6c1827791",
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
PROGRAM SR_YOffset
VAR
	xInitDone					: BOOL;
	xInitError					: BOOL;
	etResult					: MOIN.ET_Result;

	fbDriveEnable				: PDL_FB_DriveEnable;
	fbYOffsetCorrection			: PDL_FB_YOffsetCorrection;
	fbVarioPosJerk				: PDL_FB_VarioPosJerk;
END_VAR
__IMPLEMENTATION__

IF  NOT xInitDone 
THEN
	
	IF  SR_Sercos.q_xSercosRun
	THEN
		xInitDone := TRUE;
	
		fbVarioPosJerk.i_lrAcc   		:= 1000;
		fbVarioPosJerk.i_lrDec  		:= 1000;
		fbVarioPosJerk.i_lrJerk 		:= 1000;
		fbVarioPosJerk.i_lrVel   		:= 100;
		fbVarioPosJerk.i_lrTarget 		:= 200;
		fbVarioPosJerk.i_etPosMode		:= PDL_ET_PosMode.Absolute;
		
		Logical_Encoder_YOffset.ConnectMasterAxis( i_ifAxis := DRV_YOffset.Axis,
													q_xError   => xInitError,
													q_etResult => etResult  
													);
	
		fbYOffsetCorrection.i_lrCorrection 	:= 100;
		fbYOffsetCorrection.i_lrMaxCorrAcc 	:= 1000;		
		fbYOffsetCorrection.i_lrMaxCorrVel 	:= 100;		
		fbYOffsetCorrection.i_lrXFactor 	:= 50;		
		fbYOffsetCorrection.i_lrXStartPos 	:= 100;			
	END_IF																					
END_IF


fbDriveEnable( i_ifDrive := DRV_YOffset.Axis );


fbYOffsetCorrection( 	i_ifDrive 	 := DRV_YOffset.Axis,
						i_lencMaster := Logical_Encoder_YOffset );
						
						
//pos mode endless does not work with channel (setpos not working)
fbVarioPosJerk( i_ifDrive := fbYOffsetCorrection.ifGetControlChannel );


