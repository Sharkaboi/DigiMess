import 'package:equatable/equatable.dart';

abstract class StaffLeavesEvents extends Equatable {
  const StaffLeavesEvents();
}

class GetAllLeaves extends StaffLeavesEvents {
  final String userId;

  GetAllLeaves(this.userId);

  @override
  List<Object> get props => [];
}
