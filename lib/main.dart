import 'dart:async';

import 'package:coa/screens/dash/dashboard.dart';
import 'package:coa/screens/login/login_screen.dart';
import 'package:coa/support/app_colors.dart';
import 'package:coa/support/app_icons.dart';
import 'package:coa/support/app_text.dart';
import 'package:coa/support/prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COA',
      routes: {
        '/dashboard': (context) => const Dashboard(),
        '/login': (context) => const LoginScreen(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        primaryColor: AppColors.primary,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String version = '';

  @override
  void initState() {
    super.initState();
    _readVersion();
    _launchScreen();
  }

  _readVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  _launchScreen() {
    Timer(const Duration(seconds: 3), () async {
      if ((await Pref.getToken())?.isNotEmpty == true) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Dashboard()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: SizedBox(
          child: Image.asset(
            AppIcons.logo,
            width: 300,
            height: 300,
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(30),
        child:
        AppText.regularText('Version: $version', align: TextAlign.center),
      ),
    );
  }
}
