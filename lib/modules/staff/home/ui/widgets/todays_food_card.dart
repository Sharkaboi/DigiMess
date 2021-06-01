import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TodaysFoodCard extends StatelessWidget {
  final List<MenuItem> listOfTodaysMeals;

  const TodaysFoodCard({Key key, this.listOfTodaysMeals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 30, 20, 20),
      width: double.infinity,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: DMColors.black.withOpacity(0.25), offset: Offset(0, 4), blurRadius: 4)
      ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(margin: EdgeInsets.all(20), child: getMenuIconOrClosedIcon()),
          Expanded(
            child: Container(margin: EdgeInsets.all(20), child: getTodayMessOrClosedHint()),
          ),
        ],
      ),
    );
  }

  Widget getTodayMessOrClosedHint() {
    if (DateExtensions.isNightTime()) {
      return Text("Mess closed", style: DMTypo.bold24BlackTextStyle);
    } else {
      return Column(
        children: [
          Text("Today's Food", style: DMTypo.bold24BlackTextStyle),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(getTimeInterval(), style: DMTypo.bold12MutedTextStyle),
          ),
          getFoodItemsOfCurrentTime()
        ],
      );
    }
  }

  String getTimeInterval() {
    if (DateExtensions.isBreakfastTime()) {
      return "9:00 AM - 11:00 AM";
    } else if (DateExtensions.isLunchTime()) {
      return "12:00 PM - 1:00 PM";
    } else if (DateExtensions.isDinnerTime()) {
      return "8:00 PM - 9:00 PM";
    } else {
      return "";
    }
  }

  Widget getFoodItemsOfCurrentTime() {
    String mealsString;
    if (DateExtensions.isBreakfastTime()) {
      final meals = listOfTodaysMeals
              .where((element) => element.itemIsAvailable.isBreakfast && element.isVeg)
              .take(1)
              .toList() +
          listOfTodaysMeals
              .where((element) => element.itemIsAvailable.isBreakfast && !element.isVeg)
              .take(1)
              .toList();
      meals.forEach((element) {
        if (mealsString == null) {
          mealsString = "• ${element.name}";
        } else {
          mealsString += " / ${element.name}";
        }
      });
    } else if (DateExtensions.isLunchTime()) {
      final meals = listOfTodaysMeals
              .where((element) => element.itemIsAvailable.isLunch && element.isVeg)
              .take(1)
              .toList() +
          listOfTodaysMeals
              .where((element) => element.itemIsAvailable.isLunch && !element.isVeg)
              .take(1)
              .toList();
      meals.forEach((element) {
        if (mealsString == null) {
          mealsString = "• ${element.name}";
        } else {
          mealsString += " / ${element.name}";
        }
      });
    } else if (DateExtensions.isDinnerTime()) {
      final meals = listOfTodaysMeals
              .where((element) => element.itemIsAvailable.isDinner && element.isVeg)
              .take(1)
              .toList() +
          listOfTodaysMeals
              .where((element) => element.itemIsAvailable.isDinner && !element.isVeg)
              .take(1)
              .toList();
      meals.forEach((element) {
        if (mealsString == null) {
          mealsString = "• ${element.name}";
        } else {
          mealsString += " / ${element.name}";
        }
      });
    }

    return Text(mealsString ?? "Food not marked by mess staff", style: DMTypo.bold12BlackTextStyle);
  }

  getMenuIconOrClosedIcon() {
    if (DateExtensions.isNightTime()) {
      return SvgPicture.asset("assets/icons/moon_icon.svg");
    } else {
      return SvgPicture.asset("assets/icons/food_icon.svg");
    }
  }
}
