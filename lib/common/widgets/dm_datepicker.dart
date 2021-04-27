import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:flutter/material.dart';

class DMDatePicker extends StatefulWidget {

  const DMDatePicker({Key key, this.labelText, this.datecontroller}):super(key: key);


  @override
  _DMDatePickerState createState() => _DMDatePickerState();
  final labelText;
  final TextEditingController datecontroller;
}
class _DMDatePickerState extends State<DMDatePicker> {
  @override


  void dispose() {
    widget.datecontroller.dispose();
    super.dispose();
  }


  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10.0),
      child:TextFormField(
        readOnly: true,
        autofocus: true,
        controller: widget.datecontroller,
        style: TextStyle(
          color: DMColors.accentBlue
        ),
        decoration: InputDecoration(
                labelText: widget.labelText,
                labelStyle: TextStyle(color: DMColors.black),
                hintText: 'choose date',
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                enabledBorder: InputBorder.none,
                border: InputBorder.none,
              ),
        onTap: () async {
          var date =  await showDatePicker(
              context: context,
              initialDate:DateTime.now(),
              firstDate:DateTime(1900),
              lastDate: DateTime(2100));
          widget.datecontroller.text = date.toString().substring(0,10);
        },)
    );
  }
}
