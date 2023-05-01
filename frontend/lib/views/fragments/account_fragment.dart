import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uscheduler/utils/navigation_service.dart';
import 'package:uscheduler/view_models/login_viewmodel.dart';
import 'package:uscheduler/views/pages/login_page.dart';

Widget accountFragment() {
  final GlobalKey<NavigatorState> navigation = NavigationService.navigatorKey;
  final LoginViewModel _loginViewModel = GetIt.instance<LoginViewModel>();
  return Center(
      child: TextButton(onPressed: () {
        _loginViewModel.logOut();
        Navigator.of(navigation.currentContext!).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
      }, child: const Text("Log out")));
}
