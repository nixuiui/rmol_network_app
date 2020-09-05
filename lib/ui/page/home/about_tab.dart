import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:rmol_network_app/core/bloc/general/general_bloc.dart';
import 'package:rmol_network_app/core/bloc/general/general_event.dart';
import 'package:rmol_network_app/core/bloc/general/general_state.dart';
import 'package:rmol_network_app/core/models/general_info.dart';
import 'package:rmol_network_app/ui/page/info_page.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutTab extends StatefulWidget {
  const AboutTab({
    Key key,
    this.appInfo
  }) : super(key: key);

  final GeneralInfoModel appInfo;

  @override
  _AboutTabState createState() => _AboutTabState();
}

class _AboutTabState extends State<AboutTab> {

  final generalBloc = GeneralBloc();
  GeneralInfoModel info;

  @override
  void initState() {
    generalBloc.add(LoadGeneralInfo());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: generalBloc,
      listener: (context, state) {
        if(state is GeneralInfoLoaded) {
          setState(() {
            info = state.data;
          });
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(24),
            width: MediaQuery.of(context).size.width,
            child: ListView(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 48),
                    info != null ? Image.network(info.companyLogoColor, width: 160) : Container(),
                    SizedBox(height: 48),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300]),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Feather.info, color: Color(0xff15afff)),
                            title: Text("Tentang Kami", style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600
                            )),
                            onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (context) => InfoPage(
                                title: "Tentang Kami",
                                slug: "tentang-kami",
                              )),
                            ),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Feather.phone, color: Color(0xff15afff)),
                            title: Text("Kontak", style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600
                            )),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Feather.file_text, color: Color(0xff15afff)),
                            title: Text("Disclaimer", style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600
                            )),
                            onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (context) => InfoPage(
                                title: "Disclaimer",
                                slug: "disclaimer",
                              )),
                            ),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Feather.users, color: Color(0xff15afff)),
                            title: Text("Ketentuan Kontributor", style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600
                            ))
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Feather.globe, color: Color(0xff15afff)),
                            title: Text("Kunjungi Website", style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600
                            )),
                            onTap: () => _launchURL("https://www.rmollampung.id/"),
                          ),
                          Divider(),
                          Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: <Widget>[
                                Text("Ikuti Kami", style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600
                                )),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    info?.facebook != null && info?.facebook != "" ? GestureDetector(
                                      onTap: () => _launchURL(info.facebook),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Ionicons.logo_facebook, color: Color(0xff1977f3)),
                                      )
                                    ) : Container(),
                                    info?.twitter != null && info?.twitter != "" ? GestureDetector(
                                      onTap: () => _launchURL(info.twitter),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Ionicons.logo_twitter, color: Color(0xff1ca1f2)),
                                      )
                                    ) : Container(),
                                    info?.instagram != null && info?.instagram != "" ? GestureDetector(
                                      onTap: () => _launchURL(info.instagram),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Ionicons.logo_instagram, color: Color(0xff563e94)),
                                      )
                                    ) : Container(),
                                    info?.youtube != null && info?.youtube != "" ? GestureDetector(
                                      onTap: () => _launchURL(info.youtube),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Ionicons.logo_youtube, color: Color(0xffcf1312)),
                                      )
                                    ) : Container(),
                                  ],
                                ),
                              ],
                            )
                          )
                        ],
                      )
                    ),
                    SizedBox(height: 24),
                    Text(info?.emailOffice ?? "", textAlign: TextAlign.center),
                    SizedBox(height: 8),
                    Text(info?.addressOffice ?? "", textAlign: TextAlign.center),
                    SizedBox(height: 24),
                    Text(info?.androidVersion ?? ""),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}