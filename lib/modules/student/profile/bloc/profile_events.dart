import 'package:equatable/equatable.dart';

abstract class StudentProfileEvents extends Equatable {
  const StudentProfileEvents();
}

class GetUserDetails extends StudentProfileEvents {
  @override
  List<Object> get props => [];
}

class CloseAccount extends StudentProfileEvents {
  @override
  List<Object> get props => [];
}