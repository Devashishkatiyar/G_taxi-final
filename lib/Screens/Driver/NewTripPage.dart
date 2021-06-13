import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trackingapp/DataModels/TripDetails.dart';
import 'package:trackingapp/Helpers/HelperMethods.dart';
import 'package:trackingapp/Helpers/MapKitHelper.dart';
import 'package:trackingapp/Widgets/Driver/CollectPaymentDialog.dart';
import 'package:trackingapp/Widgets/User/GlobalVariables.dart';
import 'package:trackingapp/Widgets/User/ProgressDialog.dart';
import 'package:trackingapp/Widgets/User/SnackBar.dart';
import 'package:trackingapp/Widgets/User/TaxiButton.dart';
import 'package:trackingapp/brand_colors.dart';


class NewTripPage extends StatefulWidget {
  static const String id = "NewTripRequest";
  const NewTripPage({Key key}) : super(key: key);

  @override
  _NewTripPageState createState() => _NewTripPageState();
}

class _NewTripPageState extends State<NewTripPage> {

  GoogleMapController rideMapController;
  Completer<GoogleMapController> _controller = Completer();
  Set<Polyline> polyLinesSet = Set<Polyline>();
  Set<Marker> markers = Set<Marker>();
  Set<Circle> circles = Set<Circle>();
  List<LatLng> polyLineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  TripDetails tripDetails;
  Position myPosition;
  String status = "accepted";
  String durationString = "";

  bool isRequestingDirection = false;
  DatabaseReference rideRef;
  String buttonTitle = "ARRIVED";
  Color buttonColor = BrandColors.colorGreen;
  Timer timer;
  int durationCounter = 0;

  void acceptTrip(){
    String rideId = tripDetails.rideId;
    rideRef = FirebaseDatabase.instance.reference().child("Ride Request/$rideId");
    rideRef.update({
      "status":"accepted",
      "driver_name":"${currentDriverInfo.name}",
      "car_details":"${currentDriverInfo.carColour} - ${currentDriverInfo.carModel}",
      "driver_phone":"${currentDriverInfo.phoneNumber}",
      "driver_id":"${currentDriverInfo.uId}",
    });

    Map locationMap =  {
      "latitude":"${currentDriverInfo.currentPosition.latitude}",
      "longitude":"${currentDriverInfo.currentPosition.longitude}",
    };

    rideRef.child("driver_location").set(locationMap);

    DatabaseReference historyRef = FirebaseDatabase.instance.reference().child("Drivers/DriversData/${currentDriverInfo.uId}/history/$rideId");
    historyRef.set(true);

  }

   BitmapDescriptor movingMarkerIcon;

  void createMarker(){
    if(movingMarkerIcon==null){
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context,size: Size(2,2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car_android.png").then((icon) {
        movingMarkerIcon = icon;
      });
    }
  }


  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   Future.delayed(Duration.zero,(){
  //
  //     print(tripDetails.rideId);
  //   });
  //   acceptTrip();
  // }
  // @override
  Widget build(BuildContext context) {
   tripDetails = ModalRoute.of(context).settings.arguments;
   createMarker();
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.terrain,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            circles:  circles,
            polylines: polyLinesSet,
            markers: markers,
            padding: EdgeInsets.only(top: MediaQuery
                .of(context)
                .size
                .height * 0.42,bottom: MediaQuery.of(context).size.height * 0.35),
            initialCameraPosition: CameraPosition(
              target: LatLng(currentDriverInfo.currentPosition.latitude,currentDriverInfo.currentPosition.longitude),
              zoom: 13,
            ),
            onMapCreated: (GoogleMapController controller) async{
              _controller.complete(controller);
              rideMapController = controller;
              var currentLatLng = LatLng(currentDriverInfo.currentPosition.latitude,currentDriverInfo.currentPosition.longitude);
              var pickUpLatLng = tripDetails.pickUp;

              await getDirection(currentLatLng,pickUpLatLng);
              getLocationUpdates(context);

            },
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.34,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.02,
                  ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.07,
                    ),
                    Text(
                        (durationString=="")?"Journey Duration":durationString.split(" ").first+ " " + durationString.split(" ").last.replaceFirst("m", "M"),
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Brand-Bold",
                        color: BrandColors.colorAccentPurple
                    ),
              ),
                  ],
                ),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.02,
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.07,
                  ),
                  Text(
                    tripDetails.riderName,
                    style: TextStyle(fontSize: 22, fontFamily: "Brand-Bold"),),
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.3,
                  ),
                  Icon(
                    Icons.call,
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.02,
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.07,
                  ),
                  Image.asset("images/pickicon.png", height: 16, width: 16,),
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.05,
                  ),
                  Expanded(
                    child: Text(
                      tripDetails.pickupAddress,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.02,
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.07,
                  ),
                  Image.asset("images/desticon.png", height: 16, width: 16,),
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.05,
                  ),
                  Expanded(
                    child: Text(
                      tripDetails.destinationAddress,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: TaxiButton(
                      title: buttonTitle,
                      bgColor: buttonColor,
                      onPressed: ()async{

                        if(status=="accepted"){
                          status = "arrived";
                          rideRef.child("status").set("arrived");
                          setState(() {
                            buttonTitle = "START TRIP";
                            buttonColor = BrandColors.colorAccentPurple;
                          });

                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context){
                                return ProgressDialog(
                                  status: "Please Wait...",
                                );
                              }
                          );
                          await getDirection(tripDetails.pickUp, tripDetails.destination);
                          Navigator.pop(context);
                        }
                        else if(status == "arrived"){
                          status = "ontrip";
                          rideRef.child("status").set("ontrip");
                          setState(() {
                            buttonTitle = "END TRIP";
                            buttonColor = Colors.red[900];
                          });
                          startTimer();
                        }
                        else if(status == "ontrip"){
                          endTrip();
                        }

                      },
                    ),
                  )
              ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getLocationUpdates(context){
    
    LatLng oldPosition = LatLng(0,0);
    
    ridePositionStream = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high).listen((Position position) {
      myPosition = position;
      currentDriverInfo.currentPosition = position;
      print(position);
      LatLng pos = LatLng(position.latitude, position.longitude);

      var rotation = MapKitHelper.getMarkerRotation(oldPosition.latitude, oldPosition.longitude, pos.latitude, pos.longitude);


      Marker movingMarker = Marker(
        markerId: MarkerId("moving"),
        position: pos,
        icon: movingMarkerIcon,
        rotation: rotation,
        infoWindow: InfoWindow(title: "Current Location")
      );

      setState(() {
        CameraPosition cp = CameraPosition(target: pos,zoom: 13);
        rideMapController.animateCamera(CameraUpdate.newCameraPosition(cp));
        markers.removeWhere((marker) => marker.markerId.value == "moving");
        markers.add(movingMarker);
      });

      oldPosition = pos;

      updateTripDetails(context);

      Map locationMap = {
        "latitude":myPosition.latitude.toString(),
        "longitude":myPosition.longitude.toString(),
      };

      rideRef.child("driver_location").set(locationMap);

    });
  }

  Future<void> getDirection(LatLng pickUpLatLng,LatLng destinationLatLng) async {

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
          status: "Please Wait...",
        ));

    var thisDetails =
    await HelperMethods.getDirectionDetails(pickUpLatLng, destinationLatLng);

    Navigator.pop(context);

    List<PointLatLng> results =
    polylinePoints.decodePolyline(thisDetails.encodedPoints);

    polyLineCoordinates.clear();

    if (results.isNotEmpty) {
      //iterate over each points and covert it into latitude & Longitude

      results.forEach((PointLatLng point) {
        polyLineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    polyLinesSet.clear();
    setState(() {
      Polyline polyLine = Polyline(
        polylineId: PolylineId("PolyId"),
        color: Color.fromARGB(255, 95, 109, 237),
        points: polyLineCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polyLinesSet.add(polyLine);
    });

    // Make PolyLine to fit into the Map
    LatLngBounds bounds;
    if (pickUpLatLng.latitude > destinationLatLng.latitude &&
        pickUpLatLng.longitude > destinationLatLng.longitude) {
      bounds =
          LatLngBounds(southwest: destinationLatLng, northeast: pickUpLatLng);
    } else if (pickUpLatLng.longitude > destinationLatLng.longitude) {
      bounds = LatLngBounds(
        southwest: LatLng(pickUpLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, pickUpLatLng.longitude),
      );
    } else if (pickUpLatLng.latitude > destinationLatLng.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, pickUpLatLng.longitude),
        northeast: LatLng(pickUpLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      bounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: destinationLatLng);
    }
    rideMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 160));
    acceptTrip();

    Marker pickUpMarker = Marker(
      markerId: MarkerId("PickUp"),
      position: pickUpLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId("Destination"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );

    setState(() {
      markers.add(pickUpMarker);
      markers.add(destinationMarker);
    });

    Circle pickupCircle = Circle(
      circleId: CircleId("PickUp"),
      strokeColor: Colors.orange[300],
      strokeWidth: 2,
      radius: 10,
      center: pickUpLatLng,
      fillColor: BrandColors.colorOrange,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId("Destination"),
      strokeColor: Colors.blue[300],
      strokeWidth: 2,
      radius: 10,
      center: destinationLatLng,
      fillColor: BrandColors.colorBlue,
    );

    setState(() {
      circles.add(pickupCircle);
      circles.add(destinationCircle);
    });
  }

  Future updateTripDetails(context)async{

    if(myPosition==null){
      return rootScaffoldMessengerKey.currentState.showSnackBar(showSnackBar("Position is Null", context));
    }

    if(!isRequestingDirection){

      isRequestingDirection = true;
      var positionLatLng = LatLng(myPosition.latitude, myPosition.longitude);
      LatLng destinationLatLng;

      if(status=="accepted"){
        destinationLatLng = tripDetails.pickUp;
      }
      else{
        destinationLatLng = tripDetails.destination;
      }
      var directionDetails = await HelperMethods.getDirectionDetails(positionLatLng, destinationLatLng);

      if(directionDetails!=null){

        print(directionDetails.durationText);

        setState(() {
          durationString = directionDetails.durationText;
        });
      }

      isRequestingDirection = false;

    }

  }

  void startTimer(){
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {
      durationCounter+=1;
    });
  }

  void endTrip() async {

    timer.cancel();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
          return ProgressDialog(
            status: "Please Wait...",
          );
        }
    );
    var currentLatLng = LatLng(myPosition.latitude, myPosition.longitude);
    var directionDetails = await HelperMethods.getDirectionDetails(tripDetails.pickUp,  currentLatLng);

    Navigator.pop(context);

    int fares = HelperMethods.estimateFares(directionDetails, durationCounter);

    rideRef.child("fares").set(fares.toString());
    rideRef.child("status").set("ended");
    ridePositionStream.cancel();

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
          return CollectPayment(
            fares: fares,
          );
        }
    );

    topUpEarnings(fares);

  }

  void topUpEarnings(int fares){
    DatabaseReference earningsRef = FirebaseDatabase.instance.reference().child("Drivers/DriversData/${currentDriverInfo.uId}/earnings");
    earningsRef.once().then((DataSnapshot snapshot) {
      print(1);
      if(snapshot.value!=null){
        double oldEarnings = double.parse(snapshot.value.toString());

        double adjustedFares = (fares.toDouble()*0.85) + oldEarnings;
        
        earningsRef.set(adjustedFares.toStringAsFixed(2));
      }
      else{
        print(2);
        double adjustedFares = (fares.toDouble()*0.85);
        earningsRef.set(adjustedFares.toStringAsFixed(2));
      }
    });
  }

}
