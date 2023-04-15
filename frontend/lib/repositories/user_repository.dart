import 'dart:convert';
import 'dart:io';

import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;
import 'package:uscheduler/utils/constants.dart';
import 'package:uscheduler/utils/status.dart';

class UserRepository {
  final url = SERVER_URL;

  Future<Object> signUpUser(SignupData data) async {
    Map<String, dynamic> request = {
      "email": data.name,
      "password": data.password
    };
    final headers = {'Content-Type': 'application/json'};
    try {
      var response = await http.post(Uri.parse("$url/user/signup"),
          headers: headers, body: json.encode(request));
      if (SUCCESS == response.statusCode) {
        return Success(response: response.body);
      }
      return Failure(
          code: USER_INVALID_RESPONSE, errorResponse: 'Invalid Response');
    } on HttpException {
      return Failure(
          code: NO_INTERNET, errorResponse: 'No Internet Connection');
    } on SocketException {
      return Failure(
          code: NO_INTERNET, errorResponse: 'No Internet Connection');
    } on FormatException {
      return Failure(code: INVALID_FORMAT, errorResponse: 'Invalid Format');
    } catch (e) {
      return Failure(code: UNKNOWN_ERROR, errorResponse: 'Unknown Error');
    }
  }
}
