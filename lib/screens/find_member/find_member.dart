import 'package:coa/bloc/find_member/find_member_bloc.dart';
import 'package:coa/screens/id_card/id_card.dart';
import 'package:coa/support/app_colors.dart';
import 'package:coa/support/app_text.dart';
import 'package:coa/support/widget_utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../support/app_text_style.dart';

class FindMember extends StatefulWidget {
  const FindMember({super.key});

  @override
  State<FindMember> createState() => _FindMemberState();
}

class _FindMemberState extends State<FindMember> {
  String _district = '--select--';
  String _mekhala = '--select--';
  String _username = '';
  final _bloc = FindMemberBloc();

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
            AppText.mediumText('District'),
            const SizedBox(height: 5),
            _dropdown(),
            const SizedBox(height: 15),
            AppText.mediumText('Mekhala'),
            const SizedBox(height: 5),
            _dropdownMekhala(),
            const SizedBox(height: 15),
            AppText.mediumText('Name'),
            const SizedBox(height: 5),
            _usernameField(),
            const SizedBox(height: 15),
            _loginButton(),
            const SizedBox(height: 20),
            BlocBuilder(
              bloc: _bloc,
              builder: (context, state) {
                if (state is FindMemberSuccess) {
                  return Column(
                    children: [
                      _item(),
                    ],
                  );
                }
                return Container();
              },
            )
          ],
        ),
      );

  MaterialButton _item() {
    return MaterialButton(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const IdCard()));
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
                      case 'Call':
                        {
                          context.launchPhone('1234567890');
                        }
                        break;
                      case 'Text Message':
                        {
                          context.launchLinkExt('sms:1234567890');
                        }
                        break;
                      case 'WhatsApp Message':
                        {
                          context.launchLinkExt(
                              'http://api.whatsapp.com/send?phone=+911234567890');
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

  _loginButton() => BlocConsumer(
        bloc: _bloc,
        listener: (context, state) async {
          if (kDebugMode) {
            print(state);
          }
          if (state is FindMemberFailed) {
            context.errorSnackBar(state.message);
          }
        },
        builder: (context, state) {
          if (state is FindMemberRequested) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Shimmer.fromColors(
                baseColor: AppColors.primaryLight,
                highlightColor: AppColors.primary,
                child: MaterialButton(
                    color: AppColors.primaryLight,
                    elevation: 0,
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                            color: AppColors.primary, width: 1)),
                    onPressed: () {
                      context.snackBar('Finding member');
                    },
                    child: AppText.boldText('Finding member',
                        color: AppColors.white)),
              ),
            );
          }
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: MaterialButton(
                color: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(15),
                onPressed: () {
                  if (_username.isEmpty) {
                    context.snackBar('Provide name');
                  } else {
                    FocusScope.of(context).focusedChild?.unfocus();
                    _bloc.add(RequestFindMember());
                  }
                },
                child: AppText.boldText('Search', color: AppColors.white)),
          );
        },
      );

  _usernameField() => Container(
        decoration: const BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        child: TextField(
          style: AppTextStyle.regularTextStyle(color: AppColors.text),
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.username],
          decoration: InputDecoration(
              hintText: 'Type Name',
              hintStyle: AppTextStyle.regularTextStyle(color: AppColors.hint),
              border: InputBorder.none),
          onChanged: (value) => _username = value,
        ),
      );

  _dropdown() => Container(
        decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.outline)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            items: [
              '--select--',
              'Alappuzha',
              'Ernakulam',
              'Idukki',
              'Kannur',
              'Kasaragod',
              'Kollam',
              'Kottayam',
              'Kozhikode',
              'Malappuram',
              'Palakkad',
              'Pathanamthitta',
              'Thiruvananthapuram',
              'Thrissur',
              'Wayanad',
            ]
                .map((String item) => DropdownMenuItem<String>(
                    value: item, child: AppText.mediumText(item)))
                .toList(),
            value: _district,
            onChanged: (String? value) {
              setState(() {
                _district = value ?? '--select--';
              });
            },
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.only(left: 5, right: 20),
            ),
            // menuItemStyleData: const MenuItemStyleData(
            //   height: 40,
            // ),
          ),
        ),
      );

  _dropdownMekhala() => Container(
        decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.outline)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            items: [
              '--select--',
              'Alappuzha',
              'Ernakulam',
              'Idukki',
              'Kannur',
              'Kasaragod',
            ]
                .map((String item) => DropdownMenuItem<String>(
                    value: item, child: AppText.mediumText(item)))
                .toList(),
            value: _mekhala,
            onChanged: (String? value) {
              setState(() {
                _mekhala = value ?? '--select--';
              });
            },
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.only(left: 5, right: 20),
            ),
            // menuItemStyleData: const MenuItemStyleData(
            //   height: 40,
            // ),
          ),
        ),
      );
}
