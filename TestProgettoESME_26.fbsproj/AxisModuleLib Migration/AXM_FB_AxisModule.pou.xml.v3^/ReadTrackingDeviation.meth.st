__METADATA__
{
  "v3Meta": {
    "objectGuid": "16dc0616-d9b1-4637-9ce5-aae0e418a722",
    "objectTypeGuid": "f8a58466-d7f6-439f-bbb8-d4600e41d099",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {
      "_3S.CoDeSys.LanguageModelManager.BuildProperty": "<?xml version=\"1.0\" encoding=\"utf-8\"?><Single xml:space=\"preserve\" Type=\"{24568a24-c491-472c-a21f-ee5d33859fab}\" Method=\"IArchivable\"><Single Name=\"MemoryReserveForOnlineChange\" Type=\"int\">0</Single><Single Name=\"ExcludeFromBuild\" Type=\"bool\">False</Single><Single Name=\"External\" Type=\"bool\">False</Single><Single Name=\"EnableSystemCall\" Type=\"bool\">False</Single><Single Name=\"CompilerDefines\" Type=\"string\"></Single><Single Name=\"LinkAlways\" Type=\"bool\">False</Single><Array Name=\"Undefines\" Type=\"string\" /></Single>"
    },
    "subObjects": {}
  }
}
__DECLARATION__
METHOD ReadTrackingDeviation : LREAL

VAR_OUTPUT
	q_sLrealConversion	: STRING[80];
END_VAR
VAR
	etConversionDiag	: SE_CTBX.ET_Result;
END_VAR
__IMPLEMENTATION__
	GetInterfaces();
	
	IF ifDrive2 <> 0 THEN
		ReadTrackingDeviation :=  ifDrive2.TrackingDeviation;
		
		q_sLrealConversion := SE_CTBX.FC_LrealToString(
									i_sFormat := '10#0.______',
									i_lrInput := ReadTrackingDeviation,
									q_etResult => etConversionDiag,
									q_sResultMsg => 
									);
						
		IF etConversionDiag <> SE_CTBX.ET_Result.Ok THEN
			q_sLrealConversion := 'LREAL too big';
		END_IF
	ELSE
		q_sLrealConversion := 'TrackingDeviation not available';
		ReadTrackingDeviation := 0.0;		
	END_IF
