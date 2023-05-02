import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:uscheduler/utils/constants.dart';
import 'package:uscheduler/utils/network.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import '../utils/status.dart';

@singleton
class EventsRepository {
  final url = SERVER_URL;
  final storage = new FlutterSecureStorage();


  Future<Status> getClubsAndClasses(String query) async {
    Map<String, dynamic> request = {"query": query};
    final token = await storage.read(key: 'jwt');
    final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
    return await Network.handleNetworkResponse(
        Uri.parse("$url/events/get"), headers, json.encode(request));
  }
}
