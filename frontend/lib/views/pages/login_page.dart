import 'package:flutter/cupertino.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';

import '../../view_models/login_viewmodel.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  late LoginViewModel _usersViewModel;

  Future<String?> _signupUser(SignupData data) async {
    return await _usersViewModel.validateEmail(data);
  }

  Future<String?> _loginUser(LoginData data) async {
    return await _usersViewModel.loginUser(data);
  }

  Future<String?> _recoverPassword(String name) async {
    return await _usersViewModel.recoverPassword(name);
  }

  Future<String?>? _confirmRecover(String code, LoginData data) async {
    if (code == _usersViewModel.recoveryCode) {
      return await _usersViewModel.changeUserPassword(data);
    }
    return "Given verification code is incorrect";
  }

  Future<String?>? _confirmSignUp(String code, LoginData data) async {
    if (code == _usersViewModel.verificationCode) {
      return await _usersViewModel.signUpUser(data);
    }
    return "Given verification code is incorrect";
  }

  Future<String?>? _resendCode(SignupData data) async {
    return await _usersViewModel.validateEmail(data);
  }

  @override
  Widget build(BuildContext context) {
    LoginViewModel usersViewModel = context.watch<LoginViewModel>();
    _usersViewModel = usersViewModel;
    return FlutterLogin(
      onRecoverPassword: _recoverPassword,
      onLogin: _loginUser,
      onSignup: _signupUser,
      onConfirmSignup: _confirmSignUp,
      onResendCode: _resendCode,
      onConfirmRecover: _confirmRecover,
      title: 'UScheduler',
    );
  }
}
