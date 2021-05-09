import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:flutter/material.dart';

class StudentAnnualPollCard extends StatefulWidget {
  @override
  _StudentAnnualPollCardState createState() => _StudentAnnualPollCardState();
}

class _StudentAnnualPollCardState extends State<StudentAnnualPollCard> {
  bool showPollCard = false;

  @override
  void initState() {
    super.initState();
    getLastVotedDate();
  }

  void getLastVotedDate() async {
    final DateTime lastVotedYear = await SharedPrefRepository.getLastPollYear();
    final DateTime now = DateTime.now();
    setState(() {
      showPollCard = now.month == 12 && now.difference(lastVotedYear).inDays.abs() > 31;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: showPollCard,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20).copyWith(top: 0),
        padding: EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: DMColors.black.withOpacity(0.25), offset: Offset(0, 4), blurRadius: 4)
        ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Annual Poll", style: DMTypo.bold18BlackTextStyle),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text("Vote for next year’s menu", style: DMTypo.bold12MutedTextStyle),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Center(
                child: DMPillButton(
                    text: "Vote here",
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    onPressed: () async {
                      Navigator.pushNamed(context, Routes.ANNUAL_POLL_SCREEN,
                          arguments: onVoteCallback);
                    },
                    textStyle: DMTypo.bold18WhiteTextStyle),
              ),
            )
          ],
        ),
      ),
    );
  }

  void onVoteCallback() {
    setState(() {
      showPollCard = false;
    });
  }
}
