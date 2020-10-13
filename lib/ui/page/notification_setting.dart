import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rmol_network_app/helper/app_general_widget.dart';
import 'package:rmol_network_app/ui/widget/text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  bool notificationActive = false;

  @override
  void initState() {
    checkNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pengaturan"),
        bottom: AppGeneralWidget.appBarBorderBottom,
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16, right: 16, bottom: 8, left: 16),
            child: TextCustom(
              "Aktifkan jika ingin menerima pemberitahuan berita terbaru.", 
              maxLines: 3,
              fontSize: 12
            ),
          ),
          Divider(),
          Container(
            color: Colors.white,
            child: SwitchListTile(
              value: notificationActive,
              title: Text("Pemberitahuan"),
              onChanged: (bool value) {
                setState(() {
                  notificationActive = value;
                  setNotification(value);
                });
              }
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  setNotification(bool isActive) async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(isActive) {
      prefs.setString("subscribeNotif", "subscribed");
      _firebaseMessaging.subscribeToTopic("rmolkalbar_public");
      print("subscribed");
    }
    else {
      prefs.setString("subscribeNotif", "unsubscribed");
      _firebaseMessaging.unsubscribeFromTopic("rmolkalbar_public");
      print("unsubscribed");
    }
  }
  
  checkNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var subscribeNotif = prefs.getString("subscribeNotif");
    setState(() {
      notificationActive = subscribeNotif == null || subscribeNotif == "subscribed";
    });
  }

}