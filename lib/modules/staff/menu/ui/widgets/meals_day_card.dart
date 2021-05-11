import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


List <String> Days = [];
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
        child: Align(
          alignment: Alignment.center,
          child: Row(
            children: [
              Checkbox(value: checkState,
                onChanged: (bool value){
                  setState(() {
                    checkState = value;
                    if (value == true){
                      if (Days.contains(widget.availableDays)){
                      }
                      else
                      {
                        Days.add(widget.availableDays);
                      }
                    }
                    else{
                      if (Days.contains(widget.availableDays)){
                        Days.remove(widget.availableDays);
                      }
                    }
                    print(Days);
                  });
                },),
              Text(widget.availableDays,style: DMTypo.normal12BlackTextStyle,),
            ],
          ),
        )
    );
  }
}

