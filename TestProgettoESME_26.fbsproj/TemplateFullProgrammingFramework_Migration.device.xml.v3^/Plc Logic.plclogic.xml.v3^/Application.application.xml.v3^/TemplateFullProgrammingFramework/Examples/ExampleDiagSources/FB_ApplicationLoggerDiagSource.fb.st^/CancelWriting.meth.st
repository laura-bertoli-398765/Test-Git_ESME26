__METADATA__
{
  "v3Meta": {
    "objectGuid": "39c6bc84-c08f-4565-8e7d-d86df8828183",
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
METHOD INTERNAL CancelWriting
VAR_INPUT
END_VAR
__IMPLEMENTATION__
(* Deactivate writing if we are (for whatever reason) no longer adressed.
   May happen in case network connection with Diagnostics is disrupted or Source will be disabled *)

THIS^.diOldCmd			:= 0;
THIS^.diCmdExecState	:= 0; 
