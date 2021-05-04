import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class DatePickerFormField extends StatefulWidget {
  final DateTime initialDateTime;
  final Function(DateTime) onChanged;
  final String labelText;
  final String hint;
  final String Function(DateTime) validator;
  final bool showError;

  const DatePickerFormField(
      {Key key,
      this.initialDateTime,
      this.onChanged,
      this.labelText = "",
      this.hint = "",
      this.validator,
      this.showError = false})
      : super(key: key);

  @override
  _DatePickerFormFieldState createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends State<DatePickerFormField> {
  DateTime currentDate;
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
      child: InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onTap: () async {
          FocusScope.of(context).unfocus();
          final date = await DMDatePicker.showPicker(context,
              lastDate: DateTime.now().add(Duration(days: 365 * 6)));
          currentDate = date;
          _controller.text = getFormattedDateString(date);
          if (date != null) {
            setState(() {
              widget.onChanged(date);
            });
          } else {
            setState(() {
              widget.onChanged(null);
            });
          }
        },
        child: Container(
          width: double.infinity,
          child: TextFormField(
              autofocus: false,
              focusNode: null,
              decoration: InputDecoration(
                  labelText: widget.labelText,
                  errorStyle: DMTypo.bold12RedTextStyle,
                  enabled: false,
                  labelStyle: DMTypo.bold14BlackTextStyle,
                  alignLabelWithHint: true,
                  hintStyle: DMTypo.bold16BlackTextStyle,
                  suffixIcon: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: SvgPicture.asset("assets/icons/calendar.svg",
                        color: DMColors.primaryBlue, height: 15, width: 15),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: DMColors.primaryBlue)),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: DMColors.primaryBlue)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: DMColors.red)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: DMColors.primaryBlue))),
              validator: (_) {
                return widget.validator(currentDate);
              },
              readOnly: true,
              controller: _controller,
              style: widget.initialDateTime == null
                  ? DMTypo.bold16BlackTextStyle
                  : DMTypo.bold16PrimaryBlueTextStyle),
        ),
      ),
    );
  }

  String getFormattedDateString(DateTime date) {
    if (date == null) {
      return null;
    } else {
      final format = DateFormat("d/M/y");
      return format.format(date);
    }
  }
}
