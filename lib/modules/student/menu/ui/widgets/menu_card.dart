import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final MenuItem item;

  const MenuCard({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: Colors.red,
      height: 100,
    );
  }
}
