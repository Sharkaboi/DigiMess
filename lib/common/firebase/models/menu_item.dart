import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MenuItem extends Equatable {
  final String itemId;
  final bool isVeg;
  final String name;
  final bool isEnabled;
  final String imageUrl;
  final _MenuItemIsAvailable itemIsAvailable;
  final _DaysAvailable daysAvailable;
  final _AnnualPollVotes annualPollVotes;

  MenuItem(
      {@required this.itemId,
      @required this.name,
      @required this.isVeg,
      @required this.isEnabled,
      @required this.imageUrl,
      @required this.itemIsAvailable,
      @required this.annualPollVotes,
      @required this.daysAvailable});

  @override
  List<Object> get props => [
        this.itemId,
        this.name,
        this.isVeg,
        this.isEnabled,
        this.imageUrl,
        this.itemIsAvailable,
        this.annualPollVotes,
        this.daysAvailable
      ];

  factory MenuItem.fromQueryDocumentSnapshot(QueryDocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data();
    return MenuItem(
        itemId: doc.id,
        name: data['name'],
        isVeg: data['isVeg'],
        isEnabled: data['isEnabled'],
        imageUrl: data['imageUrl'],
        itemIsAvailable: _MenuItemIsAvailable.fromMap(data['isAvailable']),
        annualPollVotes: _AnnualPollVotes.fromMap(data['annualPoll']),
        daysAvailable: _DaysAvailable.fromMap(data['daysAvailable']));
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'isVeg': this.isVeg,
      'isEnabled': this.isEnabled,
      'imageUrl': this.imageUrl,
      'isAvailable': this.itemIsAvailable.toMap(),
      'annualPoll': this.annualPollVotes.toMap(),
      'daysAvailable': this.daysAvailable.toMap(),
    };
  }
}

class _MenuItemIsAvailable extends Equatable {
  final bool isBreakfast;
  final bool isLunch;
  final bool isDinner;

  _MenuItemIsAvailable(
      {@required this.isBreakfast,
      @required this.isLunch,
      @required this.isDinner});

  factory _MenuItemIsAvailable.fromMap(Map<String, dynamic> mapField) {
    return _MenuItemIsAvailable(
        isBreakfast: mapField['breakfast'],
        isDinner: mapField['dinner'],
        isLunch: mapField['lunch']);
  }

  Map<String, dynamic> toMap() {
    return {
      'breakfast': this.isBreakfast,
      'dinner': this.isDinner,
      'lunch': this.isLunch
    };
  }

  @override
  List<Object> get props => [this.isBreakfast, this.isLunch, this.isDinner];
}

class _DaysAvailable extends Equatable {
  final bool monday;
  final bool tuesday;
  final bool wednesday;
  final bool thursday;
  final bool friday;
  final bool saturday;
  final bool sunday;

  _DaysAvailable({
    @required this.monday,
    @required this.tuesday,
    @required this.wednesday,
    @required this.thursday,
    @required this.friday,
    @required this.saturday,
    @required this.sunday,
  });

  factory _DaysAvailable.fromMap(Map<String, dynamic> mapField) {
    return _DaysAvailable(
        monday: mapField['monday'],
        tuesday: mapField['tuesday'],
        wednesday: mapField['wednesday'],
        thursday: mapField['thursday'],
        friday: mapField['friday'],
        saturday: mapField['saturday'],
        sunday: mapField['sunday']);
  }

  Map<String, dynamic> toMap() {
    return {
      'monday': this.monday,
      'tuesday': this.tuesday,
      'wednesday': this.wednesday,
      'thursday': this.thursday,
      'friday': this.friday,
      'saturday': this.saturday,
      'sunday': this.sunday,
    };
  }

  @override
  List<Object> get props => [
        this.monday,
        this.tuesday,
        this.wednesday,
        this.thursday,
        this.friday,
        this.saturday,
        this.sunday
      ];
}

class _AnnualPollVotes extends Equatable {
  final int forBreakFast;
  final int forLunch;
  final int forDinner;

  _AnnualPollVotes(
      {@required this.forBreakFast,
      @required this.forLunch,
      @required this.forDinner});

  factory _AnnualPollVotes.fromMap(Map<String, dynamic> mapField) {
    return _AnnualPollVotes(
        forBreakFast: mapField['forBreakFast'],
        forLunch: mapField['forLunch'],
        forDinner: mapField['forDinner']);
  }

  Map<String, dynamic> toMap() {
    return {
      'forBreakFast': this.forBreakFast,
      'forLunch': this.forLunch,
      'forDinner': this.forDinner
    };
  }

  @override
  List<Object> get props => [this.forDinner, this.forLunch, this.forBreakFast];
}
