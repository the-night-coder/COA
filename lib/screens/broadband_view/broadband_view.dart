import 'package:coa/support/app_colors.dart';
import 'package:coa/support/app_text.dart';
import 'package:flutter/material.dart';

class BroadbandView extends StatefulWidget {
  const BroadbandView({super.key});

  @override
  State<BroadbandView> createState() => _BroadbandViewState();
}

class _BroadbandViewState extends State<BroadbandView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryLight,
        title: AppText.boldText('1234HDFACD', size: 18),
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
        const SizedBox(height: 15),
        _item('Name', 'Sample name'),
        _item('Address', 'Sample address'),
        _item('Key', 'value'),
        _item('-----', '-----'),
        _item('-----', '-----'),
        _item('-----', '-----'),
        _item('-----', '-----'),
        _item('-----', '-----'),
        _item('-----', '-----'),
      ],
    ),
  );

  _item(String key, String value)=> Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Expanded(child: AppText.mediumText(key)),
        Expanded(child: AppText.mediumText(value, color: AppColors.primary, align: TextAlign.end)),
      ],
    ),
  );
}
