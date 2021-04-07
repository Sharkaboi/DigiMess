import 'package:DigiMess/common/constants/vote_entry.dart';
import 'package:equatable/equatable.dart';

abstract class StudentAnnualPollEvents extends Equatable {
  const StudentAnnualPollEvents();
}

class GetAllMenuItems extends StudentAnnualPollEvents {
  @override
  List<Object> get props => [];
}

class PlaceVote extends StudentAnnualPollEvents {
  final List<VoteEntry> listOfVotes;

  PlaceVote(this.listOfVotes);

  @override
  List<Object> get props => [listOfVotes];
}
