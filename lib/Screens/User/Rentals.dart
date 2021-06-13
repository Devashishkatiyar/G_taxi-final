import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'AddCar.dart';
import 'CarProfile.dart';

class Rentals extends StatefulWidget{
  static const String id= "Rentals";
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RentalsState();
  }

}
class RentalsState extends State<Rentals>{
  final CollectionReference ref= FirebaseFirestore.instance.collection("Rentals Data");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color:Colors.white,
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
                      SizedBox(width: MediaQuery.of(context).size.width-160,),
                      FloatingActionButton(onPressed: (){
                        Navigator.pushNamed(context, AddCar.id);
                      },
                        tooltip: "Press to add your Car",
                        elevation: 20.0,
                        child:Icon(Icons.add,
                          size: 45,
                          color: Colors.white,),
                        backgroundColor: Colors.green,
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 35,),
                      RichText(
                          text: TextSpan(
                            text: 'What is your ',
                            style: TextStyle(
                                color: Colors.black, fontSize: 23,fontFamily: "Brand-Regular"),
                            children: <TextSpan>[
                              TextSpan(text: 'choice',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 23,fontWeight: FontWeight.bold,fontFamily: "Brand-Bold")
                              ),
                              TextSpan(text: '?',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 23,fontFamily: "Brand-Regular")
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                  SizedBox(height:70),
                  StreamBuilder(
                      stream: ref.snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        else return ListView.builder
                          (
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.hasData?snapshot.data.docs.length :0,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Card(
                                      elevation: 20,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40.0),
                                      ),
                                      child:Container(
                                        height: 260,
                                        width: MediaQuery.of(context).size.width-40,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(40),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 25,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                // SizedBox(width: 0,),
                                                Text('${snapshot.data.docChanges[index].doc['company name']}',
                                                    style: TextStyle(
                                                        color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold,fontFamily: "Brand-Bold")
                                                ),
                                                SizedBox(width: 30,),
                                                Text( '${snapshot.data.docChanges[index].doc['model name']}',
                                                    style: TextStyle(
                                                        color: Colors.black54, fontSize: 20,fontFamily: "Brand-Regular")
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                            GestureDetector(
                                              onTap: (){
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>CarProfile(
                                                  '${snapshot.data.docChanges[index].doc['company name']}',
                                                  '${snapshot.data.docChanges[index].doc['model name']}',
                                                  '${snapshot.data.docChanges[index].doc['per day rent']}',
                                                  '${snapshot.data.docChanges[index].doc['seats']}',
                                                  '${snapshot.data.docChanges[index].doc['Car Type']}',
                                                  '${snapshot.data.docChanges[index].doc['Transmission']}',
                                                  '${snapshot.data.docChanges[index].doc['Fuel Type']}',
                                                  // CarProfile({this.companyName,this.modelName,this.rent,this.seats,this.carType,this.transmission,this.fuelType});
                                                )));
                                              },
                                              child: Container(
                                                height: 130,
                                                // color: Colors.amber,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    fit: BoxFit.contain,
                                                    image: AssetImage("images/taxi.png"),
                                                  ),
                                                ),
                                              ),
                                            ),
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
                                                          TextSpan(text: '${snapshot.data.docChanges[index].doc['per day rent']}',
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
                                                  height: 70,
                                                  width: 180,
                                                  decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(40),
                                                        bottomRight: Radius.circular(40),
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
                                  ),
                                  SizedBox(height: 20,),
                                ],
                              );
                            }
                        );
                      }
                  ),

                ]),
          ),
        ));
  }
  Stream<QuerySnapshot> getDataStreamSnapshots(BuildContext context) async*{
    final uid = await getCurrentUID();
    yield* FirebaseFirestore.instance.collection("Cars data").snapshots();
  }
}