__METADATA__
{
  "v3Meta": {
    "objectGuid": "46e7b8f9-5bc6-4448-84b6-d9d015b501c9",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {
      "_3S.CoDeSys.LanguageModelManager.BuildProperty": "<?xml version=\"1.0\" encoding=\"utf-8\"?><Single xml:space=\"preserve\" Type=\"{24568a24-c491-472c-a21f-ee5d33859fab}\" Method=\"IArchivable\"><Single Name=\"MemoryReserveForOnlineChange\" Type=\"int\">0</Single><Single Name=\"ExcludeFromBuild\" Type=\"bool\">True</Single><Single Name=\"External\" Type=\"bool\">False</Single><Single Name=\"EnableSystemCall\" Type=\"bool\">False</Single><Single Name=\"CompilerDefines\" Type=\"string\"></Single><Single Name=\"LinkAlways\" Type=\"bool\">False</Single><Array Name=\"Undefines\" Type=\"string\" /></Single>"
    },
    "subObjects": {}
  },
  "excludeFromBuild": true
}
__IMPLEMENTATION__
(*
FB version: 1.0.8.0
Example Project version: 26.0.11.0 (Automatically generated, do not change!)

revision history:
=========================================================================================================
version	| date			| author				| comment
=========================================================================================================
1.0.0.0	| 2025-03-18	| Schneider Electric	| - initial release
---------------------------------------------------------------------------------------------------------
1.0.1.0	| 2025-07-01	| Schneider Electric	| - only AxisState is evaluated for output q_xDriveEnabled
---------------------------------------------------------------------------------------------------------
1.0.2.0	| 2025-07-03	| Schneider Electric	| - check drive errors and sercos phase
---------------------------------------------------------------------------------------------------------
1.0.3.0	| 2025-07-03	| Schneider Electric	| - bugfix: q_xDriveEnabled was set to true, when FB is disabled
---------------------------------------------------------------------------------------------------------
1.0.4.0	| 2025-07-29	| Schneider Electric	| - activate PowerSupply in case of real Axis
---------------------------------------------------------------------------------------------------------
1.0.5.0	| 2025-08-21	| Schneider Electric	| - reset fbPower if error is detected
---------------------------------------------------------------------------------------------------------
1.0.6.0	| 2025-09-01	| Schneider Electric	| - Add axis name in Error Message
---------------------------------------------------------------------------------------------------------
1.0.7.0	| 2025-09-22	| Schneider Electric	| - Call MC_Reset at i_xDiagQuit when axis is in Errorstop
---------------------------------------------------------------------------------------------------------
1.0.8.0	| 2025-09-26	| Schneider Electric	| - Change the order of inputs and outputs like at the original PacDrive-Lib FB
---------------------------------------------------------------------------------------------------------
1.x.y.z	| 20xx-xx-xx	| your name				| - What has been modified?
=========================================================================================================
*)
