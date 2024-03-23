import 'package:flutter/material.dart';

import '../../../support/app_colors.dart';
import '../../../support/app_text.dart';

class AssociationTab extends StatefulWidget {
  final Function() callback;
  const AssociationTab({super.key, required this.callback});

  @override
  State<AssociationTab> createState() => _AssociationTabState();
}

class _AssociationTabState extends State<AssociationTab> {
  String _bGroupValue = 'No';
  String _dGroupValue = 'No';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField(
              items: const [
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
              decoration: InputDecoration(labelText: 'District'),
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
              decoration: InputDecoration(labelText: 'Mekhala'),
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
              decoration: InputDecoration(labelText: 'Distributor'),
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
              decoration: InputDecoration(labelText: 'Sub Distributor'),
              validator: (value) {
                if (value == null) {
                  return 'Please select association';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            AppText.mediumText('Broadband ID'),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: Text('Yes'),
                    value: 'Yes',
                    groupValue: _bGroupValue,
                    onChanged: (value) {
                      setState(() {
                        _bGroupValue = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: Text('No'),
                    value: 'No',
                    groupValue: _bGroupValue,
                    onChanged: (value) {
                      setState(() {
                        _bGroupValue = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            if (_bGroupValue == 'Yes')
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
                  child:
                      AppText.boldText('ADD MAGIC ID', color: AppColors.white),
                ),
              ),
            const SizedBox(height: 20),
            AppText.mediumText('Magical ID'),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: Text('Yes'),
                    value: 'Yes',
                    groupValue: _dGroupValue,
                    onChanged: (value) {
                      setState(() {
                        _dGroupValue = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: Text('No'),
                    value: 'No',
                    groupValue: _dGroupValue,
                    onChanged: (value) {
                      setState(() {
                        _dGroupValue = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            if (_dGroupValue == 'Yes')
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
                  child:
                      AppText.boldText('ADD MAGIC ID', color: AppColors.white),
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
      ),
    );
  }
}
