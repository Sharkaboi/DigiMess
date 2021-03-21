import 'package:equatable/equatable.dart';

abstract class StudentHomeEvents extends Equatable {
  const StudentHomeEvents();
}

class FetchStudentHomeDetails extends StudentHomeEvents {
  @override
  List<Object> get props => [];
}
