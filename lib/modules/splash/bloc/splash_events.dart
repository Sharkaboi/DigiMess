import 'package:equatable/equatable.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();
}

class InitApp extends SplashEvent {
  @override
  List<Object> get props => [];
}
