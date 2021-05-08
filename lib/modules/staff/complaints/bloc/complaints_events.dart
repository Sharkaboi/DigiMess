import 'package:equatable/equatable.dart';

abstract class ComplaintsEvents extends Equatable {
  const ComplaintsEvents();
}

class GetAllComplaints extends ComplaintsEvents {
  @override
  List<Object> get props => [];
}