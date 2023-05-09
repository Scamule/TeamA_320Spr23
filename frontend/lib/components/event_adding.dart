import 'package:flutter/material.dart';
import 'package:uscheduler/models/course.dart';

class EventAdding extends ChangeNotifier {
  final List<Course> addedEvents = []; //list of Courses
  List<Course> get events => addedEvents; //getter function to access list of Courses

  void addEvent(Course event) { //method that adds Course to list
    addedEvents.add(event);

    notifyListeners(); //notify changes are made
  }
}