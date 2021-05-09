import 'dart:async';

import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/widgets/dm_filter_menu.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/staff/students/all_students/bloc/all_students_bloc.dart';
import 'package:DigiMess/modules/staff/students/all_students/bloc/all_students_events.dart';
import 'package:DigiMess/modules/staff/students/all_students/bloc/all_students_states.dart';
import 'package:DigiMess/modules/staff/students/all_students/data/util/student_filter_type.dart';
import 'package:DigiMess/modules/staff/students/all_students/ui/widgets/student_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AllStudentsScreen extends StatefulWidget {
  @override
  _AllStudentsScreenState createState() => _AllStudentsScreenState();
}

class _AllStudentsScreenState extends State<AllStudentsScreen> {
  List<User> currentList = [];
  List<User> fullList = [];
  bool _isLoading = false;
  AllStudentsBloc _bloc;
  String searchQuery = "";
  TextEditingController _searchController = TextEditingController(text: "");
  StudentFilterType currentFilter = StudentFilterType.BOTH;
  Timer searchDebounceTimer;
  int selectedFilterIndex = 2;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      dismissible: false,
      child: BlocConsumer<AllStudentsBloc, AllStudentsStates>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is AllStudentsLoading;
          });
          if (state is AllStudentsSuccess) {
            setState(() {
              fullList = state.listOfUsers;
              currentList = fullList;
            });
          } else if (state is AllStudentsError) {
            DMSnackBar.show(context, state.error.message);
          }
        },
        builder: (context, state) {
          _bloc = BlocProvider.of<AllStudentsBloc>(context);
          if (state is AllStudentsIdle) {
            _bloc.add(GetAllStudents());
            return Container();
          } else if (state is AllStudentsLoading) {
            return Container();
          } else {
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: DMColors.lightBlue,
              child: Column(
                children: [
                  Container(
                    height: 40,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: DMColors.blueBg,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: "Search student",
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                                hintStyle: DMTypo.bold16MutedTextStyle,
                                prefixIcon: Container(
                                    child:
                                        Icon(Icons.search, color: DMColors.primaryBlue, size: 20))),
                            maxLines: 1,
                            style: DMTypo.bold16BlackTextStyle,
                            keyboardType: TextInputType.text,
                            controller: _searchController,
                            onChanged: onSearch,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          height: 40,
                          width: 40,
                          child: DMFilterMenu(
                            icon: Icon(Icons.filter_list, color: DMColors.primaryBlue, size: 20),
                            selectedValue: selectedFilterIndex,
                            listOfValuesAndItems: [
                              MapEntry(0, "show veg only"),
                              MapEntry(1, "show non-veg only"),
                              MapEntry(2, "show all"),
                            ],
                            onChanged: filterBySelected,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: getListViewOrEmptyHint(),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void onSearch(String value) {
    searchQuery = value;
    if (searchDebounceTimer != null) {
      searchDebounceTimer.cancel();
    }
    searchDebounceTimer = Timer(Duration(milliseconds: 800), () {
      final FocusScopeNode currentScope = FocusScope.of(context);
      if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
        FocusManager.instance.primaryFocus.unfocus();
      }
      setState(() {
        if (searchQuery.trim().isEmpty) {
          _searchController.text = "";
          currentList = fullList;
        } else {
          currentList = fullList.where((element) {
            return element.name.trim().toLowerCase().contains(searchQuery.trim().toLowerCase()) ||
                element.username.trim().toLowerCase().contains(searchQuery.trim().toLowerCase()) ||
                element.email.trim().toLowerCase().contains(searchQuery.trim().toLowerCase()) ||
                element.phoneNumber
                    .toString()
                    .toLowerCase()
                    .contains(searchQuery.trim().toLowerCase());
          }).toList();
        }
      });
    });
  }

  void filterBySelected(int value) {
    selectedFilterIndex = value;
    searchQuery = "";
    _searchController.text = "";
    if (value == 0) {
      currentFilter = StudentFilterType.VEG;
    } else if (value == 1) {
      currentFilter = StudentFilterType.NONVEG;
    } else {
      currentFilter = StudentFilterType.BOTH;
    }
    _bloc.add(GetAllStudents(studentFilterType: currentFilter));
  }

  Widget getListViewOrEmptyHint() {
    if (currentList.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Text("No items for the selected search and filter found.",
            style: DMTypo.bold14MutedTextStyle, textAlign: TextAlign.center),
      );
    } else {
      return Container(
        child: ListView.builder(
          itemCount: currentList.length,
          itemBuilder: (_, int index) {
            return StudentCard(
                item: currentList[index],
                onItemClickCallback: (user) {
                  Navigator.pushNamed(context, Routes.STUDENT_DETAILS_SCREEN, arguments: user);
                });
          },
        ),
      );
    }
  }
}
