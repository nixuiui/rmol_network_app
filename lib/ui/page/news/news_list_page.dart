import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rmol_network_app/core/bloc/news/news_bloc.dart';
import 'package:rmol_network_app/core/bloc/news/news_event.dart';
import 'package:rmol_network_app/core/bloc/news/news_state.dart';
import 'package:rmol_network_app/core/models/news_model.dart';
import 'package:rmol_network_app/helper/app_general_widget.dart';
import 'package:rmol_network_app/ui/page/news/news_detail.dart';
import 'package:rmol_network_app/ui/widget/news_item.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({
    Key key,
    this.title,
    this.type,
    this.tag,
    this.cat,
  }) : super(key: key);

  final String title;
  final String type;
  final String tag;
  final String cat;

  @override
  NewsListPageState createState() => NewsListPageState();
}

class NewsListPageState extends State<NewsListPage> {

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
      type: widget.type,
      tag: widget.tag,
      cat: widget.cat,
      isRefresh: true
    ));
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
      child: Scaffold(
        appBar: AppBar(
          leading: AppGeneralWidget.backButton(context),
          title: Text(widget.title),
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
              Expanded(
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
                )
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
      if(!isStarting) {
        bloc.add(LoadNews(
          isLoadMore: true,
          type: widget.type,
          tag: widget.tag,
          cat: widget.cat,
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
        type: widget.type,
        tag: widget.tag,
        cat: widget.cat,
      ));
      setState(() {
        isStarting = false;
      });
    }
  }

}