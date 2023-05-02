import 'package:flutter/material.dart';
import 'package:uscheduler/models/course.dart';

class EventAdding extends ChangeNotifier {
  final List<Course> addedEvents = [];
  List<Course> get events => addedEvents;

  void addEvent(Course event) {
    addedEvents.add(event);

    notifyListeners();
  }
}