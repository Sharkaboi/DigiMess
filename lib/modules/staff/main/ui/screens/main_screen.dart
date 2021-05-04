import 'package:DigiMess/common/bloc/dm_bloc.dart';
import 'package:DigiMess/common/bloc/dm_events.dart';
import 'package:DigiMess/common/widgets/dm_scaffold.dart';
import 'package:DigiMess/modules/staff/main/ui/widgets/staff_nav_drawer.dart';
import 'package:DigiMess/modules/staff/main/util/staff_nav_destinations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffMainScreen extends StatefulWidget {
  @override
  _StaffMainScreenState createState() => _StaffMainScreenState();
}

class _StaffMainScreenState extends State<StaffMainScreen> {
  StaffNavDestinations currentScreen = StaffNavDestinations.HOME;

  @override
  Widget build(BuildContext context) {
    return DMScaffold(
      isAppBarRequired: true,
      appBarTitleText: getTitleFromCurrentScreen(),
      body: getCurrentScreen(),
      floatingActionButton: getFab(),
      drawer: StaffNavDrawer(
        currentScreen: currentScreen,
        itemOnClickCallBack: itemOnClick,
      ),
    );
  }

  Widget getCurrentScreen() {
    if (currentScreen == StaffNavDestinations.HOME) {
      return Container();
    } else if (currentScreen == StaffNavDestinations.STUDENTS) {
      return Container();
    } else if (currentScreen == StaffNavDestinations.MENU) {
      return Container();
    } else if (currentScreen == StaffNavDestinations.NOTICES) {
      return Container();
    } else if (currentScreen == StaffNavDestinations.LEAVES) {
      return Container();
    } else if (currentScreen == StaffNavDestinations.POLL) {
      return Container();
    } else if (currentScreen == StaffNavDestinations.COMPLAINTS) {
      return Container();
    } else if (currentScreen == StaffNavDestinations.HELP) {
      return Container();
    } else if (currentScreen == StaffNavDestinations.ABOUT) {
      return Container();
    } else {
      return Container();
    }
  }

  itemOnClick(StaffNavDestinations destination) {
    Navigator.pop(context);
    if (destination == StaffNavDestinations.LOGOUT) {
      showLogOutAlertDialog();
    } else {
      setState(() {
        currentScreen = destination;
      });
    }
  }

  String getTitleFromCurrentScreen() {
    return currentScreen.toStringValue();
  }

  void showLogOutAlertDialog() {
    BlocProvider.of<DMBloc>(context).add(LogOutUser());
  }

  FloatingActionButton getFab() {
    return null;
  }
}
