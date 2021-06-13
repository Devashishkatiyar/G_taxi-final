import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackingapp/DataModels/Prediction.dart';
import 'package:trackingapp/DataProviders/AppData.dart';
import 'package:trackingapp/Helpers/RequestHelper.dart';
import 'package:trackingapp/Widgets/User/GlobalVariables.dart';
import 'package:trackingapp/Widgets/User/PredictionTile.dart';
import 'package:trackingapp/brand_colors.dart';

class SearchPage extends StatefulWidget {
  static const String id= "SearchPage";
  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

   var pickupController= TextEditingController();
   var destinationController=TextEditingController();
   // var focusDestination = FocusNode();
   // bool focused = false;
   //  void setFocus(){
   //    if(!focused){
   //      FocusScope.of(context).requestFocus(focusDestination);
   //      focused=true;
   //    }
   //  }
   List<Prediction> destinationPredictionList=[];
   void searchPlace(String placeName) async {
     if (placeName.length > 1) {
       String url= "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=123254251&components=country:in";
       var response = await RequestHelper.getRequest(url);
       if (response=="Failed"){
         return;
       }
       if(response['status']=='OK'){
         var predictionJson = response['predictions'];
         var thisList = (predictionJson as List).map((e) => Prediction.fromJson(e)).toList();
         setState(() {
           destinationPredictionList=thisList;
         });
       }
     }
   }


  @override
  Widget build(BuildContext context) {

      // setFocus();

    String address = Provider.of<AppData>(context).pickupAddress.placeName??"";
    pickupController.text = address;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.29,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                      blurRadius: 5.0,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.7,
                        0.7
                      ),
                    ),
                  ]
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.01,
                        ),
                        IconButton(
                            icon: Icon(Icons.arrow_back),
                          onPressed: (){
                              Navigator.pop(context);
                          },
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.2,
                        ),
                        Text(
                            "Set Destination",
                          style: TextStyle(
                            fontFamily: "Brand-Bold",
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.02,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.05,
                        ),
                        Image.asset("images/pickicon.png",height: 20,width: 20,),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.05,
                        ),
                        Expanded(
                          child: Container(
                            // height: 50,
                            decoration: BoxDecoration(
                              color: BrandColors.colorLightGrayFair,
                              borderRadius: BorderRadius.circular(8)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: pickupController,
                                decoration: InputDecoration(
                                  hintText: "PickUp Location",
                                  fillColor: BrandColors.colorLightGrayFair,
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(left: 10,top: 8,bottom: 8)
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.05,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.02,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.05,
                        ),
                        Image.asset("images/desticon.png",height: 20,width: 20,),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.05,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: BrandColors.colorLightGrayFair,
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                // focusNode: focusDestination,
                                autofocus: true,
                                controller: destinationController,
                                onChanged: (value){
                                  searchPlace(value);
                                },
                                decoration: InputDecoration(
                                    hintText: "Where To?",
                                    fillColor: BrandColors.colorLightGrayFair,
                                    filled: true,
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(left: 10,top: 8,bottom: 8)
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.05,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              (destinationPredictionList.length>0)?
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: ListView.separated(
                    itemBuilder: (context,index){
                      return PredictionTile(
                        prediction: destinationPredictionList[index],
                      );
                    },
                    separatorBuilder: (BuildContext context,int index)=> Divider(
                      thickness: 1.5,
                      height: 3,
                      indent: 15,
                      endIndent: 15,
                      color: Colors.black26
                    ),
                    itemCount: destinationPredictionList.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                ),
              ):
                  Container(),
            ],
          ),
        ),
      ),
    );
  }
}


