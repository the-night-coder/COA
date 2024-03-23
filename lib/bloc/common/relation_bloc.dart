import 'dart:async';
import 'dart:convert';

import 'package:coa/api/api_model.dart';
import 'package:coa/api/api_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RelationsBloc
    extends Bloc<RelationsBlocEvent, RelationsBlocState> {
  final _repo = ApiRepository();

  RelationsBloc() : super(RelationsBlocInitState()) {
    on<RelationsLoadEvent>(_load);
  }

  FutureOr<void> _load(
      RelationsLoadEvent event, Emitter<RelationsBlocState> emit) async {
    emit(RelationsBlocLoadingState());
    ApiResponse response = await _repo.getRelations();
    // if (response.status) {
    //   List<dynamic> list = response.data['data']?['members'] ?? [];
    //   if (list.isEmpty) {
    //     emit(RelationsBlocEmptyState());
    //   } else {
    //     emit(RelationsBlocLoadedState(list));
    //   }
    // }
    emit(RelationsBlocLoadedState([
      'Father',
      'Mother',
      'Daughter',
      'Son',
      'Wife',
      'Other'
    ]));
  }
}

abstract class RelationsBlocState {}

abstract class RelationsBlocEvent {}

class RelationsBlocLoadingState extends RelationsBlocState {}

class RelationsBlocEmptyState extends RelationsBlocState {}

class RelationsBlocInitState extends RelationsBlocState {}

class RelationsBlocErrorState extends RelationsBlocState {
  final String message;

  RelationsBlocErrorState(this.message);
}

class RelationsBlocLoadedState extends RelationsBlocState {
  final List<dynamic> data;

  RelationsBlocLoadedState(this.data);
}

class RelationsLoadEvent extends RelationsBlocEvent {}
