import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:rmol_network_app/core/bloc/news/news_bloc.dart';
import 'package:rmol_network_app/core/bloc/news/news_event.dart';
import 'package:rmol_network_app/core/bloc/news/news_state.dart';
import 'package:rmol_network_app/core/models/news_model.dart';
import 'package:rmol_network_app/helper/app_general_widget.dart';
import 'package:rmol_network_app/ui/page/news/news_list_page.dart';
import 'package:rmol_network_app/ui/widget/header_for_list.dart';
import 'package:rmol_network_app/ui/widget/news_item.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetail extends StatefulWidget {
  const NewsDetail({
    Key key,
    this.news
  }) : super(key: key);

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

  @override
  void initState() {
    initializeDateFormatting();
    formatDate = DateFormat.yMMMMEEEEd("id").add_Hm();
    bloc.add(LoadNews(type: "news", perPage: 5, page: 1));
    favoritBloc.add(LoadFavorits());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener(
          bloc: bloc,
          listener: (context, state) {
            if(state is NewsLoaded) {
              setState(() {
                news = state.data;
                isStarting = false;
              });
            }
          }
        ),
        BlocListener(
          bloc: favoritBloc,
          listener: (context, state) {
            if(state is NewsFavoritsLoaded) {
              setState(() {
                favorits = state.data;
                if(favorits.length > 0) {
                  if(favorits.firstWhere((item) => item.content.id == widget.news.content.id) != null) {
                    isFavorite = true;
                  }
                }
              });
            }
          }
        )
      ],
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
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
                                image: NetworkImage("http://rmoljatim.id/assets/img/user.png"),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Oleh", style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 11
                                )),
                                Text(widget.news.content.authorUsername, 
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
              ),
              Divider(),
              Expanded(
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
                                    title: widget?.news?.content?.categoryName ?? "",
                                    type: "category",
                                    cat: widget?.news?.content?.categorySlug ?? "",
                                  )),
                                ),
                                child: Text(widget?.news?.content?.categoryName ?? "", 
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blueAccent
                                  )
                                ),
                              ),
                              AppGeneralWidget.dotIcon,
                              Text(formatDate.format(widget.news.content.createdAt).toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black45
                                )
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            widget?.news?.content?.title ?? "",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.black87,
                              fontWeight: FontWeight.w700
                            ),
                          ),
                          SizedBox(height: 32),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: AspectRatio(
                              aspectRatio: 600/420,
                              child: Image.network(widget.news.content.imageBig, fit: BoxFit.cover)
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              widget?.news?.content?.imageDescription ?? "",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(widget?.news?.content?.summary ?? "", style: TextStyle(
                            fontWeight: FontWeight.w500
                          )),
                          Html(
                            shrinkWrap: true,
                            data: widget?.news?.content?.content ?? "",
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
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text("Editor: ${widget.news?.content?.editorUsername}"),
                          ),
                          Container(
                            child: Wrap(
                              children: widget.news.tag.map((data){
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
                          )
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
    var desc = widget.news.content.title + "\n\n";
    desc += widget.news.content.postUrl;
    Share.text('Bagikan Berita', desc, 'text/plain');
  }

  favoriteClicked() {
    setState(() {
      isFavorite = !isFavorite;
      if(isFavorite) {
        favorits.add(widget.news);
      }
      else {
        favorits.removeAt(favorits.indexWhere((item) => item.content.id == widget.news.content.id));
      }
      favoritBloc.add(UpdateFavorite(favorits: favorits));
    });
  }
}