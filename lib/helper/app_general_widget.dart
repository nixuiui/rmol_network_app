import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class AppGeneralWidget {
  static PreferredSize appBarBorderBottom = PreferredSize(
    preferredSize: Size.fromHeight(1),
    child: Divider()
  );
  
  static Widget dotIcon = Container(
    width: 3,
    height: 3,
    margin: EdgeInsets.symmetric(horizontal: 6),
    decoration: BoxDecoration(
      color: Colors.black26,
      borderRadius: BorderRadius.circular(10)
    ),
  );
  
  static backButton(BuildContext context) {
    return IconButton(
      icon: Icon(Ionicons.md_arrow_back, color: Colors.black),
      onPressed: () => Navigator.pop(context),
    );
  }
}