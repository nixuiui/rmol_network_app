import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rmol_network_app/ui/page/home/home_page.dart';
import 'package:rmol_network_app/ui/page/news/news_detail.dart';

class NotificationHandler {
    
    Map<String, dynamic> message;

    NotificationHandler({
        this.message
    });

    Widget pageDirection() {
      return pageDirectionFromNotification(this.getType(), this.getId());
    }

    String getId() =>  Platform.isAndroid ? this.message['data']['id'].toString() : this.message['id'].toString();
    String getTitle() => Platform.isAndroid ? this.message['data']['title'] : this.message['title'];
    String getType() => Platform.isAndroid ? this.message['data']['type'] : this.message['type'];
    String getMessage() => Platform.isAndroid ? this.message['data']['message'] : this.message['message'];

}

Widget pageDirectionFromNotification(String type, String id) {
  switch (type) {
    case "news":
      return NewsDetail(id: id);
    case "public":
      return HomePage();
    default:
    return HomePage();
  }
}