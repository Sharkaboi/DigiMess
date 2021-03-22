import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:DigiMess/common/styles/dm_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MenuCard extends StatelessWidget {
  final MenuItem item;

  const MenuCard({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
          color: DMColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: DMColors.black.withOpacity(0.25),
                blurRadius: 4,
                offset: Offset(0, 4))
          ]),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 65,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: NetworkImage(item.imageUrl), fit: BoxFit.cover)),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child:
                          Text(item.name, style: DMTypo.bold12BlackTextStyle)),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: SvgPicture.asset(item.isVeg
                          ? "assets/icons/veg_icon.svg"
                          : "assets/icons/non_veg_icon.svg")),
                  Container(
                      padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
                      child: Text(getDaysAvailable(),
                          style: DMTypo.bold12MutedTextStyle)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String getDaysAvailable() {
    String days;
    int count = 0;
    item.daysAvailable.toMap().forEach((key, value) {
      if (value) {
        count++;
        if (days == null) {
          days = "Available on ${key}s";
        } else {
          days += ", ${key}s";
        }
      }
    });
    if (days == null) {
      return "Days available not marked by staff.";
    } else if (count == 7) {
      return "Available everyday.";
    } else {
      return "$days.";
    }
  }
}
