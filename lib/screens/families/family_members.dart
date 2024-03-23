import 'package:coa/bloc/common/relation_bloc.dart';
import 'package:coa/bloc/family/family_members_bloc.dart';
import 'package:coa/screens/families/add_family_member.dart';
import 'package:coa/support/app_colors.dart';
import 'package:coa/support/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class FamilyMembers extends StatefulWidget {
  const FamilyMembers({super.key});

  @override
  State<FamilyMembers> createState() => _FamilyMembersState();
}

class _FamilyMembersState extends State<FamilyMembers> {
  final _bloc = FamilyMemberBloc();

  @override
  void initState() {
    _bloc.add(FamilyMemberLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _appBar(context),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddFamilyMember(
                      callback: () => _bloc.add(FamilyMemberLoadEvent()),
                    ))),
        backgroundColor: AppColors.primary,
        child: const Icon(
          Icons.add_rounded,
          color: AppColors.white,
        ),
      ),
    );
  }

  _appBar(BuildContext context) => AppBar(
        title: AppText.boldText('Family Members', size: 18),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_rounded)),
      );

  _body() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder(
            bloc: _bloc,
            builder: (context, state) {
              if (state is FamilyMemberBlocLoadingState) {
                return Center(
                  child: Shimmer.fromColors(
                      baseColor: AppColors.primaryLight,
                      highlightColor: AppColors.primary,
                      child: AppText.boldText(
                        'Loading \nFamily Members',
                        size: 20,
                        align: TextAlign.center,
                      )),
                );
              } else if (state is FamilyMemberBlocEmptyState) {
                return Center(
                  child: AppText.boldText('No Family Members, Try to add one.'),
                );
              } else if (state is FamilyMemberBlocErrorState) {
                return Center(
                  child: Column(
                    children: [
                      AppText.mediumText(state.message),
                      TextButton(
                          onPressed: () => _bloc.add(FamilyMemberLoadEvent()),
                          child: AppText.boldText('Retry'))
                    ],
                  ),
                );
              } else if (state is FamilyMemberBlocLoadedState) {
                return _list(state.data);
              }
              return Center(
                child: Shimmer.fromColors(
                    baseColor: AppColors.primaryLight,
                    highlightColor: AppColors.primary,
                    child: AppText.boldText(
                      'Preparing',
                      size: 20,
                      align: TextAlign.center,
                    )),
              );
            }),
      );

  _list(List<dynamic> list) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: list
            .map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: _item(e),
                ))
            .toList(),
      );

  MaterialButton _item(dynamic data) => MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        onPressed: () {},
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: AppColors.primaryLight),
            borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppText.boldText(data['name']),
                  AppText.mediumText(data['relation']),
                  AppText.regularText(data['dob']),
                  AppText.mediumText(
                      'Blood Group ${data['blood_group'].toString().toUpperCase()}')
                ],
              ),
            ),
            Positioned(
                right: 0,
                top: 0,
                child: PopupMenuButton<String>(
                  surfaceTintColor: AppColors.white,
                  icon: const Icon(Icons.more_vert_rounded),
                  onSelected: (String result) {
                    switch (result) {
                      case 'Update':
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddFamilyMember(
                              data: data,
                              callback: () =>
                                  _bloc.add(FamilyMemberLoadEvent()),
                            ),
                          ),
                        );
                        break;
                      default:
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'Update',
                      child: AppText.mediumText('Update'),
                    ),
                  ],
                ))
          ],
        ),
      );
}
