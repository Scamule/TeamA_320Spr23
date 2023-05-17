import 'package:injectable/injectable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uscheduler/utils/extensions.dart';

import 'package:flutter/foundation.dart' show debugPrint;

@singleton
class SecuredSharedPreferencesRepo {
  final storage = const FlutterSecureStorage();

  /// Getter to check if the user is logged in.
  ///
  /// Returns a [Future] with a boolean indicating the logged in status.
  Future<bool> get isLoggedIn async {
    try {
      String isLoggedIn =
          await storage.read(key: Preferences.is_logged_in) ?? "false";
      return isLoggedIn.parseBool();
    } catch (exception) {
      debugPrint("Failed to get isLoggedIn: ${exception.toString()}");
      return false;
    }
  }

  /// Method to save the logged in status.
  ///
  /// Returns a [Future] indicating the completion of the operation.
  Future<void> saveIsLoggedIn(bool value) async {
    String isLoggedIn = value.toString();
    try {
      return await storage.write(
          key: Preferences.is_logged_in, value: isLoggedIn);
    } catch (exception) {
      debugPrint("Failed to save isLoggedIn: ${exception.toString()}");
    }
  }

  /// Getter to retrieve the user token.
  ///
  /// Returns a [Future] with the user token as a string.
  Future<String> get userToken async {
    try {
      String userToken =
          await storage.read(key: Preferences.user_token) ?? "-1";
      return userToken;
    } catch (exception) {
      debugPrint("Failed to get userToken: ${exception.toString()}");
      return "-1";
    }
  }

  /// Method to save the user token.
  ///
  /// Returns a [Future] indicating the completion of the operation.
  Future<void> saveUserToken(String userToken) async {
    try {
      return await storage.write(key: Preferences.user_token, value: userToken);
    } catch (exception) {
      debugPrint("Failed to save userToken: ${exception.toString()}");
    }
  }
}

class Preferences {
  Preferences._();

  static const String is_logged_in = "isLoggedIn";
  static const String user_token = "userToken";
}
