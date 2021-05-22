import 'dart:math';

import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/extensions/string_extensions.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_dialogs.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/staff/annual_poll/bloc/annual_poll_bloc.dart';
import 'package:DigiMess/modules/staff/annual_poll/bloc/annual_poll_events.dart';
import 'package:DigiMess/modules/staff/annual_poll/bloc/annual_poll_states.dart';
import 'package:DigiMess/modules/staff/annual_poll/ui/util/meal_timing.dart';
import 'package:DigiMess/modules/staff/annual_poll/ui/widgets/annual_poll_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StaffAnnualPollScreen extends StatefulWidget {
  @override
  _StaffAnnualPollScreenState createState() => _StaffAnnualPollScreenState();
}

class _StaffAnnualPollScreenState extends State<StaffAnnualPollScreen> {
  bool _isLoading = false;
  List<MenuItem> listOfItems = [];
  StaffAnnualPollBloc _bloc;
  MealTiming currentSelectedTab = MealTiming.BREAKFAST;
  int breakfastMaxVotes = 0;
  int lunchMaxVotes = 0;
  int dinnerMaxVotes = 0;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      dismissible: false,
      child: BlocConsumer<StaffAnnualPollBloc, StaffAnnualPollStates>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is AnnualPollLoading;
          });

          if (state is AnnualPollError) {
            DMSnackBar.show(context, state.error.message);
          } else if (state is AnnualPollFetchSuccess) {
            setState(() {
              listOfItems = state.listOfItems;
              breakfastMaxVotes =
                  listOfItems.map((e) => e.annualPollVotes.forBreakFast).reduce(max);
              lunchMaxVotes = listOfItems.map((e) => e.annualPollVotes.forLunch).reduce(max);
              dinnerMaxVotes = listOfItems.map((e) => e.annualPollVotes.forDinner).reduce(max);
            });
          } else if (state is AnnualPollResetSuccess) {
            _bloc.add(GetAllVotes());
          }
        },
        builder: (context, state) {
          _bloc = BlocProvider.of<StaffAnnualPollBloc>(context);
          if (state is AnnualPollIdle) {
            _bloc.add(GetAllVotes());
            return Container();
          } else if (state is AnnualPollLoading) {
            return Container();
          } else {
            return Container(child: getAnnualPollScreen());
          }
        },
      ),
    );
  }

  Widget getAnnualPollScreen() {
    if (listOfItems == null || listOfItems.isEmpty) {
      return Center(
        child: Text("No menu items added.",
            style: DMTypo.bold14MutedTextStyle, textAlign: TextAlign.center),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Annual poll status", style: DMTypo.bold16BlackTextStyle),
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(getAnnualPollStatus(), style: DMTypo.normal14BlackTextStyle))
                    ],
                  ),
                ),
                DMPillOutlinedButton(
                  text: "Reset",
                  textStyle: DMTypo.bold14DarkBlueTextStyle,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  onPressed: () async {
                    final bool choice = await DMAlertDialog.show(context, "Reset annual poll?");
                    if (choice) {
                      _bloc.add(ResetAnnualPoll());
                    }
                  },
                )
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Text("Ratings", style: DMTypo.bold16BlackTextStyle)),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text("The students voted for these foods.",
                  style: DMTypo.normal14BlackTextStyle)),
          getMealTimingTabs(),
          Expanded(
              child: GestureDetector(
            onHorizontalDragEnd: _onSwipe,
            child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 40).copyWith(top: 20),
                itemCount: listOfItems.length,
                itemBuilder: (context, index) {
                  return AnnualPollItem(
                      name: listOfItems[index].name,
                      votes: getVotes(listOfItems[index]),
                      mealTiming: currentSelectedTab,
                      maxVotesOfTiming: getMaxVoteOfCurrentTab());
                }),
          ))
        ],
      );
    }
  }

  String getAnnualPollStatus() {
    final DateTime now = DateTime.now();
    if (now.month == 12) {
      return "Open";
    } else {
      return "Closed";
    }
  }

  _setSelectedTab(MealTiming mealTiming) {
    setState(() {
      currentSelectedTab = mealTiming;
    });
  }

  getMaxVoteOfCurrentTab() {
    if (currentSelectedTab == MealTiming.BREAKFAST) {
      return breakfastMaxVotes;
    } else if (currentSelectedTab == MealTiming.LUNCH) {
      return lunchMaxVotes;
    } else {
      return dinnerMaxVotes;
    }
  }

  int getVotes(MenuItem menuItem) {
    if (currentSelectedTab == MealTiming.BREAKFAST) {
      return menuItem.annualPollVotes.forBreakFast;
    } else if (currentSelectedTab == MealTiming.LUNCH) {
      return menuItem.annualPollVotes.forLunch;
    } else {
      return menuItem.annualPollVotes.forDinner;
    }
  }

  Widget getMealTimingTabs() {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: Row(
            children: List.generate(MealTiming.values.length, (index) {
          final currentTiming = MealTiming.values[index];
          final isCurrent = currentSelectedTab == currentTiming;
          return Expanded(
              child: InkWell(
            onTap: () => _setSelectedTab(currentTiming),
            child: Container(
                child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  child: Text(currentTiming.toStringValue().capitalizeFirst(),
                      style:
                          isCurrent ? DMTypo.bold14BlackTextStyle : DMTypo.normal14BlackTextStyle),
                ),
                Divider(
                    color: isCurrent ? DMColors.primaryBlue : Colors.transparent,
                    thickness: 2,
                    indent: 20,
                    endIndent: 20)
              ],
            )),
          ));
        })));
  }

  void _onSwipe(DragEndDetails details) {
    if (details.primaryVelocity > 0) {
      // Right Swipe (+x axis movement)
      if (currentSelectedTab == MealTiming.DINNER) {
        setState(() {
          currentSelectedTab = MealTiming.LUNCH;
        });
      } else if (currentSelectedTab == MealTiming.LUNCH) {
        setState(() {
          currentSelectedTab = MealTiming.BREAKFAST;
        });
      }
    } else if (details.primaryVelocity < 0) {
      //Left Swipe (-x axis movement)
      if (currentSelectedTab == MealTiming.BREAKFAST) {
        setState(() {
          currentSelectedTab = MealTiming.LUNCH;
        });
      } else if (currentSelectedTab == MealTiming.LUNCH) {
        setState(() {
          currentSelectedTab = MealTiming.DINNER;
        });
      }
    }
  }
}
