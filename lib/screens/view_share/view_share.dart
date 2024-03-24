import 'dart:convert';

import 'package:coa/api/api_model.dart';
import 'package:coa/api/api_repo.dart';
import 'package:coa/support/app_colors.dart';
import 'package:coa/support/app_text.dart';
import 'package:coa/support/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import '../../support/prefs.dart';

class ShareView extends StatefulWidget {
  final dynamic data;
  final String keyValue;

  const ShareView({super.key, this.data, required this.keyValue});

  @override
  State<ShareView> createState() => _ShareViewState();
}

class _ShareViewState extends State<ShareView> {
  dynamic _user;

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !EasyLoading.isShow,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryLight,
          title: AppText.boldText(
              (widget.data['magicIds'] ??
                      widget.data['folio'] ??
                      widget.data['id_no'] ??
                      widget.data['partnerCode'])
                  .toString(),
              size: 18),
          actions: [
            // if (_user?['is_approved'] != 'approved')
            TextButton(
                onPressed: () {
                  _unlinkDialog();
                },
                child: AppText.boldText('Unlink', color: AppColors.danger)),
            const SizedBox(width: 10),
          ],
        ),
        body: _body(),
      ),
    );
  }

  Future<void> _getUser() async {
    _user = jsonDecode(await Pref.getUser() ?? '');
    setState(() {});
    print(_user);
  }

  _body() => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            AppText.boldText('Details', size: 18),
            const SizedBox(height: 10),
            const Divider(color: AppColors.outline),
            if (widget.keyValue == 'kccl_folio') _kccl(),
            if (widget.keyValue == 'kcbl_folio') _kcbl(),
            if (widget.keyValue == 'cidco_membership') _cido(),
            if (widget.keyValue == 'broadband_share') _broadband(),
          ],
        ),
      );

  _unlinkDialog() {
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
                      _unlink();
                    },
                    child: AppText.boldText('Unlink', color: AppColors.danger)),
              ],
            ));
  }

  _unlink() async {
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
    }
    ApiResponse response =
        await repo.unlinkShare(type, widget.data['id'].toString());
    EasyLoading.dismiss();
    if (response.status) {
      context.successSnackBar('Share unlinked!');
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/dashboard', (route) => false);
    } else {
      context.errorDialog('Error', response.message ?? 'Something went wrong!');
    }
  }

  _kccl() => Column(
        children: [
          _item('Name', widget.data['operatorName']),
          _item('Address', widget.data['address']),
          _item('Email', widget.data['email']),
          _item('District', widget.data['dist']),
          _item('PAN', widget.data['pan']),
          _item('Folio No.', widget.data['folio_no']),
          _item('Shares', widget.data['shares'].toString()),
          _item('Updated At', _getDate(widget.data['updated_at'].toString())),
          _item('Created At', _getDate(widget.data['created_at'].toString())),
        ],
      );

  _kcbl() => Column(
        children: [
          _item('Name', widget.data['operatorName']),
          _item('Address', widget.data['address']),
          _item('Email', widget.data['email'] ?? ''),
          _item('Mobile No', widget.data['mobile'] ?? ''),
          _item('District', widget.data['district_id'].toString()),
          _item('Allowed Share', widget.data['allowed_share']),
          _item('Folio No.', widget.data['folio'].toString()),
          _item('Total Amount', widget.data['total_amount'].toString()),
          _item('Updated At', _getDate(widget.data['updated_at'].toString())),
          _item('Created At', _getDate(widget.data['created_at'].toString())),
        ],
      );

  _cido() => Column(
        children: [
          _item('Name', widget.data['name']),
          _item('Father or Mother', widget.data['father_or_mother']),
          _item('Address', widget.data['address']),
          _item('District', widget.data['dist'].toString()),
          _item('Updated At', _getDate(widget.data['updated_at'].toString())),
          _item('Created At', _getDate(widget.data['created_at'].toString())),
        ],
      );

  _broadband() => Column(
        children: [
          _item('Partner Name', widget.data['partnerName']),
          _item('Partner Code', widget.data['partnerCode']),
          _item('Telephone', widget.data['telephone']),
          _item('Contact Person Name', widget.data['contactPersonName']),
          _item('Address', widget.data['address'].toString()),
          _item('Updated At', _getDate(widget.data['updated_at'].toString())),
          _item('Created At', _getDate(widget.data['created_at'].toString())),
        ],
      );

  String _getDate(String data) {
    final format = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    final time = DateFormat("dd MMM yyyy, hh:mm a")
        .format(format.parse(data, true).toLocal());
    return time;
  }

  _item(String key, String value) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: AppText.mediumText(key, size: 14)),
                Expanded(
                    child: AppText.mediumText(value,
                        color: AppColors.primary,
                        align: TextAlign.end,
                        size: 14)),
              ],
            ),
          ),
          const Divider(color: AppColors.outline)
        ],
      );
}
