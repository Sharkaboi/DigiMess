import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AvailableTime extends StatefulWidget {
  const AvailableTime({Key key}) : super(key: key);

  @override
  _AvailableTimeState createState() => _AvailableTimeState();
}

class _AvailableTimeState extends State<AvailableTime> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints){
      return Container(
        width: double.infinity,
        child: Column(
          children: [
            AvailableDays(availableDays: "Sunday",),
            AvailableDays(availableDays: "Monday",),
            AvailableDays(availableDays: "Tuesday",),
            AvailableDays(availableDays: "Wednesday",),
            AvailableDays(availableDays: "Thursday",),
            AvailableDays(availableDays: "Friday",),
            AvailableDays(availableDays: "Saturday",),
          ],
        ),
      );
    });
    }
  }




class AvailableDays extends StatefulWidget {
  final String availableDays;
  const AvailableDays({Key key, this.availableDays}) : super(key: key);

  @override
  _AvailableDaysState createState() => _AvailableDaysState();
}

class _AvailableDaysState extends State<AvailableDays> {
  bool checkState = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(widget.availableDays,style: TextStyle(fontSize: 12),),
          value: checkState,
          selected: checkState,
          onChanged: (bool value) {
            setState(() {
              checkState = value;
            });
          },
           //  <-- leading Checkbox
        )
    );
   }
  }


