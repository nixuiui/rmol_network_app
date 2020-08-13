import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  PackageInfo packageInfo;
  String version = "";

  @override
  void initState() {
    super.initState();
    _getAppInfo();
  }

  _getAppInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    startSplashScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Image.asset(
                  "assets/logo.png", 
                  width: MediaQuery.of(context).size.width * (2/3),
                )
              ),
            ),
            Text("$version"),
            SizedBox(height: 24)
          ],
        ),
      ),
    );
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, () {
      Navigator.of(context).pushReplacementNamed("/home");
    });
  }
}