import 'dart:convert';

import 'package:coa/support/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../bloc/dashboard/dashboard_bloc.dart';
import '../../support/app_colors.dart';
import '../../support/prefs.dart';

class IdCard extends StatefulWidget {
  const IdCard({super.key});

  @override
  State<IdCard> createState() => _IdCardState();
}

class _IdCardState extends State<IdCard> {
  final _bloc = DashboardBloc();
  dynamic _user;

  @override
  void initState() {
    _getUser();
    _bloc.add(DashboardBlocLoadEvent());
    super.initState();
  }

  Future<void> _getUser() async {
    _user = jsonDecode(await Pref.getUser() ?? '');
    setState(() {});
    print(_user);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: _bloc,
        listener: (context, state) {
          if (state is DashboardBlocSuccess) {
            _getUser();
          }
        },
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
                title: AppText.boldText('Digital ID Card', size: 18),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    _profileImage(_user?['media']?[0]?['original_url']),
                    const SizedBox(height: 15),
                    AppText.boldText(_user?['name'] ?? 'Loading', size: 18),
                    AppText.mediumText(_user?['register_no'] ?? 'Loading',
                        color: AppColors.hint),
                    AppText.regularText(_user?['role'] ?? 'Loading',
                        color: AppColors.hint),
                    AppText.regularText(
                        "${_user?['district_name'] ?? 'Loading'}, ${_user?['mekhala_name'] ?? 'Loading'}",
                        color: AppColors.hint),
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: QrImageView(
                        data: _user?['register_no'] ?? 'Loading',
                        version: QrVersions.auto,
                        size: 100.0,
                      ),
                    ),
                    AppText.mediumText(_user?['register_no'] ?? 'Loading',
                        color: AppColors.hint),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Container _profileImage(String? url) {
    if (url == null) {
      return Container(
        height: 150,
        width: 140,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 2, color: AppColors.success)),
        child: const ClipOval(
          child: Icon(
            Icons.person_rounded,
            size: 50,
          ),
        ),
      );
    } else {
      return Container(
          height: 150,
          width: 140,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(width: 2, color: AppColors.success)),
          child: Image.network(
            url.toString().replaceAll('https', 'http'),
            fit: BoxFit.cover,
          ));
    }
  }
}
