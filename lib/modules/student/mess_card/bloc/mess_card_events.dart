import 'package:equatable/equatable.dart';

abstract class MessCardEvents extends Equatable {
  const MessCardEvents();
}

class GetMessCardStatus extends MessCardEvents {
  @override
  List<Object> get props => [];
}
