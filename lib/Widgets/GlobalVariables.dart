import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trackingapp/DataModels/Users.dart';

String mapKey="AIzaSyDo3VloofMnq6q5TpJ_MVu2f92GCHSF-Oc";

FirebaseAuth currentFirebaseUser;
Users currentUserInfo;
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();