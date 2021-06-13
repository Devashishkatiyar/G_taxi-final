import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackingapp/DataProviders/AppData.dart';
import 'package:trackingapp/Widgets/Driver/HistoryTile.dart';
import 'package:trackingapp/brand_colors.dart';

class HistoryPage extends StatefulWidget {
  static const String id = "DriverHistoryPage";
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip History'),
        backgroundColor: BrandColors.colorPrimary,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_arrow_left),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(0),
        itemBuilder: (context, index) {
          return HistoryTile(
            history: Provider.of<AppData>(context).tripHistory[index],
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 2,
          thickness: 1.5,
          indent: 10,
          endIndent: 10,
          color: BrandColors.colorLightGrayFair,
        ),
        itemCount: Provider.of<AppData>(context).tripHistory.length,
        physics: ClampingScrollPhysics(),
        shrinkWrap:  true,
      ),
    );
  }
}