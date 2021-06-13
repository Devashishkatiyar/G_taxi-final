import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trackingapp/DataModels/DirectionDetails.dart';
import 'package:trackingapp/DataModels/DriverHistory.dart';
import 'package:trackingapp/DataModels/Users.dart';
import 'package:trackingapp/DataProviders/AppData.dart';
import 'package:trackingapp/Helpers/RequestHelper.dart';
import 'package:trackingapp/Widgets/User/GlobalVariables.dart';
import 'package:trackingapp/DataModels/Address.dart';
import 'package:trackingapp/DataModels/Drivers.dart';

class HelperMethods {

  static Future<Position> currentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return position;
  }

  static void getUserInfo() async {
    FirebaseAuth currentFirebaseUser = FirebaseAuth.instance;
    String userId = currentFirebaseUser.currentUser.uid;
    DatabaseReference userRef = FirebaseDatabase.instance.reference().child(
        "Users/UsersData/$userId");
    userRef.once().then((DataSnapshot snapShot) {
      if (snapShot.value != null) {
        currentUserInfo = Users.fromSnapshot(snapShot);
        print(currentUserInfo.name);
      }
    });
  }

  static void getDriverInfo() async {
    FirebaseAuth currentFirebaseDriver = FirebaseAuth.instance;
    String driverId = currentFirebaseDriver.currentUser.uid;
    DatabaseReference userRef = FirebaseDatabase.instance.reference().child(
        "Drivers/DriversData/$driverId");
    userRef.once().then((DataSnapshot snapShot) {
      if (snapShot.value != null) {
        currentDriverInfo = Drivers.fromSnapshot(snapShot);
        print(currentDriverInfo.name);
      }
    });
  }

  static Future<String> findCoordinatesAddress(Position position,
      context) async {
    String placeAddress = "";
    var connectivityStatus = await Connectivity().checkConnectivity();
    if (connectivityStatus != ConnectivityResult.mobile &&
        connectivityStatus != ConnectivityResult.wifi) {
      return placeAddress;
    }
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position
        .latitude},${position.longitude}&key=$mapKey";
    var response = await RequestHelper.getRequest(url);

    if (response != "Failed") {
      placeAddress = response["results"][0]["formatted_address"];
      Address pickupAddress = Address();
      pickupAddress.latitude = position.latitude;
      pickupAddress.longitude = position.longitude;
      pickupAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false).updatePickupAddress(
          pickupAddress);
    }
    return placeAddress;
  }

  static Future<DirectionDetails> getDirectionDetails(LatLng startPosition,
      LatLng endPosition) async {
    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition
        .latitude},${startPosition.longitude}&destination=${endPosition
        .latitude},${endPosition.longitude}&mode=driving&key=$mapKey";
    var response = await RequestHelper.getRequest(url);
    if (response == "Failed") {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.durationText =
    response['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue =
    response['routes'][0]['legs'][0]['duration']['value'];

    directionDetails.distanceText =
    response['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue =
    response['routes'][0]['legs'][0]['distance']['value'];

    directionDetails.encodedPoints =
    response['routes'][0]['overview_polyline']['points'];

    return directionDetails;
  }

  static int estimateFaresUser(DirectionDetails direction) {
    /// per km Rs-8
    /// per minute Rs-6
    /// base fare Rs 40
    double baseFare = 40;
    double distanceFare = (direction.distanceValue / 1000) * 8;
    double timeFare = (direction.durationValue / 60) * 6;
    double totalFare = baseFare + distanceFare + timeFare;

    return totalFare.truncate();
  }

  static int estimateFares(DirectionDetails direction, int durationValue) {
    /// per km Rs-8
    /// per minute Rs-6
    /// base fare Rs 40
    double baseFare = 40;
    double distanceFare = (direction.distanceValue / 1000) * 8;
    double timeFare = (durationValue / 60) * 6;
    double totalFare = baseFare + distanceFare + timeFare;

    return totalFare.truncate();
  }

  static double generateRandomNumber(int max) {
    var randomGenerator = Random();
    int randInt = randomGenerator.nextInt(max);
    return randInt.toDouble();
  }

  static void disableHomeTabLocationUpdates() {
    homeTabPositionStream.pause();
    Geofire.removeLocation(currentDriverInfo.uId);
  }

  static void enableHomeTabLocationUpdates() {
    homeTabPositionStream.resume();
    Geofire.setLocation(
        currentDriverInfo.uId, currentDriverInfo.currentPosition.longitude,
        currentDriverInfo.currentPosition.longitude);
  }

  static void sendNotifications(String token, context, String rideId) async {
    var destination = Provider
        .of<AppData>(context, listen: false)
        .destinationAddress;

    try {
      http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': serverKey,
        },
        body: jsonEncode({
          'to': token,
          'data': {
            'ride_id': rideId,
          },
          'notification': {
            'title': 'NEW TRIP REQUEST',
            'body': 'Destination ${destination.placeName}',
          },
        }),
      );
      print(jsonDecode(response.body));
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  static void getHistoryInfo(context) {
    DatabaseReference earningRef = FirebaseDatabase.instance.reference().child(
        "Drivers/DriversData/${currentDriverInfo.uId}/earnings");
    earningRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        String earnings = snapshot.value.toString();
        Provider.of<AppData>(context, listen: false).updateEarnings(earnings);
      }
    });
    DatabaseReference historyRef = FirebaseDatabase.instance.reference().child(
        'Drivers/DriversData/${currentDriverInfo.uId}/history');
    historyRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        int tripCount = values.length;

        // update trip count to data provider
        Provider.of<AppData>(context, listen: false).updateTripCount(tripCount);

        List<String> tripHistoryKeys = [];
        values.forEach((key, value) {
          tripHistoryKeys.add(key);
        });

        // update trip keys to data provider
        Provider.of<AppData>(context, listen: false).updateTripKeys(
            tripHistoryKeys);

        getHistoryData(context);
      }
    });
  }

  static void getHistoryData(context) {
    var keys = Provider
        .of<AppData>(context, listen: false)
        .tripHistoryKeys;
    for (String key in keys) {
      DatabaseReference historyRef = FirebaseDatabase.instance.reference()
          .child('Ride Request/$key');

      historyRef.once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          var history = History.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false).updateTripHistory(
              history);

          print(history.pickup);
          print(history.destination);
          print(history.fares.runtimeType);
        }
      });
    }
  }

  static String formatMyDate(String dateString){

    DateTime thisDate = DateTime.parse(dateString);
    String formattedDate = '${DateFormat.MMMd().format(thisDate)}, ${DateFormat.y().format(thisDate)} - ${DateFormat.jm().format(thisDate)}';

    return formattedDate;
  }

}
