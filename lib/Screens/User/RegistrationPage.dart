import 'dart:ui';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trackingapp/DataProviders/SharedPreferences.dart';
import 'package:trackingapp/Screens/Driver/VehiclesInfo.dart';
import 'package:trackingapp/Screens/User/LoginPage.dart';
import 'package:trackingapp/Widgets/User/GlobalVariables.dart';
import 'package:trackingapp/Widgets/User/ProgressDialog.dart';
import 'package:trackingapp/Widgets/User/TaxiButton.dart';
import 'package:trackingapp/brand_colors.dart';
import 'package:trackingapp/Widgets/User/SnackBar.dart';


class RegistrationPage extends StatefulWidget {
  static const String id= "RegistrationPage";
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  bool user1,driver;
  _RegistrationPageState(){
    MySharedPreferences.instance.getBooleanValue("Driver").then((value) =>
      setState(() {
        driver = value;
      })
    );
    MySharedPreferences.instance.getBooleanValue("User").then((value) =>
      setState(() {
        user1 = value;
      })
    );
  }

  static GlobalKey<ScaffoldState> scaffoldKey=GlobalKey<ScaffoldState>();

  var fullName= TextEditingController();
  var emailAddress= TextEditingController();
  var phoneNumber= TextEditingController();
  var password=TextEditingController();
  var confirmPassword= TextEditingController();
  bool passwordCheck;
  String driverId;

  final FirebaseAuth auth=FirebaseAuth.instance;

  Future<void> register() async{
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
          return ProgressDialog(
            status: "Registering you..Please Wait",
          );
        }
    );
  final UserCredential user = await auth.createUserWithEmailAndPassword(
        email: emailAddress.text,
        password: password.text,
    ).catchError((error){

      //check error & display message

      Exception thisEx = error;
      Navigator.pop(context);
      rootScaffoldMessengerKey.currentState.showSnackBar(showSnackBar(thisEx.toString(),context));

  });
  if(user!=null){
    //prepare users data to be stored on database
   Future<void> newUserRef=  FirebaseDatabase.instance.reference().child(user1==true?"Users/UsersData/${user.user.uid}":"Drivers/DriversData/${user.user.uid}").set(
       {
         "Full Name": fullName.text,
         "Phone Number": phoneNumber.text,
         "Email Address": emailAddress.text,
         "Password": password.text,
       });
   if(user1==true){
     Navigator.pushNamedAndRemoveUntil(context, LoginPage.id, (route) => false);
   }
   else{
     driverId = user.user.uid;
     Navigator.pushNamedAndRemoveUntil(context, VehicleInfo.id, (route) => false,arguments: driverId);
   }
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      alignment: Alignment.center,
                      image: AssetImage(
                          "images/logo.png"
                      ),
                      height: 120,
                      width: 120,
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.04,
                ),
                Text(
                  user1==true?"Create a User\'s Account":"Create a Driver\'s Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: "Brand-Bold"
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Theme(
                        data: ThemeData(
                          primaryColor: driver==true?BrandColors.colorAccentPurple:BrandColors.colorAccent,
                        ),
                        child: TextField(
                          controller: fullName,
                          keyboardType: TextInputType.name,
                          keyboardAppearance: Brightness.dark,
                          onEditingComplete: ()=> FocusScope.of(context).nextFocus(),
                          // expands: true,
                          selectionHeightStyle: BoxHeightStyle.tight,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: "Full Name",
                            labelStyle:TextStyle(
                              fontSize: 14,
                            ),
                            hintText: "Ex:- Mike Jordan",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.02,
                      ),
                      Theme(
                        data: ThemeData(
                          primaryColor: driver==true?BrandColors.colorAccentPurple:BrandColors.colorAccent,
                        ),
                        child: TextField(
                          controller: emailAddress,
                          keyboardType: TextInputType.emailAddress,
                          keyboardAppearance: Brightness.dark,
                          onEditingComplete: ()=> FocusScope.of(context).nextFocus(),
                          // expands: true,
                          selectionHeightStyle: BoxHeightStyle.tight,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: "Email Address",
                            labelStyle:TextStyle(
                              fontSize: 14,
                            ),
                            hintText: "abc@provider.com",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.02,
                      ),
                      Theme(
                        data: ThemeData(
                          primaryColor: driver==true?BrandColors.colorAccentPurple:BrandColors.colorAccent,
                        ),
                        child: TextField(
                          controller: phoneNumber,
                          keyboardType: TextInputType.phone,
                          keyboardAppearance: Brightness.dark,
                          onEditingComplete: ()=> FocusScope.of(context).nextFocus(),
                          // expands: true,
                          selectionHeightStyle: BoxHeightStyle.tight,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: "Phone Number",
                            labelStyle:TextStyle(
                              fontSize: 14,
                            ),
                            hintText: "1234567890",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.02,
                      ),
                      Theme(
                        data: ThemeData(
                          primaryColor: driver==true?BrandColors.colorAccentPurple:BrandColors.colorAccent,
                        ),
                        child: TextField(
                          controller: password,
                          selectionHeightStyle: BoxHeightStyle.tight,
                          keyboardAppearance: Brightness.dark,
                          onEditingComplete: ()=> FocusScope.of(context).nextFocus(),
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: "Password",
                            labelStyle:TextStyle(
                              fontSize: 14,
                            ),
                            hintText: "Type your password",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.02,
                      ),
                      Theme(
                        data: ThemeData(
                          primaryColor: driver==true?BrandColors.colorAccentPurple:BrandColors.colorAccent,
                        ),
                        child: TextField(
                          controller: confirmPassword,
                          selectionHeightStyle: BoxHeightStyle.tight,
                          keyboardAppearance: Brightness.dark,
                          onEditingComplete: ()=> FocusScope.of(context).unfocus(),
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: "Confirm Password",
                            labelStyle:TextStyle(
                              fontSize: 14,
                            ),
                            hintText: "Re-type your password",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.04,
                ),
                TaxiButton(
                  title: "REGISTER",
                  onPressed: ()async{

                    // check connectivity result
                    var connectivityStatus=await Connectivity().checkConnectivity();
                    if(connectivityStatus!=ConnectivityResult.mobile && connectivityStatus!=ConnectivityResult.wifi){
                      return rootScaffoldMessengerKey.currentState.showSnackBar(showSnackBar("No internet connection",context));
                    }

                    register();
                  },
                  bgColor: driver==true?BrandColors.colorAccentPurple:BrandColors.colorGreen,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.02,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, LoginPage.id, (route) => false);
                    },
                  style: TextButton.styleFrom(
                      primary: Colors.black87
                  ),
                    child: Text(
                      user1==true?"Already have a USER\'s Account!! Log In":"Already have a DRIVER\'s Account!! Log In",
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
