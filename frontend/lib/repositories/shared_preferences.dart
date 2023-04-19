import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class SharedPreferencesRepo {
  late final Future<SharedPreferences> _sharedPreference;

  SharedPreferencesRepo() {
    _sharedPreference = SharedPreferences.getInstance();
  }

  Future<bool> get isLoggedIn async {
    return _sharedPreference.then((preference) {
      return preference.getBool(Preferences.is_logged_in) ?? false;
    });
  }

  Future<void> saveIsLoggedIn(bool value) async {
    return _sharedPreference.then((preference) {
      preference.setBool(Preferences.is_logged_in, value);
    });
  }
}

class Preferences {
  Preferences._();

  static const String is_logged_in = "isLoggedIn";
}
