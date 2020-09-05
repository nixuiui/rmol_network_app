import 'package:equatable/equatable.dart';

abstract class GeneralEvent extends Equatable {
  const GeneralEvent();

  @override
  List<Object> get props => [];
}

class LoadGeneralInfo extends GeneralEvent {
  final bool refresh;

  const LoadGeneralInfo({this.refresh});

  @override
  List<Object> get props => [refresh];
}

class LoadAds extends GeneralEvent {}

class CheckUpdate extends GeneralEvent {}

class LoadPage extends GeneralEvent {
  final String slug;

  const LoadPage({this.slug});

  @override
  List<Object> get props => [slug];
}