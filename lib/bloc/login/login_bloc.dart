import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/api_model.dart';
import '../../api/api_repo.dart';
import '../../support/prefs.dart';

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
      emit(OTPSent(res.message ?? 'OTP has been sent'));
    } else {
      emit(LoginFailed(res.message.toString()));
    }
    print(res.data);
  }

  FutureOr<void> _getLogin(RequestLogin event, Emitter<LoginState> emit) async {
    emit(LoginRequested());
    ApiResponse res = await _repo.getLoginWithOtp(event.mobile, event.otp);
    if (res.status) {
      await Pref.setToken(res.data['data']?['token']);
      await Pref.setUser(jsonEncode(res.data['data']?['member']));
      emit(LoginSuccess(res.data));
    } else {
      emit(LoginFailed(res.message.toString()));
    }
    print(res.data);
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
