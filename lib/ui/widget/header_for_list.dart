import 'package:flutter/material.dart';
import 'package:rmol_network_app/ui/widget/box.dart';

class HeaderForListWidget extends StatelessWidget {
  const HeaderForListWidget({
    Key key,
    @required this.title,
    this.page
  }) : super(key: key);

  final String title;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Box(
                    width: 4,
                    height: 36,
                    color: Colors.red,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 12, top: 16, right: 16, bottom: 16),
                    child: Text(
                      title, 
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                ],
              ),
              page != null ? GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => page),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Show All",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                ),
              ) : Container()
            ]
          ),
          Divider(),
        ],
      ),
    );
  }
}