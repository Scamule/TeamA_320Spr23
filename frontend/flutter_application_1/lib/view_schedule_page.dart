import 'package:flutter/material.dart';
import 'package:flutter_application_1/event_editing_page.dart';
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
        initialSelectedDate: DateTime.now(),
        firstDayOfWeek: 7,
        headerHeight: 55,
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => EventEditingPage()))
          //debugPrint('Clicked on button!'); },
          ),
    );
  }
}
