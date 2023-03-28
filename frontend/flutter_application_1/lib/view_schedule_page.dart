import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
class ViewSchedulePage extends StatefulWidget {
  const ViewSchedulePage({super.key});
  @override
  State<ViewSchedulePage> createState() => _ViewSchedulePageState();
}
class _ViewSchedulePageState extends State<ViewSchedulePage> {
  DateTime today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Schedule')),
        body: SfCalendar(
          view: CalendarView.week,
          firstDayOfWeek: 7,
          headerHeight: 55,
        ));
  }
}
List<Appointment> getAppointments() {
  List<Appointment> meetings = <Appointment>[];
  DateTime today = DateTime.now();
  DateTime startDate = DateTime(today.year, today.month, today.day, 9, 0, 0);
  return meetings;
}
class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}