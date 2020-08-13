import 'dart:convert';

PageModel pageModelFromJson(String str) => PageModel.fromJson(json.decode(str));

String pageModelToJson(PageModel data) => json.encode(data.toJson());

class PageModel {
    PageModel({
        this.id,
        this.langId,
        this.title,
        this.slug,
        this.description,
        this.keywords,
        this.pageContent,
        this.pageOrder,
        this.pageType,
        this.createdAt,
    });

    int id;
    int langId;
    String title;
    String slug;
    String description;
    String keywords;
    String pageContent;
    int pageOrder;
    String pageType;
    DateTime createdAt;

    factory PageModel.fromJson(Map<String, dynamic> json) => PageModel(
        id: json["id"],
        langId: json["lang_id"],
        title: json["title"],
        slug: json["slug"],
        description: json["description"],
        keywords: json["keywords"],
        pageContent: json["page_content"],
        pageOrder: json["page_order"],
        pageType: json["page_type"],
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "lang_id": langId,
        "title": title,
        "slug": slug,
        "description": description,
        "keywords": keywords,
        "page_content": pageContent,
        "page_order": pageOrder,
        "page_type": pageType,
        "created_at": createdAt.toIso8601String(),
    };
}
