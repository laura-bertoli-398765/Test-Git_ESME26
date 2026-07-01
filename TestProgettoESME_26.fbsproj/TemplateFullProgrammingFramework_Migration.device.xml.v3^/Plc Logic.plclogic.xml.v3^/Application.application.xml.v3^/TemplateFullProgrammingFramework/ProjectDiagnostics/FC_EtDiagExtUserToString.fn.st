__METADATA__
{
  "v3Meta": {
    "objectGuid": "44e4f49a-f63d-430a-af1b-c64ce8a36e4a",
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
FUNCTION FC_EtDiagExtUserToString : STRING[80]
VAR_INPUT
	i_etDiagExt : ET_DiagExtUser;
END_VAR
VAR_OUTPUT
	q_etDiag	: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt	: ET_DiagExt := ET_DiagExt.Ok;
END_VAR
VAR
END_VAR
__IMPLEMENTATION__
CASE i_etDiagExt OF
	ET_DiagExtUser.Exception1FromEquipmentModule	: FC_EtDiagExtUserToString := 'Exception1FromEquipmentModule';
	ET_DiagExtUser.Exception2FromEquipmentModule	: FC_EtDiagExtUserToString := 'Exception2FromEquipmentModule';
	
	ET_DiagExtUser.Exception1FromMain				: FC_EtDiagExtUserToString := 'Exception1FromMain';
	ET_DiagExtUser.Exception2FromMain				: FC_EtDiagExtUserToString := 'Exception2FromMain';
	ET_DiagExtUser.Exception3FromMain				: FC_EtDiagExtUserToString := 'Exception3FromMain';
	ET_DiagExtUser.Exception4FromMain				: FC_EtDiagExtUserToString := 'Exception4FromMain';
	ET_DiagExtUser.Exception5FromMain				: FC_EtDiagExtUserToString := 'Exception5FromMain';
ELSE
	FC_EtDiagExtUserToString := CONCAT('Unkown ET_DiagExtUser ', UDINT_TO_STRING(i_etDiagExt));
		
	q_etDiag	:= GD.ET_Diag.InputParameterInvalid;
	q_etDiagExt	:= ET_DiagExt.UnknownDiagExtUser;
END_CASE
	
