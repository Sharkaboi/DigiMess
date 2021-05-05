import 'package:equatable/equatable.dart';

abstract class StaffHomeEvents extends Equatable {
  const StaffHomeEvents();
}

class FetchStaffHomeDetails extends StaffHomeEvents {
  @override
  List<Object> get props => [];
}
