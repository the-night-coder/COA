import 'package:coa/support/app_colors.dart';
import 'package:coa/support/app_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShareView extends StatefulWidget {
  final dynamic data;
  final String keyValue;

  const ShareView({super.key, this.data, required this.keyValue});

  @override
  State<ShareView> createState() => _ShareViewState();
}

class _ShareViewState extends State<ShareView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryLight,
        title: AppText.boldText(
            (widget.data['magicIds'] ??
                    widget.data['folio'] ??
                    widget.data['id_no'])
                .toString(),
            size: 18),
      ),
      body: _body(),
    );
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
            if (widget.keyValue == 'broadband_share') _cido(),
          ],
        ),
      );

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
      _item('Name', widget.data['name']),
      _item('Father or Mother', widget.data['father_or_mother']),
      _item('Address', widget.data['address']),
      _item('District', widget.data['dist'].toString()),
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
                Expanded(child: AppText.mediumText(key)),
                Expanded(
                    child: AppText.mediumText(value,
                        color: AppColors.primary, align: TextAlign.end)),
              ],
            ),
          ),
          const Divider(color: AppColors.outline)
        ],
      );
}
