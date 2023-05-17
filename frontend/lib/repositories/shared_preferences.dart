import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class SharedPreferencesRepo {
  late final Future<SharedPreferences> _sharedPreference;

  SharedPreferencesRepo() {
    // Initialize the SharedPreferences instance asynchronously
    _sharedPreference = SharedPreferences.getInstance();
  }

  /// Getter to check if the user is logged in.
  Future<bool> get isLoggedIn async {
    return _sharedPreference.then((preference) {
      // Retrieve the 'is_logged_in' preference value from SharedPreferences
      // If the value is not found, return false as default
      return preference.getBool(Preferences.is_logged_in) ?? false;
    });
  }

  /// Method to save the logged in status.
  Future<void> saveIsLoggedIn(bool value) async {
    return _sharedPreference.then((preference) {
      // Set the 'is_logged_in' preference value in SharedPreferences
      preference.setBool(Preferences.is_logged_in, value);
    });
  }
}

class Preferences {
  Preferences._();

  static const String is_logged_in = "isLoggedIn";
}
