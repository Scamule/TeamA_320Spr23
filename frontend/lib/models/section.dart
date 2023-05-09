import 'dart:convert';
import 'package:intl/intl.dart';

List<Section> sectionFromJson(String str) =>
    List<Section>.from(json.decode(str).map((x) => Section.fromJson(x)));


class Section {
  final List<dynamic> days; //days of meeting
  final DateTime endTime; //represents .to time for class
  final String id; //unique ID
  final DateTime startTime; //represents .from time for class


  Section({
    required this.days,
    required this.endTime,
    required this.id,
    required this.startTime,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
     //representing class section in JSON formatting
    DateFormat format = DateFormat('HH:mm:ss');
    return Section(
      days: json['days'].map((item) => item.toString()).toList(),
      endTime: format.parse(json['end_time'] as String),
      id: json['id'] as String,
      startTime: format.parse(json['start_time'] as String),
    );
  }
}