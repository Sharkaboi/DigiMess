import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class RegisterStates extends Equatable {
  const RegisterStates();
}

class UserNameAvailableSuccess extends RegisterStates {
  @override
  List<Object> get props => [];
}

class RegisterSuccess extends RegisterStates {
  @override
  List<Object> get props => [];
}

class RegisterLoading extends RegisterStates {
  @override
  List<Object> get props => [];
}

class RegisterIdle extends RegisterStates {
  @override
  List<Object> get props => [];
}

class RegisterError extends RegisterStates {
  final DMError error;

  RegisterError(this.error);

  @override
  List<Object> get props => [error];
}
