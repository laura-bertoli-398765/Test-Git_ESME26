__METADATA__
{
  "v3Meta": {
    "objectGuid": "11d70f74-47d0-4737-952b-66e503b3332f",
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
{attribute 'no_explicit_call' := 'Do not call body of FB_Average'}
FUNCTION_BLOCK PDL_FB_MovingAverage

VAR
	uiOrder_loc			: UINT := 1;			
										
	lrAverage_loc		: LREAL;		
	xInitialized		: BOOL;			
	
	uiI					: UINT;			
	uiLevel_loc			: UINT;			
	uiWriteIndex		: UINT;			
	alrBufferElements	: ARRAY[1..Gc_uiMovingAverageMaxOrder] OF LREAL;
										
	lrSum				: LREAL;		
	uiValidValues		: UINT;
END_VAR
__IMPLEMENTATION__
;
