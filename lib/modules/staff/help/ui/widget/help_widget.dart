import 'package:flutter/material.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StaffHelpWidget extends StatefulWidget {
  final String question;
  final String answer;

  const StaffHelpWidget({Key key, this.question, this.answer})
      : super(key: key);

  @override
  _StaffHelpWidgetState createState() => _StaffHelpWidgetState();
}

class _StaffHelpWidgetState extends State<StaffHelpWidget> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  margin:
                  EdgeInsets.only(left: 20, top: 20).copyWith(bottom: 0),
                  child:
                  Text(widget.question, style: DMTypo.bold14BlackTextStyle),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 25)
                    .copyWith(bottom: 0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                  child: SvgPicture.asset(
                    isVisible
                        ? "assets/icons/dropdownblue.svg"
                        : "assets/icons/dropdown.svg",
                    height: 25,
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: isVisible,
            child: Container(
              margin: EdgeInsets.only(
                left: 20,
                right: 50,
                top: 25,
              ).copyWith(bottom: 0),
              child: Text(
                widget.answer,
                style: DMTypo.bold14MutedTextStyle,
              ),
            ),
          ),
          Divider(
            color: DMColors.accentBlue,
            height: 30,
            indent: 40,
            endIndent: 40,
          ),
        ],
      ),
    );
  }
}
