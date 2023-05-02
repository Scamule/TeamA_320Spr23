import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:injectable/injectable.dart';
import 'package:uscheduler/repositories/user_repository.dart';

import '../repositories/shared_preferences.dart';
import '../utils/status.dart';


@singleton
class LoginViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  final SharedPreferencesRepo _sharedPreferences;
  String? verificationCode;
  String? recoveryCode;

  LoginViewModel(this._sharedPreferences, this._userRepository);

  signUpUser(LoginData data) async {
    var response = await _userRepository.signUpUser(data);
    if (response is Success) {
      var id = response.response as String;
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

  loginUser(LoginData data) async {
    var response = await _userRepository.loginUser(data);
    if (response is Success) {
      var res = response.response as String;
      if (res == "-1") {
        return "Incorrect login or password";
      } else {
        _sharedPreferences.saveIsLoggedIn(true);
        return null;
      }
    }
    if (response is Failure) {
      return response.errorResponse as String;
    }
  }

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

  changeUserPassword(LoginData data) async {
    var response = await _userRepository.changeUserPassword(data);
    if (response is Success) {
      var res = response.response as String;
      if (res == "-1") {
        return "The user does not exists";
      } else {
        return null;
      }
    }
    if (response is Failure) {
      return response.errorResponse as String;
    }
  }

  Future<bool> get isLoggedIn async {
    return await _sharedPreferences.isLoggedIn;
  }
}
