import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:uscheduler/models/section.dart';

//converts a string in JSON format containing the schedules into an object that can be used in Dart
List<Schedule> scheduleFromJson(String str) =>
    List<Schedule>.from(json.decode(str).map((x) => Schedule.fromJson(x)));

//creates the Schedule class, which contains a list of sections and a function to convert a string in JSON format into a schedule
class Schedule {
  final List<Section> sections;

  Schedule({required this.sections});

  factory Schedule.fromJson(List<dynamic> json) {
    return Schedule(
      sections: sectionFromJson(jsonEncode(json)),
    );
  }
}
