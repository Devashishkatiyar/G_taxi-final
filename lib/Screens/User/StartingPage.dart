import "package:flutter/material.dart";
import 'package:trackingapp/DataProviders/SharedPreferences.dart';
import 'package:trackingapp/Screens/User/LoginPage.dart';
import 'package:trackingapp/Widgets/User/GlobalVariables.dart';
import 'package:trackingapp/Widgets/User/TaxiButton.dart';
import 'package:trackingapp/brand_colors.dart';
import 'package:trackingapp/Widgets/User/SnackBar.dart';

class StartingPage extends StatefulWidget {
  static const String id = "StartingPage";

  @override
  _StartingPageState createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  GlobalKey<ScaffoldState> scaffoldKey=GlobalKey<ScaffoldState>();
  bool user=false, driver=false;

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      alignment: Alignment.center,
                      image: AssetImage("images/logo.png"),
                      height: 120,
                      width: 120,
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),
                Text(
                  "Please select one of the options given below",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: "Brand-Bold"),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: user,
                        onChanged: (value){
                          setState(() {
                            user=value;
                            driver=false;
                            MySharedPreferences.instance.setBooleanValue("User", true);
                            MySharedPreferences.instance.setBooleanValue("Driver", false);
                          });
                        },
                      activeColor: BrandColors.colorAccent,
                    ),
                    Text(
                      "User",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15,),
                    ),
                    Checkbox(
                        value: driver,
                        onChanged: (value){
                          setState(() {
                            driver=value;
                            user=false;
                            MySharedPreferences.instance.setBooleanValue("Driver", true);
                            MySharedPreferences.instance.setBooleanValue("User", false);
                          });
                        },
                      activeColor: BrandColors.colorAccent,
                    ),
                    Text(
                      "Driver",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15,),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),
                TaxiButton(
                    title:"Continue",
                  onPressed: () {
                    if (user == false && driver == false) {
                      rootScaffoldMessengerKey.currentState.showSnackBar(showSnackBar("Please Select one of the options",context));
                    }
                    else {
                      MySharedPreferences.instance.setBooleanValue("FirstTimeOpen", true);
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginPage.id, (route) => false);
                    }
                  },
                  bgColor: BrandColors.colorGreen,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
