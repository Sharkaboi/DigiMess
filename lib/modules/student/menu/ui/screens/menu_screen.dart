import 'dart:async';

import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:DigiMess/common/styles/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_filter_menu.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/student/menu/bloc/menu_bloc.dart';
import 'package:DigiMess/modules/student/menu/bloc/menu_events.dart';
import 'package:DigiMess/modules/student/menu/bloc/menu_states.dart';
import 'package:DigiMess/modules/student/menu/data/util/menu_filter_type.dart';
import 'package:DigiMess/modules/student/menu/ui/widgets/menu_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StudentMenuScreen extends StatefulWidget {
  @override
  _StudentMenuScreenState createState() => _StudentMenuScreenState();
}

class _StudentMenuScreenState extends State<StudentMenuScreen> {
  List<MenuItem> currentList = [];
  List<MenuItem> fullList = [];
  bool _isLoading = false;
  StudentMenuBloc _bloc;
  String searchQuery = "";
  MenuFilterType currentFilter = MenuFilterType.BOTH;
  Timer searchDebounceTimer;
  int selectedFilterIndex = 2;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      dismissible: false,
      child: BlocConsumer<StudentMenuBloc, StudentMenuStates>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is StudentMenuLoading;
          });
          if (state is StudentMenuSuccess) {
            setState(() {
              fullList = state.menuItems;
              currentList = fullList;
            });
          } else if (state is StudentMenuError) {
            DMSnackBar.show(context, state.error.message);
          }
        },
        builder: (context, state) {
          _bloc = BlocProvider.of<StudentMenuBloc>(context);
          if (state is StudentMenuIdle) {
            _bloc.add(FilterMenuItems());
            return Container();
          } else if (state is StudentMenuLoading) {
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
                                hintText: "Search food item",
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                                hintStyle: DMTypo.bold16MutedTextStyle,
                                prefixIcon: Container(
                                    child: Icon(Icons.search,
                                        color: DMColors.primaryBlue,
                                        size: 20))),
                            maxLines: 1,
                            style: DMTypo.bold16BlackTextStyle,
                            keyboardType: TextInputType.text,
                            initialValue: searchQuery,
                            onChanged: onSearch,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          height: 40,
                          width: 40,
                          child: DMFilterMenu(
                            icon: Icon(Icons.filter_list,
                                color: DMColors.primaryBlue, size: 20),
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
    searchDebounceTimer = Timer(Duration(milliseconds: 500), () {
      final FocusScopeNode currentScope = FocusScope.of(context);
      if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
        FocusManager.instance.primaryFocus.unfocus();
      }
      setState(() {
        if (searchQuery.isEmpty) {
          currentList = fullList;
        } else {
          currentList = fullList
              .where((element) => element.name
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
              .toList();
        }
      });
    });
  }

  void filterBySelected(int value) {
    selectedFilterIndex = value;
    searchQuery = "";
    if (value == 0) {
      currentFilter = MenuFilterType.VEG;
    } else if (value == 1) {
      currentFilter = MenuFilterType.NONVEG;
    } else {
      currentFilter = MenuFilterType.BOTH;
    }
    _bloc.add(FilterMenuItems(menuFilterType: currentFilter));
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
            return MenuCard(item: currentList[index]);
          },
        ),
      );
    }
  }
}
