import 'package:DigiMess/common/styles/colors.dart';
import 'package:DigiMess/common/styles/dm_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NavItem extends StatelessWidget {
  final String text;
  final String iconAsset;
  final bool isItemSelected;
  final VoidCallback onClick;

  const NavItem(
      {Key key, this.text, this.iconAsset, this.isItemSelected, this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(right: 15),
              child: SvgPicture.asset(iconAsset,
                  height: 24,
                  color: isItemSelected ? DMColors.darkBlue : Colors.black),
            ),
            Text(text,
                style: isItemSelected
                    ? DMStyles.smallerBlueTextStyle
                    : DMStyles.smallerTextStyle)
          ],
        ),
      ),
    );
  }
}
