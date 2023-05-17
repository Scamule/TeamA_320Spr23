import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../components/find_event_page_search_delegate.dart';
import '../../models/course.dart';
import '../../utils/status.dart';
import '../../view_models/home_viewmodel.dart';

class FindEventPage extends StatefulWidget {
  const FindEventPage({super.key});

  @override
  State<FindEventPage> createState() => _FindEventPageState();
}

class _FindEventPageState extends State<FindEventPage> {
  final HomeViewModel _homeViewModel = GetIt.instance<HomeViewModel>(); // Get an instance of HomeViewModel using GetIt

  Future<bool> _onWillPop() async {
    setState(() {});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Function to be called when the search is closed
    onSearchClosed() => {setState(() => {})};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search for events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: FindEventPageSearchDelegate(onClosed: onSearchClosed),
              ).then((value) async {
                setState(() {});
              });
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _homeViewModel.suggestEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var results = <Course>[];
            var response = snapshot.data;

            // Check if the response is a Failure object
            if (response is Failure) {
              return Center(
                child: Text(
                  jsonDecode(response.errorResponse as String)["message"],
                  style: const TextStyle(fontSize: 18),
                ),
              );
            }

            var res = jsonEncode(response);
            results = courseFromJson(res);
            List<bool?> isClicked = List.filled(results.length, false);

            var events = _homeViewModel.getEvents();

            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                // Retrieve events and update isClicked based on their presence in the list
                events.then((list) {
                  for (var i = 0; i < results.length; i++) {
                    list.forEach((e) {
                      if (e['id'] == results[i].id) {
                        isClicked[i] = true;
                      }
                    });
                  }
                  setState(() {});
                });

                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    var result = results[index];
                    return ListTile(
                      title: Text(result.id ?? ""),
                      trailing: SizedBox(
                        width: 70,
                        child: Checkbox(
                          value: isClicked[index],
                          onChanged: (bool? val) {
                            setState(() {
                              isClicked[index] = val;
                            });
                            if (val!) {
                              _homeViewModel.addEvent(results[index]);
                            } else {
                              _homeViewModel.deleteEvent(results[index]);
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
