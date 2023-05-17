import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:injectable/injectable.dart';
import 'package:uscheduler/repositories/secured_shared_preferences.dart';
import 'package:uscheduler/repositories/user_repository.dart';

import '../utils/status.dart';

@singleton
class LoginViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  final SecuredSharedPreferencesRepo _securedSharedPreferences;
  String? verificationCode;
  String? recoveryCode;

  LoginViewModel(this._securedSharedPreferences, this._userRepository);

  /// Method to sign up a user.
  ///
  /// Returns a [String] indicating the result of the operation. Returns null if successful.
  signUpUser(LoginData data) async {
    var response = await _userRepository.signUpUser(data);
    if (response is Success) {
      var id = response.response;
      if (id == "-1") {
        return "User already exists";
      } else {
        return null;
      }
    }
    if (response is Failure) {
      return response.errorResponse as String;
    }
  }

  /// Method to log in a user.
  ///
  /// Returns a [String] indicating the result of the operation. Returns null if successful.
  loginUser(LoginData data) async {
    var response = await _userRepository.loginUser(data);
    if (response is Success) {
      var res = jsonDecode(response.response as String);
      _securedSharedPreferences.saveUserToken(res["token"]);
      _securedSharedPreferences.saveIsLoggedIn(true);
      return null;
    }
    if (response is Failure) {
      return response.errorResponse as String;
    }
  }

  /// Method to validate email.
  ///
  /// Returns a [String] indicating the result of the operation. Returns null if successful.
  validateEmail(SignupData data) async {
    var response = await _userRepository.validateEmail(data);
    if (response is Success) {
      var res = response.response as String;
      if (res.split(" ")[0] == "Exception:") {
        return res;
      } else {
        verificationCode = res;
        return null;
      }
    }
    if (response is Failure) {
      return response.errorResponse as String;
    }
  }

  /// Method to recover password.
  ///
  /// Returns a [String] indicating the result of the operation. Returns null if successful.
  recoverPassword(String data) async {
    var response = await _userRepository.recoverPassword(data);
    if (response is Success) {
      var res = response.response as String;
      if (res.split(" ")[0] == "Exception:") {
        return res;
      } else {
        recoveryCode = res;
        return null;
      }
    }
    if (response is Failure) {
      return response.errorResponse as String;
    }
  }

  /// Method to change user password.
  ///
  /// Returns a [String] indicating the result of the operation. Returns null if successful.
  changeUserPassword(LoginData data) async {
    var response = await _userRepository.changeUserPassword(data);
    if (response is Success) {
      var res = response.response as String;
      if (res == "-1") {
        return "The user does not exist";
      } else {
        return null;
      }
    }
    if (response is Failure) {
      return response.errorResponse as String;
    }
  }

  /// Getter to check if the user is logged in.
  Future<bool> get isLoggedIn async {
    return await _securedSharedPreferences.isLoggedIn;
  }

  /// Method to log out the user.
  logOut() {
    _securedSharedPreferences.saveIsLoggedIn(false);
    _securedSharedPreferences.saveUserToken("");
  }
}
