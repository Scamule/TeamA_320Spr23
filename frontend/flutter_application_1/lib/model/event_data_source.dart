import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/event.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> events) {
    appointments = events;
  }

  Event getEvent(int index) => appointments![index] as Event;

  @override
  DateTime getStartTime(int index) => getEvent(index).from;

  @override
  DateTime getEndTime(int index) => getEvent(index).to;

  @override
  String getSubject(int index) => getEvent(index).title;

  @override
  Color getColor(int index) => getEvent(index).backgroundColor;
}
