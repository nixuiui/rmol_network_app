import 'dart:convert';

List<NewsModel> newsModelFromJson(String str) => List<NewsModel>.from(json.decode(str).map((x) => NewsModel.fromJson(x)));

String newsModelToJson(List<NewsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
    });

    int id;
    String title;
    String titleSlug;
    String summary;
    String content;
    int categoryId;
    String imageBig;
    String imageSlider;
    String imageMid;
    String imageSmall;
    String imageMime;
    int sliderOrder;
    int featuredOrder;
    String postType;
    String imageUrl;
    int userId;
    int pageviews;
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
    int commentCount;

    factory Content.fromJson(Map<String, dynamic> json) => Content(
        id: json["id"],
        title: json["title"],
        titleSlug: json["title_slug"],
        summary: json["summary"],
        content: json["content"],
        categoryId: json["category_id"],
        imageBig: json["image_big"],
        imageSlider: json["image_slider"],
        imageMid: json["image_mid"],
        imageSmall: json["image_small"],
        imageMime: json["image_mime"],
        sliderOrder: json["slider_order"],
        featuredOrder: json["featured_order"],
        postType: json["post_type"],
        imageUrl: json["image_url"],
        userId: json["user_id"],
        pageviews: json["pageviews"],
        createdAt: DateTime.parse(json["created_at"]),
        postUrl: json["post_url"],
        imageDescription: json["image_description"],
        categoryName: json["category_name"],
        categorySlug: json["category_slug"],
        categoryColor: json["category_color"],
        authorUsername: json["author_username"],
        authorSlug: json["author_slug"],
        editorUsername: json["editor_username"],
        editorSlug: json["editor_slug"],
        commentCount: json["comment_count"],
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
    };
}

class Tag {
    Tag({
        this.id,
        this.postId,
        this.tag,
        this.tagSlug,
    });

    int id;
    int postId;
    String tag;
    String tagSlug;

    factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json["id"],
        postId: json["post_id"],
        tag: json["tag"],
        tagSlug: json["tag_slug"],
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
