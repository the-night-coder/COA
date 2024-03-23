import 'package:coa/support/app_colors.dart';
import 'package:coa/support/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../support/app_text_style.dart';

class PersonalTab extends StatelessWidget {
  final Function() callback;

  const PersonalTab({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 150,
                height: 160,
                decoration: BoxDecoration(
                    color: AppColors.primaryBackground,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppColors.primary)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: AppText.regularText('Click to upload photo',
                        align: TextAlign.center, color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                enabled: false,
                decoration: InputDecoration(
                    labelText: 'Mobile',
                    suffixStyle:
                        AppTextStyle.mediumTextStyle(color: AppColors.hint)),
                keyboardType: TextInputType.phone,
                style: AppTextStyle.mediumTextStyle(color: AppColors.hint),
                initialValue: '8156906701',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter mobile number';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Full Name*',
                    suffixStyle: AppTextStyle.mediumTextStyle()),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                style: AppTextStyle.mediumTextStyle(),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter mobile number';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Email*',
                    suffixStyle: AppTextStyle.mediumTextStyle()),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                style: AppTextStyle.mediumTextStyle(),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter mobile number';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'House Name, Street Name*',
                    suffixStyle: AppTextStyle.mediumTextStyle()),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                style: AppTextStyle.mediumTextStyle(),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter mobile number';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Pincode*',
                    suffixStyle: AppTextStyle.mediumTextStyle()),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.postalCode],
                style: AppTextStyle.mediumTextStyle(),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter mobile number';
                  }
                  return null;
                },
              ),
              TextFormField(
                enabled: false,
                decoration: InputDecoration(
                    labelText: 'District*',
                    suffixStyle: AppTextStyle.mediumTextStyle()),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.postalCode],
                style: AppTextStyle.mediumTextStyle(),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter mobile number';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
                items: [
                  DropdownMenuItem(
                    child: Text('Association A'),
                    value: 'Association A',
                  ),
                  DropdownMenuItem(
                    child: Text('Association B'),
                    value: 'Association B',
                  ),
                ],
                onChanged: (value) {
                  // Handle association dropdown value change
                },
                decoration: InputDecoration(
                  labelText: 'Post Office*',
                  suffixStyle: AppTextStyle.mediumTextStyle(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please select association';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
                items: [
                  DropdownMenuItem(
                    child: Text('Association A'),
                    value: 'Association A',
                  ),
                  DropdownMenuItem(
                    child: Text('Association B'),
                    value: 'Association B',
                  ),
                ],
                onChanged: (value) {
                  // Handle association dropdown value change
                },
                decoration: InputDecoration(
                  labelText: 'Blood Group*',
                  suffixStyle: AppTextStyle.mediumTextStyle(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please select association';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'WhatsApp No.',
                  suffixStyle: AppTextStyle.mediumTextStyle(),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.postalCode],
                style: AppTextStyle.mediumTextStyle(),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter mobile number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: MaterialButton(
                  padding: const EdgeInsets.all(14),
                  elevation: 0,
                  highlightElevation: 0,
                  color: AppColors.primary,
                  onPressed: () {
                    callback();
                  },
                  child: AppText.boldText('CONTINUE', color: AppColors.white),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  _mobile() => Container(
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: const EdgeInsets.all(3),
        child: TextField(
          enabled: false,
          style: AppTextStyle.regularTextStyle(color: AppColors.text),
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.username],
          decoration: InputDecoration(
              hintText: 'Mobile number',
              prefixIcon: const Icon(
                Icons.phone_rounded,
                color: AppColors.hint,
              ),
              hintStyle: AppTextStyle.regularTextStyle(color: AppColors.hint),
              border: InputBorder.none),
          // onChanged: (value) => _username = value,
        ),
      );
}
