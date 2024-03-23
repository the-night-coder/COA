import 'dart:async';
import 'dart:convert';

import 'package:coa/api/api_model.dart';
import 'package:coa/api/api_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FamilyMemberBloc
    extends Bloc<FamilyMemberBlocEvent, FamilyMemberBlocState> {
  final _repo = ApiRepository();

  FamilyMemberBloc() : super(FamilyMemberBlocInitState()) {
    on<FamilyMemberLoadEvent>(_load);
  }

  FutureOr<void> _load(
      FamilyMemberLoadEvent event, Emitter<FamilyMemberBlocState> emit) async {
    emit(FamilyMemberBlocLoadingState());
    ApiResponse response = await _repo.getFamilyMembers();
    if (response.status) {
      List<dynamic> list = response.data['data']?['members'] ?? [];
      if (list.isEmpty) {
        emit(FamilyMemberBlocEmptyState());
      } else {
        emit(FamilyMemberBlocLoadedState(list));
      }
    } else {
      emit(FamilyMemberBlocErrorState(
          response.message ?? 'Something went wrong!'));
    }
  }
}

abstract class FamilyMemberBlocState {}

abstract class FamilyMemberBlocEvent {}

class FamilyMemberBlocLoadingState extends FamilyMemberBlocState {}

class FamilyMemberBlocEmptyState extends FamilyMemberBlocState {}

class FamilyMemberBlocInitState extends FamilyMemberBlocState {}

class FamilyMemberBlocErrorState extends FamilyMemberBlocState {
  final String message;

  FamilyMemberBlocErrorState(this.message);
}

class FamilyMemberBlocLoadedState extends FamilyMemberBlocState {
  final List<dynamic> data;

  FamilyMemberBlocLoadedState(this.data);
}

class FamilyMemberLoadEvent extends FamilyMemberBlocEvent {}
