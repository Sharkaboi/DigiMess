import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // gives us height and width of the screen
    final String topLeftBackground = 'assets/background/top_left_bg.svg';
    final String bottomRightBackground = 'assets/background/bottom_right_bg.svg';
    return Container(
      height: size.height,
      width: size.width,
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: SvgPicture.asset(
                topLeftBackground,
                semanticsLabel: 'background',
                width: size.width * 0.3,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: SvgPicture.asset(
                bottomRightBackground,
                semanticsLabel: 'background',
                width: size.width * 0.3,
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}