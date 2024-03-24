import 'dart:convert';

import 'package:coa/screens/shares/add_share.dart';
import 'package:coa/screens/view_share/view_share.dart';
import 'package:coa/support/app_colors.dart';
import 'package:coa/support/app_text.dart';
import 'package:coa/support/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../api/api_model.dart';
import '../../api/api_repo.dart';
import '../../support/prefs.dart';

class Shares extends StatefulWidget {
  final List<dynamic> list;
  final String keyValue;

  const Shares({super.key, required this.list, required this.keyValue});

  @override
  State<Shares> createState() => _SharesState();
}

class _SharesState extends State<Shares> {
  dynamic _user;

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryLight,
        title: AppText.mediumText('Shares', size: 18),
      ),
      body: widget.list.isNotEmpty
          ? SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child:
                  Column(children: widget.list.map((e) => _item(e)).toList()))
          : Center(
              child: AppText.boldText('No Share.'),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddShare(keyValue: widget.keyValue)));
        },
        child: AppText.boldText('Link', color: AppColors.white),
      ),
    );
  }

  Future<void> _getUser() async {
    _user = jsonDecode(await Pref.getUser() ?? '');
    setState(() {});
    print(_user);
  }

  Widget _item(dynamic item) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: MaterialButton(
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ShareView(
                    data: item,
                    keyValue: widget.keyValue,
                  )));
        },
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: AppColors.primaryLight),
            borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppColors.primaryLight,
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.mediumText((item['magicIds'] ??
                          item['folio'] ??
                          item['id_no'] ??
                          item['partnerCode'])
                      .toString()),
                  PopupMenuButton<String>(
                    surfaceTintColor: AppColors.white,
                    icon: const Icon(Icons.more_vert_rounded),
                    onSelected: (String result) {
                      switch (result) {
                        case 'View':
                          {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ShareView(
                                      data: item,
                                      keyValue: widget.keyValue,
                                    )));
                          }
                          break;
                        case 'Unlink':
                          _unlinkDialog(item['id'].toString());
                        default:
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'View',
                        child: AppText.mediumText('View'),
                      ),
                      // if (_user?['is_approved'] != 'approved')
                      PopupMenuItem<String>(
                        value: 'Unlink',
                        child: AppText.mediumText('Unlink',
                            color: AppColors.danger),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.boldText(item['operatorName'] ??
                      item['name'] ??
                      item['partnerName']),
                  const SizedBox(height: 5),
                  AppText.regularText(item['address'],
                      color: AppColors.hint, size: 12),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _unlinkDialog(String id) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: AppColors.white,
              surfaceTintColor: AppColors.white,
              title:
                  AppText.boldText('Unlink', size: 18, color: AppColors.danger),
              content: AppText.mediumText(
                  'Are you sure you want to unlink this share?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: AppText.boldText('Cancel')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _unlink(id);
                    },
                    child: AppText.boldText('Unlink', color: AppColors.danger)),
              ],
            ));
  }

  _unlink(String id) async {
    EasyLoading.show(
        status: 'Unlinking',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
    final repo = ApiRepository();
    String type = '';
    switch (widget.keyValue) {
      case 'kcbl_folio':
        type = 'kcbl';
      case 'kccl_folio':
        type = 'kccl';
      case 'kvbl_folio':
        type = 'kvbl';
      case 'cidco_membership':
        type = 'cido';
      case 'broadband_share':
        type = 'broadband';
      case 'magic_share':
        type = 'magic';
    }
    ApiResponse response = await repo.unlinkShare(type, id);
    EasyLoading.dismiss();
    if (response.status) {
      context.successSnackBar('Share unlinked!');
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/dashboard', (route) => false);
    } else {
      context.errorDialog('Error', response.message ?? 'Something went wrong!');
    }
  }
}
