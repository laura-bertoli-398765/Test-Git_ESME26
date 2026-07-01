__METADATA__
{
  "v3Meta": {
    "objectGuid": "1115d78a-31f9-4155-88f9-c7f7f0d6e24d",
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
FB version: 1.0.5.0
Example Project version: 26.0.11.0 (Automatically generated, do not change!)

revision history:
=========================================================================================================
version	| date			| author				| comment
=========================================================================================================
1.0.0.0	| 2025-03-18	| Schneider Electric	| - initial release
---------------------------------------------------------------------------------------------------------
1.0.1.0	| 2025-08-07	| Schneider Electric	| - IECLIB-37480: Check Velocity and Acceleration limits
---------------------------------------------------------------------------------------------------------
1.0.2.0	| 2025-09-01	| Schneider Electric	| - Add axis name in Error Message
---------------------------------------------------------------------------------------------------------
1.0.3.0	| 2025-09-19	| Schneider Electric	| - BugFix when during Homing the HW-Limits are reached
---------------------------------------------------------------------------------------------------------
1.0.4.0	| 2025-09-26	| Schneider Electric	| - Change the order of inputs and outputs like at the original PacDrive-Lib FB
---------------------------------------------------------------------------------------------------------
1.0.5.0	| 2025-09-26	| Schneider Electric	| - changed motionparameter are now considered on a new start
												| - error messages are now always from the current motion-fb
---------------------------------------------------------------------------------------------------------
1.x.y.z	| 20xx-xx-xx	| your name				| - What has been modified?
=========================================================================================================
*)
