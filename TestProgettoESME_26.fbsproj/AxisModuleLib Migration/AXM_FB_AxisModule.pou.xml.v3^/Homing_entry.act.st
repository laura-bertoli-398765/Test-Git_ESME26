__METADATA__
{
  "v3Meta": {
    "objectGuid": "411e9c86-3a69-437b-80f4-8b885b1b2658",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
fbhome.RegisterLoggerPoint(	i_ifParent	:= fbLoggerPoint,
							i_sName		:= 'Homing',
							q_etDiag	=> ,
							q_etDiagExt => );

xRefActive := TRUE;
xRefAxisEnableOld := FALSE;

IF iq_stAxisModuleItf.stHome.i_etMode = PDL_ET_HomeMode.NegDirectionNegEdgeHWLimitNeg OR
	iq_stAxisModuleItf.stHome.i_etMode = PDL_ET_HomeMode.PosDirectionNegEdgeHWLimitPos THEN
	
	stExceptionModuleReaction2.etDiag 		:= GD.ET_Diag.ConfigurationFailed;
	stExceptionModuleReaction2.udiDiagExt 	:= AXM_ET_DiagExt.HomingModeNotSupported;
	stExceptionModuleReaction2.sMsg 		:= 'HomingMode LimitSwitch with NegEdge not supported. Use PosEdge inverted inputs';
	ReportException(iq_stException 	:= stExceptionModuleReaction2);
	
END_IF
