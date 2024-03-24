import 'package:coa/screens/registration/forms/family.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../support/app_colors.dart';
import '../../support/app_text.dart';
import 'forms/association.dart';
import 'forms/personal.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _appBar(context),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          PersonalTab(
            callback: () {
              _tabController.animateTo(_tabController.index + 1);
            },
          ),
          AssociationTab(
            callback: () {
              _tabController.animateTo(_tabController.index + 1);
            },
          ),
          ShareTab(
            callback: () {
              _tabController.animateTo(_tabController.index + 1);
            },
          ),
          FamilyTab(callback: () {}),
        ],
      ),
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded)),
      title: AppText.boldText('Registration', size: 18),
      centerTitle: true,
      bottom: TabBar(
        controller: _tabController,
        isScrollable: true,
        enableFeedback: false,
        tabs: const [
          Tab(text: 'Personal'),
          Tab(text: 'Association'),
          Tab(text: 'Shares'),
          Tab(text: 'Family'),
        ],
      ),
    );
  }
}

class ShareTab extends StatefulWidget {
  final Function() callback;

  const ShareTab({super.key, required this.callback});

  @override
  State<ShareTab> createState() => _ShareTabState();
}

class _ShareTabState extends State<ShareTab> {
  String _kcclGroupValue = 'No';
  String _cdcoGroupValue = 'No';
  String _kcblGroupValue = 'No';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          AppText.mediumText('KCCL Folio'),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: RadioListTile(
                  title: Text('Yes'),
                  value: 'Yes',
                  groupValue: _kcclGroupValue,
                  onChanged: (value) {
                    setState(() {
                      _kcclGroupValue = value!;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile(
                  title: Text('No'),
                  value: 'No',
                  groupValue: _kcclGroupValue,
                  onChanged: (value) {
                    setState(() {
                      _kcclGroupValue = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          if (_kcclGroupValue == 'Yes')
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: AppColors.primaryBackground,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.primary)),
              child: MaterialButton(
                padding: const EdgeInsets.all(14),
                elevation: 0,
                highlightElevation: 0,
                color: AppColors.primary,
                onPressed: () {},
                child: AppText.boldText('ADD KCCL FOLIO',
                    color: AppColors.white, size: 12),
              ),
            ),
          const SizedBox(height: 20),
          AppText.mediumText('CDCO Folio'),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: RadioListTile(
                  title: Text('Yes'),
                  value: 'Yes',
                  groupValue: _cdcoGroupValue,
                  onChanged: (value) {
                    setState(() {
                      _cdcoGroupValue = value!;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile(
                  title: Text('No'),
                  value: 'No',
                  groupValue: _cdcoGroupValue,
                  onChanged: (value) {
                    setState(() {
                      _cdcoGroupValue = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          if (_cdcoGroupValue == 'Yes')
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: AppColors.primaryBackground,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.primary)),
              child: MaterialButton(
                padding: const EdgeInsets.all(14),
                elevation: 0,
                highlightElevation: 0,
                color: AppColors.primary,
                onPressed: () {},
                child: AppText.boldText('ADD CDCO FOLIO',
                    color: AppColors.white, size: 12),
              ),
            ),
          const SizedBox(height: 20),
          AppText.mediumText('KCBL Folio'),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: RadioListTile(
                  title: Text('Yes'),
                  value: 'Yes',
                  groupValue: _kcblGroupValue,
                  onChanged: (value) {
                    setState(() {
                      _kcblGroupValue = value!;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile(
                  title: Text('No'),
                  value: 'No',
                  groupValue: _kcblGroupValue,
                  onChanged: (value) {
                    setState(() {
                      _kcblGroupValue = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          if (_kcblGroupValue == 'Yes')
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: AppColors.primaryBackground,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.primary)),
              child: MaterialButton(
                padding: const EdgeInsets.all(14),
                elevation: 0,
                highlightElevation: 0,
                color: AppColors.primary,
                onPressed: () {},
                child: AppText.boldText('ADD KCBL FOLIO',
                    color: AppColors.white, size: 12),
              ),
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
                widget.callback();
              },
              child: AppText.boldText('CONTINUE', color: AppColors.white),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
