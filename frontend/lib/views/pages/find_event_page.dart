import 'package:flutter/material.dart';

import '../../components/find_event_page_search_delegate.dart';

class FindEventPage extends StatefulWidget {
  const FindEventPage({super.key});

  @override
  State<FindEventPage> createState() => _FindEventPageState();
}

class _FindEventPageState extends State<FindEventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text('Search for events'),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            showSearch(
                context: context, delegate: FindEventPageSearchDelegate());
          },
        ),
      ],
    ));
  }
}
