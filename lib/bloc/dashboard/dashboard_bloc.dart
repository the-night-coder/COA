import 'dart:async';
import 'dart:convert';

import 'package:coa/api/api_model.dart';
import 'package:coa/api/api_repo.dart';
import 'package:coa/support/prefs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardBloc extends Bloc<DashboardBlocEvent, DashboardBlocState> {
  final _rep = ApiRepository();

  DashboardBloc() : super(DashboardBlocInit()) {
    on<DashboardBlocEvent>(_loadData);
  }

  FutureOr<void> _loadData(
      DashboardBlocEvent event, Emitter<DashboardBlocState> emit) async {
    emit(DashboardBlocLoading());
    ApiResponse response = await _rep.getDashboard();
    if (response.status) {
      await Pref.setDash(jsonEncode(response.data['data']));
      await Pref.setUser(jsonEncode(response.data['data']['user']));
      emit(DashboardBlocSuccess(response.data));
    } else {
      emit(DashboardBlocFailed(response.message ?? ''));
    }
  }
}

abstract class DashboardBlocState {}

abstract class DashboardBlocEvent {}

class DashboardBlocLoading extends DashboardBlocState {}

class DashboardBlocFailed extends DashboardBlocState {
  final String message;

  DashboardBlocFailed(this.message);
}

class DashboardBlocSuccess extends DashboardBlocState {
  final dynamic data;

  DashboardBlocSuccess(this.data);
}

class DashboardBlocInit extends DashboardBlocState {}

class DashboardBlocLoadEvent extends DashboardBlocEvent {}
