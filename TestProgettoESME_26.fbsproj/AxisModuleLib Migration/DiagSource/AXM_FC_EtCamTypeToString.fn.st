__METADATA__
{
  "v3Meta": {
    "objectGuid": "777dc5ac-38fd-4b61-bdfe-dcbdae9e7841",
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
FUNCTION INTERNAL AXM_FC_EtCamTypeToString : STRING[80]
VAR_INPUT
	i_etCamType	: CMT.ET_CamType;
END_VAR
VAR
END_VAR
__IMPLEMENTATION__
CASE i_etCamType OF
	CMT.ET_CamType.Straight:
		AXM_FC_EtCamTypeToString := 'Straight';
	
	CMT.ET_CamType.Poly5Com:
		AXM_FC_EtCamTypeToString := 'Poly5Com';
	
	CMT.ET_CamType.SimplSin:
		AXM_FC_EtCamTypeToString := 'SimplSin';
	
	CMT.ET_CamType.IncliSin:
		AXM_FC_EtCamTypeToString := 'IncliSin';
	
	CMT.ET_CamType.ModiSin:
		AXM_FC_EtCamTypeToString := 'ModiSin';
	
	CMT.ET_CamType.ModAccTr:
		AXM_FC_EtCamTypeToString := 'ModAccTr';
	
	CMT.ET_CamType.Poly5:
		AXM_FC_EtCamTypeToString := 'Poly5';
	
	CMT.ET_CamType.Parable2:
		AXM_FC_EtCamTypeToString := 'Parable2';
	
	CMT.ET_CamType.UserCam:
		AXM_FC_EtCamTypeToString := 'UserCam';
	
	CMT.ET_CamType.ModiSinCom:
		AXM_FC_EtCamTypeToString := 'ModiSinCom';
	
	CMT.ET_CamType.ModAccTrCom:
		AXM_FC_EtCamTypeToString := 'ModAccTrCom';
	
	CMT.ET_CamType.HarmoComb:
		AXM_FC_EtCamTypeToString := 'HarmoComb';
	
	CMT.ET_CamType.SinStraightComb:		
		AXM_FC_EtCamTypeToString := 'SinStraightComb';
	
ELSE
	AXM_FC_EtCamTypeToString := Standard.CONCAT('Unknown CamType ', INT_TO_STRING(i_etCamType));
END_CASE
