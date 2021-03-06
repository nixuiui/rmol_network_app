import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:rmol_network_app/core/api/general_api.dart';
import 'package:rmol_network_app/core/bloc/general/general_event.dart';
import 'package:rmol_network_app/core/bloc/general/general_state.dart';
import 'package:rmol_network_app/core/models/general_info.dart';
import 'package:rmol_network_app/core/models/page_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneralBloc extends Bloc<GeneralEvent, GeneralState> {
  final api = GeneralApi();

  GeneralBloc() : super(GeneralUninitialized());

  @override
  Stream<GeneralState> mapEventToState(GeneralEvent event) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (event is LoadPage) {
      try {
        yield GeneralLoading();
        var page = prefs.getString("page_${event.slug}");
        if(page != null) yield PageLoaded(data: pageModelFromJson(page));
        final response = await api.loadPage(event.slug);
        prefs.setString("page_${event.slug}", pageModelToJson(response));
        yield PageLoaded(data: response);
      } catch (error) {
        print("ERROR: $error");
        yield GeneralFailure(error: error.toString());
      }
    }
    
    if (event is LoadGeneralInfo) {
      try {
        yield GeneralLoading();
        var info = prefs.getString("general_info");
        if(info != null) yield GeneralInfoLoaded(data: generalInfoModelFromJson(info));
        if(info == null || event.refresh) {
          final response = await api.loadGeneralInfo();
          prefs.setString("general_info", generalInfoModelToJson(response));
          yield GeneralInfoLoaded(data: response);
        }
      } catch (error) {
        print("ERROR: $error");
        yield GeneralFailure(error: error.toString());
      }
    }
    
    if (event is CheckUpdate) {
      try {
        PackageInfo package = await PackageInfo.fromPlatform();
        yield GeneralLoading();
        final response = await api.loadGeneralInfo();
        yield UpdateCheckingResult(
          isNeedUpdate: int.parse(package.buildNumber) < response.androidVersionCode,
          data: response
        );
      } catch (error) {
        print("ERROR: $error");
        yield GeneralFailure(error: error.toString());
      }
    }
    
    if (event is LoadAds) {
      try {
        yield GeneralLoading();
        final response = await api.loadAds();
        yield AdsLoaded(data: response);
      } catch (error) {
        print("ERROR: $error");
        yield GeneralFailure(error: error.toString());
      }
    }

  }
}