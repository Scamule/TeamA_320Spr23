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

// GetIt instance to manage dependency injection
final getIt = GetIt.instance;

// Initialize dependencies using the @InjectableInit annotation
@InjectableInit(preferRelativeImports: false)
void configureDependencies() => getIt.init();

void main() {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Configure dependencies
  configureDependencies();

  // Run the MyApp widget
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  MyApp({Key? key});

  // Retrieve an instance of LoginViewModel from the GetIt instance
  final LoginViewModel _loginViewModel = GetIt.instance<LoginViewModel>();

  // Retrieve an instance of HomeViewModel from the GetIt instance
  final HomeViewModel _homeViewModel = GetIt.instance<HomeViewModel>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide LoginViewModel to the widget tree
        ChangeNotifierProvider(create: (_) => _loginViewModel),
        // Provide HomeViewModel to the widget tree
        ChangeNotifierProvider(create: (_) => _homeViewModel),
      ],
      child: MaterialApp(
        // Set the navigator key for NavigationService to enable navigation
        navigatorKey: NavigationService.navigatorKey,
        title: 'MVVM',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          brightness: Brightness.light,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // Set the LoginPage as the home page of the app
        home: LoginPage(),
      ),
    );
  }
}
