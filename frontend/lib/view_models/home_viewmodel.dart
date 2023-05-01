import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:uscheduler/models/event.dart';
import 'package:uscheduler/repositories/events_repository.dart';

import '../repositories/secured_shared_preferences.dart';
import '../utils/status.dart';

@singleton
class HomeViewModel extends ChangeNotifier {
  final EventsRepository _eventsRepository;
  final SecuredSharedPreferencesRepo _securedSharedPreferences;

  HomeViewModel(this._eventsRepository, this._securedSharedPreferences);

  Future<Status> getClubsAndClasses(String query) async {
    var token = await _securedSharedPreferences.userToken;
    return _eventsRepository.getClubsAndClasses(query, token);
  }

  addEvent(Event event) async {
    var token = await _securedSharedPreferences.userToken;
    var response = await _eventsRepository.addEvent(event, token);
    if (response is Failure) {
      return response.errorResponse as String;
    }
  }

  Future<Status> deleteEvent(Event event) async {
    var token = await _securedSharedPreferences.userToken;
    var response = await _eventsRepository.deleteEvent(event, token);
    return response;
  }

  getEvents() async {
    var token = await _securedSharedPreferences.userToken;
    var response = await _eventsRepository.getEvents(token);
    if (response is Success) {
      return jsonDecode(response.response as String) as List<dynamic>;
    }
    if (response is Failure) {
      return response;
    }
  }
}
