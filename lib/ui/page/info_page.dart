import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:rmol_network_app/core/bloc/general/general_bloc.dart';
import 'package:rmol_network_app/core/bloc/general/general_event.dart';
import 'package:rmol_network_app/core/bloc/general/general_state.dart';
import 'package:rmol_network_app/core/models/page_model.dart';
import 'package:rmol_network_app/helper/app_general_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({
    Key key,
    this.title,
    this.slug
  }) : super(key: key);

  final String title;
  final String slug;

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {

  PageModel page;
  final bloc = GeneralBloc();

  @override
  void initState() {
    bloc.add(LoadPage(slug: widget.slug));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: bloc,
      listener: (context, state) {
        if(state is PageLoaded) {
          setState(() => page = state.data);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: AppGeneralWidget.backButton(context),
          title: Text(page?.title ?? widget.title),
          bottom: AppGeneralWidget.appBarBorderBottom,
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            Html(
              shrinkWrap: true,
              data: page?.pageContent ?? "",
              onLinkTap: (url) => _launchURL(url),
              style: {
                "img": Style(
                  display: Display.INLINE_BLOCK
                ),
                "p, li, ul, span": Style(
                  color: Colors.black87,
                  fontSize: FontSize(16),
                ),
                "blockquote": Style(
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                    fontSize: FontSize(24),
                    fontFamily: 'PTSerif',
                    margin: EdgeInsets.only(left: 0),
                    padding: EdgeInsets.only(left: 16),
                    border: Border(left: BorderSide(color: Colors.red, width: 3))
                ),
                "blockquote p": Style(
                    color: Colors.black87,
                    fontSize: FontSize(20),
                ),
              },
            ),
            SizedBox(height: 40)
          ],
        ),
      ),
    );
  }

  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}