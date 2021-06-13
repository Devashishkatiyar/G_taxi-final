import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';

class Drivers{
  String name;
  String phoneNumber;
  String email;
  String uId;
  Position currentPosition;
  String carModel;
  String carColour;
  String vehicleNumber;

  Drivers({
    this.phoneNumber,
    this.name,
    this.email,
    this.uId,
    this.currentPosition,
    this.carColour,
    this.carModel,
    this.vehicleNumber,
  });

  Drivers.fromSnapshot(DataSnapshot snapshot){
    uId = snapshot.key;
    phoneNumber = snapshot.value["Phone Number"];
    name = snapshot.value["Full Name"];
    email = snapshot.value["Email Address"];
    carModel = snapshot.value["vehicle_details"]["car_model"];
    carColour = snapshot.value["vehicle_details"]["car_colour"];
    vehicleNumber = snapshot.value["vehicle_details"]["vehicle_number"];
  }
}