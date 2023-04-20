import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uscheduler/models/course.dart';
import 'package:uscheduler/view_models/home_viewmodel.dart';
import 'package:debounce_throttle/debounce_throttle.dart';

import '../utils/status.dart';

class FindEventPageSearchDelegate extends SearchDelegate {
  final HomeViewModel _homeViewModel = GetIt.instance<HomeViewModel>();

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
                response.errorResponse as String,
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
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              var result = results[index];
              return ListTile(
                title: Text(result.id ?? ""),
              );
            },
          );
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
                    response.errorResponse as String,
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
              return ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  var result = results[index];
                  return ListTile(
                    title: Text(result.id ?? ""),
                  );
                },
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
