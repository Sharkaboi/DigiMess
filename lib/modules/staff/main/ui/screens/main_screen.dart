import 'package:DigiMess/common/bloc/dm_bloc.dart';
import 'package:DigiMess/common/bloc/dm_events.dart';
import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/widgets/dm_dialogs.dart';
import 'package:DigiMess/common/widgets/dm_scaffold.dart';
import 'package:DigiMess/modules/staff/complaints/bloc/complaints_bloc.dart';
import 'package:DigiMess/modules/staff/complaints/bloc/complaints_states.dart';
import 'package:DigiMess/modules/staff/complaints/data/complaints_repository.dart';
import 'package:DigiMess/modules/staff/complaints/ui/screens/complaints_screen.dart';
import 'package:DigiMess/modules/staff/home/bloc/home_bloc.dart';
import 'package:DigiMess/modules/staff/home/bloc/home_states.dart';
import 'package:DigiMess/modules/staff/home/data/home_repository.dart';
import 'package:DigiMess/modules/staff/home/ui/screens/home_screen.dart';
import 'package:DigiMess/modules/staff/leaves/bloc/leaves_bloc.dart';
import 'package:DigiMess/modules/staff/leaves/bloc/leaves_states.dart';
import 'package:DigiMess/modules/staff/leaves/data/leaves_repository.dart';
import 'package:DigiMess/modules/staff/leaves/ui/screens/leaves_screen.dart';
import 'package:DigiMess/modules/staff/main/ui/widgets/staff_nav_drawer.dart';
import 'package:DigiMess/modules/staff/main/util/staff_nav_destinations.dart';
import 'package:DigiMess/modules/staff/students/all_students/bloc/all_students_bloc.dart';
import 'package:DigiMess/modules/staff/students/all_students/bloc/all_students_states.dart';
import 'package:DigiMess/modules/staff/students/all_students/data/all_students_repository.dart';
import 'package:DigiMess/modules/staff/students/all_students/ui/screens/students_screen.dart';
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
      return BlocProvider(
          create: (_) => StaffHomeBloc(
              StaffHomeIdle(),
              StaffHomeRepository(
                  FirebaseClient.getMenuCollectionReference(),
                  FirebaseClient.getNoticesCollectionReference(),
                  FirebaseClient.getAbsenteesCollectionReference(),
                  FirebaseClient.getUsersCollectionReference())),
          child: StaffHomeScreen(
            noticesCallback: noticesCallback,
          ));
    } else if (currentScreen == StaffNavDestinations.STUDENTS) {
      return BlocProvider(
          create: (_) => AllStudentsBloc(AllStudentsIdle(),
              AllStudentsRepository(FirebaseClient.getUsersCollectionReference())),
          child: AllStudentsScreen());
    } else if (currentScreen == StaffNavDestinations.MENU) {
      return Container();
    } else if (currentScreen == StaffNavDestinations.NOTICES) {
      return Container();
    } else if (currentScreen == StaffNavDestinations.LEAVES) {
      return BlocProvider(
          create: (_) => StaffLeavesBloc(StaffLeavesIdle(),
              StaffLeavesRepository(FirebaseClient.getAbsenteesCollectionReference())),
          child: StaffLeavesHistoryScreen());
    } else if (currentScreen == StaffNavDestinations.POLL) {
      return Container();
    } else if (currentScreen == StaffNavDestinations.COMPLAINTS) {
      return BlocProvider(
          create: (_) => StaffComplaintsBloc(ComplaintsIdle(),
              ComplaintsRepository(FirebaseClient.getComplaintsCollectionReference())),
          child: StaffComplaintsScreen());
    } else if (currentScreen == StaffNavDestinations.HELP) {
      return Container();
    } else if (currentScreen == StaffNavDestinations.ABOUT) {
      return Container();
    } else {
      return Container();
    }
  }

  void noticesCallback() {
    setState(() {
      currentScreen = StaffNavDestinations.NOTICES;
    });
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

  void showLogOutAlertDialog() async {
    final bool choice = await DMAlertDialog.show(context, "Logout of Digimess?");
    if (choice) {
      BlocProvider.of<DMBloc>(context).add(LogOutUser());
    }
  }

  FloatingActionButton getFab() {
    return null;
  }
}
