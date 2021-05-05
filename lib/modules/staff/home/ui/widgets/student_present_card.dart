import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/modules/staff/home/data/models/home_students_present.dart';
import 'package:flutter/material.dart';

class StudentPresentCard extends StatelessWidget {
  final StudentPresentCount studentPresentCount;

  const StudentPresentCard({Key key, this.studentPresentCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(color: DMColors.blueBg, borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: DMColors.primaryBlue,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50))),
            child: Center(
              child: Column(
                children: [
                  Text(studentPresentCount.studentsPresent.toString(),
                      style: DMTypo.bold36WhiteTextStyle),
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text("Students present", style: DMTypo.bold14WhiteTextStyle))
                ],
              ),
            ),
          )),
          Expanded(
              child: Container(
            margin: EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(studentPresentCount.studentsPresentNonVeg.toString(),
                            style: DMTypo.bold24DarkBlueTextStyle),
                        Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text("non-veg", style: DMTypo.bold14DarkBlueTextStyle))
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(studentPresentCount.studentsPresentVeg.toString(),
                            style: DMTypo.bold24PrimaryBlueTextStyle),
                        Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text("veg", style: DMTypo.bold14PrimaryBlueTextStyle))
                      ])
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
