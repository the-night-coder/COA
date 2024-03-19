import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/api_repo.dart';

class MobileVerifyBloc
    extends Bloc<MobileVerifyBlocEvent, MobileVerifyBlocState> {
  final _repo = ApiRepository();
  String mobile = '';
  MobileVerifyBloc() : super(MobileVerifyBlocInit()) {
    on<MobileVerifyBlocSendOtp>(_sentOtp);
    on<MobileVerifyBlocVerifyOtp>(_verifyOtp);
  }

  FutureOr<void> _sentOtp(MobileVerifyBlocSendOtp event,
      Emitter<MobileVerifyBlocState> emit) async {
    emit(MobileVerifyBlocLoading('Sending OTP'));
    // final resp = await _repo.sentOptMobile(mobile);
    // if (resp.status) {
    //   emit(MobileVerifyBlocOtpSent());
    // } else {
    //   emit(MobileVerifyBlocOtpFailed(resp.message.toString()));
    // }
    await Future.delayed(const Duration(seconds: 3));
    emit(MobileVerifyBlocOtpSent());
  }

  FutureOr<void> _verifyOtp(MobileVerifyBlocVerifyOtp event,
      Emitter<MobileVerifyBlocState> emit) async {
    emit(MobileVerifyBlocLoading('Verifying OTP'));
    // final resp = await _repo.verifyOptMobile(mobile, event.otp);
    // if (resp.status) {
    //   emit(MobileVerifyBlocEmailVerified());
    // } else {
    //   emit(MobileVerifyBlocFailed(resp.message.toString()));
    // }
    await Future.delayed(const Duration(seconds: 3));
    emit(MobileVerifyBlocVerified());
  }
}

class MobileVerifyBlocState {}

class MobileVerifyBlocEvent {}

class MobileVerifyBlocInit extends MobileVerifyBlocState {}

class MobileVerifyBlocSetVerified extends MobileVerifyBlocEvent {}

class MobileVerifyBlocSendOtp extends MobileVerifyBlocEvent {}

class MobileVerifyBlocVerifyOtp extends MobileVerifyBlocEvent {
  final String otp;

  MobileVerifyBlocVerifyOtp(this.otp);
}

class MobileVerifyBlocLoading extends MobileVerifyBlocState {
  final String message;

  MobileVerifyBlocLoading(this.message);
}

class MobileVerifyBlocOtpSent extends MobileVerifyBlocState {}

class MobileVerifyBlocVerified extends MobileVerifyBlocState {}

class MobileVerifyBlocFailed extends MobileVerifyBlocState {
  final String message;

  MobileVerifyBlocFailed(this.message);
}

class MobileVerifyBlocOtpFailed extends MobileVerifyBlocState {
  final String message;

  MobileVerifyBlocOtpFailed(this.message);
}
