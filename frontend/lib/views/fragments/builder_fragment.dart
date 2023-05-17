import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uscheduler/views/pages/find_event_page.dart';

import '../../models/course.dart';
import '../../utils/status.dart';
import '../../view_models/home_viewmodel.dart';

//displays list of classes fetched async
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
      //widget returns FutureBuilder and Floatingbutton
      body: FutureBuilder(
        future: _homeViewModel.getEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //if true the course is displayed on the ListView widget
            var results = <Course>[];
            var response = snapshot.data;
            if (response is Failure) {
              return Center(
                child: Text(
                  jsonDecode(response.errorResponse as String)["message"],
                  style: const TextStyle(fontSize: 18),
                ),
              );
            }
            //returns a ListView widget
            //parsed by JSON data returned by .getEvents()
            var res = jsonEncode(response);
            results = courseFromJson(res);
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
                        tooltip: "Delete class",
                        onPressed: () {
                          //deletes class from the remote API
                          _homeViewModel.deleteEvent(results[index]);
                          results.removeAt(index);
                          setState(() {
                            //list is rewritten without ^ class
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => {
          //when the + button is pressed on
          Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (context) => const FindEventPage(),
              ))
              .then((value) => setState(
                  () {})) //setState rebuilds ListView widget and displays new page
        },
      ),
    );
  }
}
