import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/event.dart';

class EventEditingPage extends StatefulWidget {
  final Event? event;

  const EventEditingPage({
    Key? key,
    this.event,
  }) : super(key: key);

  @override
  State<EventEditingPage> createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  final form_key = GlobalKey<FormState>();
  final titleController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;

  @override
  void initState() {
    super.initState();

    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
    }
  }

  @override
  void dispose() {
    titleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: CloseButton(),
          actions: editingActions(),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Form(
            key: form_key,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              buildTitle(),
              SizedBox(height: 12),
              buildDateTime(),
            ]),
          ),
        ),
      );

  List<Widget> editingActions() => [
        ElevatedButton.icon(
            onPressed: () {},
            label: Text('Save'),
            icon: Icon(Icons.done),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent)),
        //label: Text('Save'),
      ];

  Widget buildTitle() => TextFormField(
        style: const TextStyle(fontSize: 24),
        decoration: const InputDecoration(
            border: UnderlineInputBorder(), hintText: 'Add Title'),
        onFieldSubmitted: (_) {},
        validator: (title) =>
            title != null && title.isEmpty ? 'Title can not be empty' : null,
        controller: titleController,
      );

  Widget buildDateTime() => Column(
        children: [buildFrom()],
      );

  Widget buildFrom() => Row(
        children: [
          //Expanded(child: buildDropdown(text: fromDate),)
        ],
      );
}
