import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uscheduler/models/course.dart';
import 'package:uscheduler/view_models/home_viewmodel.dart';
import 'package:debounce_throttle/debounce_throttle.dart';

import '../utils/status.dart';

class FindEventPageSearchDelegate extends SearchDelegate {
  final HomeViewModel _homeViewModel = GetIt.instance<HomeViewModel>();
  final Function() onClosed;

  FindEventPageSearchDelegate({required this.onClosed});

  Completer<Status> _completer = Completer();

  late final Debouncer _debouncer = Debouncer(const Duration(milliseconds: 300),
      initialValue: '', onChanged: (value) {
    _completer.complete(_homeViewModel.getClubsAndClasses(value));
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: _homeViewModel.getClubsAndClasses(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
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
          if (response is Success) {
            var res = response.response as String?;
            if (res != null) {
              results = courseFromJson(res);
            }
          }
          List<bool?> isClicked = List.filled(results.length, false);
          var events = _homeViewModel.getEvents();
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            events.then((list) => {
                  for (var i = 0; i < results.length; i++)
                    {
                      list.forEach((e) => {
                            if (e['id'] == results[i].id) {isClicked[i] = true}
                          })
                    },
                  setState(() {})
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
          });
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _debouncer.value = query;
    _completer = Completer();

    return FutureBuilder(
        future: _completer.future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occured',
                  style: const TextStyle(fontSize: 18),
                ),
              );
            } else if (snapshot.hasData) {
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
              if (response is Success) {
                var res = response.response as String?;
                if (res != null) {
                  results = courseFromJson(res);
                }
              }
              List<bool?> isClicked = List.filled(results.length, false);
              var events = _homeViewModel.getEvents();
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                events.then((list) => {
                      for (var i = 0; i < results.length; i++)
                        {
                          list.forEach((e) => {
                                if (e['id'] == results[i].id)
                                  {isClicked[i] = true}
                              })
                        },
                      setState(() {})
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
              });
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  @override
  void close(BuildContext context, result) {
    onClosed();
    super.close(context, result);
  }
}
