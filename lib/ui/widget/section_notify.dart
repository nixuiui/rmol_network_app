import 'package:flutter/material.dart';

class SectionNotify extends StatelessWidget {
  const SectionNotify({
    Key key,
    this.image,
    this.message
  }) : super(key: key);

  final Widget image;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          image,
          SizedBox(height: 32),
          Text(message, style: TextStyle(
            fontSize: 16,
            color: Colors.black54
          )),
        ],
      ),
    );
  }
}