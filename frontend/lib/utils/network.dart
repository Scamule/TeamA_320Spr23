import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:uscheduler/utils/constants.dart';
import 'package:uscheduler/utils/status.dart';

class Network {
  static handleNetworkResponse(uri, headers, body) async {
    try {
      var response = await http.post(uri, headers: headers, body: body);
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
