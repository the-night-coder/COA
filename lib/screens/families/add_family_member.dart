import 'package:coa/bloc/family/add_family_bloc.dart';
import 'package:coa/support/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../api/c.dart';
import '../../support/app_colors.dart';
import '../../support/app_text.dart';
import '../../support/app_text_style.dart';

class AddFamilyMember extends StatefulWidget {
  final dynamic data;
  final Function() callback;

  const AddFamilyMember({super.key, this.data, required this.callback});

  @override
  State<AddFamilyMember> createState() => _AddFamilyMemberState();
}

class _AddFamilyMemberState extends State<AddFamilyMember> {
  final _formKey = GlobalKey<FormState>();
  final _bloc = AddFamilyMemberBloc();
  final _dob = TextEditingController();

  @override
  void initState() {
    if (widget.data != null) {
      _bloc.id = widget.data['id'].toString();
      _dob.text = widget.data?['dob'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  _body() => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name*',
                        suffixStyle: AppTextStyle.mediumTextStyle(),
                      ),
                      initialValue: widget.data?['name'] ?? '',
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.name],
                      style: AppTextStyle.mediumTextStyle(),
                      onSaved: (value) {
                        _bloc.name = value.toString();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField(
                      items: [
                        'Father',
                        'Mother',
                        'Daughter',
                        'Son',
                        'Wife',
                        'Other'
                      ]
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: AppText.boldText(e),
                              ))
                          .toList(),
                      value: widget.data?['relation'],
                      onChanged: (value) {
                        // Handle association dropdown value change
                      },
                      decoration: InputDecoration(
                        labelText: 'Relation*',
                        suffixStyle: AppTextStyle.mediumTextStyle(),
                      ),
                      onSaved: (value) {
                        _bloc.relation = value.toString();
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select relation';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _dob,
                      decoration: InputDecoration(
                          labelText: 'Date of Birth*',
                          suffixStyle: AppTextStyle.mediumTextStyle(),
                          suffixIcon: IconButton(
                              onPressed: () async {
                                var date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1700, 01, 01),
                                  lastDate: DateTime.now(),
                                );
                                if (date != null) {
                                  setState(() {
                                    _dob.text =
                                        DateFormat('yyyy-MM-dd').format(date);
                                  });
                                }
                              },
                              icon: const Icon(Icons.calendar_month))),
                      keyboardType: TextInputType.none,
                      textInputAction: TextInputAction.next,
                      style: AppTextStyle.mediumTextStyle(),
                      onSaved: (value) {
                        _bloc.dob = value.toString();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please select date of birth';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField(
                      items: C.bloodGroups
                          .map((e) => DropdownMenuItem(
                                value: e.toLowerCase(),
                                child: AppText.boldText(e),
                              ))
                          .toList(),
                      onChanged: (value) {
                        // Handle association dropdown value change
                      },
                      value: widget.data?['blood_group'],
                      decoration: InputDecoration(
                        labelText: 'Blood Group*',
                        suffixStyle: AppTextStyle.mediumTextStyle(),
                      ),
                      onSaved: (value) {
                        _bloc.blood = value.toString();
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select blood group';
                        }
                        return null;
                      },
                    ),
                  ],
                )),
            const SizedBox(height: 20),
            BlocConsumer(
                bloc: _bloc,
                listener: (context, state) {
                  if (state is AddFamilyMemberBlocErrorState) {
                    context.errorDialog('Error', state.message);
                  } else if (state is AddFamilyMemberBlocSuccessState) {
                    widget.callback();
                    Navigator.of(context).pop();
                  }
                },
                builder: (context, state) {
                  if (state is AddFamilyMemberBlocLoadingState) {
                    return Shimmer.fromColors(
                        baseColor: AppColors.primaryLight,
                        highlightColor: AppColors.primary,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: MaterialButton(
                            padding: const EdgeInsets.all(14),
                            elevation: 0,
                            highlightElevation: 0,
                            onPressed: () {},
                            child: AppText.boldText(
                                '${widget.data == null ? 'Adding' : 'Updating'} Family Member',
                                color: AppColors.white),
                          ),
                        ));
                  }
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: MaterialButton(
                      padding: const EdgeInsets.all(14),
                      elevation: 0,
                      highlightElevation: 0,
                      color: AppColors.primary,
                      onPressed: () {
                        FocusScope.of(context).focusedChild?.unfocus();
                        if (_formKey.currentState?.validate() == true) {
                          _formKey.currentState?.save();
                          _bloc.add(AddFamilyMemberLoadEvent());
                        }
                      },
                      child: AppText.boldText('ADD', color: AppColors.white),
                    ),
                  );
                }),
            const SizedBox(height: 16),
          ],
        ),
      );

  _appBar() => AppBar(
        title: AppText.boldText(
            '${widget.data == null ? 'Add' : 'Update'} Family Member',
            size: 18),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_rounded)),
      );
}
