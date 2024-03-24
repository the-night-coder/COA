import 'dart:async';
import 'dart:convert';

import 'package:coa/api/api_model.dart';
import 'package:coa/api/api_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DistrictsBloc extends Bloc<DistrictsBlocEvent, DistrictsBlocState> {
  final _repo = ApiRepository();

  DistrictsBloc() : super(DistrictsBlocInitState()) {
    on<DistrictsLoadEvent>(_load);
  }

  FutureOr<void> _load(
      DistrictsLoadEvent event, Emitter<DistrictsBlocState> emit) async {
    emit(DistrictsBlocLoadingState());
    ApiResponse response = await _repo.getDistrict();
    if (response.status) {
      List<dynamic> list = response.data['data']?['districts'] ?? [];
      if (list.isEmpty) {
        emit(DistrictsBlocEmptyState());
      } else {
        emit(DistrictsBlocLoadedState(list));
      }
    } else {
      emit(
          DistrictsBlocErrorState(response.message ?? 'Something went wrong!'));
    }
  }
}

abstract class DistrictsBlocState {}

abstract class DistrictsBlocEvent {}

class DistrictsBlocLoadingState extends DistrictsBlocState {}

class DistrictsBlocEmptyState extends DistrictsBlocState {}

class DistrictsBlocInitState extends DistrictsBlocState {}

class DistrictsBlocErrorState extends DistrictsBlocState {
  final String message;

  DistrictsBlocErrorState(this.message);
}

class DistrictsBlocLoadedState extends DistrictsBlocState {
  final List<dynamic> data;

  DistrictsBlocLoadedState(this.data);
}

class DistrictsLoadEvent extends DistrictsBlocEvent {}
