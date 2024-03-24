import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/api_model.dart';
import '../../api/api_repo.dart';

class FindMemberBloc extends Bloc<FindMemberBlocEvent, FindMemberBlocState> {
  final _repo = ApiRepository();

  FindMemberBloc() : super(FindMemberBlocInit()) {
    on<RequestFindMember>(_getData);
  }

  FutureOr<void> _getData(
      RequestFindMember event, Emitter<FindMemberBlocState> emit) async {
    emit(FindMemberRequested());
    ApiResponse res =
        await _repo.findMember(event.dist, event.mek, event.search);
    if (res.status) {
      List<dynamic> list = res.data['data']['members'];
      if (list.isNotEmpty) {
        emit(FindMemberSuccess(list));
      } else {
        emit(FindMemberEmpty());
      }
    } else {
      emit(FindMemberFailed(res.message.toString()));
    }
  }
}

abstract class FindMemberBlocState {}

abstract class FindMemberBlocEvent {}

class FindMemberBlocInit extends FindMemberBlocState {}

class RequestFindMember extends FindMemberBlocEvent {
  final String search;
  final String mek;
  final String dist;

  RequestFindMember(this.search, this.mek, this.dist);
}

class FindMemberRequested extends FindMemberBlocState {}

class FindMemberEmpty extends FindMemberBlocState {}

class FindMemberSuccess extends FindMemberBlocState {
  final List<dynamic> data;

  FindMemberSuccess(this.data);
}

class FindMemberFailed extends FindMemberBlocState {
  final String message;

  FindMemberFailed(this.message);
}
