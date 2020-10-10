import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:rmol_network_app/core/bloc/general/general_bloc.dart';
import 'package:rmol_network_app/core/bloc/general/general_event.dart';
import 'package:rmol_network_app/core/bloc/general/general_state.dart';
import 'package:rmol_network_app/core/models/general_info.dart';
import 'package:rmol_network_app/helper/notification_handler.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  PackageInfo packageInfo;
  String version = "";
  final bloc = GeneralBloc();
  GeneralInfoModel data;
  bool isNotifClicked = false;

  @override
  void initState() {
    super.initState();
    bloc.add(LoadGeneralInfo(refresh: true));
    _getAppInfo();
  }

  _getAppInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  setFirebase() async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          isNotifClicked = true;
        });
        NotificationHandler handler = NotificationHandler(message: message);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => handler.pageDirection()),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: bloc,
      listener: (context, state) {
        if(state is GeneralInfoLoaded) {
          startSplashScreen();
          setState(() {
            data = state.data;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: data != null ? Image.network(
                    data.companyLogoColor, 
                    width: MediaQuery.of(context).size.width * (2/3),
                  ) : Container()
                ),
              ),
              Text("$version"),
              SizedBox(height: 24)
            ],
          ),
        ),
      ),
    );
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, () {
      if(!isNotifClicked) {
        Navigator.of(context).pushReplacementNamed("/home");
      }
    });
  }
}