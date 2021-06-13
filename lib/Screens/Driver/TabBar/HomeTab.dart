import 'dart:async';
import 'package:provider/provider.dart';
import 'package:trackingapp/DataProviders/AppData.dart';
import 'package:trackingapp/Helpers/HelperMethods.dart';
import 'package:trackingapp/Helpers/PushNotificationService.dart';
import 'package:trackingapp/Widgets/Driver/ConfirmSheet.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trackingapp/Widgets/User/GlobalVariables.dart';
import 'package:trackingapp/Widgets/User/TaxiButton.dart';
import 'package:trackingapp/brand_colors.dart';

class HomeTab extends StatefulWidget {
  Position coordinate;
  HomeTab({Key key,this.coordinate}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller  = Completer();
  double topPadding = 0;
  DatabaseReference tripRequestRef;

  String availabilityTitle = "GO ONLINE";
  Color availabilityColor = BrandColors.colorOrange;
  bool isAvailable = false;

  void setupPositionLocator(){
    LatLng pos = LatLng(widget.coordinate.latitude,widget.coordinate.longitude);
    mapController.animateCamera(CameraUpdate.newLatLng(pos));
  }

  void notificationService()async{
    PushNotificationService pushNotificationService = PushNotificationService();
    pushNotificationService.initialize(context);
    pushNotificationService.getToken();
    HelperMethods.getHistoryInfo(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationService();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.terrain,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          padding: EdgeInsets.only(top: topPadding,),
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.coordinate.latitude,widget.coordinate.longitude),
            zoom: 13,
          ),
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
            mapController = controller;
            setState(() {
              topPadding = MediaQuery.of(context).size.height*0.70;
            });
            setupPositionLocator();
          },
        ),
        Container(
          height: MediaQuery.of(context).size.height*0.23,
          width: MediaQuery.of(context).size.width,
          color: BrandColors.colorPrimary,
        ),
        Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TaxiButton(
                title: availabilityTitle,
                bgColor: availabilityColor,
                onPressed: (){
                  showModalBottomSheet(
                    isDismissible: false,
                      context: context,
                      builder: (BuildContext context) => ConfirmSheet(
                        title: (!isAvailable)?"GO ONLINE":"GO OFFLINE",
                        subtitle: (!isAvailable)?"You are about to become available to receive trip request":"You will stop receiving new request",
                        onPressed: (){
                          if(!isAvailable){
                            goOnline();
                            getLocationUpdates();
                            Navigator.pop(context);
                            setState(() {
                              availabilityColor = BrandColors.colorGreen;
                              availabilityTitle = "GO OFFLINE";
                              isAvailable = true;
                            });
                          }
                          else{
                            goOffline();
                            Navigator.pop(context);
                            setState(() {
                              availabilityColor = BrandColors.colorOrange;
                              availabilityTitle = "GO ONLINE";
                              isAvailable = false;
                            });
                          }
                        },
                      )
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void goOnline(){
    Geofire.initialize("driversAvailable");
    Geofire.setLocation(currentDriverInfo.uId, widget.coordinate.latitude, widget.coordinate.longitude);
    tripRequestRef = FirebaseDatabase.instance.reference().child("Drivers/DriversData/${currentDriverInfo.uId}/new_trip");
    tripRequestRef.set("waiting");

    tripRequestRef.onValue.listen((event) {

    });
  }

  void goOffline(){
    Geofire.removeLocation(currentDriverInfo.uId);
    tripRequestRef.onDisconnect();
    tripRequestRef.remove();
    tripRequestRef = null;
  }

  void getLocationUpdates(){

    homeTabPositionStream = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.bestForNavigation,distanceFilter: 2).listen((Position position) {
      widget.coordinate = position;

      if(isAvailable){
        Geofire.setLocation(currentDriverInfo.uId, position.latitude, position.longitude);
      }

      LatLng pos = LatLng(position.latitude,position.longitude);
      mapController.animateCamera(CameraUpdate.newLatLng(pos));

    });
  }

}
