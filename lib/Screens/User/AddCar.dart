import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackingapp/Widgets/User/GlobalVariables.dart';
import 'package:trackingapp/Widgets/User/ProgressDialog.dart';

class AddCar extends StatefulWidget{
  static const String id= "AddCar";
  @override
  State<StatefulWidget> createState() {
    return AddCarState();
  }
}
class AddCarState extends State<AddCar>{
  TextEditingController companyName = TextEditingController();
  TextEditingController modelName = TextEditingController();
  TextEditingController rent = TextEditingController();
  TextEditingController seats = TextEditingController();
  final CollectionReference ref= FirebaseFirestore.instance.collection("Rentals Data");

  var _carType = [
    "Micro",
    "Sedan",
    "Suv",
    "Hatchback",
  ];
  var _fuelType = [
    "Petrol",
    "Diesel",
    "Gas",
  ];
  var _transmissionType = [
    "Manual",
    "Auto",
  ];
  var _seats = [
    "5",
    "7",
  ];
  String _currentSelectedValueCarType;
  String _currentSelectedValueTransmissionType;
  String _currentSelectedValueFuelType;
  String _currentSelectedValueSeats;
  Future<void> addCar()async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return ProgressDialog(
            status: "Adding Your Details Please Wait...",
          );
        }
    );
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 15,),
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_rounded,
                      size: 21,
                      color: Colors.black87,),),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 35,),
                  RichText(
                      text: TextSpan(
                        text: 'Add your ',
                        style: TextStyle(
                            color: Colors.black, fontSize: 23,fontFamily: "Brand-Regular"),
                        children: <TextSpan>[
                          TextSpan(text: 'Car',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 23,fontWeight: FontWeight.bold,fontFamily: "Brand-Bold")
                          ),
                        ],
                      )
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Theme(
                      data: ThemeData(
                        primaryColor: Color(0xFF21ba45),
                      ),
                      child: TextField(
                        controller: companyName,
                        keyboardType: TextInputType.name,
                        keyboardAppearance: Brightness.dark,
                        onEditingComplete: ()=> FocusScope.of(context).nextFocus(),
                        // expands: true,
                        selectionHeightStyle: BoxHeightStyle.tight,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: "Company Name",
                          labelStyle:TextStyle(
                            fontSize: 14,
                          ),
                          hintText: "Ex:- Hyundai , Maruti Suzuki , Honda",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.05,
                    ),
                    Theme(
                      data: ThemeData(
                        primaryColor: Color(0xFF21ba45),
                      ),
                      child: TextField(
                        controller: modelName,
                        keyboardType: TextInputType.name,
                        keyboardAppearance: Brightness.dark,
                        onEditingComplete: ()=> FocusScope.of(context).nextFocus(),
                        // expands: true,
                        selectionHeightStyle: BoxHeightStyle.tight,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: "Model Name",
                          labelStyle:TextStyle(
                            fontSize: 14,
                          ),
                          hintText: "Ex:- Verna , Swift , Amaze",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.05,
                    ),
                    Theme(
                      data: ThemeData(
                        primaryColor: Color(0xFF21ba45),
                      ),
                      child: TextField(
                        controller: rent,
                        keyboardType: TextInputType.number,
                        keyboardAppearance: Brightness.dark,
                        onEditingComplete: ()=> FocusScope.of(context).nextFocus(),
                        // expands: true,
                        selectionHeightStyle: BoxHeightStyle.tight,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: "Per Day Rent",
                          labelStyle:TextStyle(
                            fontSize: 14,
                          ),
                          hintText: "Enter in Rupees",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.05,
                    ),
                    FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return Theme(
                          data: ThemeData(
                            primaryColor: Color(0xFF21ba45),),
                          child: InputDecorator(
                            decoration: InputDecoration(
                                hintText: "Car Type",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                                labelText: "No. of Seats",
                                labelStyle: TextStyle(fontSize: 16.0),
                                // errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
                            isEmpty: _currentSelectedValueSeats == '',
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _currentSelectedValueSeats,
                                isDense: true,
                                onChanged: (String newValue) {
                                  setState(() {
                                    _currentSelectedValueSeats = newValue;
                                    state.didChange(newValue);
                                    print(_currentSelectedValueSeats);
                                  });
                                },
                                items: _seats.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.05,
                    ),
                    FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return Theme(
                          data: ThemeData(
                            primaryColor: Color(0xFF21ba45),),
                          child: InputDecorator(
                            decoration: InputDecoration(
                                hintText: "Car Type",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                                labelText: "Car Type",
                                labelStyle: TextStyle(fontSize: 16.0),
                                // errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
                            isEmpty: _currentSelectedValueCarType == '',
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _currentSelectedValueCarType,
                                isDense: true,
                                onChanged: (String newValue) {
                                  setState(() {
                                    _currentSelectedValueCarType = newValue;
                                    state.didChange(newValue);
                                    print(_currentSelectedValueCarType);
                                  });
                                },
                                items: _carType.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.05,
                    ),
                    FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return Theme(
                          data: ThemeData(
                            primaryColor: Color(0xFF21ba45),),
                          child: InputDecorator(
                            decoration: InputDecoration(
                                hintText: "Car Type",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                                labelText: "Transmission",
                                labelStyle: TextStyle(fontSize: 16.0),
                                // errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
                            isEmpty: _currentSelectedValueTransmissionType == '',
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _currentSelectedValueTransmissionType,
                                isDense: true,
                                onChanged: (String newValue) {
                                  setState(() {
                                    _currentSelectedValueTransmissionType = newValue;
                                    state.didChange(newValue);
                                    print(_currentSelectedValueTransmissionType);
                                  });
                                },
                                items: _transmissionType.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.05,
                    ),
                    FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return Theme(
                          data: ThemeData(
                            primaryColor: Color(0xFF21ba45),),
                          child: InputDecorator(
                            decoration: InputDecoration(
                                hintText: "Car Type",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                                labelText: "Fuel Type",
                                labelStyle: TextStyle(fontSize: 16.0),
                                // errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
                            isEmpty: _currentSelectedValueFuelType == '',
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _currentSelectedValueFuelType,
                                isDense: true,
                                onChanged: (String newValue) {
                                  setState(() {
                                    _currentSelectedValueFuelType = newValue;
                                    state.didChange(newValue);
                                    print(_currentSelectedValueFuelType);
                                  });
                                },
                                items: _fuelType.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.07,
                    ),
                    // ignore: deprecated_member_use
                    RaisedButton(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      color: Color(0xFF40cf89),
                      textColor: Colors.white,
                      child: Container(
                        height: 50,
                        child: Center(
                          child: Text(
                            "Done",
                            style: TextStyle(
                                fontFamily: "Brand-Bold",
                                fontSize: 20
                            ),
                          ),
                        ),
                      ),
                      onPressed: () async{

                        final uid= await getCurrentUID();
                        print(uid);
                        setState(() {
                          print("in set state");
                          ref.add(
                              {
                                'company name': companyName.text,
                                'model name': modelName.text,
                                'per day rent':rent.text,
                                'seats':_currentSelectedValueSeats,
                                'Car Type':_currentSelectedValueCarType,
                                'Transmission':_currentSelectedValueTransmissionType,
                                'Fuel Type':_currentSelectedValueFuelType,
                              }
                          ).whenComplete(() => Navigator.pop(context));
                        });
                        // addCar();
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>CarProfile()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
Future<String> getCurrentUID() async {
  return currentUserInfo.uId;
}