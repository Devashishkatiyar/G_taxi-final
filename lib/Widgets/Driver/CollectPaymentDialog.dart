import 'package:flutter/material.dart';
import 'package:trackingapp/Helpers/HelperMethods.dart';
import 'package:trackingapp/Widgets/User/TaxiButton.dart';
import 'package:trackingapp/brand_colors.dart';

class CollectPayment extends StatelessWidget {

  final int fares;

  CollectPayment({this.fares});


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),

            Text('PAYMENT'),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),

            Divider(
              height: 2,
              thickness: 1.5,
              indent: 10,
              endIndent: 10,
              color: BrandColors.colorLightGrayFair,
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),

            Text("\u20B9 $fares", style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 50),),

            SizedBox(height: 16,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Amount above is the total fares to be charged to the rider', textAlign: TextAlign.center,),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),

            Container(
              width: 230,
              child: TaxiButton(
                title: 'CONFIRM',
                bgColor: BrandColors.colorGreen,
                onPressed: (){

                  Navigator.pop(context);
                  Navigator.pop(context);

                  HelperMethods.enableHomeTabLocationUpdates();

                },
              ),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
          ],
        ),
      ),
    );
  }
}