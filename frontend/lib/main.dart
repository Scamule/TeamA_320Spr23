import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:provider/provider.dart';
import 'package:uscheduler/main.config.dart';
import 'package:uscheduler/utils/navigation_service.dart';
import 'package:uscheduler/view_models/home_viewmodel.dart';
import 'package:uscheduler/view_models/login_viewmodel.dart';
import 'package:uscheduler/views/pages/home_page.dart';
import 'package:uscheduler/views/pages/login_page.dart';

final getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: false)
void configureDependencies() => getIt.init();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final LoginViewModel _loginViewModel = GetIt.instance<LoginViewModel>();
  final HomeViewModel _homeViewModel = GetIt.instance<HomeViewModel>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => _loginViewModel),
          ChangeNotifierProvider(create: (_) => _homeViewModel)
        ],
        child: MaterialApp(
          navigatorKey: NavigationService.navigatorKey,
          title: 'MVVM',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.light,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: LoginPage(),
        ));
  }
}