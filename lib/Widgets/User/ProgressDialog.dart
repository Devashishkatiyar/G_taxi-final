import 'package:flutter/material.dart';
import 'package:trackingapp/brand_colors.dart';


class ProgressDialog extends StatelessWidget {
  final String status;
  ProgressDialog({this.status});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height*0.1,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(BrandColors.colorAccent),
            ),
            Text(
              status,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15
              ),
            ),
          ],
        ),
      ),
    );
  }
}
