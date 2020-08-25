import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rmol_network_app/core/bloc/general/general_bloc.dart';
import 'package:rmol_network_app/core/bloc/general/general_event.dart';
import 'package:rmol_network_app/core/bloc/general/general_state.dart';
import 'package:rmol_network_app/core/bloc/news/news_bloc.dart';
import 'package:rmol_network_app/core/bloc/news/news_event.dart';
import 'package:rmol_network_app/core/bloc/news/news_state.dart';
import 'package:rmol_network_app/core/models/ads_model.dart';
import 'package:rmol_network_app/core/models/category_model.dart';
import 'package:rmol_network_app/core/models/news_model.dart';
import 'package:rmol_network_app/ui/page/home/about_tab.dart';
import 'package:rmol_network_app/ui/page/home/category_tab.dart';
import 'package:rmol_network_app/ui/page/home/favorit_tab.dart';
import 'package:rmol_network_app/ui/page/home/home_tab.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<StatefulWidget> _layoutPage;

  RefreshController homeRefreshController = RefreshController(initialRefresh: false);
  RefreshController categoryRefreshController = RefreshController(initialRefresh: false);

  final generalBloc = GeneralBloc();

  final homeBloc = NewsBloc();
  final newsBloc = NewsBloc();
  List<IndonesianNews> indonesianNewsList = [];
  List<NewsModel> popularPosts = [];
  List<NewsModel> latePosts = [];
  List<NewsModel> footnotes = [];
  List<NewsModel> opinies = [];
  List<NewsModel> webtorials = [];
  bool  homeStarting = true, 
        isLoadMore = false,
        hasReachedMax = false;
  
  final scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  
  final categoryBloc = NewsBloc();
  List<Category> categories = [];
  bool categoryStarting = true;
  
  final adsBloc = GeneralBloc();
  AdsModel ads;

  @override
  void initState() {
    scrollController.addListener(_onScroll);
    _layoutPage = [
      setHomeTab(),
      setCategoryTab(),
      FavoriteTab(),
      AboutTab(),
    ];
    refreshHome();
    refreshCategory();
    generalBloc.add(CheckUpdate());
    super.initState();
  }

  CategoryTab setCategoryTab() {
    return CategoryTab(
      onRefresh: () => refreshCategory(),
      isStarting: categoryStarting,
      refreshController: categoryRefreshController,
      categories: categories,
    );
  }

  HomeTab setHomeTab() {
    return HomeTab(
      onRefresh: () => refreshHome(),
      isStarting: homeStarting,
      refreshController: homeRefreshController,
      scrollController: scrollController,
      indonesianNewsList: indonesianNewsList,
      popularPosts: popularPosts,
      latePosts: latePosts,
      footnotes: footnotes,
      opinies: opinies,
      webtorials: webtorials,
      isLoadMore: isLoadMore,
      hasReachedMax: hasReachedMax,
      ads: ads
    );
  }

  refreshHome() {
    setState(() {
      _layoutPage[0] = setHomeTab();
    });
    adsBloc.add(LoadAds());
    newsBloc.add(LoadNews(isRefresh: true));
    homeBloc.add(LoadHomeNews());
  }
  
  refreshCategory() {
    setState(() {
      _layoutPage[1] = setCategoryTab();
    });
    categoryBloc.add(LoadCategories(refresh: true));
  }
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener(
          cubit: homeBloc,
          listener: (context, state) {
            if(state is HomeNewsLoaded) {
              homeRefreshController.refreshCompleted();
              setState(() {
                homeStarting = false;
                if(state.indoNews != null) {
                  indonesianNewsList = state.indoNews.indoNews;
                  popularPosts = state.indoNews.popularweek;
                }
                if(state.footnotes != null) footnotes = state.footnotes;
                if(state.opini != null) opinies = state.opini;
                if(state.webtorial != null) webtorials = state.webtorial;
                _layoutPage[0] = setHomeTab();
              });
            }
          }
        ),
        BlocListener(
          cubit: categoryBloc,
          listener: (context, state) {
            if(state is CategoriesLoaded) {
              categoryRefreshController.refreshCompleted();
              setState(() {
                categoryStarting = false;
                categories = state.data;
                _layoutPage[1] = setCategoryTab();
              });
            }
          }
        ),
        BlocListener(
          cubit: newsBloc,
          listener: (context, state) {
            if(state is NewsLoaded) {
              homeRefreshController.refreshCompleted();
              setState(() {
                homeStarting = false;
                isLoadMore = false;
                hasReachedMax = state.hasReachedMax;
                latePosts = state.data;
                _layoutPage[0] = setHomeTab();
              });
            }
          }
        ),
        BlocListener(
          cubit: generalBloc,
          listener: (context, state) async {
            if(state is UpdateCheckingResult) {
              if(state.isNeedUpdate) showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Container(
                      height: 270,
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/upgrade.svg", width: 130),
                          Text(
                            "Aplikasi RMOL LAMPUNG Telah Update di Playstore!!",
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _launchURL(state.data.androidDownloadLink);
                              },
                              color: Colors.red,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: Colors.transparent, width: 0),
                              ),
                              disabledElevation: 0,
                              padding: EdgeInsets.all(12),
                              child: Text("Update Sekarang", style: TextStyle(color: Colors.white)),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              );
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
        body: _layoutPage.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black87,
          unselectedItemColor: Colors.grey[400],
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Feather.home), title: Text('', style: TextStyle(fontSize: 0))
            ),
            BottomNavigationBarItem(
              icon: Icon(Feather.layers), title: Text('', style: TextStyle(fontSize: 0))
            ),
            BottomNavigationBarItem(
              icon: Icon(Feather.heart), title: Text('', style: TextStyle(fontSize: 0))
            ),
            BottomNavigationBarItem(
              icon: Icon(Feather.info), title: Text('', style: TextStyle(fontSize: 0))
            ),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onTabItem,
        ),
      ),
    );
  }
  
  void _onTabItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onScroll() {
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold && !hasReachedMax && !isLoadMore) {
      if(!homeStarting) {
        newsBloc.add(LoadNews(isLoadMore: true));
      }
      setState(() {
        isLoadMore = true;
      });
      _layoutPage[0] = setHomeTab();
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}