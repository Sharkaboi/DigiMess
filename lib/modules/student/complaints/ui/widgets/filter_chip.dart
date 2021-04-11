import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';

class FilterChips extends StatelessWidget {
  final String chipName;
  final bool isSelected;
  final VoidCallback onTap;

  FilterChips({
    Key key,
    this.chipName,
    this.isSelected,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: DMColors.black.withOpacity(0.25),
                offset: Offset(0, 4),
                blurRadius: 4)
          ],
          color: isSelected ? DMColors.primaryBlue : DMColors.white,
          borderRadius: BorderRadius.circular(20)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              chipName,
              style: isSelected
                  ? DMTypo.bold16WhiteTextStyle
                  : DMTypo.bold16PrimaryBlueTextStyle,
            ),
          ),
        ),
      ),
    );
  }
}
