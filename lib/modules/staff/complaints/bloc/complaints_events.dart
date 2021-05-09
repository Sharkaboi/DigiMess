import 'package:equatable/equatable.dart';

abstract class StaffComplaintsEvents extends Equatable {
  const StaffComplaintsEvents();
}

class GetAllComplaints extends StaffComplaintsEvents {
  @override
  List<Object> get props => [];
}