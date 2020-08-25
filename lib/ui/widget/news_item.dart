import 'package:flutter/material.dart';
import 'package:rmol_network_app/core/models/ads_model.dart';
import 'package:rmol_network_app/core/models/news_model.dart';
import 'package:rmol_network_app/helper/app_general_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as TimeAgo;
import 'package:url_launcher/url_launcher.dart';

class NewsVerticalItem extends StatelessWidget {
  const NewsVerticalItem({
    Key key,
    this.onClick,
    this.news,
    this.ads
  }) : super(key: key);

  final VoidCallback onClick;
  final NewsModel news;
  final AdsModel ads;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onClick,
          child: Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                news?.content?.imageBig == null ? Container() : Expanded(
                  flex: 5,
                  child: AspectRatio(
                    aspectRatio: 400/280,
                    child: Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(news.content.imageBig)
                        ),
                      ),
                    ),
                  ),
                ), 
                Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(news.content.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          Text(news.content.categoryName, 
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black38,
                            )
                          ),
                          AppGeneralWidget.dotIcon,
                          Text(TimeAgo.format(news.content.createdAt, locale: 'id').toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black38,
                            )
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 16,
                            height: 16,
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50),
                              // image: news.writerImage != null ? DecorationImage(
                              //   fit: BoxFit.cover,
                              //   image: NetworkImage(news.writerImage),
                              // ) : null,
                            ),
                          ),
                          Expanded(
                            child: Text(news.content.authorUsername, 
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 12
                              )
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ]
            ),
          ),
        ),
        ads?.getAds()?.img == null ? Container() : GestureDetector(
          onTap: () => _launchURL(ads?.getAds()?.link),
          child: Image.network(ads?.getAds()?.img)
        )
      ],
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

class NewsHorizontalItem extends StatelessWidget {
  const NewsHorizontalItem({
    Key key,
    this.onClick,
    this.news
  }) : super(key: key);

  final NewsModel news;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onClick,
      child: Container(
        color: Colors.white,
        width: 230,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 340/195,
              child: Container(
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4.0),
                  image: news.content.imageBig != "" ? DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(news.content.imageBig),
                  ) : null,
                ),
              ),
            ), 
            SizedBox(height: 8),
            Text(news.content.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Text(news.content.categoryName, 
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black38,
                  )
                ),
                AppGeneralWidget.dotIcon,
                Text(TimeAgo.format(news.content.createdAt, locale: 'id').toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black38,
                  )
                ),
              ],
            )
          ]
        ),
      ),
    );
  }
}

class NewsTitleOnlyItem extends StatelessWidget {
  const NewsTitleOnlyItem({
    Key key,
    this.news,
    this.onClick
  }) : super(key: key);

  final IndonesianNews news;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(news.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Text(news.username, 
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black38,
                  )
                ),
                AppGeneralWidget.dotIcon,
                Text(TimeAgo.format(news.createdAt, locale: 'id').toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black38,
                  )
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ShimmerNewsVerticalItem extends StatelessWidget {
  const ShimmerNewsVerticalItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: AspectRatio(
                aspectRatio: 400/280,
                child: Container(
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
            ), 
            SizedBox(width: 16),
            Expanded(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: Colors.grey
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: Colors.grey
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: Colors.grey
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]
        ),
      ), 
    );
  }
}

class ShimmerNewsHorizontalItem extends StatelessWidget {
  const ShimmerNewsHorizontalItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Container(
        width: 230,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 340/195,
              child: Container(
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ), 
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: Colors.grey
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: Colors.grey
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ]
        ),
      ), 
    );
  }
}

class ShimmerNewsTitleOnlyItem extends StatelessWidget {
  const ShimmerNewsTitleOnlyItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.grey
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: <Widget>[
                Container(
                  width: 100,
                  height: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: Colors.grey
                  ),
                ),
              ],
            ),
          ],
        ),
      ), 
    );
  }
}