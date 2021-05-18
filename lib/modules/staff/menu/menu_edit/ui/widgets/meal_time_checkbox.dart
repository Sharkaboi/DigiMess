import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CheckboxRowWidget extends StatelessWidget {
  final String hint;
  final bool value;
  final VoidCallback onClick;

  const CheckboxRowWidget({Key key, this.hint, this.value, this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, top: 20),
      child: Align(
        alignment: Alignment.center,
        child: Row(
          children: [
            InkWell(
              child: SvgPicture.asset(value
                  ? "assets/icons/checkbox_check.svg"
                  : "assets/icons/checkbox_uncheck.svg"),
              onTap: onClick,
            ),
            Container(
              width: 10,
            ),
            Text(
              hint,
              style: value
                  ? DMTypo.bold12AccentBlueTextStyle
                  : DMTypo.normal12BlackTextStyle,
            )
          ],
        ),
      ),
    );
  }
}
