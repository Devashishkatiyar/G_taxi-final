import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:trackingapp/DataProviders/SharedPreferences.dart';
import 'package:trackingapp/Screens/Driver/VehiclesInfo.dart';
import 'package:trackingapp/Screens/User/LoginPage.dart';
import 'package:trackingapp/Screens/User/MainPage.dart';
import 'package:trackingapp/Screens/User/RegistrationPage.dart';
import 'package:trackingapp/Screens/User/StartingPage.dart';
import 'package:trackingapp/DataProviders/AppData.dart';
import 'package:trackingapp/Widgets/GlobalVariables.dart';

void main() async{
  bool firstTimeOpen = false;
  WidgetsFlutterBinding.ensureInitialized();
  MySharedPreferences.instance.getBooleanValue("FirstTimeOpen").then((value) =>
  firstTimeOpen = value,
  );
  await Firebase.initializeApp();
  await Permission.location.request();
  runApp(MyApp(
    firstTimeOpen: firstTimeOpen,
  ));
}

class MyApp extends StatefulWidget {
  bool firstTimeOpen;
  MyApp({Key key, this.firstTimeOpen}): super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=> AppData(),
      child: MaterialApp(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Brand-Regular",
          primarySwatch: Colors.blue,
        ),
        initialRoute: StartingPage.id,
        routes: {
          StartingPage.id:(context) => StartingPage(),
          LoginPage.id: (context) => LoginPage(),
          RegistrationPage.id: (context) => RegistrationPage(),
          MainPage.id:(context)=>MainPage(),
          VehicleInfo.id:(context)=> VehicleInfo(),
        },
      ),
    );
  }
}
// widget.firstTimeOpen?LoginPage.id:StartingPage.id