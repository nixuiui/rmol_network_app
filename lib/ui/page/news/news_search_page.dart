import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rmol_network_app/core/bloc/news/news_bloc.dart';
import 'package:rmol_network_app/core/bloc/news/news_event.dart';
import 'package:rmol_network_app/core/bloc/news/news_state.dart';
import 'package:rmol_network_app/core/models/news_model.dart';
import 'package:rmol_network_app/helper/app_general_widget.dart';
import 'package:rmol_network_app/ui/page/news/news_detail.dart';
import 'package:rmol_network_app/ui/widget/news_item.dart';
import 'package:rmol_network_app/ui/widget/section_notify.dart';

class NewsSearchPage extends StatefulWidget {
  const NewsSearchPage({
    Key key
  }) : super(key: key);

  @override
  NewsSearchPageState createState() => NewsSearchPageState();
}

class NewsSearchPageState extends State<NewsSearchPage> {

  List<NewsModel> news = <NewsModel>[];
  final bloc = NewsBloc();
  
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  bool  isRefreshing = false, 
        isLoadMore = false,
        hasReachedMax = false,
        isLoaded = true;

  String message = "Ketik untuk mencari berita";

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    _searchController.text = "";
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: bloc,
      listener: (context, state) {
        if(state is NewsLoaded) {
          setState(() {
            isLoaded = true;
            isRefreshing = false;
            isLoadMore = false;
            hasReachedMax = state.hasReachedMax;
            news = state.data;
            message = state.data.length <= 0 ? "Hasil pencarian tidak ditemukan" : "";
          });
          _refreshController.refreshCompleted();
        } else if (state is NewsFailure) {
          setState(() {
            isRefreshing = false;
            isLoadMore = false;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: AppGeneralWidget.backButton(context),
          title: Text("Cari"),
          bottom: AppGeneralWidget.appBarBorderBottom,
          actions: <Widget>[
            IconButton(
              icon: Icon(Feather.home, color: Colors.black87), 
              onPressed: () => Navigator.popUntil(context, ModalRoute.withName("/home"))
            )
          ],
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                        child: TextFormField(
                          controller: _searchController,
                          cursorColor: Colors.black54,
                          style: TextStyle(color: Colors.black87, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: "Search here...",
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black38),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16)
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.grey[50],
                    child: IconButton(
                      color: Colors.white,
                      disabledColor: Colors.white,
                      icon: Icon(Icons.search, color: Colors.black87),
                      onPressed: () {
                        setState(() {
                          isLoaded = false;
                          isRefreshing = true;
                        });
                        bloc.add(LoadNews(
                          isRefresh: true,
                          type: "search",
                          keyword: _searchController.text,
                        ));
                      }
                    ),
                  )
                ],
              ),
              Divider(),
              Expanded(
                child: isLoaded && news.length <= 0 
                ? SectionNotify(
                  message: message,
                  image: SvgPicture.asset(
                    "assets/search.svg",
                    width: 100
                  ),
                )
                : SmartRefresher(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  child: ListView(
                    shrinkWrap: true,
                    controller: _scrollController,
                    children: <Widget>[
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: isRefreshing ? 3 : news.length,
                        itemBuilder: (context, index) => 
                          isRefreshing
                          ? ShimmerNewsVerticalItem() 
                          : NewsVerticalItem(
                            onClick: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => NewsDetail(news: news[index])),
                            ),
                            news: news[index]
                          ),
                      ),
                      isLoadMore ? ShimmerNewsVerticalItem() : Container()
                    ],
                  )
                ),
              )
            ]
          ),
        )
      ),
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold && !hasReachedMax && !isLoadMore) {
      if(!isRefreshing) {
        bloc.add(LoadNews(
          isLoadMore: true,
          type: "search",
          keyword: _searchController.text,
        ));
      }
      setState(() {
        isLoadMore = true;
      });
    }
  }

  Future<void> _onRefresh() async {
    if(!isRefreshing && !isLoadMore) {
      bloc.add(LoadNews(
        isRefresh: true,
        type: "search",
        keyword: _searchController.text,
      ));
      setState(() {
        isRefreshing = false;
      });
    }
  }

}