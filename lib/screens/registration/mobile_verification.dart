import 'dart:async';

import 'package:coa/screens/registration/registraction_screen.dart';
import 'package:coa/support/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

import '../../bloc/mobile_verify/mobile_verify_bloc.dart';
import '../../support/app_colors.dart';
import '../../support/app_icons.dart';
import '../../support/app_text.dart';
import '../../support/app_text_style.dart';

class MobileVerification extends StatefulWidget {
  const MobileVerification({super.key});

  @override
  State<MobileVerification> createState() => _MobileVerificationState();
}

class _MobileVerificationState extends State<MobileVerification>
    with AutomaticKeepAliveClientMixin {
  final _bloc = MobileVerifyBloc();
  final _textController = TextEditingController();
  Timer? timer;
  int secondsRemaining = 0;
  bool enableResent = false;

  _startTimer() {
    secondsRemaining = 60 * 3;
    enableResent = false;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResent = true;
        });
      }
    });
  }

  _stopTimer() {
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _body(),
      appBar: _appBar(),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded)),
      // title: AppText.boldText('Welcome to COA', size: 18),
      centerTitle: true,
    );
  }

  _body() => BlocConsumer(
        bloc: _bloc,
        listener: (context, state) {
          _textController.text = _bloc.mobile;
          if (state is MobileVerifyBlocFailed) {
            EasyLoading.dismiss();
            context.errorDialog('Error!', state.message);
          } else if (state is MobileVerifyBlocOtpFailed) {
            EasyLoading.dismiss();
            context.errorDialog('Error!', state.message);
          } else if (state is MobileVerifyBlocOtpSent) {
            EasyLoading.dismiss();
            context.successSnackBar('OTP has been sent to ${_bloc.mobile}');
            _startTimer();
          } else if (state is MobileVerifyBlocLoading) {
            EasyLoading.show(
                status: state.message,
                maskType: EasyLoadingMaskType.black,
                dismissOnTap: false);
          } else if (state is MobileVerifyBlocVerified) {
            EasyLoading.dismiss();
            context.successSnackBar('Mobile Number Verified');
            _stopTimer();
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const RegistrationForm()));
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: AppText.boldText('Welcome to COA', size: 30),
                  ),
                  const SizedBox(height: 10),
                  AppText.mediumText(
                    'അസ്സോസിയേഷന്റെ 2023-24 വർഷത്തെ മെമ്പർഷിപ്പ് പുതുക്കുന്നതിന് ഡിജിറ്റൽ ഫോം ആണ് തയ്യാറാക്കിയിരിക്കുന്നത്. ഇവിടെ നിന്ന് ആയാസ രഹിതമായി നിങ്ങളുടെ വിവരങ്ങൾ ചേർക്കാവുന്നതാണ്. എല്ലാ കോളങ്ങളും പൂരിപ്പിക്കാൻ ശ്രദ്ധിക്കുക.',
                    color: AppColors.hint,
                    align: TextAlign.center,
                    size: 12,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: AppText.mediumText(
                      'സെക്രട്ടറി',
                      color: AppColors.hint,
                      size: 12,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 70,
                          width: 70,
                          child: Image.asset(AppIcons.mobile),
                        ),
                        const SizedBox(height: 30),
                        AppText.boldText('Verify Mobile', size: 20),
                        const SizedBox(height: 5),
                        AppText.mediumText(
                            'Please enter your mobile number to get a verification code',
                            align: TextAlign.center,
                            color: AppColors.hint),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  _phoneField(),
                  const SizedBox(height: 15),
                  Center(
                    child: Builder(builder: (context) {
                      if (state is MobileVerifyBlocOtpSent ||
                          state is MobileVerifyBlocFailed) {
                        return Column(
                          children: [
                            AppText.boldText('Enter OTP'),
                            const SizedBox(height: 10),
                            OTPTextField(
                              length: 4,
                              fieldWidth: 50,
                              width: MediaQuery.of(context).size.width,
                              style: AppTextStyle.boldTextStyle(),
                              textFieldAlignment: MainAxisAlignment.spaceEvenly,
                              fieldStyle: FieldStyle.box,
                              onCompleted: (pin) {
                                _bloc.add(MobileVerifyBlocVerifyOtp(pin));
                              },
                            ),
                            const SizedBox(height: 20),
                            Builder(builder: (context) {
                              if (enableResent) {
                                return TextButton(
                                    onPressed: () => _sentOtp(),
                                    child: AppText.boldText('Resent OTP',
                                        color: AppColors.primary));
                              } else {
                                return AppText.boldText(
                                  'Resent OTP\nAfter $secondsRemaining seconds',
                                  align: TextAlign.center,
                                  color: AppColors.success,
                                );
                              }
                            }),
                          ],
                        );
                      } else {
                        return MaterialButton(
                          color: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          onPressed: () => _sentOtp(),
                          child: AppText.boldText('Get OTP',
                              color: AppColors.white),
                        );
                      }
                    }),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      );

  _phoneField() => Container(
        decoration: BoxDecoration(
            color: AppColors.field,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: AppColors.outline)),
        child: TextFormField(
          controller: _textController,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.phone,
          onChanged: (value) {
            _bloc.mobile = value;
          },
          style: AppTextStyle.mediumTextStyle(color: AppColors.text),
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              hintText: 'Mobile Number',
              hintStyle: AppTextStyle.mediumTextStyle(color: AppColors.hint),
              border: InputBorder.none),
        ),
      );

  _sentOtp() {
    FocusScope.of(context).focusedChild?.unfocus();
    if (_bloc.mobile.isNotEmpty) {
      if (_bloc.mobile.length == 10) {
        _bloc.add(MobileVerifyBlocSendOtp());
      } else {
        context.errorDialog('Invalid Mobile Number',
            'Provide a valid phone number and continue');
      }
    } else {
      context.errorDialog(
          'Mobile Number is missing', 'Provide a mobile number and continue');
    }
  }

  @override
  bool get wantKeepAlive => true;
}
