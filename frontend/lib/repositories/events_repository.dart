import 'dart:convert';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:uscheduler/models/event.dart';
import 'package:uscheduler/utils/constants.dart';
import 'package:uscheduler/utils/network.dart';

import '../utils/status.dart';

@singleton
class EventsRepository {
  final url = SERVER_URL;

  Future<Status> getClubsAndClasses(String query, String token) async {
    Map<String, dynamic> request = {"query": query};
    final headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    return await Network.handleNetworkResponse(
        Uri.parse("$url/events/get"), headers, json.encode(request));
  }

  Future<Status> addEvent(Event event, String token) async {
    Map<String, dynamic> request = {"event": event};
    final headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/events/add"), headers, json.encode(request));
  }

  Future<Status> deleteEvent(Event event, String token) async {
    Map<String, dynamic> request = {"event": event};
    final headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/events/delete"), headers, json.encode(request));
  }

  Future<Status> getEvents(String token) async {
    Map<String, dynamic> request = {};
    final headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/events/get"), headers, json.encode(request));
  }
}
