import 'package:flutter/material.dart';
import 'package:flutter_application_1/event_editing_page.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
