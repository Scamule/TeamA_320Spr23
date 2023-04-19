import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:uscheduler/utils/constants.dart';
import 'package:uscheduler/utils/network.dart';

import '../utils/status.dart';

@singleton
class EventsRepository {
  final url = SERVER_URL;

  Future<Status> getClubsAndClasses(String query) async {
    Map<String, dynamic> request = {"query": query};
    final headers = {'Content-Type': 'application/json'};
    return await Network.handleNetworkResponse(
        Uri.parse("$url/events/get"), headers, json.encode(request));
  }
}
