import 'dart:ui';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trackingapp/DataProviders/SharedPreferences.dart';
import 'package:trackingapp/Helpers/HelperMethods.dart';
import 'package:trackingapp/Screens/User/LocationSearch.dart';
import 'package:trackingapp/Screens/User/RegistrationPage.dart';
import 'package:trackingapp/Widgets/User/GlobalVariables.dart';
import 'package:trackingapp/Widgets/User/ProgressDialog.dart';
import 'package:trackingapp/brand_colors.dart';
import 'package:trackingapp/Widgets/User/TaxiButton.dart';
import 'package:trackingapp/Widgets/User/SnackBar.dart';

class LoginPage extends StatefulWidget {
  static const String id= "loginPage";
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool driver,user1;
  bool done = false;

  _LoginPageState(){
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
  FirebaseAuth auth=FirebaseAuth.instance;
  var emailAddress=TextEditingController();
  var password=TextEditingController();
  String name;

  Future<void> login()async{
    showDialog(
      barrierDismissible: false,
        context: context,
      builder: (BuildContext context){
          return ProgressDialog(
            status: "Verifying Credentials...",
          );
      }
    );

final UserCredential user = await auth.signInWithEmailAndPassword(
    email: emailAddress.text,
    password: password.text
).catchError((error){

  //check error & display message

  Exception thisEx=error;
  Navigator.pop(context);
  print(thisEx);
  rootScaffoldMessengerKey.currentState.showSnackBar(showSnackBar(thisEx.toString(), context));
});

//check if the users data is present in the database

if(user!=null && auth.currentUser.uid!=null){
  if(user1==true){
    HelperMethods.getUserInfo();
  }
  else{
    HelperMethods.getDriverInfo();
  }
  DatabaseReference userRef = FirebaseDatabase.instance.reference().child(
          user1 == true
              ? "Users/UsersData/${user.user.uid}"
              : "Drivers/DriversData/${user.user.uid}");
      userRef.once().then((DataSnapshot snapshot) => {
            if (snapshot.value != null)
              {
                Navigator.pushNamedAndRemoveUntil(context, LocationSearch.id, (route) => false,arguments: user1)
              }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  user1==true?"Sign In as a User":"Sign In as a Driver",
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
                          controller: emailAddress,
                          keyboardType: TextInputType.emailAddress,
                          // keyboardAppearance: Brightness.dark,
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
                          controller: password,
                          selectionHeightStyle: BoxHeightStyle.tight,
                          keyboardAppearance: Brightness.dark,
                          onEditingComplete: ()=> FocusScope.of(context).unfocus(),
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
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.04,
                ),
                TaxiButton(
                  title: "LOGIN",
                  onPressed: () async {
                    // check connectivity result
                    var connectivityStatus= await Connectivity().checkConnectivity();
                    if(connectivityStatus!=ConnectivityResult.mobile && connectivityStatus!=ConnectivityResult.wifi){
                      return rootScaffoldMessengerKey.currentState.showSnackBar(showSnackBar("No internet connection",context));
                    }

                    login();
                  },
                  bgColor: user1==true?BrandColors.colorGreen:BrandColors.colorAccentPurple,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.02,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, RegistrationPage.id, (route) => false);
                  },
                    style: TextButton.styleFrom(
                        primary: Colors.black87
                    ),
                    child: Text(
                        "Don\'t have an account? Sign Up here",
                    )
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.01,
                ),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(
                        fontFamily: "Brand-Bold",
                        letterSpacing: 2,
                        fontSize: 15
                      ),
                    ),
                  style: TextButton.styleFrom(
                      primary: Colors.black87
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

