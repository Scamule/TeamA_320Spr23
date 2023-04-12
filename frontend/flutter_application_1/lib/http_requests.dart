import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// This file will hold all of the http request heavy stuff
/// so the other files are not completely littered with dumb
/// http stuff

/// Returns a Map in the form { "ok": boolean, "message": String }
/// if the login info is correct
/// [clientEmail] is the email the user has inputted
/// [clientPassword] is the password the user has inputted
/// We may use get requests for receiving into in the future,
/// but this was just to test post requests.
Future<Map<String, dynamic>> login(
    String clientEmail, String clientPassword) async {
  final http.Response response = await http.post(
    Uri.parse('http://127.0.0.1:5000/userlogin'),
    body: <String, dynamic>{
      "email": clientEmail,
      "password": clientPassword,
    },
  );
  debugPrint(response.statusCode.toString());
  if (response.statusCode != HttpStatus.ok) {
    debugPrint('Invalid request.');
    return {"ok": false, "message": "Request failed. Please try again."};
  }
  var data = jsonDecode(response.body);
  // In the form of { "statusCode": number, "error": String, "body": JSON String }
  // If statusCode is 200, it means the email and password was in the database
  if (data['statusCode'] == HttpStatus.ok) {
    debugPrint('Username and password are correct');
    return {"ok": true, "message": "Success"};
  } else {
    debugPrint(
        'User not found or invalid input, status code: ${data['statusCode']}');
    return {"ok": false, "message": "Email and password do not match"};
  }
}
