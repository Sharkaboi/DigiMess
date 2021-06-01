import 'package:equatable/equatable.dart';

abstract class StudentDetailsEvents extends Equatable {
  const StudentDetailsEvents();
}

class DisableStudent extends StudentDetailsEvents {
  final String userId;

  final bool isDisabled;

  DisableStudent(this.userId, this.isDisabled);

  @override
  List<Object> get props => [userId];
}
