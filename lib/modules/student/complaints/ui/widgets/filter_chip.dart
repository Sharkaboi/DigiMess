import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:DigiMess/common/styles/dm_typography.dart';
import 'package:flutter/material.dart';

class FilterChips extends StatefulWidget {
  final String chipName;
  final bool isSelected;

  FilterChips({
    Key key,
    this.chipName,
    this.isSelected,
  }) : super(key: key);

  @override
  _FilterChipsState createState() => _FilterChipsState();
}

class _FilterChipsState extends State<FilterChips> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: DMColors.black.withOpacity(0.25),
                offset: Offset(0, 4),
                blurRadius: 4)
          ],
          color: widget.isSelected ? DMColors.primaryBlue : DMColors.white,
          borderRadius: BorderRadius.circular(20)),
      child: Text(
        widget.chipName,
        style: widget.isSelected
            ? DMTypo.bold16WhiteTextStyle
            : DMTypo.bold16PrimaryBlueTextStyle,
      ),
    );
  }
}
