// import 'dart:convert';
// import 'dart:html';
// import 'dart:io' show Platform;
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart' as http;
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trackingapp/DataModels/TripDetails.dart';
import 'package:trackingapp/Widgets/Driver/NotificationDialog.dart';
import 'package:trackingapp/Widgets/User/GlobalVariables.dart';
import 'package:trackingapp/Widgets/User/ProgressDialog.dart';
// import 'package:trackingapp/main.dart';

class PushNotificationService{

  final FirebaseMessaging fcm = FirebaseMessaging.instance;
  Future<void> initialize(context)async{
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // RemoteNotification notification = message.notification;
      // AndroidNotification android = message.notification?.android;
      // if (notification != null && android != null) {
      //   flutterLocalNotificationsPlugin.show(
      //       notification.hashCode,
      //       notification.title,
      //       notification.body,
      //       NotificationDetails(
      //         android: AndroidNotificationDetails(
      //           channel.id,
      //           channel.name,
      //           channel.description,
      //           // TODO add a proper drawable resource to android, for now using
      //           //      one that already exists in example app.
      //           icon: 'launch_background',
      //         ),
      //       ));
      // }
      print(message.data);
      fetchRideInfo(getRideID(message.data),context);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
  }

  void getToken()async{
    String token = await fcm.getToken();
    print("token: $token");
    FirebaseDatabase.instance.reference().child("Drivers/DriversData/${currentDriverInfo.uId}").update({
      "token": "$token",
    });

    fcm.subscribeToTopic("allDrivers");
    fcm.subscribeToTopic("allUsers");

      // if (token == null) {
      //   print('Unable to send FCM message, no token exists.');
      //   return;
      // }
      //
      // try {
      //  http.Response response =  await http.post(
      //     Uri.parse('https://fcm.googleapis.com/fcm/send'),
      //     headers: <String, String>{
      //       'Content-Type': 'application/json; charset=UTF-8',
      //       'Authorization': 'key=AAAAGzJJMSE:APA91bF2598PO7ViYgldeCu7tgZJBFUabtF0X205OLZdBsU8E4xDwxusG4lRbOW0KH7cpacFPOhvRih4wxb1Lojl2Y7pSNH5d-eqITcvSkG3ihtBei7uIyZX7OttA8cC4yoh5avM7CFa'
      //     },
      //     body: constructFCMPayload(token),
      //   );
      //  print(jsonDecode(response.body));
      //   print('FCM request for device sent!');
      // } catch (e) {
      //   print(e);
      // }



  }
  // String constructFCMPayload(String token) {
  //   return jsonEncode({
  //     'to': token,
  //     'data': {
  //       'via': 'FlutterFire Cloud Messaging!!!',
  //       'count': "2",
  //     },
  //     'notification': {
  //       'title': 'Hello FlutterFire!',
  //       'body': 'This notification was created via FCM!',
  //     },
  //   });
  // }

  String getRideID(Map<String, dynamic> message){
    String rideId = "";
    rideId = message['ride_id'];
    print(rideId);
    return rideId;
  }

  void fetchRideInfo(String rideId,context){

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
          return ProgressDialog(
            status: "Fetching Please Wait...",
          );
        }
    );

    DatabaseReference rideRef = FirebaseDatabase.instance.reference().child("Ride Request/$rideId");

    rideRef.once().then((DataSnapshot snapshot) {

      Navigator.pop(context);

      if(snapshot.value!=null){

        final assetAudioPlayer = AssetsAudioPlayer();
        assetAudioPlayer.open(Audio("sounds/alert.mp3"));
        assetAudioPlayer.play();

        double pickUpLat = double.parse(snapshot.value["location"]["latitude"].toString());
        double pickUpLng = double.parse(snapshot.value["location"]["longitude"].toString());
        String pickUpAddress = snapshot.value["pickup_address"].toString();

        double destinationLat = double.parse(snapshot.value["destination"]["latitude"].toString());
        double destinationLng = double.parse(snapshot.value["destination"]["longitude"].toString());
        String destinationAddress = snapshot.value["destination_address"].toString();
        String paymentMethod = snapshot.value["payment"];
        String riderName = snapshot.value["rider_name"];
        String phoneNumber = snapshot.value["phone_number"];

        TripDetails tripDetails = TripDetails();
        tripDetails.rideId = rideId;
        tripDetails.pickupAddress = pickUpAddress;
        tripDetails.destinationAddress = destinationAddress;
        tripDetails.paymentMethod = paymentMethod;
        tripDetails.pickUp = LatLng(pickUpLat,pickUpLng);
        tripDetails.destination = LatLng(destinationLat,destinationLng);
        tripDetails.riderName = riderName;
        tripDetails.riderPhone = phoneNumber;

        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context)=>NotificationDialog(tripDetails: tripDetails,assetAudioPlayer: assetAudioPlayer,)
        );

      }
    });
  }

}