import 'dart:convert';
import 'package:intl/intl.dart';

List<Section> sectionFromJson(String str) =>
    List<Section>.from(json.decode(str).map((x) => Section.fromJson(x)));


class Section {
  final List<dynamic> days;
  final DateTime endTime;
  final String id;
  final DateTime startTime;

  Section({
    required this.days,
    required this.endTime,
    required this.id,
    required this.startTime,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    DateFormat format = DateFormat('HH:mm:ss');
    return Section(
      days: json['days'].map((item) => item.toString()).toList(),
      endTime: format.parse(json['end_time'] as String),
      id: json['id'] as String,
      startTime: format.parse(json['start_time'] as String),
    );
  }
}