import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class LoginStates extends Equatable {
  const LoginStates();
}

class LoginSuccess extends LoginStates {
  @override
  List<Object> get props => [];

}
class LoginLoading extends LoginStates {
  @override
  List<Object> get props => [];
}

class LoginIdle extends LoginStates {
  @override
  List<Object> get props => [];
}

class LoginError extends LoginStates {
  final DMError error;

  LoginError(this.error);

  @override
  List<Object> get props => [error];
}
