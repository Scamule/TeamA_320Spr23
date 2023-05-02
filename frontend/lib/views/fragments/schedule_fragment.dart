import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

Widget scheduleFragment(){
  return Scaffold(
    body: SfCalendar(
        view: CalendarView.week,
        //dataSource: EventDataSource(events),
        initialSelectedDate: DateTime.now(),
        firstDayOfWeek: 7,
        headerHeight: 55,
      ),
      appBar: AppBar(
        title: const Text("UScheduler"),
      ),
  );
}

