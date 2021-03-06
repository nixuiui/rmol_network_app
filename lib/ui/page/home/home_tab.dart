import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rmol_network_app/core/models/ads_model.dart';
import 'package:rmol_network_app/core/models/general_info.dart';
import 'package:rmol_network_app/core/models/news_model.dart';
import 'package:rmol_network_app/helper/app_general_widget.dart';
import 'package:rmol_network_app/ui/page/news/news_detail.dart';
import 'package:rmol_network_app/ui/page/news/news_search_page.dart';
import 'package:rmol_network_app/ui/page/news/webview_page.dart';
import 'package:rmol_network_app/ui/widget/header_for_list.dart';
import 'package:rmol_network_app/ui/widget/news_item.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({
    Key key,
    this.onRefresh,
    this.refreshController,
    this.scrollController,
    this.indonesianNewsList,
    this.latePosts,
    this.popularPosts,
    this.footnotes,
    this.opinies,
    this.webtorials,
    this.isStarting,
    this.isLoadMore,
    this.hasReachedMax,
    this.appInfo,
    this.ads,
  }) : super(key: key);

  final VoidCallback onRefresh;
  final RefreshController refreshController;
  final ScrollController scrollController;
  final List<IndonesianNews> indonesianNewsList;
  final List<NewsModel> popularPosts;
  final List<NewsModel> latePosts;
  final List<NewsModel> footnotes;
  final List<NewsModel> opinies;
  final List<NewsModel> webtorials;
  final bool isStarting;
  final bool isLoadMore;
  final bool hasReachedMax;
  final GeneralInfoModel appInfo;
  final AdsModel ads;

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  @override
  void initState() {
    super.initState();
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: widget.appInfo != null ? Image.network(widget.appInfo.companyLogoColor, height: 30) : Container(),
        bottom: AppGeneralWidget.appBarBorderBottom,
        actions: <Widget>[
          IconButton(
            icon: Icon(Feather.search), 
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewsSearchPage()),
            )
          )
        ],
      ),
      body: SmartRefresher(
        controller: widget.refreshController,
        onRefresh: widget.onRefresh,
        child: ListView(
          controller: widget.scrollController,
          children: <Widget>[
            HeaderForListWidget(title: "Berita Terbaru", page: null),
            Container(
              height: 235,
              child: ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.all(16),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => SizedBox(width: 16),
                itemCount: widget.isStarting ? 4 : (widget.latePosts.length > 5 ? 5 : widget.latePosts.length),
                itemBuilder: (context, index) => !widget.isStarting ? NewsHorizontalItem(
                  news: widget.latePosts[index],
                  onClick: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewsDetail(news: widget.latePosts[index])),
                  ),
                ) : ShimmerNewsHorizontalItem()
              ),
            ),
            widget.ads?.getAds()?.img != null ? GestureDetector(
              onTap: () => _launchURL(widget.ads?.getAds()?.link),
              child: Image.network(widget.ads?.getAds()?.img)
            ) : Container(),
            HeaderForListWidget(title: "Indonesia Terkini", page: null),
            ListView.separated(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              separatorBuilder: (context, index) => Divider(),
              itemCount: widget.isStarting ? 3 : widget.indonesianNewsList.length,
              itemBuilder: (context, index) => !widget.isStarting ? NewsTitleOnlyItem(
                news: widget.indonesianNewsList[index],
                onClick: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WebViewPage(news: widget.indonesianNewsList[index])),
                )
              ) : ShimmerNewsTitleOnlyItem()
            ),
            !widget.isStarting && widget.popularPosts.length == 0 ? Container() : HeaderForListWidget(title: "Terpopuler", page: null),
            !widget.isStarting && widget.popularPosts.length == 0 ? Container() : Container(
              height: 235,
              child: ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.all(16),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => SizedBox(width: 16),
                itemCount: widget.isStarting ? 4 : widget.popularPosts.length,
                itemBuilder: (context, index) => !widget.isStarting ? NewsHorizontalItem(
                  news: widget.popularPosts[index],
                  onClick: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewsDetail(news: widget.popularPosts[index])),
                  ),
                ) : ShimmerNewsHorizontalItem()
              ),
            ),
            !widget.isStarting && widget.footnotes.length == 0 ? Container() : HeaderForListWidget(title: "Footnote", page: null),
            !widget.isStarting && widget.footnotes.length == 0 ? Container() : Container(
              height: 235,
              child: ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.all(16),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => SizedBox(width: 16),
                itemCount: widget.isStarting ? 4 : widget.footnotes.length,
                itemBuilder: (context, index) => !widget.isStarting ? NewsHorizontalItem(
                  news: widget.footnotes[index],
                  onClick: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewsDetail(news: widget.footnotes[index])),
                  ),
                ) : ShimmerNewsHorizontalItem()
              ),
            ),
            !widget.isStarting && widget.opinies.length == 0 ? Container() : HeaderForListWidget(title: "Opini", page: null),
            !widget.isStarting && widget.opinies.length == 0 ? Container() : Container(
              height: 235,
              child: ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.all(16),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => SizedBox(width: 16),
                itemCount: widget.isStarting ? 4 : widget.opinies.length,
                itemBuilder: (context, index) => !widget.isStarting ? NewsHorizontalItem(
                  news: widget.opinies[index],
                  onClick: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewsDetail(news: widget.opinies[index])),
                  ),
                ) : ShimmerNewsHorizontalItem()
              ),
            ),
            !widget.isStarting && widget.webtorials.length == 0 ? Container() : HeaderForListWidget(title: "Webtorial", page: null),
            !widget.isStarting && widget.webtorials.length == 0 ? Container() : Container(
              height: 235,
              child: ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.all(16),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => SizedBox(width: 16),
                itemCount: widget.isStarting ? 4 : widget.webtorials.length,
                itemBuilder: (context, index) => !widget.isStarting ? NewsHorizontalItem(
                  news: widget.webtorials[index],
                  onClick: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewsDetail(news: widget.webtorials[index])),
                  ),
                ) : ShimmerNewsHorizontalItem()
              ),
            ),
            widget.ads?.getAds()?.img != null ? GestureDetector(
              onTap: () => _launchURL(widget.ads?.getAds()?.link),
              child: Image.network(widget.ads?.getAds()?.img)
            ) : Container(),
            Divider(),
            ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 40),
              children: <Widget>[
                !widget.isStarting ? ListView.separated(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.all(0),
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: widget.latePosts.length,
                  itemBuilder: (context, index) => NewsVerticalItem(
                    news: widget.latePosts[index],
                    ads: (index+1)%15 == 0 ? widget.ads : null,
                    onClick: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewsDetail(news: widget.latePosts[index])),
                    ),
                  ),
                ) : ShimmerNewsVerticalItem(),
                widget.isLoadMore ? ShimmerNewsVerticalItem() : Container()
              ],
            ),
            SizedBox(height: 80)
          ],
        ),
      ),
    );
  }
}