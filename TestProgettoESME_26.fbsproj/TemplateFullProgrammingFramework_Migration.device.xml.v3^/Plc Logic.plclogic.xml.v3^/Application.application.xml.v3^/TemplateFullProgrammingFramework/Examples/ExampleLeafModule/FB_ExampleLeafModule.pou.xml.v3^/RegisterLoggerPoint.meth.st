__METADATA__
{
  "v3Meta": {
    "objectGuid": "b4942ee7-87de-4021-b3ec-24da59f1854e",
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
METHOD PUBLIC RegisterLoggerPoint
VAR_INPUT
	i_ifParent		: APL.IF_LoggerPoint;
	i_sName			: STRING[80];
END_VAR
VAR_OUTPUT
	q_etDiag		: GD.ET_Diag := GD.ET_Diag.Ok;
	q_etDiagExt		: ET_DiagExtExampleLeafModule := ET_DiagExtExampleLeafModule.Ok;
	q_sMsg			: STRING[80] := '';
END_VAR
VAR
	etDiagBuffer		: GD.ET_Diag;
	etDiagExtBufferAPL	: APL.ET_DiagExt;
END_VAR
__IMPLEMENTATION__
THIS^.fbLoggerPoint.RegisterLoggerPoint(	i_ifParent		:= i_ifParent,
											i_sName			:= i_sName,
											i_sType			:= 'FB_ExampleLeafModule',
											i_sSource		:= 'Project',
											q_etDiag		=> etDiagBuffer,
											q_etDiagExt		=> etDiagExtBufferAPL);
IF (etDiagBuffer <> GD.ET_Diag.Ok) THEN
	CASE etDiagExtBufferAPL OF
		APL.ET_DiagExt.ParentInvalid:
			q_etDiag := GD.ET_Diag.InputParameterInvalid;
			q_etDiagExt := ET_DiagExtExampleLeafModule.ParentInvalid;
			
		APL.ET_DiagExt.ParentNotRegistered:
			q_etDiag := GD.ET_Diag.InputParameterInvalid;
			q_etDiagExt := ET_DiagExtExampleLeafModule.ParentNotRegistered;
			
		APL.ET_DiagExt.MaxNumberOfLoggerPointsExeeded:
			q_etDiag := GD.ET_Diag.InputParameterInvalid;
			q_etDiagExt := ET_DiagExtExampleLeafModule.MaxNumberOfLoggerPointsExeeded;
			
	ELSE
		q_etDiag := GD.ET_Diag.UnexpectedProgramBehavior;
		q_etdiagExt := ET_DiagExtExampleLeafModule.UnexpectedDiagExt;
		q_sMsg := Standard.CONCAT('RegisterLoggerPoint: ', APL.FC_EtDiagExtToString(i_etDiagExt := etDiagExtBufferAPL));
	END_CASE
END_IF
