import 'package:flutter/material.dart';

 showSnackBar(String title,BuildContext context){
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 15
      ),
    ),
  );
}