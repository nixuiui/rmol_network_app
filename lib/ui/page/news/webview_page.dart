import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rmol_network_app/core/models/news_model.dart';
import 'package:rmol_network_app/helper/app_general_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {

  WebViewPage({this.news});

  final IndonesianNews news;

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {

  final Completer<WebViewController> controller = Completer<WebViewController>();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Indonesia Terkini"),
        bottom: AppGeneralWidget.appBarBorderBottom,
      ),
      body: Column(
        children: <Widget>[
          isLoading ? Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Memuat"),
          ) : Container(),
          Expanded(
            child: WebView(
              initialUrl: widget.news.postUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                controller.complete(webViewController);
              },
              javascriptChannels: <JavascriptChannel>[
                _toasterJavascriptChannel(context),
              ].toSet(),
              onPageFinished: (String url) {
                setState(() => isLoading = false);
              },
              gestureNavigationEnabled: true,
            ),
          ),
        ],
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Toaster',
      onMessageReceived: (JavascriptMessage message) {
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(message.message)),
        );
      }
    );
  }
}