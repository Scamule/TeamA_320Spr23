import 'package:flutter/material.dart';
import 'package:flutter_application_1/login_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/event_adding.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:flutter_application_1/profile_page.dart';

import 'package:line_awesome_flutter/line_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => EventAdding(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.purple),
        home: const RootPage(),
      ));
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});
  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  //int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoginPage(),
    );
  }
}
