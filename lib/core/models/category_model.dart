import 'dart:convert';

List<Category> categoryFromJson(String str) => List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

String categoryToJson(List<Category> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Category {
    Category({
        this.id,
        this.langId,
        this.name,
        this.nameSlug,
        this.parentId,
        this.description,
        this.keywords,
        this.color,
        this.blockType,
        this.categoryOrder,
        this.showAtHomepage,
        this.showOnMenu,
        this.createdAt,
        this.parentSlug,
    });

    int id;
    int langId;
    String name;
    String nameSlug;
    int parentId;
    String description;
    String keywords;
    String color;
    BlockType blockType;
    int categoryOrder;
    int showAtHomepage;
    int showOnMenu;
    DateTime createdAt;
    dynamic parentSlug;

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        langId: json["lang_id"],
        name: json["name"],
        nameSlug: json["name_slug"],
        parentId: json["parent_id"],
        description: json["description"],
        keywords: json["keywords"],
        color: json["color"],
        blockType: blockTypeValues.map[json["block_type"]],
        categoryOrder: json["category_order"],
        showAtHomepage: json["show_at_homepage"],
        showOnMenu: json["show_on_menu"],
        createdAt: DateTime.parse(json["created_at"]),
        parentSlug: json["parent_slug"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "lang_id": langId,
        "name": name,
        "name_slug": nameSlug,
        "parent_id": parentId,
        "description": description,
        "keywords": keywords,
        "color": color,
        "block_type": blockTypeValues.reverse[blockType],
        "category_order": categoryOrder,
        "show_at_homepage": showAtHomepage,
        "show_on_menu": showOnMenu,
        "created_at": createdAt.toIso8601String(),
        "parent_slug": parentSlug,
    };
}

enum BlockType { BLOCK_3, BLOCK_1, BLOCK_5, BLOCK_2 }

final blockTypeValues = EnumValues({
    "block-1": BlockType.BLOCK_1,
    "block-2": BlockType.BLOCK_2,
    "block-3": BlockType.BLOCK_3,
    "block-5": BlockType.BLOCK_5
});

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}
