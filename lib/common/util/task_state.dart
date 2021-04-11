import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DMTaskState extends Equatable {
  final bool isTaskSuccess;
  final dynamic taskResultData;
  final DMError error;

  DMTaskState(
      {@required this.isTaskSuccess,
      @required this.taskResultData,
      @required this.error});

  @override
  List<Object> get props =>
      [this.isTaskSuccess, this.taskResultData, this.error];
}
