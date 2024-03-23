import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_colors.dart';
import 'app_text.dart';

extension AppSnackBars on BuildContext {
  snackBar(
    String message, {
    Color color = AppColors.white,
    Color background = AppColors.primary,
  }) =>
      ScaffoldMessenger.of(this).showSnackBar(SnackBar(
        content: AppText.mediumText(message, color: color),
        backgroundColor: background,
      ));

  errorSnackBar(
    String message, {
    Color color = AppColors.white,
    Color background = AppColors.text,
  }) =>
      snackBar(message, background: AppColors.danger);

  successSnackBar(
    String message, {
    Color color = AppColors.white,
    Color background = AppColors.text,
  }) =>
      snackBar(message, background: AppColors.success);

  errorDialog(String title, String message) => showDialog(
      context: this,
      builder: (context) => AlertDialog(
            surfaceTintColor: AppColors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.error,
                  color: AppColors.danger,
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: AppText.boldText(title,
                        size: 20, color: AppColors.danger)),
              ],
            ),
            content: AppText.mediumText(message),
            contentPadding:
                const EdgeInsets.only(left: 25, right: 20, top: 10, bottom: 5),
            actionsPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: AppText.boldText('Close'))
            ],
          ));

  warningDialog(String title, String message) => showDialog(
      context: this,
      builder: (context) => AlertDialog(
            surfaceTintColor: AppColors.white,
            title: Row(
              children: [
                const Icon(
                  Icons.error,
                  color: AppColors.warning,
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: AppText.boldText(title,
                        size: 20, color: AppColors.warning)),
              ],
            ),
            content: AppText.mediumText(message),
            contentPadding:
                const EdgeInsets.only(left: 25, right: 20, top: 10, bottom: 5),
            actionsPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: AppText.boldText('Close'))
            ],
          ));

  successDialog(String title, String message, Function() callback) =>
      showDialog(
          context: this,
          builder: (context) => AlertDialog(
                surfaceTintColor: AppColors.white,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: AppText.boldText(title,
                            size: 20, color: AppColors.success)),
                  ],
                ),
                content: AppText.mediumText(message),
                contentPadding: const EdgeInsets.only(
                    left: 25, right: 20, top: 10, bottom: 5),
                actionsPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        callback();
                      },
                      child: AppText.boldText('Close'))
                ],
              ));

  Future<void> launchPhone(String url) async {
    if (!await launchUrl(Uri.parse('tel:$url'),
        mode: LaunchMode.externalApplication)) {
      errorSnackBar('Error dialing $url');
    }
  }

  Future<void> launchMail(String url) async {
    if (!await launchUrl(Uri.parse('mailto:$url'),
        mode: LaunchMode.externalApplication)) {
      errorSnackBar('Error open mail to $url');
    }
  }

  Future<void> launchLink(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView)) {
      errorSnackBar('Error open $url');
    }
  }

  Future<void> launchLinkExt(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      errorSnackBar('Error open $url');
    }
  }

  String getCustomerStatus(int status) {
    String text = '';
    switch (status) {
      case 1:
        text = "Active";
      case 2:
        text = "Inactive";
      case 3:
        text = "Suspended";
      case 4:
        text = "Trial";
      case 5:
        text = "New - Activation Pending";
      case 6:
        text = "Dormant";
      case 7:
        text = "Terminated";
      case 8:
        text = "In Grace";
      default:
        text = "undefined";
    }
    return text;
  }
}
