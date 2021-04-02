import 'package:equatable/equatable.dart';

abstract class StudentComplaintsEvents extends Equatable {
  const StudentComplaintsEvents();
}

class PlaceComplaint extends StudentComplaintsEvents {
  final List<String> categories;
  final String complaint;

  PlaceComplaint(this.categories, this.complaint);

  @override
  List<Object> get props => [this.categories, this.complaint];
}
