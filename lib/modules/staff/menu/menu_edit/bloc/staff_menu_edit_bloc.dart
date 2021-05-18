import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/menu/menu_edit/bloc/staff_menu_edit_events.dart';
import 'package:DigiMess/modules/staff/menu/menu_edit/bloc/staff_menu_edit_states.dart';
import 'package:DigiMess/modules/staff/menu/menu_edit/data/staff_edit_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffMenuEditBloc extends Bloc<StaffMenuEditEvents, StaffMenuEditStates> {
  final StaffMenuEditRepository _menuRepository;

  StaffMenuEditBloc(StaffMenuEditStates initialState, this._menuRepository) : super(initialState);

  @override
  Stream<StaffMenuEditStates> mapEventToState(StaffMenuEditEvents event) async* {
    yield StaffMenuEditLoading();
    if (event is ChangeEnabledStatus) {
      final DMTaskState result =
          await _menuRepository.changeEnabledStatus(event.isEnabled, event.id);
      if (result.isTaskSuccess) {
        yield StaffMenuEditSuccess();
      } else {
        yield StaffMenuEditError(result.error);
      }
    } else if (event is AvailableDay) {
      final DMTaskState result = await _menuRepository.setAvailableDay(event.id, event.days);
      if (result.isTaskSuccess) {
        yield StaffMenuEditSuccess();
      } else {
        yield StaffMenuEditError(result.error);
      }
    } else if (event is AvailableTime) {
      final DMTaskState result = await _menuRepository.setAvailableTime(event.id, event.time);
      if (result.isTaskSuccess) {
        yield StaffMenuEditSuccess();
      } else {
        yield StaffMenuEditError(result.error);
      }
    }
  }
}
