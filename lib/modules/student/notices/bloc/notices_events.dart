import 'package:equatable/equatable.dart';

abstract class StudentNoticesEvents extends Equatable {
  const StudentNoticesEvents();
}

class GetAllNotices extends StudentNoticesEvents {
  @override
  List<Object> get props => [];
}
