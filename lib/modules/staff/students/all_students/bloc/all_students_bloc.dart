import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/students/all_students/bloc/all_students_events.dart';
import 'package:DigiMess/modules/staff/students/all_students/bloc/all_students_states.dart';
import 'package:DigiMess/modules/staff/students/all_students/data/all_students_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllStudentsBloc extends Bloc<AllStudentsEvents, AllStudentsStates> {
  final AllStudentsRepository _allStudentsRepository;

  AllStudentsBloc(AllStudentsStates initialState, this._allStudentsRepository)
      : super(initialState);

  @override
  Stream<AllStudentsStates> mapEventToState(AllStudentsEvents event) async* {
    yield AllStudentsLoading();
    if (event is GetAllStudents) {
      final DMTaskState result =
          await _allStudentsRepository.getAllStudents(studentFilterType: event.studentFilterType);
      if (result.isTaskSuccess) {
        yield AllStudentsSuccess(result.taskResultData);
      } else {
        yield AllStudentsError(result.error);
      }
    }
  }
}
