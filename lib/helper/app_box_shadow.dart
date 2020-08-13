import 'package:flutter/material.dart';

class AppBoxShadow {
  static BoxShadow type1 = BoxShadow(
    color: Colors.black45,
    offset: Offset(0, 0),
    blurRadius: 3,
    spreadRadius: -1
  );
  
  static BoxShadow type2 = BoxShadow(
    color: Colors.black45,
    offset: Offset(0, -2),
    blurRadius: 5,
    spreadRadius: -4
  );

  static BoxShadow type3 = BoxShadow(
    color: Colors.black26,
    offset: Offset(0, 1),
    blurRadius: 3,
    spreadRadius: -1
  );
}