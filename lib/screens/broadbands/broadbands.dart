import 'package:coa/screens/broadband_view/broadband_view.dart';
import 'package:coa/support/app_colors.dart';
import 'package:coa/support/app_text.dart';
import 'package:flutter/material.dart';

class Broadband extends StatefulWidget {
  const Broadband({super.key});

  @override
  State<Broadband> createState() => _BroadbandState();
}

class _BroadbandState extends State<Broadband> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryLight,
        title: AppText.mediumText('Broadband IDs', size: 18),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 15),
            _item(),
            const SizedBox(height: 15),
            _item(),
            const SizedBox(height: 15),
            _item(),
          ],
        ),
      ),
    );
  }

  MaterialButton _item() {
    return MaterialButton(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const BroadbandView()));
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
                AppText.mediumText('12377FDTKN'),
                PopupMenuButton<String>(
                  surfaceTintColor: AppColors.white,
                  icon: const Icon(Icons.more_vert_rounded),
                  onSelected: (String result) {
                    switch (result) {
                      case 'View':
                        {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const BroadbandView()));
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
                AppText.boldText('Keralavision Broadband Ltd'),
                const SizedBox(height: 5),
                AppText.regularText(
                    'Sample address, city, post office, sample pincode, street',
                    color: AppColors.text),
              ],
            ),
          )
        ],
      ),
    );
  }
}
