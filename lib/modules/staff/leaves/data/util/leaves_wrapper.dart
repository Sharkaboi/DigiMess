import 'package:DigiMess/common/firebase/models/leave_entry.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:equatable/equatable.dart';

class LeavesWrapper extends Equatable {
  final LeaveEntry leaveEntry;
  final User user;

  LeavesWrapper(this.leaveEntry, this.user);

  @override
  List<Object> get props => [leaveEntry, user];
}
