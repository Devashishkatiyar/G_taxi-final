import 'package:flutter/material.dart';
import 'package:trackingapp/DataModels/DriverHistory.dart';
import 'package:trackingapp/Helpers/HelperMethods.dart';
import 'package:trackingapp/brand_colors.dart';


class HistoryTile extends StatelessWidget {

  final History history;
  HistoryTile({this.history});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: <Widget>[

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Container(
                child: Row(
                  children: <Widget>[

                    Image.asset('images/pickicon.png', height: 16, width: 16,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.04,
                    ),
                    Expanded(child: Container(child: Text(history.pickup, style: TextStyle(fontSize: 18),))),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    Text('\u20B9 '+ history.fares != null ? '${history.fares}' :"0", style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 16, color: BrandColors.colorPrimary),),
                  ],
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.01,
              ),

              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Image.asset('images/desticon.png', height: 16, width: 16,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  Expanded(child: Text(history.destination, style: TextStyle(fontSize: 18),)),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.02,
              ),

              Text(HelperMethods.formatMyDate(history.createdAt), style: TextStyle(color: BrandColors.colorTextLight),),
            ],
          ),
        ],
      ),
    );
  }
}
