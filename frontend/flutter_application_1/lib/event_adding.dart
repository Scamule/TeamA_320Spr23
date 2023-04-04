import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/event.dart';
import 'package:flutter_application_1/model/utils.dart';

class EventAdding extends ChangeNotifier {
  final List<Event> addedEvents = [];
  List<Event> get events => addedEvents;

  void addEvent(Event event) {
    addedEvents.add(event);

    notifyListeners();
  }
}
