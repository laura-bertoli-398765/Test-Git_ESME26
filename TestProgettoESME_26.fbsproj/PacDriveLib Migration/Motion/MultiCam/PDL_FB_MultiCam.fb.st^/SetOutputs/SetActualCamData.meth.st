__METADATA__
{
  "v3Meta": {
    "objectGuid": "8acd7184-771b-4661-8f31-8071e86cbffe",
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
METHOD PRIVATE SetActualCamData : BOOL
VAR_INPUT
END_VAR
__IMPLEMENTATION__


//set values
q_stActualCamData.diProfileId	:= -1;
q_stActualCamData.lrXOffset		:= stActiveMultiCamData.astCamPoint[0].lrX; 
q_stActualCamData.lrYOffset		:= stActiveMultiCamData.astCamPoint[0].lrY;
q_stActualCamData.lrXFactor		:=  stActiveMultiCamData.astCamPoint[stActiveMultiCamData.diNumberOfCamPoints-1].lrX 
								  - stActiveMultiCamData.astCamPoint[0].lrX;

MOIN.FC_CamBounds(	i_stCamTableID		:= stActiveMultiCamData, 
					i_lrMasterVelMax	:= 0, 
					i_lrMasterAccMax	:= 0, 
					i_lrMasterScaling	:= 1, 
					i_lrSlaveScaling	:= 1, 
					q_lrMaxPosition		=> q_stActualCamData.lrYFactor
					);
					
q_stActualCamData.diUserTableId	:= stActiveMultiCamData.diUserTableId;

lrYPeriode := stActiveMultiCamData.lrYPeriod;
lrXPeriode := stActiveMultiCamData.astCamPoint[stActiveMultiCamData.diNumberOfCamPoints-1].lrX - stActiveMultiCamData.astCamPoint[0].lrX;








