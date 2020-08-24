import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rmol_network_app/core/bloc/news/news_bloc.dart';
import 'package:rmol_network_app/core/bloc/news/news_event.dart';
import 'package:rmol_network_app/core/bloc/news/news_state.dart';
import 'package:rmol_network_app/core/models/news_model.dart';
import 'package:rmol_network_app/helper/app_general_widget.dart';
import 'package:rmol_network_app/ui/page/news/news_detail.dart';
import 'package:rmol_network_app/ui/widget/news_item.dart';

class FavoriteTab extends StatefulWidget {
  @override
  _FavoriteTabState createState() => _FavoriteTabState();
}

class _FavoriteTabState extends State<FavoriteTab> {

  final favoritBloc = NewsBloc();
  List<NewsModel> favorits = <NewsModel>[];

  @override
  void initState() {
    favoritBloc.add(LoadFavorits());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: favoritBloc,
      listener: (context, state) {
        if(state is NewsFavoritsLoaded) {
          setState(() {
            favorits = state.data;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("FAVORITE"),
          centerTitle: true,
          bottom: AppGeneralWidget.appBarBorderBottom,
        ),
        body: ListView.separated(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.all(0),
          separatorBuilder: (context, index) => Divider(),
          itemCount: favorits.length,
          itemBuilder: (context, index) => NewsVerticalItem(
            news: favorits[index],
            onClick: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewsDetail(news: favorits[index])),
            ),
          ),
        ),
      ),
    );
  }
}