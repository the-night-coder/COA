import 'dart:convert';

import 'package:coa/bloc/dashboard/dashboard_bloc.dart';
import 'package:coa/screens/families/family_members.dart';
import 'package:coa/support/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../support/app_colors.dart';
import '../../support/prefs.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _bloc = DashboardBloc();
  dynamic _user;

  @override
  void initState() {
    _bloc.add(DashboardBlocLoadEvent());
    _getUser();
    super.initState();
  }

  Future<void> _getUser() async {
    _user = jsonDecode(await Pref.getUser() ?? '');
    setState(() {});
    print(_user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryLight,
        title: AppText.boldText('My Profile', size: 18),
        actions: [
          PopupMenuButton<String>(
            surfaceTintColor: AppColors.white,
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (String result) {
              switch (result) {
                case 'Family':
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => FamilyMembers()));
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Family',
                child: AppText.mediumText('Family Members'),
              ),
            ],
          )
        ],
      ),
      body: _body(),
    );
  }

  _body() => BlocConsumer(
      bloc: _bloc,
      listener: (context, state) {
        if (state is DashboardBlocSuccess) {
          _getUser();
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _header(((_user['media'] ?? []) as List<dynamic>).isNotEmpty ?
                      (_user['media']?[0]?['original_url'])
                  : null),
              const SizedBox(height: 20),
              AppText.boldText(_user['name'] ?? 'Loading', size: 16),
              const SizedBox(height: 5),
              AppText.boldText(_user['register_no'] ?? 'Loading',
                  size: 16, color: AppColors.hint),
              const SizedBox(height: 20),
              _item('Mobile No.', _user['mobile'] ?? 'Loading'),
              _item('WhatsApp No.',
                  _user['whatsapp_number'] ?? _user['mobile'] ?? 'Loading'),
              _item('Name', _user['name'] ?? 'Loading'),
              _item('Email', _user['email'] ?? 'Loading'),
              _item('District', _user['district_name'] ?? 'Loading'),
              _item('Mekhala', _user['mekhala_name'] ?? 'Loading'),
            ],
          ),
        );
      });

  _item(String title, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText.boldText(title),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.primaryLight),
            child: AppText.mediumText(value),
          ),
          const SizedBox(height: 15),
        ],
      );

  _header(String? url) {
    if (url == null) {
      return Center(
        child: Container(
          height: 100,
          width: 100,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(width: 2, color: AppColors.success)),
          child: const ClipOval(
            child: Icon(
              Icons.person_rounded,
              size: 50,
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(width: 2, color: AppColors.success)),
          child: ClipOval(
              child: Image.network(url.toString().replaceAll('https', 'http'))),
        ),
      );
    }
  }
}
