import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:trackingapp/Screens/User/LoginPage.dart';
import 'package:trackingapp/Widgets/User/GlobalVariables.dart';
import 'package:trackingapp/Widgets/User/ProgressDialog.dart';
import 'package:trackingapp/Widgets/User/SnackBar.dart';
import 'package:trackingapp/Widgets/User/TaxiButton.dart';
import 'package:trackingapp/brand_colors.dart';

class VehicleInfo extends StatefulWidget {
  static const String id = "VehicleInfo";
  const VehicleInfo({Key key}) : super(key: key);

  @override
  _VehicleInfoState createState() => _VehicleInfoState();
}

class _VehicleInfoState extends State<VehicleInfo> {

   var carModelController = TextEditingController();
   var carColourController = TextEditingController();
   var vehicleNumberController = TextEditingController();

   void updateProfile(){
     String driverId = ModalRoute.of(context).settings.arguments;
     DatabaseReference driverRef = FirebaseDatabase.instance.reference().child("Drivers/DriversData/$driverId/vehicle_details");
     Map map = {
       "car_colour":carColourController.text,
       "car_model":carModelController.text,
       "vehicle_number":vehicleNumberController.text,
     };
     driverRef.set(map);
     Navigator.pushNamedAndRemoveUntil(context, LoginPage.id, (route) => false);
   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left:30.0,right: 30),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.04,
                ),
                Image(
                  alignment: Alignment.center,
                  image: AssetImage(
                      "images/logo.png"
                  ),
                  height: 120,
                  width: 120,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.04,
                ),
                Column(
                  children: [
                    Text(
                        "Enter Text Details",
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: "Brand-bold",
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.04,
                    ),
                    Theme(
                      data: ThemeData(
                        primaryColor: BrandColors.colorAccentPurple,
                      ),
                      child: TextField(
                        controller: carModelController,
                        keyboardType: TextInputType.text,
                        keyboardAppearance: Brightness.dark,
                        onEditingComplete: ()=> FocusScope.of(context).nextFocus(),
                        // expands: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: "Car Model",
                          labelStyle:TextStyle(
                            fontSize: 14,
                          ),
                          hintText: "Ex:- Hyundai Verna",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.04,
                    ),
                    Theme(
                      data: ThemeData(
                        primaryColor: BrandColors.colorAccentPurple,
                      ),
                      child: TextField(
                        controller: carColourController,
                        keyboardType: TextInputType.text,
                        keyboardAppearance: Brightness.dark,
                        onEditingComplete: ()=> FocusScope.of(context).nextFocus(),
                        // expands: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: "Car Colour",
                          labelStyle:TextStyle(
                            fontSize: 14,
                          ),
                          hintText: "Ex:- Black,Grey etc ",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.04,
                    ),
                    Theme(
                      data: ThemeData(
                        primaryColor: BrandColors.colorAccentPurple,
                      ),
                      child: TextField(
                        controller: vehicleNumberController,
                        keyboardType: TextInputType.text,
                        keyboardAppearance: Brightness.dark,
                        onEditingComplete: ()=> FocusScope.of(context).nextFocus(),
                        // expands: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: "Vehicle Number",
                          labelStyle:TextStyle(
                            fontSize: 14,
                          ),
                          hintText: "Ex:- UP70 AZ 1125",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.04,
                    ),
                    TaxiButton(
                      title: "PROCEED",
                      bgColor: BrandColors.colorAccentPurple,
                      onPressed: (){
                        if(carModelController.text.length<3){
                          return rootScaffoldMessengerKey.currentState.showSnackBar(showSnackBar("Please provide a valid car model", context));
                        }
                        if(carColourController.text.length<3){
                          return rootScaffoldMessengerKey.currentState.showSnackBar(showSnackBar("Please provide a valid car colour", context));
                        }
                        if(vehicleNumberController.text.length<3){
                          return rootScaffoldMessengerKey.currentState.showSnackBar(showSnackBar("Please provide a valid vehicle number", context));
                        }
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context){
                              return ProgressDialog(
                                status: "Please Wait...",
                              );
                            }
                        );
                        updateProfile();
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
