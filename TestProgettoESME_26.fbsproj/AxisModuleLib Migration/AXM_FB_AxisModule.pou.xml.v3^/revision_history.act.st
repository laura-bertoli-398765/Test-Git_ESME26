__METADATA__
{
  "v3Meta": {
    "objectGuid": "6f176610-6c95-4a1c-898f-e990c130e6ca",
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
FB version: 1.0.4.0
Example Project version: 26.0.11.0 (Automatically generated, do not change!)

revision history:
=========================================================================================================
version	| date			| author				| comment
=========================================================================================================
1.0.0.0	| 2025-03-18	| Schneider Electric	| - initial release
---------------------------------------------------------------------------------------------------------
1.0.1.0	| 2025-06-17	| Schneider electric    | - Modify action ExceptionHandling: Evaluation of Diagcode
												  - Add new action GetInterfaces: Cast to necessary interfaces
                                                  - Activate method ReadTrackingDeviation and call it in Homing_active
												  - Remove method "DiagTestHoming_old"
---------------------------------------------------------------------------------------------------------
1.0.2.0	| 2025-07-28	| Schneider electric    | - PDL_FB_Brake now available
												  - replace not available IF_Drive with IF_Drive2
                                                  - Activate method ReadTrackingDeviation and call it in Homing_active
												  - Remove method "DiagTestHoming_old"		
---------------------------------------------------------------------------------------------------------
1.0.3.0	| 2025-08-28	| Schneider electric    | - BugFix IECLIB-50430: Execute HomingMode LimitSwitch without triggering an exception. 							  
---------------------------------------------------------------------------------------------------------
1.0.4.0	| 2026-03-05	| Schneider electric    | - rename struct stHomeSetPosPdl -> stFbHomeSetPosProperty in order to avoid renaming issues							  
=========================================================================================================
*)
