__METADATA__
{
  "v3Meta": {
    "objectGuid": "05cae1eb-9684-4632-bef6-8a05e37eeba1",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
(* Disconnection *)
IF NOT iq_stAxisModuleItf.stMultiCam.i_xKeepEncoderConnection THEN
	iq_stAxisModuleItf.stMain.iq_lencEncoder.DisconnectMasterAxis( 
									q_xError 	=> xError,
									q_etResult  => etResultMoin);

	IF xError THEN
		stExceptionUnexpected.udiDiagExt := AXM_ET_DiagExt.UnknownFeedback;
		stExceptionUnexpected.sMsg := TO_STRING(etResultMoin);
		ReportException(iq_stException := stExceptionUnexpected);
	END_IF
	
END_IF
iq_stAxisModuleItf.stMain.q_lrPositionX := 0.0;



