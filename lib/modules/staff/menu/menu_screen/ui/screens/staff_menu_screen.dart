import 'dart:async';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/widgets/dm_filter_menu.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/staff/menu/menu_screen/bloc/staff_menu_screen_bloc.dart';
import 'package:DigiMess/modules/staff/menu/menu_screen/bloc/staff_menu_screen_events.dart';
import 'package:DigiMess/modules/staff/menu/menu_screen/bloc/staff_menu_screen_states.dart';
import 'package:DigiMess/modules/staff/menu/menu_screen/data/util/staff_menu_filter_type.dart';
import 'package:DigiMess/modules/staff/menu/menu_screen/ui/widgets/staff_menu_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StaffMenuScreen extends StatefulWidget {
  @override
  _StaffMenuScreenState createState() => _StaffMenuScreenState();
}

class _StaffMenuScreenState extends State<StaffMenuScreen> {
  List<MenuItem> currentList = [];
  List<MenuItem> fullList = [];
  bool _isLoading = false;
  StaffMenuBloc _bloc;
  String searchQuery = "";
  TextEditingController _searchController = TextEditingController(text: "");
  MenuFilterType currentFilter = MenuFilterType.BOTH;
  Timer searchDebounceTimer;
  int selectedFilterIndex = 2;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      dismissible: false,
      child: BlocConsumer<StaffMenuBloc, StaffMenuStates>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is StaffMenuLoading;
          });
          if (state is StaffMenuSuccess) {
            setState(() {
              fullList = state.menuItems;
              currentList = fullList;
            });
          } else if (state is StaffMenuError) {
            DMSnackBar.show(context, state.error.message);
          }
        },
        builder: (context, state) {
          _bloc = BlocProvider.of<StaffMenuBloc>(context);
          if (state is StaffMenuIdle) {
            _bloc.add(FilterMenuItems());
            return Container();
          } else if (state is StaffMenuLoading) {
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
                            controller: _searchController,
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
        if (searchQuery.trim().isEmpty) {
          _searchController.text = "";
          currentList = fullList;
        } else {
          currentList = fullList
              .where((element) => element.name
                  .trim()
                  .toLowerCase()
                  .contains(searchQuery.trim().toLowerCase()))
              .toList();
        }
      });
    });
  }

  void filterBySelected(int value) {
    selectedFilterIndex = value;
    searchQuery = "";
    _searchController.text = "";
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
            return StaffMenuCard(
              item: currentList[index],
              onSuccess: onSuccess,
            );
          },
        ),
      );
    }
  }

  void onSuccess() {
    _bloc.add(FilterMenuItems(menuFilterType: currentFilter));
  }
}
