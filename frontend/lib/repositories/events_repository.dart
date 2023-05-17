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
  final url = SERVER_URL;
  final storage = new FlutterSecureStorage();

  /// Method to get clubs and classes based on the provided [query].
  ///
  /// Returns a [Future] with the status of the operation.
  Future<Status> getClubsAndClasses(String query, String token) async {
    Map<String, dynamic> request = {"query": query};

    // Define the headers for the HTTP request, including the bearer token
    final headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: "Bearer $token"
    };

    // Send the network request and handle the response
    return await Network.handleNetworkResponse(
        Uri.parse("$url/events/get"), headers, json.encode(request));
  }

  /// Method to add an event.
  ///
  /// Returns a [Future] with the status of the operation.
  Future<Status> addEvent(Event event, String token) async {
    Map<String, dynamic> request = {"event": event};

    // Define the headers for the HTTP request, including the bearer token
    final headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: "Bearer $token"
    };

    // Send the network request and handle the response
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/events/add"), headers, json.encode(request));
  }

  /// Method to delete an event.
  ///
  /// Returns a [Future] with the status of the operation.
  Future<Status> deleteEvent(Event event, String token) async {
    Map<String, dynamic> request = {"event": event};

    // Define the headers for the HTTP request, including the bearer token
    final headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: "Bearer $token"
    };

    // Send the network request and handle the response
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/events/delete"), headers, json.encode(request));
  }

  /// Method to get events.
  ///
  /// Returns a [Future] with the status of the operation.
  Future<Status> getEvents(String token) async {
    Map<String, dynamic> request = {};

    // Define the headers for the HTTP request, including the bearer token
    final headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: "Bearer $token"
    };

    // Send the network request and handle the response
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/events/get"), headers, json.encode(request));
  }

  /// Method to suggest events.
  ///
  /// Returns a [Future] with the status of the operation.
  Future<Status> suggestEvents(String token) async {
    Map<String, dynamic> request = {};

    // Define the headers for the HTTP request, including the bearer token
    final headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: "Bearer $token"
    };

    // Send the network request and handle the response
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/events/suggest"), headers, json.encode(request));
  }

  /// Method to generate schedules.
  ///
  /// Returns a [Future] with the status of the operation.

  Future<Status> generateSchedules(String token) async {
    Map<String, dynamic> request = {};

    // Define the headers for the HTTP request, including the bearer token
    final headers = {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: "Bearer $token"
    };

    // Send the network request and handle the response
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/schedule/generate"),
        headers,
        json.encode(request));
  }
}
