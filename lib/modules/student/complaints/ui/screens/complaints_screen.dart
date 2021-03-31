import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:DigiMess/common/styles/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:flutter/material.dart';
import 'package:DigiMess/common/constants/complaint_type.dart';

List <String> complaints = [];
class StudentComplaintsScreen extends StatelessWidget {
  TextEditingController _controller = TextEditingController();
  @override
    @override
    Widget build(BuildContext context) {
      return SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20, left: 10, bottom: 10),
                child: Center(
                  child: Text(
                    "Frequent Complaints",
                    style: DMTypo.bold18BlackTextStyle,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 50, right: 50),
                child: Divider(
                  thickness: 1,
                  color: DMColors.primaryBlue,
                ),
              ),
              Container(
                padding: EdgeInsets.all(15.0),
                child: Wrap(
                  spacing: 30.0,
                  runSpacing: 5.0,
                  children: [
                    FilterChips(chipName: "Hygiene",),
                    FilterChips(chipName: "Taste of Food",),
                    FilterChips(chipName: "Service",),
                    FilterChips(chipName: "Portion Size",),
                    FilterChips(chipName: "App related",),
                    FilterChips(chipName: "Others",),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: DMColors.accentBlue),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                    maxLines: 8,
                    controller: _controller,
                    maxLength: 350,
                    decoration: InputDecoration.collapsed(hintText: "Type your complaint here...",hintStyle: DMTypo.bold18MutedTextStyle),
                    style: DMTypo.bold18BlackTextStyle,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0,right: 10.0),
                padding: EdgeInsets.only(right: 10.0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Container()
                    ),
                    Expanded(
                        flex: 1,
                        child: DarkButton(
                          text: "Submit",
                          textStyle: DMTypo.bold18WhiteTextStyle,
                          onPressed: (){
                            if(!complaints.contains(_controller.text)){
                              complaints.add(_controller.text);
                            }
                            print(complaints);
                          },
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }


class FilterChips extends StatefulWidget {
  final String chipName;

  FilterChips({Key key, this.chipName,}) : super(key: key);
  @override
  _FilterChipsState createState() => _FilterChipsState();
}

class _FilterChipsState extends State<FilterChips> {
  TextStyle fontColor = DMTypo.bold14AccentBlueTextStyle;
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: new Matrix4.identity()..scale(1.15),
      child: FilterChip(
        padding: EdgeInsets.only(top: 5.0,bottom: 5.0,left: 5.0,right: 5.0),
        showCheckmark: false,
        elevation: 6.0,
        backgroundColor: DMColors.white,
        label:Text(
          widget.chipName,
        style: fontColor,
        ),
        selected: _isSelected,
        selectedColor: DMColors.primaryBlue,
        onSelected: (bool selected) {
          setState(() {
            _isSelected = selected;
            if(_isSelected == false){
              fontColor = DMTypo.bold14AccentBlueTextStyle;
              if(widget.chipName == "Hygiene"){
                complaints.remove(ComplaintType.HYGIENE.toStringValue());
              }
              if(widget.chipName == "Taste of Food"){
                complaints.remove(ComplaintType.TASTE.toStringValue());
              }
              if(widget.chipName == "Service"){
                complaints.remove(ComplaintType.SERVICE.toStringValue());
              }
              if(widget.chipName == "Portion Size"){
                complaints.remove(ComplaintType.PORTION.toStringValue());
              }
              if(widget.chipName == "App related"){
                complaints.remove(ComplaintType.APP.toStringValue());
              }
              if(widget.chipName == "Others"){
                complaints.remove(ComplaintType.OTHER.toStringValue());
              }
            }
            else{
              fontColor = DMTypo.bold14WhiteTextStyle;
              if(widget.chipName == "Hygiene"){
                complaints.add(ComplaintType.HYGIENE.toStringValue());
              }
              if(widget.chipName == "Taste of Food"){
                complaints.add(ComplaintType.TASTE.toStringValue());
              }
              if(widget.chipName == "Service"){
                complaints.add(ComplaintType.SERVICE.toStringValue());
              }
              if(widget.chipName == "Portion Size"){
                complaints.add(ComplaintType.PORTION.toStringValue());
              }
              if(widget.chipName == "App related"){
                complaints.add(ComplaintType.APP.toStringValue());
              }
              if(widget.chipName == "Others"){
                complaints.add(ComplaintType.OTHER.toStringValue());
              }
            }
          });
          print(complaints);
        },
      ),
    );
  }
}


