import 'package:DigiMess/common/util/app_status.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();
}

class SplashLoading extends SplashState {
  @override
  List<Object> get props => [];
}

class UserLoggedOutSplash extends SplashState {
  @override
  List<Object> get props => [];
}

class SplashSuccess extends SplashState {
  final AppStatus appStatus;

  SplashSuccess(this.appStatus);

  @override
  List<Object> get props => [appStatus];
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
