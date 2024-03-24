import 'dart:async';
import 'dart:convert';

import 'package:coa/api/api_model.dart';
import 'package:coa/api/api_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MekhalaBloc extends Bloc<MekhalaBlocEvent, MekhalaBlocState> {
  final _repo = ApiRepository();

  MekhalaBloc() : super(MekhalaBlocInitState()) {
    on<MekhalaLoadEvent>(_load);
  }

  FutureOr<void> _load(
      MekhalaLoadEvent event, Emitter<MekhalaBlocState> emit) async {
    emit(MekhalaBlocLoadingState());
    ApiResponse response = await _repo.getMekhala(event.id);
    if (response.status) {
      List<dynamic> list = response.data['data']?['mekhalas'] ?? [];
      if (list.isEmpty) {
        emit(MekhalaBlocEmptyState());
      } else {
        emit(MekhalaBlocLoadedState(list));
      }
    } else {
      emit(MekhalaBlocErrorState(response.message ?? 'Something went wrong!'));
    }
  }
}

abstract class MekhalaBlocState {}

abstract class MekhalaBlocEvent {}

class MekhalaBlocLoadingState extends MekhalaBlocState {}

class MekhalaBlocEmptyState extends MekhalaBlocState {}

class MekhalaBlocInitState extends MekhalaBlocState {}

class MekhalaBlocErrorState extends MekhalaBlocState {
  final String message;

  MekhalaBlocErrorState(this.message);
}

class MekhalaBlocLoadedState extends MekhalaBlocState {
  final List<dynamic> data;

  MekhalaBlocLoadedState(this.data);
}

class MekhalaLoadEvent extends MekhalaBlocEvent {
  final String id;

  MekhalaLoadEvent(this.id);
}
