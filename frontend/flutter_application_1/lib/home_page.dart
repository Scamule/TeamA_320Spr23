import 'package:flutter/material.dart';
import 'package:flutter_application_1/event_adding.dart';
import 'package:flutter_application_1/event_editing_page.dart';
import 'package:flutter_application_1/model/event_data_source.dart';
import 'package:flutter_application_1/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_application_1/calender_view.dart';

class HomePage extends StatefulWidget {
  final Todo todo;
  const HomePage({super.key, required this.todo});
  @override
  State<HomePage> createState() => _HomePageState(todo: todo);
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  _HomePageState({required this.todo});
  final Todo todo;
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [const CalenderPage(), ProfileScreen(todo: todo)];
      return Scaffold(
      body: pages[currentPage],
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
    );
  }
}

