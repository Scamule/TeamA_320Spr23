import 'package:flutter/material.dart';
import 'package:flutter_application_1/home_page.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const RootPage(),
    );
  }
}
class RootPage extends StatefulWidget {
  const RootPage({super.key});
  @override
  State<RootPage> createState() => _RootPageState();
}
class _RootPageState extends State<RootPage> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("UScheduler"),
      ),
      body: const HomePage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('Clicked on button!');
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(destinations: const [
        NavigationDestination(
            icon: Icon(Icons.calendar_month), label: 'Schedule'),
        NavigationDestination(
            icon: Icon(Icons.person), label: 'Profile')
      ],
      onDestinationSelected: (int index){
        setState(() {
          currentPage = index;
        });
      },
      selectedIndex: currentPage,
      ),
    );
  }
}