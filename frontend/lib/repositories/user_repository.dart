import 'dart:convert';

import 'package:flutter_login/flutter_login.dart';
import 'package:injectable/injectable.dart';
import 'package:uscheduler/utils/constants.dart';
import 'package:uscheduler/utils/network.dart';

@singleton
class UserRepository {
  final url = SERVER_URL;

  /// Method to sign up a user.
  ///
  /// Returns a [Future] with the result of the operation.
  Future<Object> signUpUser(LoginData data) async {
    // Prepare the request body with the provided email and password
    Map<String, dynamic> request = {
      "email": data.name,
      "password": data.password
    };

    // Define the headers for the HTTP request
    final headers = {'Content-Type': 'application/json'};

    // Send the network request and handle the response
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/signup"), headers, json.encode(request));
  }

  /// Method to log in a user.
  ///
  /// Returns a [Future] with the result of the operation.
  Future<Object> loginUser(LoginData data) async {
    // Prepare the request body with the provided email and password
    Map<String, dynamic> request = {
      "email": data.name,
      "password": data.password
    };

    // Define the headers for the HTTP request
    final headers = {'Content-Type': 'application/json'};

    // Send the network request and handle the response
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/login"), headers, json.encode(request));
  }

  /// Method to validate an email.
  ///
  /// Returns a [Future] with the result of the operation.
  Future<Object> validateEmail(SignupData data) async {
    // Prepare the request body with the provided email
    Map<String, dynamic> request = {"email": data.name};

    // Define the headers for the HTTP request
    final headers = {'Content-Type': 'application/json'};

    // Send the network request and handle the response
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/validate_email"), headers, json.encode(request));
  }

  /// Method to recover a password.
  ///
  /// Returns a [Future] with the result of the operation.
  Future<Object> recoverPassword(String data) async {
    // Prepare the request body with the provided email
    Map<String, dynamic> request = {"email": data};

    // Define the headers for the HTTP request
    final headers = {'Content-Type': 'application/json'};

    // Send the network request and handle the response
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/recover_password"), headers, json.encode(request));
  }

  /// Method to change a user's password.
  ///
  /// Returns a [Future] with the result of the operation.
  Future<Object> changeUserPassword(LoginData data) async {
    // Prepare the request body with the provided email and password
    Map<String, dynamic> request = {
      "email": data.name,
      "password": data.password
    };

    // Define the headers for the HTTP request
    final headers = {'Content-Type': 'application/json'};

    // Send the network request and handle the response
    return await Network.handleNetworkResponse(
        Uri.parse("$url/user/change_password"), headers, json.encode(request));
  }
}
