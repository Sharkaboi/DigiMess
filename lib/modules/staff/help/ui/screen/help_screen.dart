import 'package:DigiMess/common/constants/app_faqs.dart';
import 'package:DigiMess/modules/staff/help/ui/widget/help_widget.dart';
import 'package:flutter/material.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class StaffHelpScreen extends StatefulWidget {
  @override
  _StaffHelpScreenState createState() => _StaffHelpScreenState();
}
_makingPhoneCall() async {
  const url = 'tel://9876543210';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
class _StaffHelpScreenState extends State<StaffHelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20, top: 30).copyWith(bottom: 0),
                child: Text("Help centre", style: DMTypo.bold14BlackTextStyle),
              ),
            ),
            InkWell(
              onTap:() =>_makingPhoneCall(),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30,vertical: 30 ).copyWith(bottom: 0),
                child: SvgPicture.asset("assets/icons/callbutton.svg",
                    height: 25, color: DMColors.primaryBlue),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 50, right: 280).copyWith(bottom: 0),
          child: Text("FAQ", style: DMTypo.bold16DarkBlueTextStyle),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: DMFaqs.staffFAQs.length,
            itemBuilder: (_, index) {
              return StaffHelpWidget(
                question: DMFaqs.staffFAQs[index].question,
                answer: DMFaqs.staffFAQs[index].answer,
              );
            },
          ),
        )
      ],
    );
  }
}
