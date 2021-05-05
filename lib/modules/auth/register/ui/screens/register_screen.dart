import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/extensions/string_extensions.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/modules/auth/register/ui/widgets/date_picker_form_field.dart';
import 'package:DigiMess/modules/auth/register/ui/widgets/sign_up_text_form_field.dart';
import 'package:DigiMess/modules/student/payment_dummy/util/dummy_payment_args.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

enum Food { Veg, NonVeg }

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  Color textColor = DMColors.black;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _admissionController = TextEditingController();
  DateTime _dateOfBirth;
  DateTime _yearOfAdmission;
  DateTime _yearOfCompletion;
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _confirmPassController = TextEditingController();
  bool isVeg;
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 50),
                  child: Text('SIGN UP', style: DMTypo.bold24BlackTextStyle)),
              Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    SignUpTextFormField(controller: _nameController, labelText: 'Name'),
                    SignUpTextFormField(
                      controller: _admissionController,
                      labelText: 'Admission Number',
                      keyboardType: TextInputType.number,
                      maxLength: 8,
                      validator: (value) {
                        if (value.isEmpty || value.length != 8)
                          return 'Enter a valid admission number';
                        else
                          return null;
                      },
                    ),
                    DatePickerFormField(
                        labelText: 'Date of Birth',
                        hint: "Choose date",
                        showError: showError,
                        validator: (date) {
                          if (date != null &&
                              date.difference(DateTime.now()).inDays.abs() > 365 * 17) {
                            return null;
                          } else {
                            return "Must be 17 or older to enter";
                          }
                        },
                        onChanged: (date) {
                          setState(() {
                            _dateOfBirth = date;
                          });
                        },
                        initialDateTime: _dateOfBirth),
                    DatePickerFormField(
                        labelText: 'Date of Admission',
                        hint: "Choose date",
                        showError: showError,
                        validator: (date) {
                          if (date != null && date.isBefore(DateTime.now())) {
                            return null;
                          } else {
                            return "Please register after admission";
                          }
                        },
                        onChanged: (date) {
                          setState(() {
                            _yearOfAdmission = date;
                          });
                        },
                        initialDateTime: _yearOfAdmission),
                    DatePickerFormField(
                        labelText: 'Date of Completion',
                        hint: "Choose date",
                        showError: showError,
                        validator: (date) {
                          if (date != null && date.isAfter(DateTime.now())) {
                            return null;
                          } else {
                            return "Can't register after passing out";
                          }
                        },
                        onChanged: (date) {
                          setState(() {
                            _yearOfCompletion = date;
                          });
                        },
                        initialDateTime: _yearOfCompletion),
                    SignUpTextFormField(
                      controller: _phoneNumberController,
                      labelText: 'Mobile Number',
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      validator: (value) {
                        if (!value.isPhoneNumber())
                          return 'Enter a valid mobile number';
                        else
                          return null;
                      },
                    ),
                    SignUpTextFormField(
                      controller: _emailController,
                      labelText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (String value) {
                        if (!value.isEmail())
                          return 'Enter a valid email address';
                        else
                          return null;
                      },
                    ),
                    SignUpTextFormField(
                        controller: _passController,
                        labelText: 'Password',
                        validator: (value) {
                          if (value.length < 8) {
                            return "Password must be atleast 8 characters long";
                          } else {
                            return null;
                          }
                        },
                        obscureText: true),
                    SignUpTextFormField(
                      controller: _confirmPassController,
                      labelText: 'Confirm Password',
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Please re-enter new password";
                        } else if (value != _passController.text) {
                          return "Password must be same as above";
                        } else {
                          return null;
                        }
                      },
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40).copyWith(top: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Choice',
                            style: DMTypo.bold16BlackTextStyle,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  FocusScope.of(context).unfocus();
                                  isVeg = true;
                                });
                              },
                              child: Row(
                                children: [
                                  isVeg == true
                                      ? Icon(Icons.circle, color: DMColors.primaryBlue)
                                      : Icon(Icons.panorama_fish_eye, color: DMColors.grey),
                                  Container(
                                      margin: EdgeInsets.symmetric(horizontal: 5),
                                      child: Text('Veg',
                                          style: isVeg == true
                                              ? DMTypo.bold16PrimaryBlueTextStyle
                                              : DMTypo.bold16MutedTextStyle))
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  FocusScope.of(context).unfocus();
                                  isVeg = false;
                                });
                              },
                              child: Row(
                                children: [
                                  isVeg == false
                                      ? Icon(Icons.circle, color: DMColors.primaryBlue)
                                      : Icon(Icons.panorama_fish_eye, color: DMColors.grey),
                                  Container(
                                      margin: EdgeInsets.symmetric(horizontal: 5),
                                      child: Text('Non Veg',
                                          style: isVeg == false
                                              ? DMTypo.bold16PrimaryBlueTextStyle
                                              : DMTypo.bold16MutedTextStyle))
                                ],
                              ),
                            ),
                          ),
                          (isVeg == null && showError)
                              ? Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text("Choose a food category",
                                      style: DMTypo.bold14RedTextStyle))
                              : Container()
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 60,
                      margin: const EdgeInsets.all(20).copyWith(top: 40),
                      child: Hero(
                        tag: 'signUp-Staff',
                        child: DMPillButton(
                          text: "Sign up",
                          onPressed: () async {
                            setState(() {
                              showError = true;
                            });
                            if (_formKey.currentState.validate() &&
                                _dateOfBirth != null &&
                                _yearOfCompletion != null &&
                                _yearOfAdmission != null) {
                              Navigator.pushNamed(context, Routes.DUMMY_PAYMENT_SCREEN,
                                  arguments: DummyPaymentArguments("Caution deposit", 3000, () async {
                                    await SharedPrefRepository.setUserType(UserType.STUDENT);
                                    await SharedPrefRepository.setUsername("20418076");
                                    await SharedPrefRepository.setTheUserId("QXe986cVzOQUgQgC2ETo");
                                    Navigator.of(context).pushNamedAndRemoveUntil(
                                        Routes.MAIN_SCREEN_STUDENT, (route) => false);
                                  }));
                            }
                          },
                        ),
                      ),
                    ),
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
