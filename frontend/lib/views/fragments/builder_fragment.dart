import 'package:flutter/material.dart';
import 'package:uscheduler/views/pages/find_event_page.dart';

import '../../utils/navigation_service.dart';

Widget builderFragment() {
  BuildContext? context = NavigationService.navigatorKey.currentContext;
  return Scaffold(
    floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => {
        Navigator.of(context!).push(MaterialPageRoute(
          builder: (context) => const FindEventPage(),
        ))
      },
    ),
  );
}
