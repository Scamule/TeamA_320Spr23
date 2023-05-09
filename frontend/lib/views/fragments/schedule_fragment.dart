import 'dart:convert';

// Aparently all of the stuff in this are already in
//    package:flutter/material.dart
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/schedule.dart';
import '../../view_models/home_viewmodel.dart';

class ScheduleFragment extends StatefulWidget {
  const ScheduleFragment({super.key});

  @override
  State<StatefulWidget> createState() => _ScheduleFragmentState();
}

class _ScheduleFragmentState extends State<ScheduleFragment> {
  final HomeViewModel _homeViewModel = GetIt.instance<HomeViewModel>();
  List<Schedule> schedules = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              onPressed: () async {
                var res = await _homeViewModel.generateSchedules();
                schedules = scheduleFromJson(res);
                setState(() {});
              },
              child: const Text("Generate"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: schedules.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text('Schedule $index'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
