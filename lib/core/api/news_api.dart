import 'package:rmol_network_app/core/api/main_api.dart';
import 'package:rmol_network_app/core/models/category_model.dart';
import 'package:rmol_network_app/core/models/news_model.dart';

class NewsApi extends MainApi {

  Future<List<NewsModel>> loadNews({
    String type = "news",
    String tag = "",
    String cat = "",
    String keyword = "",
    int page = 1,
    int perPage = 10
  }) async {
    try {
      var response;
      if(type == "news") {
        response = getRequest(url: "$host/news?page=$page&per_page=$perPage");
        return newsModelFromJson(await response);
      }
      else if(type == "tag") {
        response = getRequest(url: "$host/tag?tag=$tag&page=$page&per_page=$perPage");
        return newsModelFromJson(await response);
      }
      else if(type == "category") {
        response = getRequest(url: "$host/news_by_category?cat=$cat&page=$page&per_page=$perPage");
        return newsModelFromJson(await response);
      }
      else if(type == "search") {
        response = getRequest(url: "$host/search?keyword=$cat&page=$page&per_page=$perPage");
        return newsModelFromJson(await response);
      }
      throw Exception("Unknown Type Request");
    } catch (error) {
      throw Exception(error);
    }
  }
  
  Future<IndonesianNewsResponse> loadIndonesianNews() async {
    try {
      final response = await getRequest(url: "$host/widget");
      return indonesianNewsResponseFromJson(response);
    } catch (error) {
      throw Exception(error);
    }
  }
  
  Future<List<Category>> loadCategories() async {
    try {
      final response = await getRequest(url: "$host/category");
      return categoryFromJson(response);
    } catch (error) {
      throw Exception(error);
    }
  }
  
  Future<NewsModel> loadNewsDetail(String id) async {
    try {
      final response = await getRequest(url: "$host/news_byid?id=$id");
      return newsDetailFromJson(response);
    } catch (error) {
      throw Exception(error);
    }
  }

}