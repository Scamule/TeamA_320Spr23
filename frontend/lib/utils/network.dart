import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:uscheduler/utils/constants.dart';
import 'package:uscheduler/utils/status.dart';

class Network {
  static handleNetworkResponse(uri, headers, body) async {
    try {
      // Make an HTTP POST request using the provided URI, headers, and body
      var response = await http.post(uri, headers: headers, body: body);

      // Check if the response status code indicates success
      if (SUCCESS == response.statusCode) {
        return Success(response: response.body);
      }

      // Return a Failure object with the response status code and body
      return Failure(code: response.statusCode, errorResponse: response.body);
    } on HttpException {
      // Handle HTTP exceptions (e.g., no internet connection)
      return Failure(code: NO_INTERNET, errorResponse: 'No Internet Connection');
    } on SocketException {
      // Handle socket exceptions (e.g., no internet connection)
      return Failure(code: NO_INTERNET, errorResponse: 'No Internet Connection');
    } on FormatException {
      // Handle format exceptions (e.g., invalid format)
      return Failure(code: INVALID_FORMAT, errorResponse: 'Invalid Format');
    } catch (e) {
      // Handle other exceptions (unknown errors)
      return Failure(code: UNKNOWN_ERROR, errorResponse: 'Unknown Error');
    }
  }
}
