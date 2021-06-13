import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:trackingapp/DataModels/Address.dart';
import 'package:trackingapp/DataModels/Prediction.dart';
import 'package:trackingapp/DataProviders/AppData.dart';
import 'package:trackingapp/Helpers/RequestHelper.dart';
import 'package:trackingapp/Widgets/User/GlobalVariables.dart';
import 'package:trackingapp/Widgets/User/ProgressDialog.dart';
import 'package:trackingapp/brand_colors.dart';

class PredictionTile extends StatelessWidget {

  final Prediction prediction;
   PredictionTile({this.prediction});

   void getPlaceDetails(String placeId,context) async{

     showDialog(
       barrierDismissible: false,
         context: context,
         builder: (BuildContext context) => ProgressDialog(status: "Please Wait...",)
     );

     String url="https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$mapKey";
     var response= await RequestHelper.getRequest(url);
     if(response=="Failed"){
       return;
     }
     if(response['status']=='OK'){

       Navigator.pop(context);

      Address thisPlace=Address();

      thisPlace.placeName=response['result']['name'];
      thisPlace.placeId=placeId;
      thisPlace.latitude=response['result']['geometry']['location']['lat'];
      thisPlace.longitude=response['result']['geometry']['location']['lng'];

      Provider.of<AppData>(context,listen: false).updateDestinationAddress(thisPlace);

     }
     Navigator.pop(context,"getDirection");
   }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.black87
      ),
      onPressed: (){
        getPlaceDetails(prediction.placeId, context);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height*0.01,
            ),
            Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                Icon(OMIcons.locationOn,color: BrandColors.colorDimText,),
                SizedBox(width: MediaQuery.of(context).size.width*0.04,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prediction.mainText,
                        maxLines: 3,
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.01,
                      ),
                      Text(
                        prediction.secondaryText,
                        maxLines: 3,
                        style: TextStyle(
                            fontSize: 12,
                            color: BrandColors.colorDimText
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.01,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}