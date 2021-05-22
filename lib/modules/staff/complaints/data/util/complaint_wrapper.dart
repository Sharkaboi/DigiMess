import 'package:DigiMess/common/firebase/models/complaint.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:equatable/equatable.dart';

class ComplaintWrapper extends Equatable {
  final Complaint complaint;
  final User user;

  ComplaintWrapper(this.complaint, this.user);

  @override
  List<Object> get props => [complaint, user];
}
