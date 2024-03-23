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
          DocumentsTab(),
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

class ShareTab extends StatelessWidget {
  final Function() callback;

  const ShareTab({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField(
            items: [
              DropdownMenuItem(
                child: Text('Share A'),
                value: 'Share A',
              ),
              DropdownMenuItem(
                child: Text('Share B'),
                value: 'Share B',
              ),
            ],
            onChanged: (value) {
              // Handle share dropdown value change
            },
            decoration: InputDecoration(labelText: 'Share'),
            validator: (value) {
              if (value == null) {
                return 'Please select share';
              }
              return null;
            },
          ),
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
    );
  }
}

class DocumentsTab extends StatelessWidget {
  const DocumentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Add image upload option
          TextButton(
            onPressed: () {
              // Implement image upload functionality
            },
            child: Text('Upload Image'),
          ),
        ],
      ),
    );
  }
}
