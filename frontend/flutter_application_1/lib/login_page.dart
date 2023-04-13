import 'package:flutter/material.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_application_1/http_requests.dart';

const users = {
  'ksubbaswamy@umass.edu': '12345',
  'epickard@umass.edu': 'umass',
  'dummy@umass.edu': 'dummy',
};

/// Determines if you use the dummy data locally or via the api
/// If this is set to TRUE, you MUST have the
/// '/backend/loginTest.py' file running
const useHttpRequest = true;

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) {
    debugPrint('\nEmail: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      if (useHttpRequest) {
        // Using API local database
        debugPrint('Running login...');
        Map<String, dynamic> loginResponse =
            await login(data.name, data.password);
        debugPrint('Finished login.');
        return loginResponse['ok'] ? null : loginResponse['message'];
      } else {
        // Using local database
        if (!users.containsKey(data.name)) {
          return 'User does not exist';
        }
        if (users[data.name] != data.password) {
          return 'Password does not match';
        }
        return null;
      }
    });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'UScheduler',
      //logo: const AssetImage('assets/images/ecorp-lightblue.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomePage(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
