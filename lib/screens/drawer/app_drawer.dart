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

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    _user = jsonDecode(await Pref.getUser() ?? '');
    setState(() {});
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
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              width: 2,
                              color: _user['is_approved'] == 'approved'
                                  ? AppColors.success
                                  : AppColors.danger)),
                      child: Builder(builder: (context) {
                        if (((_user['media'] ?? []) as List<dynamic>).isEmpty) {
                          return const ClipOval(
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Icon(Icons.person_rounded),
                            ),
                          );
                        } else {
                          return ClipOval(
                            child: Image.network(
                              (_user['media']?[0]?['original_url'])
                                  .toString()
                                  .replaceAll('https', 'http'),
                              width: 60,
                              height: 60,
                            ),
                          );
                        }
                      }),
                    ),
                    const SizedBox(height: 15),
                    AppText.boldText(
                        _user == null
                            ? 'Loading'
                            : (_user['name'] ?? '').toString().toUpperCase(),
                        color: AppColors.text,
                        size: 16),
                    AppText.mediumText(
                        _user == null ? 'Loading' : _user['register_no'] ?? '',
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
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const FindMember()));
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
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HelpSupport()));
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
              surfaceTintColor: AppColors.white,
              backgroundColor: AppColors.white,
              title: AppText.boldText('Logout?', size: 18),
              content: AppText.mediumText('Are you sure you want to logout?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(dialog);
                    },
                    child: AppText.boldText('Cancel')),
                TextButton(
                    onPressed: () async {
                      Navigator.pop(dialog);
                      await Pref.setToken(null);
                      await Pref.setUser(null);
                      await Pref.setDash(null);
                      Navigator.of(dialog)
                          .pushNamedAndRemoveUntil('/login', (route) => false);
                    },
                    child:
                        AppText.boldText('Logout', color: AppColors.danger)),
              ],
            ).build(dialog));
  }
}
