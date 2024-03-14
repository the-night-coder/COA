import 'dart:convert';

import 'package:coa/support/widget_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:shimmer/shimmer.dart';

import '../../bloc/login/login_bloc.dart';
import '../../support/app_colors.dart';
import '../../support/app_icons.dart';
import '../../support/app_text.dart';
import '../../support/app_text_style.dart';
import '../../support/prefs.dart';

class OtpScreen extends StatefulWidget {
  final String mobile;

  const OtpScreen({super.key, required this.mobile});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _password = '';
  bool _obscureText = true;
  OtpTimerButtonController controller = OtpTimerButtonController();

  final _bloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _body(),
      appBar: AppBar(
        title: Image.asset(AppIcons.logo),
        backgroundColor: AppColors.white,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded)),
      ),
    );
  }

  _body() => SingleChildScrollView(
        child: _loginBody(),
      );

  Padding _loginBody() {
    return Padding(
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          AppText.mediumText('Verify', size: 28, color: AppColors.text),
          AppText.boldText('Enter Your OTP!', size: 30, color: AppColors.text),
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: AppText.mediumText(
                'OTP has been sent to your \n mobile ${widget.mobile}',
                color: AppColors.title,
                align: TextAlign.center),
          ),
          const SizedBox(height: 20),
          AppText.mediumText('Enter OTP', color: AppColors.primary),
          const SizedBox(height: 5),
          _passwordField(),
          const SizedBox(height: 20),
          AppText.mediumText(
              'Wait for sometime for the OTP to arrive Do not refresh or close',
              color: AppColors.text,
              align: TextAlign.center),
          const SizedBox(height: 20),
          _loginButton(),
          const SizedBox(height: 30),
          Center(
            child: OtpTimerButton(
              controller: controller,
              onPressed: () => Navigator.of(context).pop(),
              text: AppText.boldText('Resent OTP', color: AppColors.primary),
              buttonType: ButtonType.text_button,
              duration: 120,
            ),
          ),
        ],
      ),
    );
  }

  _passwordField() => Container(
        padding: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: TextField(
          style: AppTextStyle.regularTextStyle(color: AppColors.text),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          obscureText: _obscureText,
          enableSuggestions: false,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
              hintText: 'Enter 4 digit OTP',
              suffixIcon: IconButton(
                  onPressed: _togglePassword,
                  icon: _obscureText
                      ? const Icon(
                          Icons.visibility,
                          color: AppColors.hint,
                        )
                      : const Icon(
                          Icons.visibility_off,
                          color: AppColors.hint,
                        )),
              prefixIcon: const Icon(
                Icons.lock,
                color: AppColors.hint,
              ),
              hintStyle: AppTextStyle.regularTextStyle(color: AppColors.hint),
              border: InputBorder.none),
          onChanged: (value) => _password = value,
        ),
      );

  _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  _routeDashboard() => Navigator.of(context)
      .pushNamedAndRemoveUntil('/dashboard', (route) => false);

  _loginButton() => BlocConsumer(
        bloc: _bloc,
        listener: (context, state) async {
          if (kDebugMode) {
            print(state);
          }
          if (state is LoginFailed) {
            context.errorSnackBar(state.message);
          } else if (state is LoginSuccess) {
            context.successSnackBar('Logged in');
            _routeDashboard();
          }
        },
        builder: (context, state) {
          if (state is LoginRequested) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Shimmer.fromColors(
                baseColor: AppColors.primaryLight,
                highlightColor: AppColors.primary,
                child: MaterialButton(
                    color: AppColors.primaryLight,
                    elevation: 0,
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                            color: AppColors.primary, width: 1)),
                    onPressed: () {
                      context.snackBar('Verifying in please wait.');
                    },
                    child: AppText.boldText('Verifying OTP',
                        color: AppColors.white)),
              ),
            );
          }
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: MaterialButton(
                color: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(15),
                onPressed: () {
                  if (_password.isEmpty) {
                    context.snackBar('Provide OTP');
                  } else if (_password.length != 4) {
                    context.snackBar('Provide valid OTP');
                  } else {
                    FocusScope.of(context).focusedChild?.unfocus();
                    _bloc.add(RequestLogin(widget.mobile, _password));
                  }
                },
                child: AppText.boldText('Verify', color: AppColors.white)),
          );
        },
      );
}
