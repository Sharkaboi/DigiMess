import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:flutter/material.dart';

class StudentCard extends StatelessWidget {
  final User item;
  final Function(User) onItemClickCallback;

  const StudentCard({Key key, this.item, this.onItemClickCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
          color: DMColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: DMColors.black.withOpacity(0.25), blurRadius: 4, offset: Offset(0, 4))
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onTap: () => onItemClickCallback(item),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child:
                            Text(getStudentNameAndUsername(), style: DMTypo.bold14BlackTextStyle))),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      color: DMColors.lightBlue, borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    children: [
                      Text("More", style: DMTypo.bold12BlackTextStyle),
                      Icon(Icons.arrow_forward_ios, color: DMColors.darkBlue, size: 10)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getStudentNameAndUsername() {
    if (item == null || item.name == null || item.username == null) {
      return "N/A";
    } else {
      return "${item.username} - ${item.name}";
    }
  }
}
