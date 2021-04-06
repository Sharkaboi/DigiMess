import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MessCardScrollView extends StatelessWidget {
  final Widget child;

  const MessCardScrollView({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: DMColors.primaryBlue)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: SvgPicture.asset("assets/icons/corner_icon_top.svg"),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: SvgPicture.asset("assets/icons/corner_icon_bottom.svg"),
              ),
              child
            ],
          ),
        ),
      ),
    );
  }
}
