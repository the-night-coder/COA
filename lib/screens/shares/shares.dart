import 'dart:convert';

import 'package:coa/screens/broadband_view/broadband_view.dart';
import 'package:coa/screens/view_share/view_share.dart';
import 'package:coa/support/app_colors.dart';
import 'package:coa/support/app_text.dart';
import 'package:flutter/material.dart';

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
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child:
                Column(children: widget.list.map((e) => _item(e)).toList())));
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
                  AppText.mediumText(
                      (item['magicIds'] ?? item['folio'] ?? item['id_no'])
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
                        default:
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'View',
                        child: AppText.mediumText('View'),
                      ),
                      if (_user?['is_approved'] != 'approved')
                        PopupMenuItem<String>(
                          value: 'Delete',
                          child: AppText.mediumText('Delete'),
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
                  AppText.boldText(item['operatorName'] ?? item['name']),
                  const SizedBox(height: 5),
                  AppText.regularText(item['address'], color: AppColors.hint),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
