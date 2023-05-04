import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uscheduler/views/pages/find_event_page.dart';

import '../../models/course.dart';
import '../../utils/status.dart';
import '../../view_models/home_viewmodel.dart';

class BuilderFragment extends StatefulWidget {
  const BuilderFragment({super.key});

  @override
  State<StatefulWidget> createState() => _BuilderFragmentState();
}

class _BuilderFragmentState extends State<BuilderFragment> {
  final HomeViewModel _homeViewModel = GetIt.instance<HomeViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _homeViewModel.getEvents(),
        builder: (context, snapshot) {
          debugPrint("checking connection");
          if (snapshot.connectionState == ConnectionState.done) {
            debugPrint("state is done");
            var results = <Course>[];
            var response = snapshot.data;
            debugPrint("Checking");
            if (response is Failure) {
              debugPrint("response was failure");
              return Center(
                child: Text(
                  jsonDecode(response.errorResponse as String)["message"],
                  style: const TextStyle(fontSize: 18),
                ),
              );
            }
            debugPrint("getting courses");
            debugPrint("Calling json encode on response");
            var res = jsonEncode(response);
            debugPrint("calling courseFromJson");
            results = courseFromJson(res);
            debugPrint("successfully got courses, returning");
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  var result = results[index];
                  return ListTile(
                    title: Text(result.id ?? ""),
                    trailing: SizedBox(
                      width: 70,
                      child: IconButton(
                        onPressed: () {
                          _homeViewModel.deleteEvent(results[index]);
                          results.removeAt(index);
                          setState(() {
                            results = results;
                          });
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                  );
                },
              );
            });
          } else {
            debugPrint("state is not done");
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => {
          Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (context) => const FindEventPage(),
              ))
              .then((value) => setState(() {}))
        },
      ),
    );
  }
}
