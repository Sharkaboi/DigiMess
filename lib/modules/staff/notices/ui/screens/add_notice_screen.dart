import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_dialogs.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/common/widgets/internet_check_scaffold.dart';
import 'package:DigiMess/modules/staff/notices/bloc/notices_bloc.dart';
import 'package:DigiMess/modules/staff/notices/bloc/notices_events.dart';
import 'package:DigiMess/modules/staff/notices/bloc/notices_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StaffAddNoticeScreen extends StatefulWidget {
  final VoidCallback callback;

  const StaffAddNoticeScreen({Key key, this.callback}) : super(key: key);

  @override
  _StaffAddNoticeScreenState createState() => _StaffAddNoticeScreenState();
}

class _StaffAddNoticeScreenState extends State<StaffAddNoticeScreen> {
  bool _isLoading = false;
  TextEditingController _controller = TextEditingController();
  StaffNoticesBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return InternetCheckScaffold(
        appBarTitleText: "New notice",
        isAppBarRequired: true,
        body: ModalProgressHUD(
          dismissible: false,
          inAsyncCall: _isLoading,
          child: BlocConsumer<StaffNoticesBloc, StaffNoticesStates>(listener: (context, state) {
            setState(() {
              _isLoading = state is NoticesLoading;
            });
            if (state is NoticesError) {
              DMSnackBar.show(context, state.error.message);
            } else if (state is PlaceNoticesSuccess) {
              DMSnackBar.show(context, "Notice placed");
              widget.callback();
              Navigator.pop(context);
            }
          }, builder: (context, state) {
            _bloc = BlocProvider.of<StaffNoticesBloc>(context);
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    child: Text(
                      "Add new notice",
                      style: DMTypo.bold16BlackTextStyle,
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
                              borderSide: BorderSide(width: 1, color: DMColors.primaryBlue)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(width: 1, color: DMColors.primaryBlue)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(width: 1, color: DMColors.primaryBlue)),
                          isDense: true,
                          counterText: "",
                          fillColor: DMColors.white,
                          hintText: "Type here...",
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
                            text: "Post",
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                            textStyle: DMTypo.bold18WhiteTextStyle,
                            onPressed: () async {
                              final String notice = _controller.text;
                              if (notice.trim().isEmpty) {
                                DMSnackBar.show(context, "Enter your notice");
                              } else {
                                final choice = await DMAlertDialog.show(
                                    context, "Do you want to post this notice?");
                                if (choice) {
                                  _bloc.add(PlaceNotice(notice));
                                }
                              }
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ));
  }
}
