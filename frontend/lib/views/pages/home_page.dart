import 'package:flutter/material.dart';
import 'package:uscheduler/views/fragments/account_fragment.dart';
import 'package:uscheduler/views/fragments/builder_fragment.dart';
import 'package:uscheduler/views/fragments/schedule_fragment.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = <Widget>[
    scheduleFragment(),
    builderFragment(),
    accountFragment()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex), //New
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.calendar_month), label: 'Schedule'),
          NavigationDestination(icon: Icon(Icons.build), label: 'Builder'),
          NavigationDestination(
              icon: Icon(Icons.supervised_user_circle), label: 'Profile')
        ],
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
