import 'package:flutter/cupertino.dart';
import 'package:trackingapp/DataModels/Address.dart';
import 'package:trackingapp/DataModels/DriverHistory.dart';
import 'package:trackingapp/DataModels/Users.dart';

class AppData extends ChangeNotifier{

  Address pickupAddress;
  Address destinationAddress;
  Users info;
  String earnings = "0";
  int tripCount = 0;
  List<String> tripHistoryKeys = [];
  List<History> tripHistory = [];

  void updatePickupAddress(Address pickup){
    pickupAddress=pickup;
    notifyListeners();
  }

  void updateDestinationAddress(Address destination){
    destinationAddress=destination;
    notifyListeners();
  }

  void userInformation(Users information){
    info=information;
    notifyListeners();
  }

  void updateEarnings(String newEarnings){
    earnings = newEarnings;
    notifyListeners();
  }

  void updateTripCount(int newTripCount){
    tripCount = newTripCount;
    notifyListeners();
  }

  void updateTripKeys(List<String> newKeys){
    tripHistoryKeys = newKeys;
    notifyListeners();
  }

  void updateTripHistory(History historyItem){
    tripHistory.add(historyItem);
    notifyListeners();
  }



}