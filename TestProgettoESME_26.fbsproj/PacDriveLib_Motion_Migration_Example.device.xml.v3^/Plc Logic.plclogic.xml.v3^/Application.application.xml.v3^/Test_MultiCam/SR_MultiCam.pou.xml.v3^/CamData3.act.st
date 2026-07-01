__METADATA__
{
  "v3Meta": {
    "objectGuid": "dfb6dab7-5463-400b-bcff-8c032a324aa9",
    "objectTypeGuid": "8ac092e5-3128-4e26-9e7e-11016c6684f2",
    "embeddedObjectTypeGuids": [
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__IMPLEMENTATION__
astCam[3].diNumberOfCamPoints := 4;
astCam[3].lrYPeriod := 270;
astCam[3].diUserTableId := 3;

astCam[3].astCamPoint[0].lrX := 0;
astCam[3].astCamPoint[0].lrY := 0;
astCam[3].astCamPoint[0].lrM := 2;
astCam[3].astCamPoint[0].lrK := 0;
astCam[3].astCamPoint[0].lrLambda := 0;
astCam[3].astCamPoint[0].lrC := 1;
astCam[3].astCamPoint[0].etCamType := CMT.ET_CAMTYPE.Poly5Com;

astCam[3].astCamPoint[1].lrX := 100;
astCam[3].astCamPoint[1].lrY := 100;
astCam[3].astCamPoint[1].lrM := 0;
astCam[3].astCamPoint[1].lrK := 0;
astCam[3].astCamPoint[1].lrLambda := 1;
astCam[3].astCamPoint[1].lrC := 1;
astCam[3].astCamPoint[1].etCamType := CMT.ET_CAMTYPE.Straight;

astCam[3].astCamPoint[2].lrX := 200;
astCam[3].astCamPoint[2].lrY := 100;
astCam[3].astCamPoint[2].lrM := 0;
astCam[3].astCamPoint[2].lrK := 0;
astCam[3].astCamPoint[2].lrLambda := 1;
astCam[3].astCamPoint[2].lrC := 1;
astCam[3].astCamPoint[2].etCamType := CMT.ET_CAMTYPE.Poly5Com;

astCam[3].astCamPoint[3].lrX := 360;
astCam[3].astCamPoint[3].lrY := 270;
astCam[3].astCamPoint[3].lrM := 2;
astCam[3].astCamPoint[3].lrK := 0;
astCam[3].astCamPoint[3].lrLambda := 0;
astCam[3].astCamPoint[3].lrC := 0;
astCam[3].astCamPoint[3].etCamType := CMT.ET_CAMTYPE.Straight;
