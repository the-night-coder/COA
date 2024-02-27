import 'package:coa/support/app_text.dart';
import 'package:flutter/material.dart';
import 'package:qr/qr.dart';

import '../../support/app_colors.dart';

class IdCard extends StatefulWidget {
  const IdCard({super.key});

  @override
  State<IdCard> createState() => _IdCardState();
}

class _IdCardState extends State<IdCard> {
  var qrCode;

  @override
  void initState() {
    qrCode = QrCode(4, QrErrorCorrectLevel.L)
      ..addData('Hello, world in QR form!');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              Container(
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
              ),
              const SizedBox(height: 15),
              AppText.boldText('Anilkumar K A', size: 18),
              AppText.mediumText('COA/456645/5654', color: AppColors.hint),
              AppText.regularText('Designation', color: AppColors.hint),
              AppText.regularText('Mekhala, District', color: AppColors.hint),
              Image.asset('assets/images/qr.png', width: 200, height: 200),
              AppText.mediumText('COA/34565/566', color: AppColors.hint),
            ],
          ),
        ),
      ],
    );
  }
}
