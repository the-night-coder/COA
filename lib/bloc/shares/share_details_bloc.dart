import 'dart:async';

import 'package:coa/api/api_model.dart';
import 'package:coa/api/api_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShareDetailsBloc extends Bloc<LoadShareDetailsEvent, ShareDetailsBlocState> {
  final _repo = ApiRepository();

  ShareDetailsBloc() : super(ShareDetailsInit()) {
    on<LoadShareDetailsEvent>(_loadData);
  }

  FutureOr<void> _loadData(
      LoadShareDetailsEvent event, Emitter<ShareDetailsBlocState> emit) async {
    emit(ShareDetailsLoading());
    ApiResponse response = await _repo.getShareDetails();
    if (response.status) {
      emit(ShareDetailsSuccess(response.data['data']));
    } else {
      emit(ShareDetailsFailed(response.message ?? 'Failed to load'));
    }
  }
}

abstract class ShareDetailsBlocState {}

abstract class ShareDetailsBlocEvent {}

class LoadShareDetailsEvent extends ShareDetailsBlocEvent {}

class ShareDetailsInit extends ShareDetailsBlocState {}

class ShareDetailsLoading extends ShareDetailsBlocState {}

class ShareDetailsFailed extends ShareDetailsBlocState {
  final String message;

  ShareDetailsFailed(this.message);
}

class ShareDetailsSuccess extends ShareDetailsBlocState {
  final List<dynamic> data;

  ShareDetailsSuccess(this.data);
}
