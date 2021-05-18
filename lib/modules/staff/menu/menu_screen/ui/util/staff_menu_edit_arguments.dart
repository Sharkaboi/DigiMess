import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:flutter/material.dart';

class StaffMenuEditArguments {
  final MenuItem item;
  final VoidCallback onSuccess;

  StaffMenuEditArguments(this.item, this.onSuccess);
}
