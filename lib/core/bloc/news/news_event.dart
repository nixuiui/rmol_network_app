import 'package:equatable/equatable.dart';
import 'package:rmol_network_app/core/models/news_model.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

class LoadHomeNews extends NewsEvent {}

class LoadCategories extends NewsEvent {}

class LoadIndonesianNews extends NewsEvent {}

class LoadFavorits extends NewsEvent {}

class UpdateFavorite extends NewsEvent {
  final List<NewsModel> favorits;

  const UpdateFavorite({
    this.favorits
  });

  @override
  List<Object> get props => [favorits];
}

class LoadNews extends NewsEvent {
  final String type;
  final String tag;
  final String cat;
  final String keyword;
  final int page;
  final int perPage;
  final bool isRefresh;
  final bool isLoadMore;

  const LoadNews({
    this.type = "news",
    this.tag,
    this.cat,
    this.keyword,
    this.page,
    this.perPage,
    this.isRefresh = false,
    this.isLoadMore = false,
  });

  @override
  List<Object> get props => [type, tag, cat, keyword, page, perPage];
}