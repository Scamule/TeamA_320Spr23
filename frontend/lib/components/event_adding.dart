import 'package:flutter/material.dart';
import 'package:uscheduler/models/course.dart';

class EventAdding extends ChangeNotifier {
  final List<Course> addedEvents = []; // List to store added events
  List<Course> get events => addedEvents; // Getter to retrieve added events

  void addEvent(Course event) {
    addedEvents.add(event); // Add the event to the list

    notifyListeners(); // Notify listeners of the change
  }
}
