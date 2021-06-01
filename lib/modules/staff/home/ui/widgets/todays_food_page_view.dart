import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/modules/student/home/ui/widgets/todays_food_item.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class TodaysFoodPageView extends StatefulWidget {
  final List<MenuItem> listOfTodaysMeals;

  const TodaysFoodPageView({Key key, this.listOfTodaysMeals}) : super(key: key);

  @override
  _TodaysFoodPageViewState createState() => _TodaysFoodPageViewState();
}

class _TodaysFoodPageViewState extends State<TodaysFoodPageView> {
  double currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20),
      width: double.infinity,
      height: 170,
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: PageController(initialPage: currentIndex.toInt()),
              onPageChanged: onPageChanged,
              children: getPages(),
            ),
          ),
          DotsIndicator(
            dotsCount: 3,
            position: currentIndex,
            decorator: DotsDecorator(
              size: const Size.square(9.0),
              activeSize: const Size(30.0, 9.0),
              activeColor: DMColors.primaryBlue,
              color: DMColors.accentBlue,
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
          )
        ],
      ),
    );
  }

  void onPageChanged(int value) {
    setState(() {
      currentIndex = value.toDouble();
    });
  }

  List<TodaysFoodItem> getPages() {
    final List<MenuItem> breakfastFood =
        widget.listOfTodaysMeals.where((element) => element.itemIsAvailable.isBreakfast).toList();
    final List<MenuItem> lunchFood =
        widget.listOfTodaysMeals.where((element) => element.itemIsAvailable.isLunch).toList();
    final List<MenuItem> dinnerFood =
        widget.listOfTodaysMeals.where((element) => element.itemIsAvailable.isDinner).toList();
    return [
      TodaysFoodItem(
          title: "Breakfast",
          vegItem: breakfastFood.firstWhere((element) => element.isVeg, orElse: () => null),
          nonVegItem: breakfastFood.firstWhere((element) => !element.isVeg, orElse: () => null)),
      TodaysFoodItem(
          title: "Lunch",
          vegItem: lunchFood.firstWhere((element) => element.isVeg, orElse: () => null),
          nonVegItem: lunchFood.firstWhere((element) => !element.isVeg, orElse: () => null)),
      TodaysFoodItem(
          title: "Dinner",
          vegItem: dinnerFood.firstWhere((element) => element.isVeg, orElse: () => null),
          nonVegItem: dinnerFood.firstWhere((element) => !element.isVeg, orElse: () => null))
    ];
  }
}
