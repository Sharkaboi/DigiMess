import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/widgets/dm_dialogs.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/common/widgets/internet_check_scaffold.dart';
import 'package:DigiMess/modules/staff/menu/menu_edit/bloc/staff_menu_edit_bloc.dart';
import 'package:DigiMess/modules/staff/menu/menu_edit/bloc/staff_menu_edit_events.dart';
import 'package:DigiMess/modules/staff/menu/menu_edit/bloc/staff_menu_edit_states.dart';
import 'package:DigiMess/modules/staff/menu/menu_edit/ui/widgets/dm_color_pill_button.dart';
import 'package:DigiMess/modules/staff/menu/menu_edit/ui/widgets/meal_time_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StaffMenuEditScreen extends StatefulWidget {
  final MenuItem item;
  final VoidCallback onSuccess;

  const StaffMenuEditScreen({Key key, this.item, this.onSuccess}) : super(key: key);

  @override
  _StaffMenuEditScreenState createState() => _StaffMenuEditScreenState();
}

class _StaffMenuEditScreenState extends State<StaffMenuEditScreen> {
  bool _isLoading = false;
  StaffMenuEditBloc _bloc;
  bool isEnabled;

  DaysAvailable days;
  MenuItemIsAvailable time;

  @override
  void initState() {
    super.initState();
    isEnabled = widget.item.isEnabled;
    days = widget.item.daysAvailable;
    time = widget.item.itemIsAvailable;
  }

  @override
  Widget build(BuildContext context) {
    return InternetCheckScaffold(
      isAppBarRequired: false,
      body: ModalProgressHUD(
          inAsyncCall: _isLoading,
          dismissible: false,
          child: BlocConsumer<StaffMenuEditBloc, StaffMenuEditStates>(
            listener: (context, state) async {
              setState(() {
                _isLoading = state is StaffMenuEditLoading;
              });
              if (state is StaffMenuEditError) {
                DMSnackBar.show(context, state.error.message);
              } else if (state is StaffMenuEditSuccess) {
                await Fluttertoast.showToast(msg: "Item Modified");
                widget.onSuccess();
              }
            },
            builder: (context, state) {
              _bloc = BlocProvider.of<StaffMenuEditBloc>(context);
              return getStaffMenuEditScreen();
            },
          )),
    );
  }

  Widget getStaffMenuEditScreen() {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.item.imageUrl), fit: BoxFit.cover)),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: DMColors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(20).copyWith(bottom: 0, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: SvgPicture.asset(widget.item.isVeg
                        ? "assets/icons/veg_icon.svg"
                        : "assets/icons/non_veg_icon.svg"),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      widget.item.name.toUpperCase(),
                      style: DMTypo.bold14UnderlinedBlackTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(20).copyWith(top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Menu status : ${isEnabled ? "Added" : "Not Added"}",
                      style: DMTypo.normal14BlackTextStyle,
                    ),
                  ),
                  DMColorPillButton(
                      padding: isEnabled
                          ? EdgeInsets.symmetric(horizontal: 30)
                          : EdgeInsets.symmetric(horizontal: 40),
                      text: isEnabled ? "Remove" : "Add",
                      textStyle: DMTypo.bold12WhiteTextStyle,
                      color: isEnabled ? DMColors.red : DMColors.green,
                      onPressed: () async {
                        final bool choice = await DMAlertDialog.show(context,
                            "${isEnabled ? "Remove" : "Add"} this item ${isEnabled ? "from" : "to"} the menu ?");
                        if (choice) {
                          isEnabled = !isEnabled;
                          _bloc.add(ChangeEnabledStatus(!isEnabled, widget.item.itemId));
                        }
                      })
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(20).copyWith(top: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Availability",
                    style: DMTypo.bold18BlackTextStyle,
                  ),
                  CheckboxRowWidget(
                      hint: "Breakfast",
                      value: time.isBreakfast,
                      onClick: () {
                        final value = !time.isBreakfast;
                        time = time.copyWith(isBreakfast: value);
                        _bloc.add(AvailableTime(time, widget.item.itemId));
                      }),
                  CheckboxRowWidget(
                      hint: "Lunch",
                      value: time.isLunch,
                      onClick: () {
                        final value = !time.isLunch;
                        time = time.copyWith(isLunch: value);
                        _bloc.add(AvailableTime(time, widget.item.itemId));
                      }),
                  CheckboxRowWidget(
                      hint: "Dinner",
                      value: time.isDinner,
                      onClick: () {
                        final value = !time.isDinner;
                        time = time.copyWith(isDinner: value);
                        _bloc.add(AvailableTime(time, widget.item.itemId));
                      }),
                  Container(
                    height: 20,
                  ),
                  Text(
                    "Days",
                    style: DMTypo.bold18BlackTextStyle,
                  ),
                  CheckboxRowWidget(
                      hint: "Sunday",
                      value: days.sunday,
                      onClick: () {
                        final value = !days.sunday;
                        days = days.copyWith(sunday: value);
                        _bloc.add(AvailableDay(days, widget.item.itemId));
                      }),
                  CheckboxRowWidget(
                      hint: "Monday",
                      value: days.monday,
                      onClick: () {
                        final value = !days.monday;
                        days = days.copyWith(monday: value);
                        _bloc.add(AvailableDay(days, widget.item.itemId));
                      }),
                  CheckboxRowWidget(
                      hint: "Tuesday",
                      value: days.tuesday,
                      onClick: () {
                        final value = !days.tuesday;
                        days = days.copyWith(tuesday: value);
                        _bloc.add(AvailableDay(days, widget.item.itemId));
                      }),
                  CheckboxRowWidget(
                      hint: "Wednesday",
                      value: days.wednesday,
                      onClick: () {
                        final value = !days.wednesday;
                        days = days.copyWith(wednesday: value);
                        _bloc.add(AvailableDay(days, widget.item.itemId));
                      }),
                  CheckboxRowWidget(
                      hint: "Thursday",
                      value: days.thursday,
                      onClick: () {
                        final value = !days.thursday;
                        days = days.copyWith(thursday: value);
                        _bloc.add(AvailableDay(days, widget.item.itemId));
                      }),
                  CheckboxRowWidget(
                      hint: "Friday",
                      value: days.friday,
                      onClick: () {
                        final value = !days.friday;
                        days = days.copyWith(friday: value);
                        _bloc.add(AvailableDay(days, widget.item.itemId));
                      }),
                  CheckboxRowWidget(
                      hint: "Saturday",
                      value: days.saturday,
                      onClick: () {
                        final value = !days.saturday;
                        days = days.copyWith(saturday: value);
                        _bloc.add(AvailableDay(days, widget.item.itemId));
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
