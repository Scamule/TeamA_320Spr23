import 'package:flutter/material.dart';
import 'package:flutter_application_1/event_adding.dart';
import 'package:flutter_application_1/event_editing_page.dart';
import 'package:flutter_application_1/model/event_data_source.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;

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
        // onTap: (details) {
        //   if (details.appointments == null) return;
        //   final event = details.appointments!.first;
        //   Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => EventEditingPage(event: event),
        //   ));
        // },
        //dataSource: EventDataSource(events),
      ),
      appBar: AppBar(
        title: const Text("UScheduler"),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.calendar_month), label: 'Schedule'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile')
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
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
