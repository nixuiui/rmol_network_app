import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rmol_network_app/core/models/ads_model.dart';
import 'package:rmol_network_app/core/models/general_info.dart';
import 'package:rmol_network_app/core/models/page_model.dart';

abstract class GeneralState extends Equatable {
  const GeneralState();
  @override
  List<Object> get props => [];
}

class GeneralUninitialized extends GeneralState {}

class GeneralLoading extends GeneralState {}

class GeneralInfoLoaded extends GeneralState {
  final GeneralInfoModel data;

  const GeneralInfoLoaded({@required this.data});

  @override
  List<Object> get props => [data];
}

class UpdateCheckingResult extends GeneralState {
  final bool isNeedUpdate;
  final GeneralInfoModel data;

  const UpdateCheckingResult({
    @required this.isNeedUpdate,
    @required this.data
  });

  @override
  List<Object> get props => [isNeedUpdate, data];
}

class PageLoaded extends GeneralState {
  final PageModel data;

  const PageLoaded({@required this.data});

  @override
  List<Object> get props => [data];
}

class AdsLoaded extends GeneralState {
  final AdsModel data;

  const AdsLoaded({@required this.data});

  @override
  List<Object> get props => [data];
}

class GeneralFailure extends GeneralState {
  final String error;

  const GeneralFailure({@required this.error});

  @override
  List<Object> get props => [error];
}
