import 'dart:convert';

GeneralInfoModel generalInfoModelFromJson(String str) => GeneralInfoModel.fromJson(json.decode(str));

String generalInfoModelToJson(GeneralInfoModel data) => json.encode(data.toJson());

class GeneralInfoModel {
    GeneralInfoModel({
        this.siteurl,
        this.rmolidLogo,
        this.rmolidIcon,
        this.rmolnetworkLogo,
        this.companyLogo,
        this.companyLogoColor,
        this.companyName,
        this.companyAbout,
        this.copyright,
        this.addressOffice,
        this.emailOffice,
        this.phoneOffice,
        this.facebook,
        this.twitter,
        this.instagram,
        this.youtube,
        this.network,
        this.rmol,
        this.androidVersion,
        this.androidVersionCode,
        this.androidVersionForced,
        this.androidDownloadLink,
    });

    String siteurl;
    String rmolidLogo;
    String rmolidIcon;
    String rmolnetworkLogo;
    String companyLogo;
    String companyLogoColor;
    String companyName;
    String companyAbout;
    String copyright;
    String addressOffice;
    String emailOffice;
    String phoneOffice;
    String facebook;
    String twitter;
    String instagram;
    String youtube;
    String network;
    String rmol;
    String androidVersion;
    int androidVersionCode;
    bool androidVersionForced;
    String androidDownloadLink;

    factory GeneralInfoModel.fromJson(Map<String, dynamic> json) => GeneralInfoModel(
        siteurl: json["siteurl"],
        rmolidLogo: json["rmolid_logo"],
        rmolidIcon: json["rmolid_icon"],
        rmolnetworkLogo: json["rmolnetwork_logo"],
        companyLogo: json["company_logo"],
        companyLogoColor: json["company_logo_color"],
        companyName: json["company_name"],
        companyAbout: json["company_about"],
        copyright: json["copyright"],
        addressOffice: json["address_office"],
        emailOffice: json["email_office"],
        phoneOffice: json["phone_office"],
        facebook: json["facebook"],
        twitter: json["twitter"],
        instagram: json["instagram"],
        youtube: json["youtube"],
        network: json["network"],
        rmol: json["rmol"],
        androidVersion: json["android_version"],
        androidVersionCode: json["android_version_code"],
        androidVersionForced: json["android_version_forced"],
        androidDownloadLink: json["android_download_link"],
    );

    Map<String, dynamic> toJson() => {
        "siteurl": siteurl,
        "rmolid_logo": rmolidLogo,
        "rmolid_icon": rmolidIcon,
        "rmolnetwork_logo": rmolnetworkLogo,
        "company_logo": companyLogo,
        "company_logo_color": companyLogoColor,
        "company_name": companyName,
        "company_about": companyAbout,
        "copyright": copyright,
        "address_office": addressOffice,
        "email_office": emailOffice,
        "phone_office": phoneOffice,
        "facebook": facebook,
        "twitter": twitter,
        "instagram": instagram,
        "youtube": youtube,
        "network": network,
        "rmol": rmol,
        "android_version": androidVersion,
        "android_version_code": androidVersionCode,
        "android_version_forced": androidVersionForced,
        "android_download_link": androidDownloadLink,
    };
}
