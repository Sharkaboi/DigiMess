import 'package:DigiMess/common/errors/error_wrapper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DMTaskState extends Equatable {
  final bool isTaskSuccess;
  final dynamic taskResultData;
  final DMError errors;

  DMTaskState(
      {@required this.isTaskSuccess,
      @required this.taskResultData,
      @required this.errors});

  @override
  List<Object> get props =>
      [this.isTaskSuccess, this.taskResultData, this.errors];
}
