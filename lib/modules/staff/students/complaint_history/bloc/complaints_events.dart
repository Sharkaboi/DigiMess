import 'package:equatable/equatable.dart';

abstract class StaffComplaintsEvents extends Equatable {
  const StaffComplaintsEvents();
}

class GetAllComplaints extends StaffComplaintsEvents {
  final String userId;

  GetAllComplaints(this.userId);

  @override
  List<Object> get props => [];
}
