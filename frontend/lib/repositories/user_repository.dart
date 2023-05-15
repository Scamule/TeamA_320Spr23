import 'dart:convert';

import 'package:flutter_login/flutter_login.dart';
import 'package:injectable/injectable.dart';
import 'package:uscheduler/utils/constants.dart';
import 'package:uscheduler/utils/network.dart';

@singleton
class UserRepository {
  //uses the url that the python server lives on
  final url = SERVER_URL;

  //sends the signup information to the server to add the new login to the database and email confirmation
  Future<Object> signUpUser(LoginData data) async {
    Map<String, dynamic> request = {
      "email": data.name,
      "password": data.password
    };
    final headers = {'Content-Type': 'application/json'};
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/signup"), headers, json.encode(request));
  }

  //sends login info to the database and returns whether or not the login was successful
  Future<Object> loginUser(LoginData data) async {
    Map<String, dynamic> request = {
      "email": data.name,
      "password": data.password
    };
    final headers = {'Content-Type': 'application/json'};
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/login"), headers, json.encode(request));
  }

  //check if the login email is a valid/existing login (ex: it must end properly, like with @umass.edu)
  Future<Object> validateEmail(SignupData data) async {
    Map<String, dynamic> request = {"email": data.name};
    final headers = {'Content-Type': 'application/json'};
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/validate_email"), headers, json.encode(request));
  }

  //updates the server to send confirmation for a new password
  Future<Object> recoverPassword(String data) async {
    Map<String, dynamic> request = {"email": data};
    final headers = {'Content-Type': 'application/json'};
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/recover_password"), headers, json.encode(request));
  }

  //updates the database of a password change for a user
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
