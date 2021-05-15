import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:flutter/material.dart';

class StaffNoticesWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback onNoticePlaced;

  const StaffNoticesWrapper({Key key, this.child, this.onNoticePlaced}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      child,
      Positioned(
          bottom: 10,
          right: 10,
          child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.STAFF_ADD_NOTICE_SCREEN,
                    arguments: onNoticePlaced);
              },
              backgroundColor: DMColors.darkBlue,
              child: Icon(Icons.add, color: DMColors.white)))
    ]);
  }
}
