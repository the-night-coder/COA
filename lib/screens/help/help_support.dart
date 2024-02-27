import 'package:coa/support/app_colors.dart';
import 'package:coa/support/app_text.dart';
import 'package:coa/support/widget_utils.dart';
import 'package:flutter/material.dart';

class HelpSupport extends StatefulWidget {
  const HelpSupport({super.key});

  @override
  State<HelpSupport> createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryLight,
        title: AppText.boldText('Help and Support', size: 18),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () {
                context.launchLink('https://coakerala.com');
              },
              padding: const EdgeInsets.all(10),
              color: AppColors.primaryLight,
              elevation: 0,
              highlightElevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded),
                  const SizedBox(width: 15),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.boldText('More about COA'),
                      AppText.mediumText('Know more about COA and other events',
                          color: AppColors.hint)
                    ],
                  ))
                ],
              ),
            ),
            const SizedBox(height: 15),
            MaterialButton(
              onPressed: () {
                context.launchLink('https://coakerala.com/contact/');
              },
              padding: const EdgeInsets.all(10),
              color: AppColors.primaryLight,
              elevation: 0,
              highlightElevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.support_agent_rounded),
                  const SizedBox(width: 15),
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.boldText('Contact Us'),
                          AppText.mediumText('Contact us through email or phone',
                              color: AppColors.hint)
                        ],
                      ))
                ],
              ),
            ),
            const SizedBox(height: 15),
            MaterialButton(
              onPressed: () {
                context.launchLink('https://coakerala.com/contact/');
              },
              padding: const EdgeInsets.all(10),
              color: AppColors.primaryLight,
              elevation: 0,
              highlightElevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.help_sharp),
                  const SizedBox(width: 15),
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.boldText('FAQ'),
                          AppText.mediumText('Frequently asked question of COA',
                              color: AppColors.hint)
                        ],
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
