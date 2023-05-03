import 'package:injectable/injectable.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';

@singleton
class SecuredSharedPreferencesRepo {
  late final Future<SecureSharedPref> _securedSharedPreference;

  SecuredSharedPreferencesRepo() {
    _securedSharedPreference = SecureSharedPref.getInstance();
  }

  Future<bool> get isLoggedIn async {
    return _securedSharedPreference.then((preference) async {
      return await preference.getBool(Preferences.is_logged_in, isEncrypted: true) ?? false;
    });
  }

  Future<void> saveIsLoggedIn(bool value) async {
    return _securedSharedPreference.then((preference) {
      preference.putBool(Preferences.is_logged_in, value, isEncrypted: true);
    });
  }

  Future<void> saveUserToken(String value) async {
    return _securedSharedPreference.then((preference) {
      preference.putString(Preferences.user_token, value, isEncrypted: true);
    });
  }

  Future<String> get userToken async {
    return _securedSharedPreference.then((preference) async {
      return await preference.getString(Preferences.user_token, isEncrypted: true) ?? "";
    });
  }
}

class Preferences {
  Preferences._();

  static const String is_logged_in = "isLoggedIn";
  static const String user_token = "userToken";
}
