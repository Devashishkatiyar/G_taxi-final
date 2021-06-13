import 'package:flutter/material.dart';

class CarProfile extends StatefulWidget{
  static const String id= "CarProfile";

  String companyName;
  String modelName;
  String rent;
  String seats;
  String carType;
  String transmission;
  String fuelType;
  CarProfile(this.companyName,this.modelName,this.rent,this.seats,this.carType,this.transmission,this.fuelType);
  @override
  State<StatefulWidget> createState() {
    return CarProfileState();
  }
}
class CarProfileState extends State<CarProfile>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body:Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              left: 140,
              child: CircleAvatar(
                backgroundColor:Color(0xffa6f1a6),
                radius: 200,
              ),
            ),
            SingleChildScrollView(
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
                  SizedBox(height:MediaQuery.of(context).size.height*0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 35,),
                      Text(widget.modelName,
                          style: TextStyle(
                              color: Colors.black, fontSize: 26,fontWeight: FontWeight.bold,fontFamily: "Brand-Bold")
                      ),
                    ],
                  ),
                  SizedBox(height:MediaQuery.of(context).size.height*0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 35,),
                      Text(widget.companyName,
                          style: TextStyle(
                              color: Colors.black54, fontSize: 23,fontFamily: "Brand-Bold")
                      ),
                    ],
                  ),
                  // SizedBox(height:MediaQuery.of(context).size.height*0.0),
                  Container(
                    height: 190,
                    // color: Colors.amber,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage("images/taxi.png"),
                      ),
                    ),
                  ),
                  // SizedBox(height:MediaQuery.of(context).size.height*0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 35,),
                      Text('Specification',
                          style: TextStyle(
                              color: Colors.black, fontSize: 26,fontWeight: FontWeight.bold,fontFamily: "Brand-Bold")
                      ),
                    ],
                  ),
                  SizedBox(height:MediaQuery.of(context).size.height*0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // SizedBox(width: 35,),
                      Card(
                        elevation: 30.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          height: 100,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 10,),
                              Icon(Icons.speed_outlined,
                                size: 40,),
                              SizedBox(height:15),
                              Text('210 Kmph',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13,fontFamily: "Brand-Regular"),)
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 30.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          height: 100,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 10,),
                              Icon(Icons.all_inclusive,
                                size: 40,),
                              SizedBox(height:15),
                              Text(widget.transmission,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13,fontFamily: "Brand-Regular"),)
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 30.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          height: 100,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 10,),
                              Icon(Icons.engineering_outlined,
                                size: 40,),
                              SizedBox(height:15),
                              Text("4 cyl",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13,fontFamily: "Brand-Regular"),)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height:MediaQuery.of(context).size.height*0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // SizedBox(width: 35,),
                      Card(
                        elevation: 30.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          height: 100,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 10,),
                              Icon(Icons.local_gas_station_rounded,
                                size: 40,),
                              SizedBox(height:15),
                              Text(widget.fuelType,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13,fontFamily: "Brand-Regular"),)
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 30.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          height: 100,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 10,),
                              Icon(Icons.airline_seat_recline_extra_sharp,
                                size: 40,),
                              SizedBox(height:15),
                              Text(widget.seats,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13,fontFamily: "Brand-Regular"),)
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 30.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          height: 100,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 10,),
                              Icon(Icons.directions_car,
                                size: 40,),
                              SizedBox(height:15),
                              Text(widget.carType,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13,fontFamily: "Brand-Regular"),)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height:MediaQuery.of(context).size.height*0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // SizedBox(width: 25,),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0,left: 40.0),
                        child:RichText(
                            text: TextSpan(
                              text: '\u20B9',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20,fontFamily: "Brand-Bold"),
                              children: <TextSpan>[
                                TextSpan(text:widget.rent,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold,fontFamily: "Brand-Bold")
                                ),
                                TextSpan(text: ' /day',
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 20,fontFamily: "Brand-Regular")
                                ),
                              ],
                            )
                        ),
                        // Text("\u20B9 3000/day",
                        //     style: TextStyle(
                        //         color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold,fontFamily: "Brand-Bold")
                        // ),
                      ),
                      Container(
                        height: 60,
                        width: 200,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              // bottomRight: Radius.circular(40),
                            )
                        ),
                        child: Center(
                          child:Text( 'Book',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 30,fontFamily: "Brand-Bold")
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}