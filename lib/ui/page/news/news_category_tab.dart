import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rmol_network_app/core/bloc/news/news_bloc.dart';
import 'package:rmol_network_app/core/bloc/news/news_event.dart';
import 'package:rmol_network_app/core/bloc/news/news_state.dart';
import 'package:rmol_network_app/core/models/category_model.dart';
import 'package:rmol_network_app/core/models/news_model.dart';
import 'package:rmol_network_app/helper/ad_manager.dart';
import 'package:rmol_network_app/helper/app_color.dart';
import 'package:rmol_network_app/helper/app_general_widget.dart';
import 'package:rmol_network_app/ui/page/news/news_detail.dart';
import 'package:rmol_network_app/ui/widget/news_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsCategoryTab extends StatefulWidget {
  const NewsCategoryTab({
    Key key,
    this.categorySelected,
    this.categories
  }) : super(key: key);

  final Category categorySelected;
  final List<Category> categories;

  @override
  _NewsCategoryTabState createState() => _NewsCategoryTabState();
}

class _NewsCategoryTabState extends State<NewsCategoryTab> {

  int initialIndex = 0;

  @override
  void initState() {
    setAd();
    initialIndex = widget.categories.indexWhere((item) => item.id == widget.categorySelected.id);
    super.initState();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        DefaultTabController(
          length: widget.categories.length,
          initialIndex: initialIndex,
          child: Scaffold(
            appBar: AppBar(
              title: Text("RUBRIK"),
              leading: AppGeneralWidget.backButton(context),
              elevation: 1,
              bottom: TabBar(
                labelColor: Colors.black87,
                unselectedLabelColor: Colors.black45,
                indicatorColor: AppColor.red,
                isScrollable: true,
                indicatorWeight: 2,
                tabs: List.generate(widget.categories.length, (index) {
                  return Tab(child: Text(widget.categories[index].name));
                }).toList(),
              ),
            ),
            body: TabBarView(
              children: List.generate(widget.categories.length, (index) {
                return NewsList(category: widget.categories[index]);
              }).toList(),
            )
          ),
        )
      ],
    );
  }



  // ADMOB
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: null,
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
    nonPersonalizedAds: true,
  );

  InterstitialAd _interstitialAd;
  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: AdManager.interstitialAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }
  
  setAd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var count = prefs.getInt("count");
    if(count == null) {
      prefs.setInt("count", 20);
    }
    else {
      if(count > 0) prefs.setInt("count", count-1);
      else {
        prefs.setInt("count", 20);
        _interstitialAd = createInterstitialAd()..load()..show();
      }
    }
  }
}

class NewsList extends StatefulWidget {
  const NewsList({
    Key key,
    this.category
  }) : super(key: key);

  final Category category;

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<NewsModel> news = <NewsModel>[];
  final bloc = NewsBloc();
  bool  isStarting = true,
        isLoadMore = false,
        hasReachedMax = false;

  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    bloc.add(LoadNews(
      type: "category",
      cat: widget.category.nameSlug,
      isRefresh: true
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: bloc,
      listener: (context, state) {
        if(state is NewsLoaded) {
          _refreshController.refreshCompleted();
          setState(() {
            news = state.data;
            isStarting = false;
            isLoadMore = false;
            hasReachedMax = state.hasReachedMax;
          });
        }
      },
      child: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          controller: _scrollController,
          padding: EdgeInsets.only(bottom: 40),
          children: <Widget>[
            !isStarting ? ListView.separated(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.all(0),
              separatorBuilder: (context, index) => Divider(),
              itemCount: news.length,
              itemBuilder: (context, index) => NewsVerticalItem(
                news: news[index],
                onClick: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewsDetail(news: news[index])),
                ),
              ),
            ) : ShimmerNewsVerticalItem(),
            isLoadMore ? ShimmerNewsVerticalItem() : Container()
            // SectionNotify(
            //   message: "Tidak ada artikel ditemukan",
            //   image: SvgPicture.asset(
            //     "assets/empty-data.svg",
            //     width: 100
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold && !hasReachedMax && !isLoadMore) {
      if(!isStarting) {
        bloc.add(LoadNews(
          isLoadMore: true,
          type: "category",
          cat: widget.category.nameSlug,
        ));
      }
      setState(() {
        isLoadMore = true;
      });
    }
  }

  Future<void> _onRefresh() async {
    if(!isStarting && !isLoadMore) {
      bloc.add(LoadNews(
        isRefresh: true,
        type: "category",
        cat: widget.category.nameSlug,
      ));
      setState(() {
        isStarting = false;
      });
    }
  }

}