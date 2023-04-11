import 'package:flutter/material.dart';
import 'package:flutter_application_1/event_adding.dart';
import 'package:flutter_application_1/event_editing_page.dart';
import 'package:flutter_application_1/model/event_data_source.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventAdding>(context).events;
    //Calendar widget
    return Scaffold(
      body: SfCalendar(
        view: CalendarView.week,
        dataSource: EventDataSource(events),
        initialSelectedDate: DateTime.now(),
        firstDayOfWeek: 7,
        headerHeight: 55,
        //dataSource: EventDataSource(events),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const EventEditingPage()))
          //debugPrint('Clicked on button!'); },
          ),
    );
  }
}
