import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:trackingapp/DataProviders/SharedPreferences.dart';
import 'package:trackingapp/Screens/Driver/DriverMainPage.dart';
import 'package:trackingapp/Screens/Driver/HistoryPage.dart';
import 'package:trackingapp/Screens/Driver/NewTripPage.dart';
import 'package:trackingapp/Screens/Driver/VehiclesInfo.dart';
import 'package:trackingapp/Screens/User/AddCar.dart';
import 'package:trackingapp/Screens/User/LocationSearch.dart';
import 'package:trackingapp/Screens/User/LoginPage.dart';
import 'package:trackingapp/Screens/User/MainPage.dart';
import 'package:trackingapp/Screens/User/RegistrationPage.dart';
import 'package:trackingapp/Screens/User/Rentals.dart';
import 'package:trackingapp/Screens/User/SearchPage.dart';
import 'package:trackingapp/Screens/User/StartingPage.dart';
import 'package:trackingapp/DataProviders/AppData.dart';
import 'package:trackingapp/Widgets/User/GlobalVariables.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async{
  bool firstTimeOpen = false;
  WidgetsFlutterBinding.ensureInitialized();
  MySharedPreferences.instance.getBooleanValue("FirstTimeOpen").then((value) =>
  firstTimeOpen = value,
  );
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
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
          // primarySwatch: Colors.blue,
        ),
        initialRoute: StartingPage.id,
        routes: {
          StartingPage.id:(context) => StartingPage(),
          LoginPage.id: (context) => LoginPage(),
          RegistrationPage.id: (context) => RegistrationPage(),
          MainPage.id:(context)=>MainPage(),
          VehicleInfo.id:(context)=> VehicleInfo(),
          AddCar.id:(context)=>AddCar(),
          Rentals.id:(context)=>Rentals(),
          DriverMainPage.id:(context)=>DriverMainPage(),
          LocationSearch.id:(context)=>LocationSearch(),
          SearchPage.id:(context)=>SearchPage(),
          NewTripPage.id:(context)=>NewTripPage(),
          HistoryPage.id:(context)=>HistoryPage(),
        },
      ),
    );
  }
}
