import 'package:flutter/material.dart';
import 'package:uscheduler/views/fragments/account_fragment.dart';
import 'package:uscheduler/views/fragments/builder_fragment.dart';
import 'package:uscheduler/views/fragments/schedule_fragment.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
//home page view seen after login
//contains body and bottom navigation bar
class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = <Widget>[
    //different page views (seen as fragments)
    const ScheduleFragment(),  //calendar that displays courses/events
    const BuilderFragment(),  //tool to search and add to schedule
    accountFragment() //profile page with user info
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            _pages.elementAt(_selectedIndex), // Display the selected fragment
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
           //three icons that lead to the different fragments
          NavigationDestination(
              icon: Icon(Icons.calendar_month), label: 'Schedule'),
          NavigationDestination(icon: Icon(Icons.build), label: 'Builder'),
          NavigationDestination(
              icon: Icon(Icons.supervised_user_circle), label: 'Profile')
        ],
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index; // Update the selected index
          });
        },
        selectedIndex: _selectedIndex, // Pass the selected index
      ),
    );
  }
}
