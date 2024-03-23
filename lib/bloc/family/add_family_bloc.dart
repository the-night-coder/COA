import 'dart:async';
import 'dart:convert';

import 'package:coa/api/api_model.dart';
import 'package:coa/api/api_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddFamilyMemberBloc
    extends Bloc<AddFamilyMemberBlocEvent, AddFamilyMemberBlocState> {
  final _repo = ApiRepository();
  String name = '';
  String relation = '';
  String blood = '';
  String dob = '';
  String id = '';

  AddFamilyMemberBloc() : super(AddFamilyMemberBlocInitState()) {
    on<AddFamilyMemberLoadEvent>(_add);
  }

  FutureOr<void> _add(AddFamilyMemberLoadEvent event,
      Emitter<AddFamilyMemberBlocState> emit) async {
    emit(AddFamilyMemberBlocLoadingState());
    ApiResponse response = await _repo.addFamilyMember({
      'name': name,
      'relation': relation,
      'dob': dob,
      'blood_group': blood,
      '_method': id.isEmpty ? 'POST' : 'PUT'
    }, id);
    if (response.status) {
      emit(AddFamilyMemberBlocSuccessState());
    } else {
      emit(AddFamilyMemberBlocErrorState(
          response.message ?? 'Something went wrong!'));
    }
  }
}

abstract class AddFamilyMemberBlocState {}

abstract class AddFamilyMemberBlocEvent {}

class AddFamilyMemberBlocLoadingState extends AddFamilyMemberBlocState {}

class AddFamilyMemberBlocEmptyState extends AddFamilyMemberBlocState {}

class AddFamilyMemberBlocInitState extends AddFamilyMemberBlocState {}

class AddFamilyMemberBlocErrorState extends AddFamilyMemberBlocState {
  final String message;

  AddFamilyMemberBlocErrorState(this.message);
}

class AddFamilyMemberBlocSuccessState extends AddFamilyMemberBlocState {}

class AddFamilyMemberLoadEvent extends AddFamilyMemberBlocEvent {}
