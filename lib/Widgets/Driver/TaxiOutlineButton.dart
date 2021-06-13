import 'package:flutter/material.dart';


class TaxiOutlineButton extends StatelessWidget {

  final String title;
  final Function onPressed;
  final Color color;
  final Color textColor;

  TaxiOutlineButton({this.title, this.onPressed, this.color,this.textColor});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: textColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          primary: textColor,
          backgroundColor: color,
        ),
        child: Container(
          height: 50.0,
          child: Center(
            child: Text(
                title,
                style: TextStyle(fontSize: 15.0, fontFamily: 'Brand-Bold')
            ),
          ),
        )
    );
  }
}


