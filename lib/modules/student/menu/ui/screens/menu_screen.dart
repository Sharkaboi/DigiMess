import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:DigiMess/common/styles/dm_typography.dart';
import 'package:DigiMess/modules/student/menu/ui/widgets/menu_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StudentMenuScreen extends StatefulWidget {
  @override
  _StudentMenuScreenState createState() => _StudentMenuScreenState();
}

class _StudentMenuScreenState extends State<StudentMenuScreen> {
  final List<MenuItem> currentList = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: DMColors.lightBlue,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 30,
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
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
                                color: DMColors.primaryBlue, size: 20))),
                    maxLines: 1,
                    style: DMTypo.bold16BlackTextStyle,
                    keyboardType: TextInputType.text,
                    onChanged: onSearch,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  height: 30,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: DMColors.white),
                  child: PopupMenuButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.filter_list,
                        color: DMColors.primaryBlue, size: 20),
                    initialValue: 2,
                    offset: Offset(0, 140),
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 0,
                        child: Text("show veg only"),
                      ),
                      PopupMenuItem(value: 1, child: Text("show non-veg only")),
                      PopupMenuItem(value: 2, child: Text("show all"))
                    ],
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

  void onSearch(String value) {}

  void onFilterPress() {}

  Widget getListViewOrEmptyHint() {
    if (currentList.isEmpty) {
      return Container(
        child: Center(
          child: Text("No items for the selected search and filter found.",
              style: DMTypo.bold14MutedTextStyle),
        ),
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
