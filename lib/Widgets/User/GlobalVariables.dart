import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trackingapp/DataModels/Users.dart';
import 'package:trackingapp/DataModels/Drivers.dart';

String mapKey="Api_Key";

String serverKey = "Server_Key";

// FirebaseAuth currentFirebaseUser;
// FirebaseAuth currentFirebaseDriver;
Users currentUserInfo;
Drivers currentDriverInfo;
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
StreamSubscription<Position> homeTabPositionStream;
StreamSubscription<Position> ridePositionStream;
// Position currentPosition;