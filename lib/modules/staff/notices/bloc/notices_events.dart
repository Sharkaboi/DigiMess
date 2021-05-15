import 'package:equatable/equatable.dart';

abstract class StaffNoticesEvents extends Equatable {
  const StaffNoticesEvents();
}

class GetAllNotices extends StaffNoticesEvents {
  @override
  List<Object> get props => [];
}

class PlaceNotice extends StaffNoticesEvents {
  final String title;

  PlaceNotice(this.title);

  @override
  List<Object> get props => [title];
}
