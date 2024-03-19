import 'dart:convert';

import 'package:coa/screens/otp/otp_screen.dart';
import 'package:coa/screens/registration/mobile_verification.dart';
import 'package:coa/support/widget_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../bloc/login/login_bloc.dart';
import '../../support/app_colors.dart';
import '../../support/app_icons.dart';
import '../../support/app_text.dart';
import '../../support/app_text_style.dart';
import '../../support/prefs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _username = '';

  final _bloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _body(),
      appBar: AppBar(
        title: Image.asset(AppIcons.logo),
        backgroundColor: AppColors.white,
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
          AppText.mediumText('Sign in to', size: 28, color: AppColors.text),
          AppText.boldText('Your Account!', size: 30, color: AppColors.text),
          const SizedBox(height: 20),
          Center(
            child: AppText.mediumText('Welcome back', color: AppColors.text),
          ),
          const SizedBox(height: 40),
          AppText.mediumText('Mobile number', color: AppColors.primary),
          const SizedBox(height: 5),
          _usernameField(),
          const SizedBox(height: 20),
          _loginButton(),
          const SizedBox(height: 30),
          _signUpButton()
        ],
      ),
    );
  }

  _signUpButton() => TextButton(
        onPressed: () {
          // context.launchLink('http://reg.coakerala.com');
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MobileVerification()));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText.mediumText("Don't have an account? "),
            AppText.boldText("Sign Up", color: AppColors.primary),
          ],
        ),
      );

  _usernameField() => Container(
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: const EdgeInsets.all(3),
        child: TextField(
          style: AppTextStyle.regularTextStyle(color: AppColors.text),
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.username],
          decoration: InputDecoration(
              hintText: 'Mobile number',
              prefixIcon: const Icon(
                Icons.phone_rounded,
                color: AppColors.hint,
              ),
              hintStyle: AppTextStyle.regularTextStyle(color: AppColors.hint),
              border: InputBorder.none),
          onChanged: (value) => _username = value,
        ),
      );

  _loginButton() => BlocConsumer(
        bloc: _bloc,
        listener: (context, state) async {
          if (kDebugMode) {
            print(state);
          }
          if (state is LoginFailed) {
            context.errorSnackBar(state.message);
          } else if (state is OTPSent) {
            _routeOtpScreen();
          }
        },
        builder: (context, state) {
          if (state is OTPRequested) {
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
                      context.snackBar('Getting OTP please wait.');
                    },
                    child: AppText.boldText('Getting OTP',
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
                  if (_username.isEmpty) {
                    context.snackBar('Provide mobile number!');
                  } else if (_username.length != 10) {
                    context.snackBar('Provide valid mobile number!');
                  } else {
                    FocusScope.of(context).focusedChild?.unfocus();
                    _bloc.add(RequestLoginOTP(_username));
                  }
                },
                child: AppText.boldText('Get OTP', color: AppColors.white)),
          );
        },
      );

  _routeOtpScreen() => Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => OtpScreen(
            mobile: _username,
          )));
}
