import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:DigiMess/common/styles/dm_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TodaysFoodItem extends StatelessWidget {
  final String title;
  final MenuItem nonVegItem;
  final MenuItem vegItem;

  const TodaysFoodItem({Key key, this.title, this.nonVegItem, this.vegItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(right: 20, bottom: 10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: DMColors.black.withOpacity(0.25),
            offset: Offset(0, 4),
            blurRadius: 4)
      ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Text(title, style: DMTypo.bold18BlackTextStyle),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: getImagesOrEmptyHint(),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> getImagesOrEmptyHint() {
    if (vegItem == null && nonVegItem == null) {
      return [
        Text("Food not marked by mess staff",
            style: DMTypo.bold12BlackTextStyle)
      ];
    } else if (vegItem == null) {
      return [
        Expanded(
          child: FoodImageItem(
              isVeg: false,
              foodName: nonVegItem.name,
              imageUrl: nonVegItem.imageUrl),
        )
      ];
    } else if (nonVegItem == null) {
      return [
        Expanded(
          child: FoodImageItem(
              isVeg: true, foodName: vegItem.name, imageUrl: vegItem.imageUrl),
        )
      ];
    } else {
      return [
        Expanded(
          child: FoodImageItem(
              isVeg: false,
              foodName: nonVegItem.name,
              imageUrl: nonVegItem.imageUrl),
        ),
        Expanded(
          child: FoodImageItem(
              isVeg: true, foodName: vegItem.name, imageUrl: vegItem.imageUrl),
        )
      ];
    }
  }
}

class FoodImageItem extends StatelessWidget {
  final bool isVeg;
  final String foodName;
  final String imageUrl;

  const FoodImageItem({Key key, this.isVeg, this.foodName, this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    image: NetworkImage(imageUrl), fit: BoxFit.cover)),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      foodName,
                      style: DMTypo.bold12BlackTextStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: SvgPicture.asset(
                    isVeg
                        ? "assets/icons/veg_icon.svg"
                        : "assets/icons/non_veg_icon.svg",
                    height: 10,
                    width: 10,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
