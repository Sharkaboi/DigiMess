import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class _FAQ extends Equatable {
  const _FAQ._({@required this.question, @required this.answer});

  final String question;
  final String answer;

  @override
  List<Object> get props => [this.question, this.answer];
}

class DMFaqs {
  const DMFaqs._();

  static const studentFAQs = [];

  static const staffFAQs = [];
}
