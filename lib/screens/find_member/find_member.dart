import 'package:coa/bloc/common/districts_bloc.dart';
import 'package:coa/bloc/common/mekhala_bloc.dart';
import 'package:coa/bloc/find_member/find_member_bloc.dart';
import 'package:coa/screens/id_card/id_card.dart';
import 'package:coa/support/app_colors.dart';
import 'package:coa/support/app_text.dart';
import 'package:coa/support/widget_utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../support/app_text_style.dart';

class FindMember extends StatefulWidget {
  const FindMember({super.key});

  @override
  State<FindMember> createState() => _FindMemberState();
}

class _FindMemberState extends State<FindMember> {
  String _district = '';
  String _mekhala = '';
  String _username = '';
  final _bloc = FindMemberBloc();
  final _distBloc = DistrictsBloc();
  final _mekhalaBloc = MekhalaBloc();

  @override
  void initState() {
    _distBloc.add(DistrictsLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryLight,
        title: AppText.boldText('Find a Member', size: 18),
      ),
      body: _body(),
    );
  }

  _body() => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            _dropdown(),
            const SizedBox(height: 15),
            _dropdownMekhala(),
            const SizedBox(height: 15),
            _usernameField(),
            const SizedBox(height: 20),
            BlocConsumer(
                bloc: _bloc,
                listener: (context, state) {
                  if (state is FindMemberFailed) {
                    context.errorDialog('Error', state.message);
                  }
                },
                builder: (context, state) {
                  if (state is FindMemberRequested) {
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
                            child: AppText.boldText('Loading Members...',
                                size: 16, color: AppColors.white),
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
                        _bloc.add(
                            RequestFindMember(_username, _mekhala, _district));
                      },
                      child: AppText.boldText('ADD', color: AppColors.white),
                    ),
                  );
                }),
            const SizedBox(height: 20),
            BlocBuilder(
              bloc: _bloc,
              builder: (context, state) {
                if (state is FindMemberSuccess) {
                  return Column(
                    children: state.data.map((e) => _item(e)).toList(),
                  );
                } else if (state is FindMemberEmpty) {
                  return Center(
                    child: AppText.mediumText('No member found!'),
                  );
                }
                return Container();
              },
            )
          ],
        ),
      );

  Widget _item(dynamic item) {
    final format = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    final time = DateFormat('EEE, dd MMM yyyy, hh:mm a')
        .format(format.parse(item['created_at'], true).toLocal());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: MaterialButton(
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    clipBehavior: Clip.hardEdge,
                    contentPadding: EdgeInsets.zero,
                    surfaceTintColor: AppColors.white,
                    backgroundColor: AppColors.white,
                    content: IdCard(
                      user: item,
                    ),
                  ));
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
                  AppText.mediumText(
                      '${item['register_no']} | ${item['is_approved']}'),
                  PopupMenuButton<String>(
                    surfaceTintColor: AppColors.white,
                    icon: const Icon(Icons.more_vert_rounded),
                    onSelected: (String result) {
                      switch (result) {
                        case 'Call':
                          {
                            context.launchPhone(item['mobile']);
                          }
                          break;
                        case 'Text Message':
                          {
                            context.launchLinkExt('sms:${item['mobile']}');
                          }
                          break;
                        case 'WhatsApp Message':
                          {
                            context.launchLinkExt(
                                'http://api.whatsapp.com/send?phone=${item['mobile']}');
                          }
                          break;
                        default:
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'Call',
                        child: AppText.mediumText('Call'),
                      ),
                      PopupMenuItem<String>(
                        value: 'Text Message',
                        child: AppText.mediumText('Text Message'),
                      ),
                      PopupMenuItem<String>(
                        value: 'WhatsApp Message',
                        child: AppText.mediumText('WhatsApp Message'),
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
                  AppText.boldText(item['name']),
                  const SizedBox(height: 5),
                  AppText.regularText(
                      '${item['district']} | ${item['mekhala']}',
                      size: 13,
                      color: AppColors.text),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: AppText.regularText('Mobile: ${item['mobile']}',
                            size: 13, color: AppColors.text),
                      ),
                      Flexible(
                        child: AppText.regularText(time,
                            size: 11, color: AppColors.text),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _usernameField() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Search',
          suffixStyle: AppTextStyle.mediumTextStyle(),
        ),
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        autofillHints: const [AutofillHints.name],
        style: AppTextStyle.mediumTextStyle(),
        onChanged: (value) {
          _username = value.toString();
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your name';
          }
          return null;
        },
      );

  _dropdown() => BlocBuilder(
      bloc: _distBloc,
      builder: (context, state) {
        if (state is DistrictsBlocLoadedState) {
          return DropdownButtonFormField(
            items: state.data
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: AppText.boldText(e['name']),
                    ))
                .toList(),
            onChanged: (dynamic value) {
              _district = value['id'].toString();
              _mekhalaBloc.add(MekhalaLoadEvent(value['id'].toString()));
            },
            decoration: InputDecoration(
              labelText: 'District',
              suffixStyle: AppTextStyle.mediumTextStyle(),
            ),
          );
        } else if (state is DistrictsBlocLoadingState) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Shimmer.fromColors(
                baseColor: AppColors.primaryLight,
                highlightColor: AppColors.primary,
                child: AppText.boldText('Loading Districts......', size: 18)),
          );
        } else if (state is DistrictsBlocErrorState) {
          return Column(
            children: [
              AppText.mediumText(
                state.message,
                size: 18,
                align: TextAlign.center,
              ),
              TextButton(
                  onPressed: () {
                    _distBloc.add(DistrictsLoadEvent());
                  },
                  child: AppText.boldText('Retry'))
            ],
          );
        } else if (state is DistrictsBlocEmptyState) {
          return Container(
            child: AppText.mediumText(
              'No district found!',
              size: 18,
              align: TextAlign.center,
            ),
          );
        }
        return Container();
      });

  _dropdownMekhala() => BlocBuilder(
      bloc: _mekhalaBloc,
      builder: (context, state) {
        if (state is MekhalaBlocLoadedState) {
          return DropdownButtonFormField(
            items: state.data
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: AppText.boldText(e['name']),
                    ))
                .toList(),
            onChanged: (dynamic value) {
              _mekhala = value['id'].toString();
            },
            decoration: InputDecoration(
              labelText: 'Mekhala',
              suffixStyle: AppTextStyle.mediumTextStyle(),
            ),
          );
        } else if (state is MekhalaBlocLoadingState) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Shimmer.fromColors(
                baseColor: AppColors.primaryLight,
                highlightColor: AppColors.primary,
                child: AppText.boldText('Loading Mekhala......', size: 18)),
          );
        } else if (state is MekhalaBlocErrorState) {
          return Column(
            children: [
              AppText.mediumText(
                state.message,
                size: 18,
                align: TextAlign.center,
              ),
              TextButton(
                  onPressed: () {
                    _mekhalaBloc.add(MekhalaLoadEvent(_district));
                  },
                  child: AppText.boldText('Retry'))
            ],
          );
        } else if (state is MekhalaBlocEmptyState) {
          return Container(
            child: AppText.mediumText(
              'No mekhala found!',
              size: 18,
              align: TextAlign.center,
            ),
          );
        }
        return Container();
      });
}
