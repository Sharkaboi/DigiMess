import 'package:equatable/equatable.dart';

abstract class StaffStudentLeavesEvents extends Equatable {
  const StaffStudentLeavesEvents();
}

class GetAllLeaves extends StaffStudentLeavesEvents {
  final String userId;

  GetAllLeaves(this.userId);

  @override
  List<Object> get props => [];
}
