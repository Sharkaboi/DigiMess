



import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:flutter/material.dart';

class DMTextFormField extends StatefulWidget {
  const DMTextFormField({Key key, this.controller, this.labelText,this.obscureText = false , this.validator, this.onChanged}) : super(key: key);


  @override
  _DMTextFormFieldState createState() => _DMTextFormFieldState();
  final TextEditingController controller;
  final labelText;
  final obscureText;
  final ValueSetter<String> validator;
  final ValueSetter<String> onChanged;
}

class _DMTextFormFieldState extends State<DMTextFormField> {
  Color textColor = DMColors.grey;
  bool underlinePresent = true;
  var borderDecoration = UnderlineInputBorder(borderSide: BorderSide(color: DMColors.primaryBlue));
  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          textColor = hasFocus ?  DMColors.black : DMColors.accentBlue;
          if (widget.controller.text.isEmpty) {
            print('input empty');
            underlinePresent = true;
          } else {
            underlinePresent = false;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            labelText: widget.labelText,
            isDense: false,
            labelStyle: TextStyle(color: DMColors.black),
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide(color: DMColors.primaryBlue)),
            enabledBorder: underlinePresent ? borderDecoration : InputBorder.none,
            border: UnderlineInputBorder(borderSide: BorderSide(color: DMColors.primaryBlue)),
          ),
          maxLines: 1,
          controller: widget.controller,
          validator: widget.validator,
          onChanged: widget.onChanged,
          obscureText: widget.obscureText,
        ),
      ),
    );
  }
}
