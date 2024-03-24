import 'package:coa/bloc/shares/add_share_bloc.dart';
import 'package:coa/support/app_text.dart';
import 'package:coa/support/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../api/api_model.dart';
import '../../api/api_repo.dart';
import '../../support/app_colors.dart';
import '../../support/app_text_style.dart';

class AddShare extends StatefulWidget {
  final String keyValue;

  const AddShare({super.key, required this.keyValue});

  @override
  State<AddShare> createState() => _AddShareState();
}

class _AddShareState extends State<AddShare> {
  final _bloc = AddShareBloc();
  final _search = TextEditingController();

  @override
  void initState() {
    switch (widget.keyValue) {
      case 'kcbl_folio':
        _bloc.type = 'kcbl';
      case 'kccl_folio':
        _bloc.type = 'kccl';
      case 'kvbl_folio':
        _bloc.type = 'kvbl';
      case 'cidco_membership':
        _bloc.type = 'cido';
      case 'broadband_share':
        _bloc.type = 'broadband';
      case 'magic_share':
        _bloc.type = 'magic';
    }
    _bloc.pagingController.addPageRequestListener((pageKey) {
      _bloc.add(AddShareBlocLoadEvent(pageKey));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _pagingBody(),
    );
  }

  _appBar() => AppBar(
        title: AppText.boldText('Search Unlinked Share', size: 18),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
          ),
        ),
      );

  _pagingBody() => CustomScrollView(slivers: [
        SliverList(
            delegate: SliverChildListDelegate([
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              controller: _search,
              decoration: InputDecoration(
                  labelText: 'Search',
                  suffixStyle: AppTextStyle.mediumTextStyle(),
                  suffixIcon: IconButton(
                      onPressed: () {
                        _bloc.search = _search.text.toString();
                        _bloc.pagingController.refresh();
                      },
                      icon: const Icon(Icons.search_rounded))),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (value) {
                _bloc.search = value.toString();
                _bloc.pagingController.refresh();
              },
              style: AppTextStyle.mediumTextStyle(),
            ),
          ),
        ])),
        SliverFillViewport(
          delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PagedListView<int, dynamic>(
                pagingController: _bloc.pagingController,
                builderDelegate: PagedChildBuilderDelegate<dynamic>(
                  itemBuilder: (context, item, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: MaterialButton(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(color: AppColors.primaryLight),
                          borderRadius: BorderRadius.circular(16)),
                      onPressed: () => _linkDialog(item['id'].toString()),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppText.boldText(item['folio'],
                              size: 16, color: AppColors.primary),
                          AppText.boldText(item['name'], size: 14),
                          const SizedBox(height: 5),
                          AppText.mediumText(item['address'],
                              size: 13, color: AppColors.hint),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        )
      ]);

  _linkDialog(String id) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: AppColors.white,
              surfaceTintColor: AppColors.white,
              title: AppText.boldText('Link Share',
                  size: 18, color: AppColors.primary),
              content: AppText.mediumText(
                  'Are you sure you want to link this share?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: AppText.boldText('Cancel')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _link(id);
                    },
                    child: AppText.boldText('Link', color: AppColors.primary)),
              ],
            ));
  }

  _link(String id) async {
    EasyLoading.show(
        status: 'Linking',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
    final repo = ApiRepository();
    String type = '';
    switch (widget.keyValue) {
      case 'kcbl_folio':
        type = 'kcbl';
      case 'kccl_folio':
        type = 'kccl';
      case 'kvbl_folio':
        type = 'kvbl';
      case 'cidco_membership':
        type = 'cido';
      case 'broadband_share':
        type = 'broadband';
      case 'magic_share':
        type = 'magic';
    }
    ApiResponse response = await repo.unlinkShare(type, id);
    EasyLoading.dismiss();
    if (response.status) {
      context.successSnackBar('Share linked!');
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/dashboard', (route) => false);
    } else {
      context.errorDialog('Error', response.message ?? 'Something went wrong!');
    }
  }
}
