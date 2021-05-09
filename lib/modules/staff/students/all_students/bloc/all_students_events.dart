import 'package:DigiMess/modules/staff/students/all_students/data/util/student_filter_type.dart';
import 'package:equatable/equatable.dart';

abstract class AllStudentsEvents extends Equatable {
  const AllStudentsEvents();
}

class GetAllStudents extends AllStudentsEvents {
  final StudentFilterType studentFilterType;

  GetAllStudents({this.studentFilterType = StudentFilterType.BOTH});

  @override
  List<Object> get props => [studentFilterType];
}
