import 'package:equatable/equatable.dart';

abstract class StaffLeavesEvents extends Equatable {
  const StaffLeavesEvents();
}

class GetAllLeaves extends StaffLeavesEvents {
  @override
  List<Object> get props => [];
}
