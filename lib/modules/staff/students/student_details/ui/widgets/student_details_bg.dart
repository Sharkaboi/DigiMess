import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StudentDetailsScrollView extends StatelessWidget {
  final Widget child;

  const StudentDetailsScrollView({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: DMColors.lightBlue,
          child: SingleChildScrollView(
              child: Container(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.maxWidth,
            ),
            child: Stack(
              children: [
                Container(
                  height: 130,
                  width: double.infinity,
                  child: SvgPicture.asset("assets/icons/home_bg.svg", fit: BoxFit.cover),
                ),
                child,
              ],
            ),
          )),
        );
      },
    );
  }
}
