import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class _FAQ extends Equatable {
  const _FAQ._({@required this.question, @required this.answer});

  final String question;
  final String answer;

  @override
  List<Object> get props => [this.question, this.answer];
}

class DMFaqs {
  const DMFaqs._();

  static const studentFAQs = [
    _FAQ._(question: "My payment failed, What should i do now?", answer: "It happens when your payment has not processed. Please wait a few days. If the problem continues,"),
    _FAQ._(question: "How to know the menu for the current year?", answer: "Sign in to your account. Click the navigation menu button at the top left corner. A list will be displayed. Select the option MENU from the list. The menu for the current year will be displayed."),
    _FAQ._(question: "Where do I post my complaints?", answer: "Sign in to your account. Click the navigation menu button at the top left corner. A list will be displayed. Select the option COMPLAINTS from the list. You can either select your complaint from a set of options or you can type it in the space provided. Click SUBMIT button at the bottom when you are done."),
    _FAQ._(question: "Where can I view my monthly mess payment history?", answer: "Sign in to your account. Click the menu button at the top left corner. A list will be displayed. Select the option PAYMENTS from the list. You will be redirected to a page showing all your previous transactions including that of monthly fees and caution deposit."),
    _FAQ._(question: "How to cancel my mess subscription?", answer: " Sign in to your account. Click the menu button at the top left corner. A list will be displayed. Select the option PROFILE from the list. Your profile, showing all your details will be displayed. Scroll down. Click the CLOSE ACCOUNT button provided at the bottom. An alert box asking for your confirmation will emerge. Select YES in order to confirm. Your mess subscription will be cancelled."),

  ];

  static const staffFAQs = [
    _FAQ._(question: "How to set the daily menu?", answer: "Sign in to your account. Click the navigation menu button at the top left corner. A list will be displayed. Select the option MENU from the list. The menu for the current year will be displayed. Select a food item from the menu. Choose from the options under Availability to set that food item as breakfast, lunch and dinner. Select the days in which that food item will be served. The daily menu will be set based on your choices for each food item."),
    _FAQ._(question: "What are the steps to be followed for conducting the annual mess poll?", answer: "Annual mess poll is to be conducted during December every year. Sign in to your account. Click the menu button at the top left corner. A list will be displayed. Select the option ANNUAL POLL from the list. The annual poll page will be opened. When it is time, select the RESET button at the top right corner. The number of votes for each food item will be set to 0. The students can then start voting through their accounts."),
    _FAQ._(question: "Where do I post the notices regarding the mess?", answer: "Sign in to your account. Click the menu button at the top left corner. A list will be displayed. Select the option NOTICES from the list. You will reach the page displaying all the previously issued notices. Click the ADD (+) button at the bottom right corner. A new page titled NEW NOTICE will appear. Type the new notice in the space provided and click the POST button at the bottom right corner when you are done."),
    _FAQ._(question: "My payment failed, What should i do now?", answer: "Sign in to your account. Click the menu button at the top left corner. A list will be displayed. Select the option MESS CUTS from the list. You will be redirected to a page titled LEAVES. A list of leaves registered by all the students up to that point will be displayed. Leaves taken can also be seen in the students section. There you can see leaves taken by each student individually"),
    _FAQ._(question: "My payment failed, What should i do now?", answer: "Sign in to your account. Click the menu button at the top left corner. A list will be displayed. Select the option STUDENTS from the list. A list showing the names of all the enrolled students will be displayed. Select the name of the student whose account you want to disable. A page showing that student's profile will appear. Below the profile, there will be a toggle button corresponding to ACCOUNT STATUS. Click the button. An alert box requesting your confirmation will appear. Select YES if you want to confirm. The selected student's account will be disabled."),
  ];
}
