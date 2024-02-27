import 'dart:convert';

import 'package:coa/screens/broadbands/broadbands.dart';
import 'package:coa/screens/devices/devices.dart';
import 'package:coa/screens/find_member/find_member.dart';
import 'package:coa/screens/help/help_support.dart';
import 'package:coa/screens/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../support/app_colors.dart';
import '../../support/app_text.dart';
import '../../support/prefs.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  dynamic _user;
  String _userType = 'Operator';

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    _user = jsonDecode(await Pref.getUser() ?? '');
    _userType = await Pref.getUserType() ?? 'Operator';
    setState(() {});
    print(_userType);
    print(_user);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.card,
              ), //BoxDecoration
              child: MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ProfileView()));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border:
                              Border.all(width: 2, color: AppColors.success)),
                      child: const ClipOval(
                        child: Icon(Icons.person_rounded),
                      ),
                    ),
                    const SizedBox(height: 15),
                    AppText.boldText(
                        _user == null
                            ? 'Anilkumar K A'
                            : _user['user']?['name'] ?? '',
                        color: AppColors.text,
                        size: 16),
                    AppText.mediumText(
                        _user == null
                            ? 'COA/23432/4556324'
                            : _user['user']?['email'] ?? '',
                        color: AppColors.hint,
                        size: 13)
                  ],
                ),
              ) //UserAccountDrawerHeader
              ), //DrawerHeader
          ListTile(
            leading: const Icon(Icons.person_rounded),
            title: AppText.mediumText('My Profile', size: 16),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ProfileView()));
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppText.mediumText('IDs', color: AppColors.hint),
          ),
          ListTile(
            leading: const Icon(Icons.device_hub_rounded),
            title: AppText.mediumText('Digital IDs', size: 16),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Devices()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.wifi_tethering_rounded),
            title: AppText.mediumText('Broadband IDs', size: 16),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Broadband()));
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppText.mediumText('Others', color: AppColors.hint),
          ),
          ListTile(
            leading: const Icon(Icons.handshake_rounded),
            title: AppText.mediumText('Shares', size: 16),
            onTap: () {
              Navigator.pop(context);
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => const FindCustomer()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_search_rounded),
            title: AppText.mediumText('Find a Member', size: 16),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const FindMember()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_rounded),
            title: AppText.mediumText('Notices', size: 16),
            onTap: () {
              Navigator.pop(context);
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => const FindCustomer()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.support_agent_rounded),
            title: AppText.mediumText('Help and Support', size: 16),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const HelpSupport()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.share_rounded),
            title: AppText.mediumText('Share', size: 16),
            onTap: () {
              Navigator.pop(context);
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => const FindCustomer()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_rounded),
            title: AppText.mediumText('About COA', size: 16),
            onTap: () {
              Navigator.pop(context);
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => const FindCustomer()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: AppText.mediumText('Logout', size: 16),
            onTap: () {
              Navigator.pop(context);
              _logout();
            },
          ),
        ],
      ),
    );
  }

  _logout() {
    showDialog(
        context: context,
        builder: (dialog) => AlertDialog(
              backgroundColor: AppColors.white,
              title: AppText.boldText('Logout?'),
              content: AppText.mediumText('Are you sure you want to logout?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(dialog);
                    },
                    child: AppText.mediumText('Cancel')),
                TextButton(
                    onPressed: () async {
                      Navigator.pop(dialog);
                      await Pref.setToken(null);
                      Navigator.of(dialog)
                          .pushNamedAndRemoveUntil('/login', (route) => false);
                    },
                    child:
                        AppText.mediumText('Logout', color: AppColors.danger)),
              ],
            ).build(dialog));
  }
}
