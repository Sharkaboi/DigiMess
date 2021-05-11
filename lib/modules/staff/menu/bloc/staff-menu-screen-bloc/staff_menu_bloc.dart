import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/menu/bloc/staff-menu-screen-bloc/staff_menu_events.dart';
import 'package:DigiMess/modules/staff/menu/bloc/staff-menu-screen-bloc/staff_menu_states.dart';
import 'package:DigiMess/modules/staff/menu/data/staff-menu-screen-data/staff_menu_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffMenuBloc extends Bloc<StaffMenuEvents, StaffMenuStates> {
  final StaffMenuRepository _menuRepository;

  StaffMenuBloc(StaffMenuStates initialState, this._menuRepository)
      : super(initialState);

  @override
  Stream<StaffMenuStates> mapEventToState(StaffMenuEvents event) async* {
    yield StaffMenuLoading();
    if (event is FilterMenuItems) {
      final DMTaskState result = await _menuRepository.getMenuItems(menuFilterType: event.menuFilterType);
      if (result.isTaskSuccess) {
        yield StaffMenuSuccess(result.taskResultData);
      } else {
        yield StaffMenuError(result.error);
      }
    }
  }
}