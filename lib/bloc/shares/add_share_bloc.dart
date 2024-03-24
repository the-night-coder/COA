import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../api/api_repo.dart';

class AddShareBloc extends Bloc<AddShareBlocEvent, AddShareBlocState> {
  final PagingController<int, dynamic> pagingController =
      PagingController(firstPageKey: 1);
  final _repo = ApiRepository();
  String type = '';
  String search = '';

  AddShareBloc() : super(AddShareBlocInit()) {
    on<AddShareBlocLoadEvent>(_getLatestAddShare);
    on<AddShareBlocSetMapEvent>(_setMap);
  }

  FutureOr<void> _getLatestAddShare(
      AddShareBlocLoadEvent event, Emitter<AddShareBlocState> emit) async {
    final response = await _repo.searchShare(type, search);
    if (response.status) {
      final List<dynamic> list = response.data['data']['data'];
      final int currentPage = response.data['data']['current_page'];
      final int lastPage = response.data['data']['last_page'];
      final isLastPage = lastPage == currentPage;
      if (isLastPage) {
        pagingController.appendLastPage(list);
      } else {
        final nextPageKey = event.page + 1;
        pagingController.appendPage(list, nextPageKey);
      }
    } else {
      pagingController.error = response.message;
    }
  }

  FutureOr<void> _setMap(
      AddShareBlocSetMapEvent event, Emitter<AddShareBlocState> emit) {
    type = event.type;
    search = event.search;
  }
}

abstract class AddShareBlocState {}

class AddShareBlocLoadEvent extends AddShareBlocEvent {
  final int page;

  AddShareBlocLoadEvent(this.page);
}

class AddShareBlocSetMapEvent extends AddShareBlocEvent {
  final String type;
  final String search;

  AddShareBlocSetMapEvent(this.type, this.search);
}

abstract class AddShareBlocEvent {}

class AddShareBlocInit extends AddShareBlocState {}
