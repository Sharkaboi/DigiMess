import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignUpTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final Function(String) validator;
  final Function(String) onChanged;
  final TextInputType keyboardType;
  final int maxLength;

  const SignUpTextFormField(
      {Key key,
      this.controller,
      this.labelText = "",
      this.obscureText = false,
      this.validator,
      this.onChanged,
      this.keyboardType,
      this.maxLength})
      : assert(controller != null),
        super(key: key);

  @override
  _SignUpTextFormFieldState createState() => _SignUpTextFormFieldState();
}

class _SignUpTextFormFieldState extends State<SignUpTextFormField> {
  bool isValid = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          final validator = widget.validator ??
              (text) {
                if (text.isEmpty) {
                  return "Enter " + widget.labelText.toLowerCase();
                } else {
                  return null;
                }
              };
          if (hasFocus || validator(widget.controller.text) != null) {
            isValid = false;
          } else {
            isValid = true;
          }
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: isValid
              ? DMTypo.bold16PrimaryBlueTextStyle
              : DMTypo.bold16BlackTextStyle,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          decoration: InputDecoration(
            labelText: widget.labelText,
            isDense: false,
            errorStyle: DMTypo.bold12RedTextStyle,
            counterText: "",
            labelStyle: DMTypo.bold14BlackTextStyle,
            alignLabelWithHint: true,
            hintStyle: DMTypo.bold16BlackTextStyle,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: DMColors.primaryBlue)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: DMColors.red)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: DMColors.red)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: DMColors.primaryBlue)),
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: DMColors.primaryBlue)),
          ),
          maxLines: 1,
          maxLength: widget.maxLength,
          controller: widget.controller,
          validator: widget.validator ??
              (text) {
                if (text.isEmpty) {
                  return "Enter " + widget.labelText.toLowerCase();
                } else {
                  return null;
                }
              },
          onChanged: widget.onChanged ?? (_) {},
          obscureText: widget.obscureText,
        ),
      ),
    );
  }
}
