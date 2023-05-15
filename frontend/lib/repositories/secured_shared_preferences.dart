import 'package:injectable/injectable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uscheduler/utils/extensions.dart';

import 'package:flutter/foundation.dart' show debugPrint;

//creates the class used to store any significant information for while the user is using the app
@singleton
class SecuredSharedPreferencesRepo {
  //initialize the storage 
  final storage = const FlutterSecureStorage();

  /// Returns true if the user is logged in according to [storage],
  /// returns false if not, or if an error occured
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

  //check if the user's login status is saved for when they switch pages or reload the app
  Future<void> saveIsLoggedIn(bool value) async {
    String isLoggedIn = value.toString();
    try {
      return await storage.write(
          key: Preferences.is_logged_in, value: isLoggedIn);
    } catch (exception) {
      debugPrint("Failed to save isLoggedIn: ${exception.toString()}");
    }
  }

  /// Returns the user token in [storage] if it exists,
  /// returns "-1" when it does not, or if an error occured
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

  //saves the user token that will be used to specify which database to query during API requests
  Future<void> saveUserToken(String userToken) async {
    try {
      return await storage.write(key: Preferences.user_token, value: userToken);
    } catch (exception) {
      debugPrint("Failed to save userToken: ${exception.toString()}");
    }
  }
}

//creates a class to store preferences that the user can possibly manipulate in settings
class Preferences {
  Preferences._();

  static const String is_logged_in = "isLoggedIn";
  static const String user_token = "userToken";
}
