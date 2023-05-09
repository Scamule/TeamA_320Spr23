import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:uscheduler/models/section.dart';

List<Schedule> scheduleFromJson(String str) =>
    List<Schedule>.from(json.decode(str).map((x) => Schedule.fromJson(x)));

class Schedule {
  final List<Section> sections;

  Schedule({required this.sections});

  factory Schedule.fromJson(List<dynamic> json) {
    return Schedule(
      sections: sectionFromJson(jsonEncode(json)),
    );
  }
}
