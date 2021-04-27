import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class MessCardStates extends Equatable {
  const MessCardStates();
}

class MessCardIdle extends MessCardStates {
  @override
  List<Object> get props => [];
}

class MessCardLoading extends MessCardStates {
  @override
  List<Object> get props => [];
}

class MessCardSuccess extends MessCardStates {
  final bool isActive;
  final String admissionNo;

  MessCardSuccess(this.isActive, this.admissionNo);

  @override
  List<Object> get props => [isActive, admissionNo];
}

class MessCardError extends MessCardStates {
  final DMError error;

  MessCardError(this.error);

  @override
  List<Object> get props => [error];
}
