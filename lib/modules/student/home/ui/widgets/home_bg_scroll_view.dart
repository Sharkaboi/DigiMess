import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScrollView extends StatelessWidget {
  final Widget child;

  const HomeScrollView({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DMColors.lightBlue,
      child: SingleChildScrollView(
          child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: Stack(
          children: [
            Container(
              height: 130,
              width: double.infinity,
              child: SvgPicture.asset("assets/icons/home_bg.svg",
                  fit: BoxFit.cover),
            ),
            child,
          ],
        ),
      )),
    );
  }
}
