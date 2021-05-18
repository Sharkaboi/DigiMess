import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/modules/staff/menu/menu_screen/ui/util/staff_menu_edit_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StaffMenuCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onSuccess;

  const StaffMenuCard({Key key, this.item, this.onSuccess}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Routes.STAFF_MENU_EDIT_SCREEN,
            arguments: StaffMenuEditArguments(item, onSuccess));
      },
      child: Container(
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
                        child: Text(item.name,
                            style: DMTypo.bold12BlackTextStyle)),
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: SvgPicture.asset(item.isVeg
                            ? "assets/icons/veg_icon.svg"
                            : "assets/icons/non_veg_icon.svg")),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
