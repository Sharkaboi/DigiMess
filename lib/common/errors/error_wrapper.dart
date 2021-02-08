import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DMError extends Equatable {
  final String message;
  final throwable;

  DMError({@required this.message, this.throwable});

  @override
  List<Object> get props => [this.message, this.throwable];
}
