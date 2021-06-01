import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/modules/staff/annual_poll/ui/util/meal_timing.dart';
import 'package:flutter/material.dart';

class AnnualPollItem extends StatelessWidget {
  final String name;
  final int votes;
  final MealTiming mealTiming;
  final int maxVotesOfTiming;

  const AnnualPollItem({Key key, this.name, this.votes, this.mealTiming, this.maxVotesOfTiming})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        margin: EdgeInsets.only(bottom: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(name, style: DMTypo.bold14BlackTextStyle),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: 5),
                        child: Text("• $votes ${votes == 1 ? "vote" : "votes"}",
                            style: DMTypo.bold14PrimaryBlueTextStyle)))
              ],
            ),
            getVoteCountBar(constraints)
          ],
        ),
      );
    });
  }

  Widget getVoteCountBar(BoxConstraints constraints) {
    final ratio = maxVotesOfTiming == 0 ? 0 : votes / maxVotesOfTiming;
    final double widthBias = ratio < 0.01 ? 0.01 : ratio;
    return Container(
      height: 5,
      margin: EdgeInsets.only(top: 10),
      width: constraints.maxWidth * widthBias,
      decoration: BoxDecoration(color: DMColors.green, borderRadius: BorderRadius.circular(50)),
    );
  }
}
