import 'dart:convert';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:uscheduler/models/event.dart';
import 'package:uscheduler/utils/constants.dart';
import 'package:uscheduler/utils/network.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/status.dart';

@singleton
class EventsRepository {
  //the server URL that all database endpoints live on
  //this is instantiated on a Python Flask server
  final url = SERVER_URL;
  final storage = new FlutterSecureStorage();

  //performs a query for clubs/classes in the database
  //the token is passed in for validation in the HTTP header
  Future<Status> getClubsAndClasses(String query, String token) async {
    Map<String, dynamic> request = {"query": query};
    final headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    return await Network.handleNetworkResponse(
        Uri.parse("$url/events/get"), headers, json.encode(request));
  }

  //sends an update to the database for an event added
  //this will allow the database to record updates on added events for each user
  Future<Status> addEvent(Event event, String token) async {
    Map<String, dynamic> request = {"event": event};
    final headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/events/add"), headers, json.encode(request));
  }

  //sends an update to the database to remove an event, which will be recorded for the specific user
  Future<Status> deleteEvent(Event event, String token) async {
    Map<String, dynamic> request = {"event": event};
    final headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/events/delete"), headers, json.encode(request));
  }

  //gets all the events for a particular user (this is specified through the token parameter)
  Future<Status> getEvents(String token) async {
    Map<String, dynamic> request = {};
    final headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/events/get"), headers, json.encode(request));
  }

  //get all events to be suggested as a user builds their search 
  Future<Status> suggestEvents(String token) async {
    Map<String, dynamic> request = {};
    final headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/events/suggest"), headers, json.encode(request));
  }

  //makes a query through the python server to build a schedule using events added to the user's database
  Future<Status> generateSchedules(String token) async {
    Map<String, dynamic> request = {};
    final headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/schedule/generate"),
        headers,
        json.encode(request));
  }
}
