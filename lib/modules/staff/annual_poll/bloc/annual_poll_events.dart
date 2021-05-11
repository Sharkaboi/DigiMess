import 'package:equatable/equatable.dart';

abstract class StaffAnnualPollEvents extends Equatable {
  const StaffAnnualPollEvents();
}

class GetAllVotes extends StaffAnnualPollEvents {
  @override
  List<Object> get props => [];
}

class ResetAnnualPoll extends StaffAnnualPollEvents {
  @override
  List<Object> get props => [];
}
