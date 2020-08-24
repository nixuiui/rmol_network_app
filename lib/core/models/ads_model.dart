import 'dart:convert';

import 'dart:math';

AdsModel adsModelFromJson(String str) => AdsModel.fromJson(json.decode(str));

String adsModelToJson(AdsModel data) => json.encode(data.toJson());

class AdsModel {
    AdsModel({
        this.adsone,
        this.adstwo,
        this.adsthree,
    });

    AdsItem adsone;
    AdsItem adstwo;
    AdsItem adsthree;

    factory AdsModel.fromJson(Map<String, dynamic> json) => AdsModel(
        adsone: AdsItem.fromJson(json["android_adsone"]),
        adstwo: AdsItem.fromJson(json["android_adstwo"]),
        adsthree: AdsItem.fromJson(json["android_adsthree"]),
    );

    Map<String, dynamic> toJson() => {
        "android_adsone": adsone.toJson(),
        "android_adstwo": adstwo.toJson(),
        "android_adsthree": adsthree.toJson(),
    };

    AdsItem getAds() {
      var random = Random().nextInt(3);
      var ads = this.adsone;
      if(random == 1) ads = this.adsone;
      else if(random == 2) ads = this.adstwo;
      else if(random == 3) ads = this.adsthree;
      return ads;
    }
}

class AdsItem {
    AdsItem({
        this.link,
        this.img,
    });

    String link;
    String img;

    factory AdsItem.fromJson(Map<String, dynamic> json) => AdsItem(
        link: json["link"] == null ? null : json["link"],
        img: json["img"] == null ? null : json["img"],
    );

    Map<String, dynamic> toJson() => {
        "link": link == null ? null : link,
        "img": img == null ? null : img,
    };
}
