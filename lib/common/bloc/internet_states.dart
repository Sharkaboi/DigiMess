import 'package:equatable/equatable.dart';

abstract class InternetStates extends Equatable {
  const InternetStates();
}

class InternetIdleState extends InternetStates {
  @override
  List<Object> get props => [];
}

class NoNetworkState extends InternetStates {
  @override
  List<Object> get props => [];
}

class NetworkConnectedState extends InternetStates {
  @override
  List<Object> get props => [];
}
