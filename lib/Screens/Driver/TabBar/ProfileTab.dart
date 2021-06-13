import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackingapp/DataProviders/AppData.dart';
import 'package:trackingapp/Screens/User/LoginPage.dart';
import 'package:trackingapp/Widgets/User/GlobalVariables.dart';

import '../../../brand_colors.dart';
import '../HistoryPage.dart';
class ProfileTab extends StatefulWidget {
  const ProfileTab({Key key}) : super(key: key);
  @override
  _ProfileTabState createState() => _ProfileTabState();

}
class _ProfileTabState extends State<ProfileTab> {
  FirebaseAuth auth = FirebaseAuth.instance;
  void signOut() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Are you sure you want to proceed?",
              style: TextStyle(fontSize: 18),
            ),
            backgroundColor: Colors.white,
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  primary: BrandColors.colorAccent,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  side: BorderSide(
                    width: 1.5,
                    color: BrandColors.colorAccent,
                  ),
                ),
                onPressed: () async {
                  await auth.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginPage.id, (route) => false);
                },
                child: Text("YES"),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.red.shade600,
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    width: 1.5,
                    color: Colors.red.shade600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("NO"),
              ),
            ],
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 30,),
                    Row(
                      children: [
                        SizedBox(width: 30,),
                        CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person_rounded,
                              size: 80,
                              color: Colors.grey,)
                        ),
                        SizedBox(width: 20,),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentDriverInfo.name,
                                style: TextStyle(
                                    fontSize: 23,
                                    fontFamily: "Brand-Bold",
                                    color: Colors.black87),
                              ),
                              SizedBox(height: 5,),
                              Text(
                                "E Mail : ${currentDriverInfo.email}",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 5,),
                              Text(
                                "Mobile : ${currentDriverInfo.phoneNumber}",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 60,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "3.6",
                              style: TextStyle(
                                  fontSize: 23,
                                  fontFamily: "Brand-Bold",
                                  color: Colors.black87),
                            ),
                            SizedBox(height: 7,),
                            Text(
                              "Rating",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              currentDriverInfo.vehicleNumber,
                              style: TextStyle(
                                  fontSize: 23,
                                  fontFamily: "Brand-Bold",
                                  color: Colors.black87),
                            ),
                            SizedBox(height: 7,),
                            Text(
                              "Vehicle No.",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87),
                            ),
                          ],
                        ),
                        Container(
                          height: 30,
                          width: 85,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  width: 1,
                                  color: Colors.black87
                              )
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: signOut,
                              child: Text(
                                "Log Out",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Brand-Bold",
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/2+20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  color: Colors.orangeAccent,
                  // Color(0xffadd8e6),
                    // Color(0xffa6f1a6)
                ),
              ),
              Positioned(
                bottom: 0.0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/2+10,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepOrange.withOpacity(1),
                        spreadRadius: 40,
                        blurRadius: 150,
                        offset: Offset(2,2), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(70),
                      topLeft: Radius.circular(70),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20,),
                      Text(
                        "Other Details",
                        style: TextStyle(
                            fontSize: 24,
                            fontFamily: "Brand-Bold",
                            color: Colors.black87),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Divider(thickness: 1,endIndent: 15,indent: 15,color: Colors.blueGrey.shade100,),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 20,),
                          Icon(Icons.money,color: Colors.blueGrey,size: 35,),
                          SizedBox(width: 20,),
                          Text('Total Earnings', style: TextStyle(color: Colors.black87,fontSize: 16),),
                          SizedBox(width: MediaQuery.of(context).size.width*0.3,),
                          Text( '\u20B9 ${Provider.of<AppData>(context).earnings}', style: TextStyle(color: Colors.black87,fontSize: 16),),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(thickness: 1,endIndent: 15,indent: 15,color: Colors.blueGrey.shade100,),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.all(0),
                            primary: Colors.black87
                        ),
                        onPressed: (){
                          Navigator.pushNamed(context, HistoryPage.id);
                        },

                        child: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                          child: Row(
                            children: [
                              Image.asset('images/taxi.png', width: 70,),
                              SizedBox(width: 16,),
                              Text('Trips', style: TextStyle(fontSize: 16), ),
                              SizedBox(width: MediaQuery.of(context).size.width*0.5,),
                              Container(child: Text(Provider.of<AppData>(context).tripCount.toString(), textAlign: TextAlign.end, style: TextStyle(fontSize: 18),)),
                            ],
                          ),
                        ),
                      ),
                      Divider(thickness: 1,endIndent: 15,indent: 15,color: Colors.blueGrey.shade100,),
                    ],
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }

}
