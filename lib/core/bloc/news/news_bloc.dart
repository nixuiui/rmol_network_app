import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rmol_network_app/core/api/news_api.dart';
import 'package:rmol_network_app/core/bloc/news/news_event.dart';
import 'package:rmol_network_app/core/bloc/news/news_state.dart';
import 'package:rmol_network_app/core/models/category_model.dart';
import 'package:rmol_network_app/core/models/news_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final api = NewsApi();
  int page = 1;
  int perPage = 20;

  NewsBloc() : super(NewsUninitialized());

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final currentState = state;

    if (event is LoadNews) {
      page = event.page ?? page;
      perPage = event.perPage ?? perPage;
      if(event.isRefresh || currentState is NewsUninitialized) {
          page = event.page ?? 1;
      } else if(currentState is NewsLoaded){
          int length = currentState.data.length;
          if(length%perPage > 0)  
            yield currentState.copyWith(hasReachedMax: true);
          page = (currentState.data.length/perPage).ceil() + 1;
      }

      try {
        yield NewsLoading();
        final news = await api.loadNews(
          type: event.type,
          tag: event.tag,
          cat: event.cat,
          keyword: event.keyword,
          page: page,
          perPage: perPage
        );
        if(event.isRefresh || currentState is NewsUninitialized) {
          yield NewsLoaded(data: news, hasReachedMax: news.length < perPage);
        } else if(currentState is NewsLoaded){
          if(news.length > 0)
            yield NewsLoaded(data: currentState.data + news, hasReachedMax: news.length < perPage);
          else
            yield currentState.copyWith(hasReachedMax: true);
        }
      } catch (error) {
        print("ERROR: $error");
        yield NewsFailure(error: error.toString());
      }
    }

    if (event is LoadHomeNews) {
      yield NewsLoading();
      try {
        var prefIndoNews = prefs.getString("indoNews");
        if(prefIndoNews != null)
          yield HomeNewsLoaded(indoNews: indonesianNewsResponseFromJson(prefIndoNews));
        var prefFootnotes = prefs.getString("footnotes");
        if(prefFootnotes != null)
          yield HomeNewsLoaded(footnotes: newsModelFromJson(prefFootnotes));
        var prefOpinies = prefs.getString("opini");
        if(prefOpinies != null)
          yield HomeNewsLoaded(opini: newsModelFromJson(prefOpinies));
        var prefWebtorials = prefs.getString("webtorial");
        if(prefWebtorials != null)
          yield HomeNewsLoaded(webtorial: newsModelFromJson(prefWebtorials));

        final indoNews = api.loadIndonesianNews();
        final footnotes = api.loadNews(type: "category", cat: 'Footnote', page: 1, perPage: 5);
        final opini = api.loadNews(type: "category", cat: 'Opini', page: 1, perPage: 5);
        final webtorial = api.loadNews(type: "category", cat: 'webtorial', page: 1, perPage: 5);
        
        prefs.setString("indoNews", indonesianNewsResponseToJson((await indoNews)));
        yield HomeNewsLoaded(indoNews: await indoNews);
        prefs.setString("footnotes", newsModelToJson((await footnotes)));
        yield HomeNewsLoaded(footnotes: await footnotes);
        prefs.setString("opini", newsModelToJson((await opini)));
        yield HomeNewsLoaded(opini: await opini);
        prefs.setString("webtorial", newsModelToJson((await webtorial)));
        yield HomeNewsLoaded(webtorial: await webtorial);
      } catch (error) {
        print("ERROR: $error");
        yield NewsFailure(error: error.toString());
      }
    }
    
    if (event is LoadCategories) {
      yield NewsLoading();
      try {
        var pref = prefs.getString("categories");
        if(pref != null) {
          yield CategoriesLoaded(data: categoryFromJson(pref));
        }
        if(event.refresh || pref == null) {
          final response = await api.loadCategories();
          prefs.setString("categories", categoryToJson(response));
          yield CategoriesLoaded(data: response);
        }
      } catch (error) {
        print("ERROR: $error");
        yield NewsFailure(error: error.toString());
      }
    }
    
    if (event is LoadFavorits) {
      yield NewsLoading();
      try {
        var pref = prefs.getString("favorits");
        if(pref != null)
          yield NewsFavoritsLoaded(data: newsModelFromJson(pref));
        else
          yield NewsFavoritsLoaded(data: []);
      } catch (error) {
        print("ERROR: $error");
        yield NewsFailure(error: error.toString());
      }
    }
    
    if (event is LoadNewsDetail) {
      yield NewsLoading();
      try {
        final response = await api.loadNewsDetail(event.id);
        yield NewsDetailLoaded(data: response);
      } catch (error) {
        print("ERROR: $error");
        yield NewsFailure(error: error.toString());
      }
    }
    
    if (event is UpdateFavorite) {
      prefs.setString("favorits", newsModelToJson(event.favorits));
    }

  }
}