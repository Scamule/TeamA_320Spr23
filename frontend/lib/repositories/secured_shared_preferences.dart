import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uscheduler/utils/extensions.dart';

@singleton
class SecuredSharedPreferencesRepo {
  final storage = const FlutterSecureStorage();

  Future<bool> get isLoggedIn async {
    String isLoggedIn =
        await storage.read(key: Preferences.is_logged_in) ?? "false";
    debugPrint("isLoggedIn is $isLoggedIn");
    return isLoggedIn.parseBool();
  }

  Future<void> saveIsLoggedIn(bool value) async {
    String isLoggedIn = value.toString();
    debugPrint("saving isLoggedIn: value is '$isLoggedIn'");
    return await storage.write(
        key: Preferences.is_logged_in, value: isLoggedIn);
  }

  Future<String> get userToken async {
    String? userToken = await storage.read(key: Preferences.user_token);
    return userToken ?? "-1";
  }

  Future<void> saveUserToken(String userToken) async {
    debugPrint("saving user token: value is '$userToken'");
    return await storage.write(key: Preferences.user_token, value: userToken);
  }
}

class Preferences {
  Preferences._();

  static const String is_logged_in = "isLoggedIn";
  static const String user_token = "userToken";
}
