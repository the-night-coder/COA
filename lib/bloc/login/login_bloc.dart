import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/api_model.dart';
import '../../api/api_repo.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final _repo = ApiRepository();

  LoginBloc() : super(LoginInit()) {
    on<RequestLoginOTP>(_getOtp);
    on<RequestLogin>(_getLogin);
  }

  FutureOr<void> _getOtp(
      RequestLoginOTP event, Emitter<LoginState> emit) async {
    emit(OTPRequested());
    ApiResponse res = await _repo.getLoginOtp(event.mobile);
    if (res.status) {
      emit(OTPSent(res.data));
    } else {
      emit(LoginFailed(res.message.toString()));
    }
    print(res.data);
  }

  FutureOr<void> _getLogin(
      RequestLogin event, Emitter<LoginState> emit) async {
    emit(LoginRequested());
    // ApiResponse res = await _repo.getLoginOtp(event.mobile);
    // if (res.status) {
    //   emit(OTPSent(res.data));
    // } else {
    //   emit(LoginFailed(res.message.toString()));
    // }
    // print(res.data);
    await Future.delayed(const Duration(seconds: 5));
    emit(LoginSuccess(null));
  }
}

abstract class LoginState {}

abstract class LoginEvent {}

class LoginInit extends LoginState {}

class RequestLoginOTP extends LoginEvent {
  final String mobile;

  RequestLoginOTP(this.mobile);
}

class RequestLogin extends LoginEvent {
  final String mobile;
  final String otp;

  RequestLogin(this.mobile, this.otp);
}

class OTPRequested extends LoginState {}
class LoginRequested extends LoginState {}
class LoginSuccess extends LoginState {
  final dynamic data;

  LoginSuccess(this.data);
}

class OTPSent extends LoginState {
  final String message;

  OTPSent(this.message);
}

class LoginFailed extends LoginState {
  final String message;

  LoginFailed(this.message);
}
