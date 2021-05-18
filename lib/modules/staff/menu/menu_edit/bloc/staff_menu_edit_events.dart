import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:equatable/equatable.dart';

abstract class StaffMenuEditEvents extends Equatable {
  const StaffMenuEditEvents();
}

class ChangeEnabledStatus extends StaffMenuEditEvents {
  final bool isEnabled;
  final String id;

  ChangeEnabledStatus(this.isEnabled, this.id);

  @override
  List<Object> get props => [isEnabled, id];
}

class AvailableDay extends StaffMenuEditEvents {
  final DaysAvailable days;
  final String id;

  AvailableDay(this.days, this.id);

  @override
  List<Object> get props => [days, id];
}

class AvailableTime extends StaffMenuEditEvents {
  final MenuItemIsAvailable time;
  final String id;

  AvailableTime(this.time, this.id);

  @override
  List<Object> get props => [time, id];
}
