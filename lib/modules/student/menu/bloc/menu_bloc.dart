import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/student/menu/bloc/menu_events.dart';
import 'package:DigiMess/modules/student/menu/bloc/menu_states.dart';
import 'package:DigiMess/modules/student/menu/data/menu_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentMenuBloc extends Bloc<StudentMenuEvents, StudentMenuStates> {
  final MenuRepository _menuRepository;

  StudentMenuBloc(StudentMenuStates initialState, this._menuRepository)
      : super(initialState);

  @override
  Stream<StudentMenuStates> mapEventToState(StudentMenuEvents event) async* {
    yield StudentMenuLoading();
    if (event is FilterMenuItems) {
      final DMTaskState result = await _menuRepository.getMenuItems(menuFilterType: event.menuFilterType);
      if (result.isTaskSuccess) {
        yield StudentMenuSuccess(result.taskResultData);
      } else {
        yield StudentMenuError(result.errors);
      }
    }
  }
}
