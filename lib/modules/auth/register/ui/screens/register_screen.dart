import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:DigiMess/common/styles/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_scaffold.dart';
import 'package:DigiMess/common/widgets/dm_datepicker.dart';
import 'package:DigiMess/common/widgets/dm_textformfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

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
  TextEditingController _dateOfBirthController = TextEditingController();
  TextEditingController _yearOfAdmissionController = TextEditingController();
  TextEditingController _yearOfCompletionController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _confirmPassController = TextEditingController();

  bool _obscureText = true;

  var _foodType = Food.Veg;

  // Toggles the password show status
  void _togglePasswordStatus() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }


  @override
  Widget build(BuildContext context) {
    return DMScaffold(
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                    child: Text('Sign Up', style: DMTypo.bold24BlackTextStyle)),
                Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(children: <Widget>[
                      // Name
                      DMTextFormField(controller: _nameController, labelText: 'Name'),

                      // Admission Name
                      DMTextFormField(
                        controller: _admissionController,
                        labelText: 'Admission Number',
                        validator: (value) {
                          Pattern mobileNoPattern =r'(^(?:[+0]9)?[0-9]{8}$)';
                          RegExp regex = new RegExp(mobileNoPattern);
                          if (!regex.hasMatch(value) || value == null)
                            return 'Enter a valid admission number';
                          else
                            return null;
                        },
                      ),

                      // Date of birth
                      DMDatePicker(labelText: 'Date of Birth',datecontroller: _dateOfBirthController),

                      // Year of admission
                      DMDatePicker(labelText: 'Year of Admission', datecontroller: _yearOfAdmissionController),

                      // Year of completion
                      DMDatePicker(labelText: 'Year of Completion', datecontroller: _yearOfCompletionController),

                      // mobile number
                      DMTextFormField(
                        controller: _phoneNumberController,
                        labelText: 'Mobile Number',
                        validator: (value) {
                          Pattern mobileNoPattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                          RegExp regex = new RegExp(mobileNoPattern);
                          if (!regex.hasMatch(value) || value == null)
                            return 'Enter a valid mobile number';
                          else
                            return null;
                        },
                      ),

                      // Email field
                      DMTextFormField(
                        controller: _emailController,
                        labelText: 'Email',
                        validator: (String value) {
                          Pattern pattern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regex = new RegExp(pattern);
                          if (!regex.hasMatch(value) || value == null)
                            return 'Enter a valid email address';
                          else
                            return null;
                        },
                      ),

                      // Password
                      DMTextFormField(
                        controller: _passController,
                        labelText: 'Password',
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter New Password";
                          } else if (value.length < 8) {
                            return "Password must be atleast 8 characters long";
                          } else if (value == "12345678" || value == "87654321") {
                            return "Please choose a strong password";
                          } else {
                            return null;
                          }
                        },
                        obscureText: true,
                      ),

                      //Confirm Password
                      DMTextFormField(
                        controller: _confirmPassController,
                        labelText: 'Confirm Password',
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Please Re-Enter New Password";
                          } else if (value != _passController.text) {
                            return "Password must be same as above";
                          } else {
                            return null;
                          }
                        },
                        obscureText: true,
                      ),

                      // Choice veg/non-veg
                      Container(
                        // padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment(-1.0, 0.0),
                              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                              child: Text(
                                'Choice',
                                style: DMTypo.bold16BlackTextStyle,
                              ),
                            ),
                            RadioListTile<Food>(
                              title: const Text('Veg'),
                              value: Food.Veg,
                              groupValue: _foodType,
                              onChanged: (value) {
                                setState(() {
                                  _foodType = value;
                                });
                              },
                            ),
                            RadioListTile<Food>(
                              title: const Text('Non-Veg'),
                              value: Food.NonVeg,
                              groupValue: _foodType,
                              onChanged: (value) {
                                setState(() {
                                  _foodType = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      // sign-up
                      Container(
                        width: 200,
                        height: 60,
                        padding: const EdgeInsets.all(5.0),
                        margin: const EdgeInsets.all(20.0),
                        child: Hero(
                          tag: 'signUp-Staff',
                          child: DarkButton(
                            text: "Sign up",
                            onPressed: () {},
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
      ),
    );
  }
}
