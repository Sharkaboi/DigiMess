// import 'dart:js';
// import 'package:DigiMess/common/design/dm_colors.dart';
// import 'package:DigiMess/common/design/dm_typography.dart';
// import 'package:DigiMess/common/firebase/models/menu_item.dart';
// import 'package:DigiMess/common/widgets/internet_check_scaffold.dart';
// import 'package:DigiMess/modules/staff/menu/ui/util/meal_timing.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import 'package:modal_progress_hud/modal_progress_hud.dart';
//
// class StaffMenuEdit extends StatefulWidget {
//   const StaffMenuEdit({Key key}) : super(key: key);
//
//   @override
//   _StaffMenuEditState createState() => _StaffMenuEditState();
// }
//
// class _StaffMenuEditState extends State<StaffMenuEdit> {
//   bool _isLoading = false;
//   List<MenuItem> listOfItems = [];
//   MealTiming currentSelectedTab = MealTiming.BREAKFAST;
//   @override
//   Widget build(BuildContext context) {
//     return InternetCheckScaffold(
//         isAppBarRequired: false,
//         body: ModalProgressHUD(
//           inAsyncCall: _isLoading,
//           dismissible: false,
//           //Bloc code here
//         ),
//     );
//
//
//   }
//
//   Widget getStaffMenuEditScreen(){
//     return Container(
//       margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
//       child: Column(
//         children: [
//           Stack(
//             children: [
//               Container(
//                 height: MediaQuery.of(context).size.height * 0.25,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     image: DecorationImage(
//                         image: NetworkImage("https://i.ytimg.com/vi/DDEU6LiR3mQ/hqdefault.jpg"), fit: BoxFit.cover)),
//               ),
//               Container(
//                 child: Align(
//                   alignment: Alignment.bottomRight,
//                   child: Icon(Icons.arrow_back_ios,
//                     color: DMColors.white,
//                     size: 20,),
//                 ),
//               ),
//             ],
//           ),
//           Container(
//             child: Row(
//               children: [
//                 Icon(Icons.backpack,
//                   size: 5,),
//                 Container(width: 10,),
//                 Text("Beef Biriyani",style: DMTypo.bold16BlackTextStyle,),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget getMealTimingTabs() {
//     return Container(
//         margin: EdgeInsets.only(top: 20),
//         child: Row(
//             children: List.generate(MealTiming.values.length, (index) {
//               final currentTiming = MealTiming.values[index];
//               final isCurrent = currentSelectedTab == currentTiming;
//               return Expanded(
//                   child: InkWell(
//                     onTap: () => _setSelectedTab(currentTiming),
//                     child: Container(
//                         child: Column(
//                           children: [
//                             Container(
//                               margin: EdgeInsets.all(5),
//                               child: Text(currentTiming.toStringValue().capitalizeFirst(),
//                                   style:
//                                   isCurrent ? DMTypo.bold14BlackTextStyle : DMTypo.normal14BlackTextStyle),
//                             ),
//                             Divider(
//                                 color: isCurrent ? DMColors.primaryBlue : Colors.transparent,
//                                 thickness: 2,
//                                 indent: 20,
//                                 endIndent: 20)
//                           ],
//                         )),
//                   ));
//             })));
//   }
//
//   void _onSwipe(DragEndDetails details) {
//     if (details.primaryVelocity > 0) {
//       // Right Swipe (+x axis movement)
//       if (currentSelectedTab == MealTiming.DINNER) {
//         setState(() {
//           currentSelectedTab = MealTiming.LUNCH;
//         });
//       } else if (currentSelectedTab == MealTiming.LUNCH) {
//         setState(() {
//           currentSelectedTab = MealTiming.BREAKFAST;
//         });
//       }
//     } else if (details.primaryVelocity < 0) {
//       //Left Swipe (-x axis movement)
//       if (currentSelectedTab == MealTiming.BREAKFAST) {
//         setState(() {
//           currentSelectedTab = MealTiming.LUNCH;
//         });
//       } else if (currentSelectedTab == MealTiming.LUNCH) {
//         setState(() {
//           currentSelectedTab = MealTiming.DINNER;
//         });
//       }
//     }
//   }
//
//
// }
//
//
