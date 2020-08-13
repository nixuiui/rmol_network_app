import 'package:equatable/equatable.dart';

abstract class GeneralEvent extends Equatable {
  const GeneralEvent();

  @override
  List<Object> get props => [];
}

class LoadGeneralInfo extends GeneralEvent {}

class LoadPage extends GeneralEvent {
  final String slug;

  const LoadPage({this.slug});

  @override
  List<Object> get props => [slug];
}