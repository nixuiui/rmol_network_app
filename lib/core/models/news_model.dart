import 'dart:convert';

List<NewsModel> newsModelFromJson(String str) => List<NewsModel>.from(json.decode(str).map((x) => NewsModel.fromJson(x)));

String newsModelToJson(List<NewsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

NewsModel newsDetailFromJson(String str) => NewsModel.fromJson(json.decode(str));

String newsDetailToJson(NewsModel data) => json.encode(data.toJson());

class NewsModel {
    NewsModel({
        this.content,
        this.tag,
    });

    Content content;
    List<Tag> tag;

    factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        content: Content.fromJson(json["content"]),
        tag: List<Tag>.from(json["tag"].map((x) => Tag.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "content": content.toJson(),
        "tag": List<dynamic>.from(tag.map((x) => x.toJson())),
    };
}

class Content {
    Content({
        this.id,
        this.title,
        this.titleSlug,
        this.summary,
        this.content,
        this.categoryId,
        this.imageBig,
        this.imageSlider,
        this.imageMid,
        this.imageSmall,
        this.imageMime,
        this.sliderOrder,
        this.featuredOrder,
        this.postType,
        this.imageUrl,
        this.userId,
        this.pageviews,
        this.createdAt,
        this.postUrl,
        this.imageDescription,
        this.categoryName,
        this.categorySlug,
        this.categoryColor,
        this.authorUsername,
        this.authorSlug,
        this.editorUsername,
        this.editorSlug,
        this.commentCount,
        this.hideReport,
    });

    int id;
    String title;
    String titleSlug;
    String summary;
    String content;
    String categoryId;
    String imageBig;
    String imageSlider;
    String imageMid;
    String imageSmall;
    String imageMime;
    String sliderOrder;
    String featuredOrder;
    String postType;
    String imageUrl;
    String userId;
    String pageviews;
    DateTime createdAt;
    String postUrl;
    String imageDescription;
    String categoryName;
    String categorySlug;
    String categoryColor;
    String authorUsername;
    String authorSlug;
    String editorUsername;
    String editorSlug;
    String commentCount;
    String hideReport;

    factory Content.fromJson(Map<String, dynamic> json) => Content(
        id: json["id"],
        title: json["title"]?.toString(),
        titleSlug: json["title_slug"]?.toString(),
        summary: json["summary"]?.toString(),
        content: json["content"]?.toString(),
        categoryId: json["category_id"]?.toString(),
        imageBig: json["image_big"]?.toString(),
        imageSlider: json["image_slider"]?.toString(),
        imageMid: json["image_mid"]?.toString(),
        imageSmall: json["image_small"]?.toString(),
        imageMime: json["image_mime"]?.toString(),
        sliderOrder: json["slider_order"]?.toString(),
        featuredOrder: json["featured_order"]?.toString(),
        postType: json["post_type"]?.toString(),
        imageUrl: json["image_url"]?.toString(),
        userId: json["user_id"]?.toString(),
        pageviews: json["pageviews"]?.toString(),
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
        postUrl: json["post_url"]?.toString(),
        imageDescription: json["image_description"]?.toString(),
        categoryName: json["category_name"]?.toString(),
        categorySlug: json["category_slug"]?.toString(),
        categoryColor: json["category_color"]?.toString(),
        authorUsername: json["author_username"]?.toString(),
        authorSlug: json["author_slug"]?.toString(),
        editorUsername: json["editor_username"]?.toString(),
        editorSlug: json["editor_slug"]?.toString(),
        commentCount: json["comment_count"]?.toString(),
        hideReport: json["hide_report"]?.toString(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "title_slug": titleSlug,
        "summary": summary,
        "content": content,
        "category_id": categoryId,
        "image_big": imageBig,
        "image_slider": imageSlider,
        "image_mid": imageMid,
        "image_small": imageSmall,
        "image_mime": imageMime,
        "slider_order": sliderOrder,
        "featured_order": featuredOrder,
        "post_type": postType,
        "image_url": imageUrl,
        "user_id": userId,
        "pageviews": pageviews,
        "created_at": createdAt.toIso8601String(),
        "post_url": postUrl,
        "image_description": imageDescription,
        "category_name": categoryName,
        "category_slug": categorySlug,
        "category_color": categoryColor,
        "author_username": authorUsername,
        "author_slug": authorSlug,
        "editor_username": editorUsername,
        "editor_slug": editorSlug,
        "comment_count": commentCount,
        "hide_report": hideReport,
    };
}

class Tag {
    Tag({
        this.id,
        this.postId,
        this.tag,
        this.tagSlug,
    });

    String id;
    String postId;
    String tag;
    String tagSlug;

    factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json["id"]?.toString(),
        postId: json["post_id"]?.toString(),
        tag: json["tag"]?.toString(),
        tagSlug: json["tag_slug"]?.toString(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "post_id": postId,
        "tag": tag,
        "tag_slug": tagSlug,
    };
}


IndonesianNewsResponse indonesianNewsResponseFromJson(String str) => IndonesianNewsResponse.fromJson(json.decode(str));

String indonesianNewsResponseToJson(IndonesianNewsResponse data) => json.encode(data.toJson());

class IndonesianNewsResponse {
    IndonesianNewsResponse({
        this.popularweek,
        this.indoNews,
    });

    List<NewsModel> popularweek;
    List<IndonesianNews> indoNews;

    factory IndonesianNewsResponse.fromJson(Map<String, dynamic> json) => IndonesianNewsResponse(
        popularweek: List<NewsModel>.from(json["popularweek"].map((x) => NewsModel.fromJson(x))),
        indoNews: List<IndonesianNews>.from(json["rmolrss"].map((x) => IndonesianNews.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "popularweek": List<dynamic>.from(popularweek.map((x) => x.toJson())),
        "rmolrss": List<dynamic>.from(indoNews.map((x) => x.toJson())),
    };
}

class IndonesianNews {
    IndonesianNews({
        this.title,
        this.titleSlug,
        this.postUrl,
        this.createdAt,
        this.username,
    });

    String title;
    String titleSlug;
    String postUrl;
    DateTime createdAt;
    String username;

    factory IndonesianNews.fromJson(Map<String, dynamic> json) => IndonesianNews(
        title: json["title"],
        titleSlug: json["title_slug"],
        postUrl: json["post_url"],
        createdAt: DateTime.parse(json["created_at"]),
        username: json["username"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "title_slug": titleSlug,
        "post_url": postUrl,
        "created_at": createdAt.toIso8601String(),
        "username": username,
    };
}
