import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uscheduler/views/pages/find_event_page.dart';

import '../../components/event_adding.dart';
import '../../models/course.dart';
import '../../models/utils.dart';
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
class EventEditingPage extends StatefulWidget {
  final Course? event;

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
            onPressed: saveForm,
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
        onFieldSubmitted: (_) => saveForm(),
        validator: (title) =>
            title != null && title.isEmpty ? 'Title can not be empty' : null,
        controller: titleController,
      );

  Widget buildDateTime() => Column(
        children: [
          buildFrom(),
          buildTo(),
        ],
      );

  Widget buildFrom() => buildHeader(
        header: 'FROM',
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: buildDropdown(
                text: Utils.toDate(fromDate),
                onClicked: () => pickFromDateTime(pickDate: true),
              ),
            ),
            Expanded(
              child: buildDropdown(
                text: Utils.toTime(fromDate),
                onClicked: () => pickFromDateTime(pickDate: false),
              ),
            )
          ],
        ),
      );
  Widget buildTo() => buildHeader(
        header: 'TO',
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: buildDropdown(
                text: Utils.toDate(toDate),
                onClicked: () => pickToDateTime(pickDate: true),
              ),
            ),
            Expanded(
              child: buildDropdown(
                text: Utils.toTime(toDate),
                onClicked: () => pickToDateTime(pickDate: false),
              ),
            )
          ],
        ),
      );

  Widget buildDropdown(
          {required String text, required VoidCallback onClicked}) =>
      ListTile(
          title: Text(text),
          trailing: const Icon(Icons.arrow_drop_down),
          onTap: onClicked);

  Widget buildHeader({required String header, required Row child}) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(header, style: const TextStyle(fontWeight: FontWeight.bold)),
        child,
      ]);

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate,
        pickDate: pickDate, firstDate: pickDate ? fromDate : null);
    if (date == null) {
      return;
    }
    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, date.hour, date.minute);
    }
    setState(() => fromDate = date);
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(toDate,
        pickDate: pickDate, firstDate: pickDate ? toDate : null);
    if (date == null) {
      return;
    }
    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, date.hour, date.minute);
    }
    setState(() => toDate = date);
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2002, 01),
        lastDate: DateTime(2100),
      );
      if (date == null) {
        return null;
      }
      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
          context: context, initialTime: TimeOfDay.fromDateTime(initialDate));

      if (timeOfDay == null) {
        return null;
      }

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }

  Future saveForm() async {
    final isValid = form_key.currentState!.validate();
    if (isValid) {
      final event = Course(
          title: titleController.text,
          description: 'Description',
          from: fromDate,
          to: toDate);

      final adder = Provider.of<EventAdding>(context, listen: false);
      adder.addEvent(event);
      Navigator.of(context).pop();
    }
  }
}
