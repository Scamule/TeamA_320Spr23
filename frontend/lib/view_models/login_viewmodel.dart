import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:uscheduler/repositories/user_repository.dart';

import '../utils/status.dart';

class LoginViewModel extends ChangeNotifier {
  late UserRepository _userRepository;

  LoginViewModel() {
    _userRepository = UserRepository();
  }

  signUpUser(SignupData data) async {
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
}