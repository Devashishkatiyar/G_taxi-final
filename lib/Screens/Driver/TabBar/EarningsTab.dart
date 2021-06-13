import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackingapp/DataProviders/AppData.dart';
import 'package:trackingapp/Screens/Driver/HistoryPage.dart';
import 'package:trackingapp/brand_colors.dart';

class EarningsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Container(
          color: BrandColors.colorPrimary,
          width: double.infinity,
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical: 70),
            child: Column(
              children: [

                Text('Total Earnings', style: TextStyle(color: Colors.white),),
                Text('\u20B9 ${Provider.of<AppData>(context).earnings}', style: TextStyle(color: Colors.white, fontSize: 40, fontFamily: 'Brand-Bold'),)
              ],
            ),
          ),
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
            padding:  EdgeInsets.symmetric(horizontal: 30, vertical: 18),
            child: Row(
              children: [
                Image.asset('images/taxi.png', width: 70,),
                SizedBox(width: 16,),
                Text('Trips', style: TextStyle(fontSize: 16), ),
                Expanded(child: Container(child: Text(Provider.of<AppData>(context).tripCount.toString(), textAlign: TextAlign.end, style: TextStyle(fontSize: 18),))),
              ],
            ),
          ),
        ),

        Divider(
          height: 2,
          thickness: 1.5,
          indent: 10,
          endIndent: 10,
          color: BrandColors.colorLightGrayFair,
        ),

      ],
    );
  }
}