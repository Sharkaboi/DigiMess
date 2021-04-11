import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:DigiMess/common/styles/dm_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PollItemCard extends StatelessWidget {
  final MenuItem item;
  final bool isChosen;
  final Function(String) onClick;

  const PollItemCard({Key key, this.item, this.isChosen, this.onClick})
      : super(key: key);

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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onClick(item.itemId),
          customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 65,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: NetworkImage(item.imageUrl),
                          fit: BoxFit.cover)),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: SvgPicture.asset(item.isVeg
                              ? "assets/icons/veg_icon.svg"
                              : "assets/icons/non_veg_icon.svg")),
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(item.name,
                                style: DMTypo.bold12BlackTextStyle)),
                      )
                    ],
                  ),
                ),
                isChosen
                    ? Container(
                        child: Icon(
                        Icons.check_circle,
                        color: DMColors.green,
                        size: 24,
                      ))
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
