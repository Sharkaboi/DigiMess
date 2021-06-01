import 'package:DigiMess/common/constants/app_faqs.dart';
import 'package:DigiMess/common/constants/dm_details.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/widgets/help_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentHelpScreen extends StatelessWidget {
  _makingPhoneCall() async {
    const url = 'tel://${DMDetails.staffPhoneNumber}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 30),
                child: Text("Help centre", style: DMTypo.bold20BlackTextStyle),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30).copyWith(bottom: 0),
              child: InkWell(
                onTap: () => _makingPhoneCall(),
                child: SvgPicture.asset("assets/icons/callbutton.svg",
                    height: 25, color: DMColors.primaryBlue),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30).copyWith(bottom: 0),
          child: Text("FAQs", style: DMTypo.bold18DarkBlueTextStyle),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10).copyWith(bottom: 0),
            itemCount: DMFaqs.studentFAQs.length,
            itemBuilder: (_, index) {
              return HelpWidget(
                question: DMFaqs.studentFAQs[index].question,
                answer: DMFaqs.studentFAQs[index].answer,
              );
            },
          ),
        )
      ],
    );
  }
}
