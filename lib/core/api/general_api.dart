import 'package:rmol_network_app/core/api/main_api.dart';
import 'package:rmol_network_app/core/models/ads_model.dart';
import 'package:rmol_network_app/core/models/general_info.dart';
import 'package:rmol_network_app/core/models/page_model.dart';

class GeneralApi extends MainApi {
  
  Future<PageModel> loadPage(String slug) async {
    try {
      final response = await getRequest(url: "$host/page/$slug");
      return pageModelFromJson(response);
    } catch (error) {
      throw Exception(error);
    }
  }
  
  Future<GeneralInfoModel> loadGeneralInfo() async {
    try {
      final response = await getRequest(url: "$host/getinfo");
      return generalInfoModelFromJson(response);
    } catch (error) {
      throw Exception(error);
    }
  }
  
  Future<AdsModel> loadAds() async {
    try {
      final response = await getRequest(url: "$host/adspace");
      return adsModelFromJson(response);
    } catch (error) {
      throw Exception(error);
    }
  }

}