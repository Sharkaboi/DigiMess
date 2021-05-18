import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CheckboxRowWidget extends StatelessWidget {
  final String hint;
  final bool value;
  final VoidCallback onClick;

  const CheckboxRowWidget({Key key, this.hint, this.value, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, top: 20),
      child: InkWell(
        onTap: onClick,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: SvgPicture.asset(
                  value ? "assets/icons/checkbox_check.svg" : "assets/icons/checkbox_uncheck.svg"),
            ),
            Text(
              hint,
              style: value ? DMTypo.bold14PrimaryBlueTextStyle : DMTypo.normal14BlackTextStyle,
            )
          ],
        ),
      ),
    );
  }
}
