import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:uscheduler/utils/constants.dart';
import 'package:uscheduler/utils/status.dart';

//creates a class for other pieces of code to use for handling any errors for server requests
class Network {
  static handleNetworkResponse(uri, headers, body) async {
    //return the body of the response if there is no error, so that all async functions can use this function
    try {
      var response = await http.post(uri, headers: headers, body: body);
      if (SUCCESS == response.statusCode) {
        return Success(response: response.body);
      }
      //handles a response where the request was successfully made, but the response itself contains an error
      return Failure(code: response.statusCode, errorResponse: response.body);
      //the rest of the code below handles different types of exceptions with their corresponding error messages 
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
