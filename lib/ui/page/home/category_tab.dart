import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rmol_network_app/core/models/category_model.dart';
import 'package:rmol_network_app/helper/app_general_widget.dart';
import 'package:rmol_network_app/ui/page/news/news_category_tab.dart';
import 'package:rmol_network_app/ui/widget/box.dart';

class CategoryTab extends StatefulWidget {
  const CategoryTab({
    Key key,
    this.onRefresh,
    this.refreshController,
    this.categories,
    this.isStarting
  }) : super(key: key);

  final VoidCallback onRefresh;
  final RefreshController refreshController;
  final List<Category> categories;
  final bool isStarting;

  @override
  _CategoryTabState createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RUBRIK"),
        centerTitle: true,
        bottom: AppGeneralWidget.appBarBorderBottom,
      ),
      body: SmartRefresher(
        controller: widget.refreshController,
        onRefresh: widget.onRefresh,
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          itemCount: widget.categories.length,
          itemBuilder: (context, index) => Box(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewsCategoryTab(
                categories: widget.categories,
                categorySelected: widget.categories[index],
              )),
            ),
            padding: 16,
            child: Text(widget.categories[index].name)
          )
        ),
      ),
    );
  }
}