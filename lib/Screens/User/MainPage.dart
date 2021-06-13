import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:trackingapp/DataModels/DirectionDetails.dart';
import 'package:trackingapp/DataModels/NearbyDriver.dart';
import 'package:trackingapp/DataProviders/AppData.dart';
import 'package:trackingapp/Helpers/FireHelper.dart';
import 'package:trackingapp/Helpers/HelperMethods.dart';
import 'package:trackingapp/Screens/User/LoginPage.dart';
import 'package:trackingapp/Screens/User/Profile.dart';
import 'package:trackingapp/Styles/Styles.dart';
import 'package:trackingapp/Widgets/User/CollectPaymentDialogUser.dart';
import 'package:trackingapp/Widgets/User/GlobalVariables.dart';
import 'package:trackingapp/Widgets/User/NoDriverDialog.dart';
import 'package:trackingapp/Widgets/User/ProgressDialog.dart';
import 'package:trackingapp/Widgets/User/TaxiButton.dart';
import 'package:trackingapp/brand_colors.dart';
import 'package:trackingapp/Screens/User/SearchPage.dart';

import 'Rentals.dart';

class MainPage extends StatefulWidget {
  static const String id = "MainPage";

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  FirebaseAuth auth = FirebaseAuth.instance;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  double mapBottomPadding = 0;
  double rideDetailSheet = 0;
  double searchDetailSheet = 0;
  double rideRequestSheet = 0;
  bool drawerCanOpen = true;

  BitmapDescriptor nearbyIcon;

  List<LatLng> polyLineCoordinates = [];
  Set<Polyline> polyLinesSet = {};
  Set<Marker> markers = {};
  Set<Circle> circles = {};
  List<NearbyDriver> availableDrivers;
  String status = "";
  String driverCarDetails = "";
  String driverName = "";
  String driverPhone = "";
  String tripStatusDisplay = "Driver is Arriving";

  DirectionDetails tripDirectionDetails;

  DatabaseReference rideRef;

  StreamSubscription<Event> rideSubscription;

  bool nearbyDriversKeyLoaded = false;
  int driverRequestTimeOut = 20;

  String appState = "NORMAL";

  double tripSheetHeight = 0;

  bool isRequestingLocationDetails = false;

  void signOut() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Are you sure you want to proceed?",
              style: TextStyle(fontSize: 18),
            ),
            backgroundColor: Colors.white,
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  primary: BrandColors.colorAccent,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  side: BorderSide(
                    width: 1.5,
                    color: BrandColors.colorAccent,
                  ),
                ),
                onPressed: () async {
                  await auth.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginPage.id, (route) => false);
                },
                child: Text("YES"),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.red.shade600,
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    width: 1.5,
                    color: Colors.red.shade600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("NO"),
              ),
            ],
          );
        });
  }

  void setupPositionLocator() async {
    String address =
        await HelperMethods.findCoordinatesAddress(currentUserInfo.currentPosition, context);
    LatLng pos = LatLng(currentUserInfo.currentPosition.latitude,currentUserInfo.currentPosition.longitude);
    mapController.animateCamera(CameraUpdate.newLatLng(pos));
    startGeoFireListener();
  }

  void showDetailsSheet() async {
    await getDirection();
    setState(() {
      searchDetailSheet = 0;
      rideDetailSheet = MediaQuery.of(context).size.height * 0.36;
      drawerCanOpen = false;
    });
  }

  void showRequestingSheet() {
    setState(() {
      rideDetailSheet = 0;
      rideRequestSheet = MediaQuery.of(context).size.height * 0.36;
      drawerCanOpen = true;
    });
    createRideRequest();
  }

  void showTripSheet(){
    setState(() {
      rideRequestSheet = 0;
      tripSheetHeight = MediaQuery.of(context).size.height * 0.40;
      mapBottomPadding = MediaQuery.of(context).size.height * 0.41;
    });
  }

  void createMarker(){
    if(nearbyIcon==null){
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context,size: Size(2,2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car_android.png").then((icon) {
        nearbyIcon = icon;
      });
    }
  }

  //  @override
  //  void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //
  // }

  @override
  Widget build(BuildContext context) {
    searchDetailSheet = MediaQuery.of(context).size.height * 0.36;
    createMarker();
    return Scaffold(
      key: scaffoldKey,
      drawer: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width * 0.6,
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.all(0),
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.32,
                  // color: Colors.white,
                  child: DrawerHeader(
                    child: Row(
                      children: [
                        Image.asset(
                          "images/user_icon.png",
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.03,
                        ),
                        Flexible(
                          child: FittedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  currentUserInfo.name,
                                  style: TextStyle(
                                      // fontSize: 20,
                                      fontFamily: "Brand-Bold"),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.005,
                                ),
                                GestureDetector(
                                    child: Text("View Profile"),
                                  onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(OMIcons.cardGiftcard),
                  title: Text(
                    "Free Rides",
                    style: kDrawerItemStyle,
                  ),
                ),
                ListTile(
                  leading: Icon(OMIcons.creditCard),
                  title: Text(
                    "Payments",
                    style: kDrawerItemStyle,
                  ),
                ),
                ListTile(
                  leading: Icon(OMIcons.history),
                  title: Text(
                    "Ride History",
                    style: kDrawerItemStyle,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Rentals()));
                  },
                  leading: Icon(OMIcons.localTaxi),
                  title: Text(
                    "Rentals",
                    style: kDrawerItemStyle,
                  ),
                ),
                ListTile(
                  leading: Icon(OMIcons.contactSupport),
                  title: Text(
                    "Support",
                    style: kDrawerItemStyle,
                  ),
                ),
                ListTile(
                  leading: Icon(OMIcons.info),
                  title: Text(
                    "About",
                    style: kDrawerItemStyle,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(
                    "Sign Out",
                    style: kDrawerItemStyle,
                  ),
                  onTap: signOut,
                ),
              ],
            ),
          )),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.terrain,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            padding: EdgeInsets.only(
              bottom: mapBottomPadding,
              top: MediaQuery.of(context).size.height * 0.38,
            ),
            initialCameraPosition: CameraPosition(
              target: LatLng(currentUserInfo.currentPosition.latitude,currentUserInfo.currentPosition.longitude),
              zoom: 13,
            ),
            polylines: polyLinesSet,
            markers: markers,
            circles: circles,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              mapController = controller;
              setState(() {
                mapBottomPadding = MediaQuery.of(context).size.height * 0.37;
              });

              setupPositionLocator();
            },
          ),

          /// Menu Button

          Positioned(
            top: 50,
            left: 18,
            child: GestureDetector(
              onTap: () {
                if (drawerCanOpen) {
                  scaffoldKey.currentState.openDrawer();
                } else {
                  resetApp();
                }
              },
              child: Container(
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
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon(
                    (drawerCanOpen) ? Icons.menu : Icons.arrow_back,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),

          /// Search Sheet

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSize(
              vsync: this,
              duration: Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                height: searchDetailSheet,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7)),
                    ]),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Text(
                        "Nice to see you",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "Where are you going",
                        style:
                            TextStyle(fontSize: 18, fontFamily: "Brand-Bold"),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      GestureDetector(
                        onTap: () async {
                          var response =
                              await Navigator.pushNamed(context, SearchPage.id);
                          if (response == "getDirection") {
                            showDetailsSheet();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    spreadRadius: 0.5,
                                    offset: Offset(0.7, 0.7)),
                              ]),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.blueAccent,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                Text("Search Destination"),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Row(
                        children: [
                          Icon(
                            OMIcons.home,
                            color: BrandColors.colorDimText,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Add Home"),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.005,
                              ),
                              Text(
                                "Your Residential Address",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: BrandColors.colorDimText,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Divider(
                        height: 1,
                        color: Color(0xFFE2E2E2),
                        thickness: 1.0,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Row(
                        children: [
                          Icon(
                            OMIcons.workOutline,
                            color: BrandColors.colorDimText,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Add Work"),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.005,
                              ),
                              Text(
                                "Your Office Address",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: BrandColors.colorDimText,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          ///  Ride Details Sheet

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              vsync: this,
              duration: Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ]),
                height: rideDetailSheet,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Container(
                      width: double.infinity,
                      color: BrandColors.colorAccent1,
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.06,
                          ),
                          Image.asset(
                            "images/taxi.png",
                            height: 70,
                            width: 70,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Taxi",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Brand-Bold",
                                ),
                              ),
                              Text(
                                tripDirectionDetails != null
                                    ? tripDirectionDetails.distanceText
                                    : "",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: BrandColors.colorTextLight,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.40,
                          ),
                          // Text(
                          //   "\u20B9" +
                          //       (tripDirectionDetails != null
                          //           ? "${HelperMethods.estimateFaresUser(tripDirectionDetails)}"
                          //           : ""),
                          //   style: TextStyle(
                          //     fontSize: 18,
                          //     fontFamily: "Brand-Bold",
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Icon(FontAwesomeIcons.moneyBillAlt,
                            size: 18, color: BrandColors.colorTextLight),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.03,
                        ),
                        Text("Cash"),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.01,
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: BrandColors.colorTextLight,
                          size: 16,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: TaxiButton(
                        title: "REQUEST CAB",
                        bgColor: BrandColors.colorGreen,
                        onPressed: () {
                          appState = "REQUESTING";
                          showRequestingSheet();
                          availableDrivers = FireHelper.nearbyDriverList;
                          print("234567"+"$availableDrivers");
                          findDrivers();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          ///  Request Ride Sheet

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSize(
              vsync: this,
              duration: Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                height: rideRequestSheet,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7)),
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    DefaultTextStyle(
                      style: TextStyle(
                          fontFamily: "Brand-Bold",
                          fontSize: 22.0,
                          color: BrandColors.colorText,
                          letterSpacing: 1.5),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          WavyAnimatedText('Requesting a Ride...',
                              speed: Duration(milliseconds: 200)),
                          WavyAnimatedText(
                            'Please Wait...',
                            speed: Duration(milliseconds: 200),
                          ),
                        ],
                        isRepeatingAnimation: true,
                        repeatForever: true,
                        onTap: () {
                          print("Tap Event");
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    GestureDetector(
                      onTap: () {
                        cancelRequest();
                        resetApp();
                      },
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35),
                          border: Border.all(
                              width: 1.0,
                              color: BrandColors.colorLightGrayFair),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 25,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Text(
                      "Cancel Ride",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),

          ///  Trip Sheet

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              vsync: this,
              duration: new Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15.0, // soften the shadow
                      spreadRadius: 0.5, //extend the shadow
                      offset: Offset(
                        0.7, // Move to right 10  horizontally
                        0.7, // Move to bottom 10 Vertically
                      ),
                    )
                  ],
                ),
                height: tripSheetHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tripStatusDisplay,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),

                    Divider(
                      height: 2,
                      thickness: 1.5,
                      indent: 10,
                      endIndent: 10,
                      color: BrandColors.colorLightGrayFair,
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),

                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.06,
                        ),
                        Text(driverCarDetails, style: TextStyle(color: BrandColors.colorTextLight),),
                      ],
                    ),

                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.06,
                        ),
                        Text(driverName, style: TextStyle(fontSize: 20),),
                      ],
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),

                    Divider(
                      height: 2,
                      thickness: 1.5,
                      indent: 10,
                      endIndent: 10,
                      color: BrandColors.colorLightGrayFair,
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular((25))),
                                border: Border.all(width: 1.0, color: BrandColors.colorTextLight),
                              ),
                              child: Icon(Icons.call),
                            ),

                            SizedBox(height: 10,),

                            Text('Call'),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular((25))),
                                border: Border.all(width: 1.0, color: BrandColors.colorTextLight),
                              ),
                              child: Icon(Icons.list),
                            ),

                            SizedBox(height: 10,),

                            Text('Details'),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular((25))),
                                border: Border.all(width: 1.0, color: BrandColors.colorTextLight),
                              ),
                              child: Icon(OMIcons.clear),
                            ),

                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),

                            Text('Cancel'),
                          ],
                        ),

                      ],
                    )

                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Future<void> getDirection() async {
    var pickUp = Provider.of<AppData>(context, listen: false).pickupAddress;
    var destination =
        Provider.of<AppData>(context, listen: false).destinationAddress;

    var pickLatLng = LatLng(pickUp.latitude, pickUp.longitude);
    var destinationLatLng = LatLng(destination.latitude, destination.longitude);

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              status: "Please Wait...",
            ));

    var thisDetails =
        await HelperMethods.getDirectionDetails(pickLatLng, destinationLatLng);

    setState(() {
      tripDirectionDetails = thisDetails;
    });

    Navigator.pop(context);

    PolylinePoints polyLinePoints = PolylinePoints();
    List<PointLatLng> results =
        polyLinePoints.decodePolyline(thisDetails.encodedPoints);

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
    if (pickLatLng.latitude > destinationLatLng.latitude &&
        pickLatLng.longitude > destinationLatLng.longitude) {
      bounds =
          LatLngBounds(southwest: destinationLatLng, northeast: pickLatLng);
    } else if (pickLatLng.longitude > destinationLatLng.longitude) {
      bounds = LatLngBounds(
        southwest: LatLng(pickLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, pickLatLng.longitude),
      );
    } else if (pickLatLng.latitude > destinationLatLng.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, pickLatLng.longitude),
        northeast: LatLng(pickLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      bounds =
          LatLngBounds(southwest: pickLatLng, northeast: destinationLatLng);
    }
    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 10));

    Marker pickUpMarker = Marker(
      markerId: MarkerId("PickUp"),
      position: pickLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      infoWindow: InfoWindow(title: "Current Location"),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId("Destination"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: InfoWindow(
        title: "Destination",
      ),
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
      center: pickLatLng,
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

  void startGeoFireListener(){
    
    Geofire.initialize("driversAvailable");

    Geofire.queryAtLocation(currentUserInfo.currentPosition.latitude, currentUserInfo.currentPosition.longitude, 10).listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        switch (callBack) {
          case Geofire.onKeyEntered:

            NearbyDriver nearbyDriver = NearbyDriver();
            nearbyDriver.key = map["key"];
            nearbyDriver.latitude = map["latitude"];
            nearbyDriver.longitude = map["longitude"];
            
            FireHelper.nearbyDriverList.add(nearbyDriver);

            if(nearbyDriversKeyLoaded==true){
              updateDriversOnMap();
            }
            break;

          case Geofire.onKeyExited:

            if(FireHelper.nearbyDriverList.length>0){
              print("Hello");
              FireHelper.removedFromList(map["key"]);
            }
            updateDriversOnMap();
            break;

          case Geofire.onKeyMoved:
          // Update your key's location
            NearbyDriver nearbyDriver = NearbyDriver();
            nearbyDriver.key = map["key"];
            nearbyDriver.latitude = map["latitude"];
            nearbyDriver.longitude = map["longitude"];

            FireHelper.updateNearbyLocation(nearbyDriver);
            updateDriversOnMap();
            break;

          case Geofire.onGeoQueryReady:
          // All Initial Data is loaded
            nearbyDriversKeyLoaded = true;
            updateDriversOnMap();
            break;
        }
      }

      // setState(() {});
  });
  }

  void updateDriversOnMap(){

    setState(() {
      markers.clear();
    });

    Set<Marker> tempMarkers = Set<Marker>();
    for(NearbyDriver driver in FireHelper.nearbyDriverList){
      LatLng driverPosition = LatLng(driver.latitude, driver.longitude);
      Marker thisMarker = Marker(
        markerId: MarkerId("driver${driver.key}"),
        position: driverPosition,
        icon: nearbyIcon,
        rotation:HelperMethods.generateRandomNumber(360),
      );

      tempMarkers.add(thisMarker);

    }

    setState(() {
      markers = tempMarkers;
    });

  }

  void createRideRequest() {
    rideRef =
        FirebaseDatabase.instance.reference().child("Ride Request").push();
    print(rideRef);

    var pickUp = Provider.of<AppData>(context, listen: false).pickupAddress;
    var destination =
        Provider.of<AppData>(context, listen: false).destinationAddress;

    Map pickUpMap = {
      "latitude": pickUp.latitude.toString(),
      "longitude": pickUp.longitude.toString()
    };

    Map destinationMap = {
      "latitude": destination.latitude.toString(),
      "longitude": destination.longitude.toString()
    };

    Map rideMap = {
      "created_at": DateTime.now().toString(),
      "rider_name": currentUserInfo.name,
      "phone_number": currentUserInfo.phoneNumber,
      "pickup_address": pickUp.placeName,
      "destination_address": destination.placeName,
      "location": pickUpMap,
      "destination": destinationMap,
      "driver_id": "waiting",
    };

    rideRef.set(rideMap);
    rideSubscription = rideRef.onValue.listen((event) async{
      if(event.snapshot.value == null){
       print("Value is null");
      }

      ///Get Car Details

      if(event.snapshot.value["car_details"]!=null){
        setState(() {
          driverCarDetails = event.snapshot.value["car_details"].toString();
        });
      }
      ///Get Driver Name

      if(event.snapshot.value["driver_name"]!=null){
        setState(() {
          driverName = event.snapshot.value["driver_name"].toString();
        });
      }
      ///Get Driver Phone number

      if(event.snapshot.value["driver_phone"]!=null){
        setState(() {
          driverPhone = event.snapshot.value["driver_phone"].toString();
        });
      }

      ///Get and USe Driver Location Updates
      if(event.snapshot.value["driver_location"]!=null){
        double driverLat = double.parse(event.snapshot.value["driver_location"]["latitude"].toString());
        double driverLng = double.parse(event.snapshot.value["driver_location"]["longitude"].toString());
        LatLng driverLocation = LatLng(driverLat,driverLng);
        if(status=="accepted"){
          updateToPickUp(driverLocation);
        }
        else if(status=="ontrip"){
          updateToDestination(driverLocation);
        }
        else if(status=="arrived"){
          setState(() {
            tripStatusDisplay = "Driver has arrived";
          });
        }

      }

      if(event.snapshot.value["status"]!=null){
        setState(() {
          status = event.snapshot.value["status"].toString();
        });
      }
      if(status=="accepted"){
        showTripSheet();
        Geofire.stopListener();
        removeGeoFireMarkers();
      }

      if(status=="ended"){
        if(event.snapshot.value["fares"]!=null){
          int fares = int.parse(event.snapshot.value["fares"].toString());
          var response = await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context){
                return CollectPaymentUser(fares: fares,);
              }
          );
          if(response=="close"){
            rideRef.onDisconnect();
            rideRef = null;
            rideSubscription.cancel();
            rideSubscription = null;
            resetApp();
          }
        }
      }

    });

  }

  void removeGeoFireMarkers(){
    setState(() {
      markers.removeWhere((m) => m.markerId.value.contains("driver"));
    });
  }

  void updateToPickUp(LatLng driverLocation)async{

    if(!isRequestingLocationDetails){
      isRequestingLocationDetails = true;
      var positionLatLng = LatLng(currentUserInfo.currentPosition.latitude,currentUserInfo.currentPosition.longitude);
      var thisDetails = await HelperMethods.getDirectionDetails(driverLocation, positionLatLng);
      if(thisDetails==null){
        print("details are Empty");
      }
      else{
        setState(() {
          tripStatusDisplay = "Driver is Arriving - ${thisDetails.durationText}";
        });
      }
      isRequestingLocationDetails = false;
    }

  }

  void updateToDestination(LatLng driverLocation)async{

    if(!isRequestingLocationDetails){
      isRequestingLocationDetails = true;
      var destination = Provider.of<AppData>(context).destinationAddress;
      var destinationLatLng = LatLng(destination.latitude,destination.longitude);
      var thisDetails = await HelperMethods.getDirectionDetails(driverLocation, destinationLatLng);
      if(thisDetails==null){
        print("details are Empty");
      }
      else{
        setState(() {
          tripStatusDisplay = "Driver to Destination - ${thisDetails.durationText}";
        });
      }
      isRequestingLocationDetails = false;
    }

  }

  void cancelRequest() {
    rideRef.remove();
    appState = "NORMAL";
  }

  resetApp() {
    setState(() {
      polyLineCoordinates.clear();
      polyLinesSet.clear();
      markers.clear();
      circles.clear();
      rideDetailSheet = 0;
      rideRequestSheet = 0;
      tripSheetHeight = 0;
      searchDetailSheet = MediaQuery.of(context).size.height * 0.36;
      drawerCanOpen = true;
      status = "";
      driverCarDetails = "";
      driverName = "";
      driverPhone = "";
      tripStatusDisplay = "Driver is Arriving";
    });
    setupPositionLocator();
  }

  void noDriverFound(){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
          return NoDriverDialog();
        }
    );
  }

  void findDrivers(){
    print(availableDrivers.length);
    if(availableDrivers.length == 0){
      cancelRequest();
      noDriverFound();
      resetApp();
    }
    else{
      var driver = availableDrivers[0];
      notifyDrivers(driver);
      availableDrivers.removeAt(0);
      print(driver.key);
    }
  }

  void notifyDrivers(NearbyDriver driver){
    DatabaseReference driverTripRef = FirebaseDatabase.instance.reference().child("Drivers/DriversData/${driver.key}/new_trip");
    driverTripRef.set(rideRef.key);

    ///Get and Notify Driver using Token
    DatabaseReference tokenRef = FirebaseDatabase.instance.reference().child("Drivers/DriversData/${driver.key}/token");
    tokenRef.once().then((DataSnapshot snapshot) {
      if(snapshot.value!=null){
        String token = snapshot.value.toString();
        ///Send push notification to selected driver
        HelperMethods.sendNotifications(token, context, rideRef.key);
      }
    });
    const oneSecTick = Duration(seconds: 1);
    var timer = Timer.periodic(oneSecTick, (timer){

      ///Stop timer when Ride request is cancelled
      if(appState != "REQUESTING"){
        driverTripRef.set("cancelled");
        driverTripRef.onDisconnect();
        timer.cancel();
        driverRequestTimeOut = 20;
      }

      driverRequestTimeOut--;
      print("Hello"+ "$driverRequestTimeOut");

      /// A value event listener for driver accepting trip request

      driverTripRef.onValue.listen((event) {
        /// Confirms that driver has clicked accepted for the new trip request
        if(event.snapshot.value.toString() == "accepted"){

          driverTripRef.onDisconnect();
          timer.cancel();
          driverRequestTimeOut = 20;
        }
      });

      if(driverRequestTimeOut==0){

        ///Informs Driver that Request Has TimedOut

        driverTripRef.set("timeout");
        driverTripRef.onDisconnect();
        driverRequestTimeOut = 20;
        timer.cancel();

        ///Select New Driver
        print("Good Morning");
        findDrivers();

      }
    });
  }
}
