import 'package:DigiMess/common/errors/error_wrapper.dart';
import 'package:DigiMess/common/util/user_types.dart';
import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();
}

class SplashLoading extends SplashState {
  @override
  List<Object> get props => [];
}

class UserLoginStatus extends SplashState {
  final UserType userType;

  UserLoginStatus(this.userType);

  @override
  List<Object> get props => [];
}

class SplashError extends SplashState {
  final DMError error;

  SplashError(this.error);

  @override
  List<Object> get props => [error];
}

class SplashIdle extends SplashState {
  @override
  List<Object> get props => [];
}
