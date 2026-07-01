__METADATA__
{
  "v3Meta": {
    "objectGuid": "16f96d09-9d0c-490f-8fba-3dc451eea1cf",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
IFB_RTOPMode(CLK:= G_xDoPrepare OR G_xDoAuto OR G_xDoManual OR G_xDoJogMachine OR G_xDoBrakeRelease );
IF G_xDoPrepare THEN
	IF g_xPrepareActive AND G_xPrepareEpas AND IFB_RTOPMode.Q THEN
		g_xPrepareActive := FALSE;
		G_xPrepareEpas:= FALSE;
	ELSIF IFB_RTOPMode.Q THEN
		g_xPrepareActive := TRUE;
		G_xPrepareEpas:= TRUE;
	END_IF
	G_xAutoEpas := FALSE;
	G_xManualEpas := FALSE;
	G_xJogMachineEpas := FALSE;
	G_xBrakeReleaseEpas := FALSE;

ELSIF G_xDoAuto THEN
	IF G_xAutoActive AND G_xAutoEpas AND IFB_RTOPMode.Q THEN
		G_xAutoActive := FALSE;
		G_xAutoEpas := FALSE;
	ELSIF IFB_RTOPMode.Q THEN
		G_xAutoActive := TRUE;
		G_xAutoEpas := TRUE;
	END_IF
	G_xManualEpas := FALSE;
	G_xJogMachineEpas := FALSE;
	G_xBrakeReleaseEpas := FALSE;
	G_xPrepareEpas:= FALSE;

ELSIF G_xDoManual THEN
	IF G_xManualActive AND G_xManualEpas AND IFB_RTOPMode.Q THEN
		G_xManualActive := FALSE;
		G_xManualEpas := FALSE;
	ELSIF IFB_RTOPMode.Q THEN
		g_xManualActive := TRUE;
		G_xManualEpas := TRUE;
	END_IF
	G_xJogMachineEpas := FALSE;
	G_xBrakeReleaseEpas := FALSE;
	G_xPrepareEpas:= FALSE;
	G_xAutoEpas := FALSE;

ELSIF g_xDoJogMachine THEN
	IF g_xJogMachineActive AND G_xJogMachineEpas AND IFB_RTOPMode.Q THEN
		g_xJogMachineActive := FALSE;
		G_xJogMachineEpas := FALSE;
	ELSIF IFB_RTOPMode.Q THEN
		g_xJogMachineActive := TRUE;
		G_xJogMachineEpas := TRUE;
	END_IF
	G_xBrakeReleaseEpas := FALSE;
	G_xPrepareEpas:= FALSE;
	G_xAutoEpas := FALSE;
	G_xManualEpas := FALSE;

ELSIF g_xDoBrakeRelease THEN
	IF g_xBrakeReleaseActive AND G_xBrakeReleaseEpas AND IFB_RTOPMode.Q THEN
		g_xBrakeReleaseActive := FALSE;
		G_xBrakeReleaseEpas := FALSE;
	ELSIF IFB_RTOPMode.Q THEN
		g_xBrakeReleaseActive := TRUE;
		G_xBrakeReleaseEpas := TRUE;
	END_IF
	G_xPrepareEpas:= FALSE;
	G_xAutoEpas := FALSE;
	G_xManualEpas := FALSE;
	G_xJogMachineEpas := FALSE;
END_IF

IF g_xDoPrepare OR  g_xDoAuto OR g_xDoManual OR g_xDoJogMachine OR g_xDoBrakeRelease THEN
	g_xPrepareActive := g_xPrepareActive  AND NOT( g_xDoAuto OR g_xDoManual OR g_xDoJogMachine OR g_xDoBrakeRelease);
	g_xAutoActive :=  g_xAutoActive AND NOT( g_xDoPrepare OR g_xDoManual OR g_xDoJogMachine OR g_xDoBrakeRelease);
	g_xManualActive := g_xManualActive AND NOT( g_xDoPrepare OR g_xDoAuto OR g_xDoJogMachine OR g_xDoBrakeRelease);
	g_xJogMachineActive :=  g_xJogMachineActive AND NOT( g_xDoPrepare OR g_xDoAuto OR g_xDoManual OR g_xDoBrakeRelease);
	g_xBrakeReleaseActive:=  g_xBrakeReleaseActive  AND NOT( g_xDoPrepare OR g_xDoAuto OR g_xDoManual OR g_xDoJogMachine);
END_IF
