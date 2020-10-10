import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:rmol_network_app/core/bloc/general/general_bloc.dart';
import 'package:rmol_network_app/core/bloc/general/general_event.dart';
import 'package:rmol_network_app/core/bloc/general/general_state.dart';
import 'package:rmol_network_app/core/bloc/news/news_bloc.dart';
import 'package:rmol_network_app/core/bloc/news/news_event.dart';
import 'package:rmol_network_app/core/bloc/news/news_state.dart';
import 'package:rmol_network_app/core/models/ads_model.dart';
import 'package:rmol_network_app/core/models/news_model.dart';
import 'package:rmol_network_app/helper/app_general_widget.dart';
import 'package:rmol_network_app/ui/page/news/news_list_page.dart';
import 'package:rmol_network_app/ui/widget/box.dart';
import 'package:rmol_network_app/ui/widget/header_for_list.dart';
import 'package:rmol_network_app/ui/widget/news_item.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetail extends StatefulWidget {
  const NewsDetail({
    Key key,
    this.news,
    this.id
  }) : super(key: key);

  final String id;
  final NewsModel news;

  @override
  _NewsDetailState createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {

  DateFormat formatDate;
  final bloc = NewsBloc();
  final favoritBloc = NewsBloc();
  List<NewsModel> news = <NewsModel>[];
  List<NewsModel> favorits = <NewsModel>[];
  bool isFavorite = false;
  bool isStarting = true;
  NewsModel newsDetail;

  final adsBloc = GeneralBloc();
  AdsModel ads;

  @override
  void initState() {
    if(widget.news != null) {
      newsDetail = widget.news;
      bloc.add(LoadNews(type: "news", perPage: 5, page: 1));
    }
    if(widget.id != null) {
      bloc.add(LoadNewsDetail(id: widget.id));
    }

    adsBloc.add(LoadAds());
    initializeDateFormatting();
    formatDate = DateFormat.yMMMMEEEEd("id").add_Hm();
    favoritBloc.add(LoadFavorits());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener(
          cubit: bloc,
          listener: (context, state) {
            if(state is NewsLoaded) {
              setState(() {
                news = state.data;
                isStarting = false;
              });
            }
            else if(state is NewsDetailLoaded) {
              setState(() {
                newsDetail = state.data;
                bloc.add(LoadNews(type: "news", perPage: 5, page: 1));
              });
            }
          }
        ),
        BlocListener(
          cubit: favoritBloc,
          listener: (context, state) {
            if(state is NewsFavoritsLoaded) {
              setState(() {
                favorits = state.data;
                if(favorits.length > 0) {
                  if(favorits.firstWhere((item) => item.content.id == newsDetail?.content?.id) != null) {
                    isFavorite = true;
                  }
                }
              });
            }
          }
        ),
        BlocListener(
          cubit: adsBloc,
          listener: (context, state) async {
            if(state is AdsLoaded) {
              setState(() => ads = state.data);
            }
          }
        )
      ],
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              newsDetail != null ? Container(
                child: Row(
                  children: <Widget>[
                    AppGeneralWidget.backButton(context),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 30,
                            height: 30,
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(50),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage("http://rmolpapua.id/assets/img/user.png"),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(newsDetail?.content?.hideReport == 1 ? "Oleh" : "Laporan", style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 11
                                )),
                                Text(newsDetail?.content?.authorUsername ?? "", 
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13
                                  )
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      icon: Icon(Ionicons.md_share, size: 20, color: Colors.black87),
                      onPressed: () => sharePost()
                    ),
                    IconButton(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      icon: Icon(isFavorite ? Ionicons.ios_heart : Ionicons.ios_heart_empty, size: 20, color: Colors.black87),
                      onPressed: () => favoriteClicked()
                    ),
                    IconButton(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      icon: Icon(Feather.home, color: Colors.black87),
                      onPressed: () => Navigator.popUntil(context, ModalRoute.withName("/home"))
                    ),
                  ],
                ),
              ) : Row(
                children: <Widget>[
                  AppGeneralWidget.backButton(context),
                  Expanded(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Box(
                            width: 30,
                            height: 30,
                            color: Colors.grey,
                            borderRadius: 50,
                          ),
                          SizedBox(width: 8),
                          Box(
                            width: 50,
                            height: 10,
                            color: Colors.grey,
                            borderRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              newsDetail != null ? Expanded(
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 16),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => NewsListPage(
                                    title: newsDetail?.content?.categoryName ?? "",
                                    type: "category",
                                    cat: newsDetail?.content?.categorySlug ?? "",
                                  )),
                                ),
                                child: Text(newsDetail?.content?.categoryName ?? "", 
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blueAccent
                                  )
                                ),
                              ),
                              AppGeneralWidget.dotIcon,
                              Text(formatDate.format(newsDetail?.content?.createdAt).toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black45
                                )
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            newsDetail?.content?.title ?? "",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.black87,
                              fontWeight: FontWeight.w700
                            ),
                          ),
                          SizedBox(height: 32),
                          newsDetail?.content?.imageBig != null ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: AspectRatio(
                              aspectRatio: 600/420,
                              child: Image.network(newsDetail?.content?.imageBig ?? "", fit: BoxFit.cover)
                            )
                          ) : Container(),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              newsDetail?.content?.imageDescription ?? "",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(newsDetail?.content?.summary ?? "", style: TextStyle(
                            fontWeight: FontWeight.w500
                          )),
                          MediaQuery( 
                            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                            child: Html(
                              shrinkWrap: true,
                              data: newsDetail?.content?.content ?? "",
                              onLinkTap: (url) => _launchURL(url),
                              style: {
                                "img": Style(
                                  display: Display.INLINE_BLOCK
                                ),
                                "p, li, ul, span": Style(
                                  color: Colors.black87,
                                  fontSize: FontSize(16),
                                  fontFamily: 'PTSerif',
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
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text("Editor: ${newsDetail?.content?.editorUsername ?? ''}"),
                          ),
                          Container(
                            child: Wrap(
                              children: newsDetail.tag.map((data){
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => NewsListPage(
                                      title: "Tag: ${data.tag}",
                                      type: "tag",
                                      tag: data.tagSlug
                                    )),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                    margin: EdgeInsets.only(right: 8, bottom: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.grey[200])
                                    ),
                                    child: Text(
                                      data.tag,
                                      style: TextStyle(
                                        fontFamily: "Gilroy",
                                        color: Colors.blueAccent
                                      ),
                                    )
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          ads?.getAds()?.img != null ? GestureDetector(
                            onTap: () => _launchURL(ads?.getAds()?.link),
                            child: Image.network(ads?.getAds()?.img)
                          ) : Container(),
                        ],
                      ),
                    ),
                    Divider(),
                    HeaderForListWidget(title: "Berita Terkait"),
                    !isStarting ? ListView.separated(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: news.length,
                      itemBuilder: (context, index) {
                        return NewsVerticalItem(
                          news: news[index],
                          onClick: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NewsDetail(news: news[index])),
                          )
                        );
                      }
                    ) : ShimmerNewsVerticalItem()
                  ],
                ),
              ) : Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Box(
                        width: 200,
                        height: 10,
                        borderRadius: 8,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 8),
                      Box(
                        width: 300,
                        height: 10,
                        borderRadius: 8,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      AspectRatio(
                        aspectRatio: 800/500,
                        child: Box(
                          width: MediaQuery.of(context).size.width,
                          borderRadius: 8,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              ),
            ],
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

  sharePost() {
    var desc = (newsDetail?.content?.title ?? "") + "\n\n";
    desc += newsDetail?.content?.postUrl ?? "";
    Share.text('Bagikan Berita', desc, 'text/plain');
  }

  favoriteClicked() {
    setState(() {
      isFavorite = !isFavorite;
      if(isFavorite) {
        favorits.add(newsDetail);
      }
      else {
        favorits.removeAt(favorits.indexWhere((item) => item.content.id == newsDetail.content.id));
      }
      favoritBloc.add(UpdateFavorite(favorits: favorits));
    });
  }
}