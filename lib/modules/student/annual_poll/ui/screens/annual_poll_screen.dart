import 'package:DigiMess/common/constants/enums/vote_entry.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/common/widgets/internet_check_scaffold.dart';
import 'package:DigiMess/modules/student/annual_poll/bloc/annual_poll_bloc.dart';
import 'package:DigiMess/modules/student/annual_poll/bloc/annual_poll_events.dart';
import 'package:DigiMess/modules/student/annual_poll/bloc/annual_poll_states.dart';
import 'package:DigiMess/modules/student/annual_poll/ui/widgets/poll_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StudentAnnualPollScreen extends StatefulWidget {
  final VoidCallback onVoteCallback;

  const StudentAnnualPollScreen({Key key, this.onVoteCallback}) : super(key: key);

  @override
  _StudentAnnualPollScreenState createState() => _StudentAnnualPollScreenState();
}

class _StudentAnnualPollScreenState extends State<StudentAnnualPollScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  StudentAnnualPollBloc _bloc;
  List<MenuItem> _listOfFoodItems = [];
  TabController _tabController;
  Set<VoteEntry> listOfSelectedVotes = Set();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return InternetCheckScaffold(
        isAppBarRequired: true,
        appBarTitleText: "Poll",
        tabBar: TabBar(
          indicatorColor: DMColors.white,
          tabs: [
            Tab(text: "Breakfast"),
            Tab(text: "Lunch"),
            Tab(text: "Dinner"),
          ],
          controller: _tabController,
        ),
        body: ModalProgressHUD(
          dismissible: false,
          inAsyncCall: _isLoading,
          child: BlocConsumer<StudentAnnualPollBloc, StudentAnnualPollStates>(
            listener: (context, state) {
              setState(() {
                _isLoading = state is StudentAnnualPollLoading;
              });

              if (state is StudentAnnualPollError) {
                DMSnackBar.show(context, state.error.message);
              } else if (state is StudentAnnualPollFetchSuccess) {
                setState(() {
                  _listOfFoodItems = state.listOfItems;
                });
              } else if (state is StudentVoteSuccess) {
                widget.onVoteCallback();
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              print(state);
              _bloc = BlocProvider.of<StudentAnnualPollBloc>(context);
              if (state is StudentAnnualPollIdle) {
                _bloc.add(GetAllMenuItems());
                return Container();
              } else if (state is StudentAnnualPollLoading) {
                return Container();
              } else {
                return Column(
                  children: [
                    Expanded(
                      child: TabBarView(controller: _tabController, children: [
                        ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            itemCount: _listOfFoodItems.length,
                            itemBuilder: (context, index) {
                              final isChosen = listOfSelectedVotes.contains(VoteEntry(
                                  _listOfFoodItems[index].itemId, MenuItemTiming.BREAKFAST));
                              return PollItemCard(
                                item: _listOfFoodItems[index],
                                onClick: (id) {
                                  onItemClick(id, isChosen, MenuItemTiming.BREAKFAST);
                                },
                                isChosen: isChosen,
                              );
                            }),
                        ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            itemCount: _listOfFoodItems.length,
                            itemBuilder: (context, index) {
                              final isChosen = listOfSelectedVotes.contains(
                                  VoteEntry(_listOfFoodItems[index].itemId, MenuItemTiming.LUNCH));
                              return PollItemCard(
                                item: _listOfFoodItems[index],
                                onClick: (id) {
                                  onItemClick(id, isChosen, MenuItemTiming.LUNCH);
                                },
                                isChosen: isChosen,
                              );
                            }),
                        ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            itemCount: _listOfFoodItems.length,
                            itemBuilder: (context, index) {
                              final isChosen = listOfSelectedVotes.contains(
                                  VoteEntry(_listOfFoodItems[index].itemId, MenuItemTiming.DINNER));
                              return PollItemCard(
                                item: _listOfFoodItems[index],
                                onClick: (id) {
                                  onItemClick(id, isChosen, MenuItemTiming.DINNER);
                                },
                                isChosen: isChosen,
                              );
                            }),
                      ]),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: DMColors.white, boxShadow: [
                        BoxShadow(
                            color: DMColors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, -4))
                      ]),
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.all(20),
                          child: DMPillButton(
                            text: "Confirm vote",
                            isEnabled: listOfSelectedVotes.length == 21,
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                            onPressed: () {
                              print(listOfSelectedVotes);
                              _bloc.add(PlaceVote(listOfSelectedVotes.toList()));
                            },
                            onDisabledPressed: () async {
                              print(listOfSelectedVotes);
                              await Fluttertoast.showToast(msg: "Choose 7 items for each meal");
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }
            },
          ),
        ));
  }

  void onItemClick(String itemId, bool isChosen, MenuItemTiming menuItemTiming) {
    setState(() {
      if (isChosen) {
        listOfSelectedVotes.remove(VoteEntry(itemId, menuItemTiming));
      } else {
        final int voteCount = listOfSelectedVotes
            .where((element) => element.menuItemTiming == menuItemTiming)
            .toList()
            .length;
        if (voteCount < 7) {
          listOfSelectedVotes.add(VoteEntry(itemId, menuItemTiming));
        }
      }
    });
  }
}
