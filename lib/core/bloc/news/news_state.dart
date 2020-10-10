import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rmol_network_app/core/models/category_model.dart';
import 'package:rmol_network_app/core/models/news_model.dart';

abstract class NewsState extends Equatable {
  const NewsState();
  @override
  List<Object> get props => [];
}

class NewsUninitialized extends NewsState {}

class NewsLoading extends NewsState {}

class HomeNewsLoaded extends NewsState {
  final IndonesianNewsResponse indoNews;
  final List<NewsModel> footnotes;
  final List<NewsModel> opini;
  final List<NewsModel> webtorial;

  const HomeNewsLoaded({
    this.indoNews,
    this.footnotes,
    this.opini,
    this.webtorial
  });

  @override
  List<Object> get props => [indoNews, footnotes, opini, webtorial];
}

class CategoriesLoaded extends NewsState {
  final List<Category> data;

  const CategoriesLoaded({@required this.data});

  @override
  List<Object> get props => [data];
}

class IndonesianNewsLoaded extends NewsState {
  final IndonesianNewsResponse data;

  const IndonesianNewsLoaded({@required this.data});

  @override
  List<Object> get props => [data];
}

class NewsDetailLoaded extends NewsState {
  final NewsModel data;

  const NewsDetailLoaded({@required this.data});

  @override
  List<Object> get props => [data];
}

class NewsLoaded extends NewsState {
  final List<NewsModel> data;
  final bool hasReachedMax;

  const NewsLoaded({
    @required this.data,
    this.hasReachedMax
  });

  NewsLoaded copyWith({
    List<NewsModel> data,
    bool hasReachedMax,
  }) {
    return NewsLoaded(
      data: data ?? this.data,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [data];
}

class NewsFavoritsLoaded extends NewsState {
  final List<NewsModel> data;

  const NewsFavoritsLoaded({@required this.data});

  @override
  List<Object> get props => [data];
}

class NewsFailure extends NewsState {
  final String error;

  const NewsFailure({@required this.error});

  @override
  List<Object> get props => [error];
}
