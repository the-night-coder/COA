import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationBloc
    extends Bloc<RegistrationBlocEvent, RegistrationBlocState> {
  RegistrationBloc(super.initialState);
}

abstract class RegistrationBlocState {}

abstract class RegistrationBlocEvent {}
