import 'package:coa/support/app_text.dart';
import 'package:flutter/material.dart';

import '../../support/app_colors.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryLight,
        title: AppText.boldText('My Profile', size: 18),
      ),
      body: _body(),
    );
  }

  _body() => SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _header(),
            const SizedBox(height: 20),
            AppText.boldText('Anilkumar K A', size: 16),
            const SizedBox(height: 5),
            AppText.boldText('COA/23432/4556324',
                size: 16, color: AppColors.hint),
            const SizedBox(height: 20),
            _item('Mobile No.', '6635781412'),
            _item('WhatsApp No.', '6635781412'),
            _item('Name', 'Anilkumar K A'),
            _item('Email', 'sample@gmail.com'),
            _item('District', 'Ernakulam'),
            _item('Mekhala', 'Kochi'),
          ],
        ),
      );

  _item(String title, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText.boldText(title),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColors.primaryLight
            ),
            child: AppText.mediumText(value),
          ),
          const SizedBox(height: 15),
        ],
      );

  _header() => Center(
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
}
