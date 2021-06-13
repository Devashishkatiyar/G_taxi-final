import 'package:flutter/material.dart';
import 'package:trackingapp/brand_colors.dart';
import 'package:trackingapp/Widgets/Driver/TaxiOutlineButton.dart';

class ConfirmSheet extends StatelessWidget {

  final String title;
  final String subtitle;
  final Function onPressed;

  const ConfirmSheet({Key key,this.onPressed,this.subtitle,this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 5.0,
          spreadRadius: 0.5,
          offset: Offset(0.7, 0.7),
        ),
      ]),
      height: MediaQuery.of(context).size.height * 0.30,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontFamily: "Brand-Bold",
              color: BrandColors.colorText,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: BrandColors.colorTextLight,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.04,
              ),
              Expanded(
                child: TaxiOutlineButton(
                  title: "BACK",
                  textColor: BrandColors.colorText,
                  color: BrandColors.colorLightGrayFair,
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.04,
              ),
              Expanded(
                child: TaxiOutlineButton(
                  textColor: Colors.white,
                  title: "CONFIRM",
                  color: (title=="GO ONLINE")?BrandColors.colorGreen:Colors.red.shade600,
                  onPressed: onPressed
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.04,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
