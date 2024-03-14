import 'dart:async';

import 'package:coa/api/api_model.dart';
import 'package:coa/api/api_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SliderBloc extends Bloc<LoadSliderEvent, SliderBlocState> {
  final _repo = ApiRepository();

  SliderBloc() : super(SliderInit()) {
    on<LoadSliderEvent>(_loadData);
  }

  FutureOr<void> _loadData(
      LoadSliderEvent event, Emitter<SliderBlocState> emit) async {
    emit(SliderLoading());
    ApiResponse response = await _repo.getSliders();
    if (response.status) {
      emit(SliderSuccess(response.data['data']['sliders']));
    } else {
      emit(SliderFailed(response.message ?? 'Failed to load'));
    }
  }
}

abstract class SliderBlocState {}

abstract class SliderBlocEvent {}

class LoadSliderEvent extends SliderBlocEvent {}

class SliderInit extends SliderBlocState {}

class SliderLoading extends SliderBlocState {}

class SliderFailed extends SliderBlocState {
  final String message;

  SliderFailed(this.message);
}

class SliderSuccess extends SliderBlocState {
  final List<dynamic> data;

  SliderSuccess(this.data);
}
