import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HelpWidget extends StatefulWidget {
  final String question;
  final String answer;

  const HelpWidget({Key key, this.question, this.answer}) : super(key: key);

  @override
  _HelpWidgetState createState() => _HelpWidgetState();
}

class _HelpWidgetState extends State<HelpWidget> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text(widget.question, style: DMTypo.bold16BlackTextStyle)),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                  child: SvgPicture.asset(
                    isVisible ? "assets/icons/dropdownblue.svg" : "assets/icons/dropdown.svg",
                    height: 25,
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: isVisible,
          child: Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              widget.answer,
              style: DMTypo.bold14MutedTextStyle,
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 10).copyWith(top: 20),
            child: Divider(color: DMColors.accentBlue)),
      ],
    );
  }
}
