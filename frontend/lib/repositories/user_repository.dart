import 'dart:convert';

import 'package:flutter_login/flutter_login.dart';
import 'package:uscheduler/utils/constants.dart';
import 'package:uscheduler/utils/network.dart';

class UserRepository {
  final url = SERVER_URL;

  Future<Object> signUpUser(LoginData data) async {
    Map<String, dynamic> request = {
      "email": data.name,
      "password": data.password
    };
    final headers = {'Content-Type': 'application/json'};
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/signup"), headers, json.encode(request));
  }

  Future<Object> loginUser(LoginData data) async {
    Map<String, dynamic> request = {
      "email": data.name,
      "password": data.password
    };
    final headers = {'Content-Type': 'application/json'};
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/login"), headers, json.encode(request));
  }

  Future<Object> validateEmail(SignupData data) async {
    Map<String, dynamic> request = {"email": data.name};
    final headers = {'Content-Type': 'application/json'};
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/validate_email"), headers, json.encode(request));
  }

  Future<Object> recoverPassword(String data) async {
    Map<String, dynamic> request = {"email": data};
    final headers = {'Content-Type': 'application/json'};
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/recover_password"), headers, json.encode(request));
  }

  Future<Object> changeUserPassword(LoginData data) async {
    Map<String, dynamic> request = {
      "email": data.name,
      "password": data.password
    };
    final headers = {'Content-Type': 'application/json'};
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/change_password"), headers, json.encode(request));
  }
}
