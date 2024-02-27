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
    // ApiResponse res = await _repo.getLoginOtp(event.mobile);
    // if (res.status) {
    //   emit(OTPSent(res.data));
    // } else {
    //   emit(LoginFailed(res.message.toString()));
    // }
    // print(res.data);
    await Future.delayed(const Duration(seconds: 5));
    emit(FindMemberSuccess(''));
  }
}

abstract class FindMemberBlocState {}

abstract class FindMemberBlocEvent {}

class FindMemberBlocInit extends FindMemberBlocState {}

class RequestFindMember extends FindMemberBlocEvent {}

class FindMemberRequested extends FindMemberBlocState {}

class FindMemberSuccess extends FindMemberBlocState {
  final dynamic data;

  FindMemberSuccess(this.data);
}

class FindMemberFailed extends FindMemberBlocState {
  final String message;

  FindMemberFailed(this.message);
}
