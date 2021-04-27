import 'package:DigiMess/common/constants/enums/complaint_category.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/student/complaints/bloc/complaints_bloc.dart';
import 'package:DigiMess/modules/student/complaints/bloc/complaints_events.dart';
import 'package:DigiMess/modules/student/complaints/bloc/complaints_states.dart';
import 'package:DigiMess/modules/student/complaints/ui/widgets/filter_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StudentComplaintsScreen extends StatefulWidget {
  @override
  _StudentComplaintsScreenState createState() =>
      _StudentComplaintsScreenState();
}

class _StudentComplaintsScreenState extends State<StudentComplaintsScreen> {
  TextEditingController _controller = TextEditingController();
  Set<String> selectedCategories = Set<String>();
  bool _isLoading = false;
  StudentComplaintsBloc _bloc;

  @override
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      dismissible: false,
      inAsyncCall: _isLoading,
      child: BlocConsumer<StudentComplaintsBloc, StudentComplaintsStates>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is StudentComplaintsLoading;
          });
          if (state is StudentComplaintsError) {
            DMSnackBar.show(context, state.error.message);
          } else if (state is StudentComplaintsSuccess) {
            DMSnackBar.show(context, "Complaint Placed");
            selectedCategories.clear();
            _controller.text = "";
          }
        },
        builder: (context, state) {
          _bloc = BlocProvider.of<StudentComplaintsBloc>(context);
          if (state is StudentComplaintsLoading) {
            return Container();
          } else {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 10),
                    child: Center(
                      child: Text(
                        "Frequent Complaints",
                        style: DMTypo.bold16BlackTextStyle,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Divider(
                      thickness: 1,
                      color: DMColors.primaryBlue,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(ComplaintCategory.values.length,
                          (index) {
                        return FilterChips(
                          chipName: ComplaintCategoryExtensions
                              .ComplaintCategoryHints[index],
                          isSelected: selectedCategories.contains(
                              ComplaintCategory.values[index].toStringValue()),
                          onTap: () {
                            setState(() {
                              final String category = ComplaintCategory
                                  .values[index]
                                  .toStringValue();
                              if (selectedCategories.contains(category)) {
                                selectedCategories.remove(category);
                              } else {
                                selectedCategories.add(category);
                              }
                            });
                          },
                        );
                      }),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      maxLines: 8,
                      controller: _controller,
                      maxLength: 350,
                      decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  width: 1, color: DMColors.primaryBlue)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  width: 1, color: DMColors.primaryBlue)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  width: 1, color: DMColors.primaryBlue)),
                          isDense: true,
                          counterText: "",
                          fillColor: DMColors.white,
                          hintText: "Type your complaint here...",
                          hintStyle: DMTypo.bold16MutedTextStyle),
                      style: DMTypo.bold18BlackTextStyle,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: Container()),
                        DMPillButton(
                            text: "Submit",
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            textStyle: DMTypo.bold18WhiteTextStyle,
                            onPressed: () {
                              final String complaint = _controller.text;
                              if (complaint.trim().isEmpty) {
                                DMSnackBar.show(
                                    context, "Enter your complaint");
                              } else if (selectedCategories.isEmpty) {
                                DMSnackBar.show(
                                    context, "Choose at least one category");
                              } else {
                                _bloc.add(PlaceComplaint(
                                    selectedCategories.toList(), complaint));
                              }
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
