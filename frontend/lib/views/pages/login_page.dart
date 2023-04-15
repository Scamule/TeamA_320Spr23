import 'package:flutter/cupertino.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';

import '../../view_models/login_viewmodel.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  late LoginViewModel _usersViewModel;

  Future<String?> _signupUser(SignupData data) async {
    return await _usersViewModel.signUpUser(data);
  }

  Future<String?> _authUser(LoginData data) {
    return Future.delayed(const Duration(milliseconds: 2250)).then((_) {
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(const Duration(milliseconds: 2250)).then((_) {
      return "";
    });
  }

  @override
  Widget build(BuildContext context) {
    LoginViewModel usersViewModel = context.watch<LoginViewModel>();
    _usersViewModel = usersViewModel;
    return FlutterLogin(
      onRecoverPassword: _recoverPassword,
      onLogin: _authUser,
      onSignup: _signupUser,
      title: 'UScheduler',
    );
  }
}
