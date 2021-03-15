import 'package:DigiMess/common/styles/dm_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoNetworkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
            margin: EdgeInsets.all(10),
            child: SvgPicture.asset("assets/icons/no_internet_icon.svg")),
        Text("Uh-oh!",
            style: DMStyles.headerStyle),
        Container(
          margin: EdgeInsets.all(10),
          child: Text("Please check your internet connection",
              style: DMStyles.normalTextStyle),
        ),
      ],
    ));
  }
}
