import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';

class CreateEditEventScreen extends StatefulWidget {
  final Event? event;

  CreateEditEventScreen({this.event});

  @override
  _CreateEditEventScreenState createState() => _CreateEditEventScreenState();
}

class _CreateEditEventScreenState extends State<CreateEditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _type;
  late String _date;
  late String _description;
  late String _organizer;
  late String _location;

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      print(widget.event!);
      _title = widget.event!.title;
      _type = widget.event!.eventType;
      _date = widget.event!.date.toIso8601String();
      _description = widget.event!.description;
      _organizer = widget.event!.organizer;
      _location = widget.event!.location;
    } else {
      // Provide default values when creating a new event
      _title = '';
      _type = 'Conference'; // Default type
      _date = DateTime.now().toIso8601String(); // Default to current date
      _description = '';
      _organizer = '';
      _location = '';
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final event = Event(
        widget.event?.id ?? DateTime.now().toString(),
        _title,
        _description,
        DateTime.now(),
        _organizer,
        _location,
        _type,
        DateTime.now(), // updatedAt is set to current time
      );

      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      if (widget.event == null) {
        eventProvider.addEvent(event);
      } else {
        eventProvider.updateEvent(event);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event == null ? 'Create Event' : 'Edit Event'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              initialValue: widget.event?.title ?? '',
              decoration: InputDecoration(labelText: 'Title'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a title' : null,
              onSaved: (value) => _title = value!,
            ),
            DropdownButtonFormField<String>(
              value: _type,
              decoration: InputDecoration(labelText: 'Type'),
              items: ['Conference', 'Workshop', 'Webinar']
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _type = value!),
            ),
            TextFormField(
              initialValue: widget.event?.organizer ?? '',
              decoration: InputDecoration(labelText: 'Organizer'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter an organizer' : null,
              onSaved: (value) => _organizer = value!,
            ),
            TextFormField(
              initialValue: widget.event?.location ?? '',
              decoration: InputDecoration(labelText: 'Location'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a location' : null,
              onSaved: (value) => _location = value!,
            ),
            TextFormField(
              controller: TextEditingController(text: _date),
              readOnly: true,
              decoration: InputDecoration(labelText: 'Date'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a date' : null,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    _date = pickedDate.toIso8601String();
                  });
                }
              },
            ),
            TextFormField(
              initialValue: widget.event?.description ?? '',
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a description' : null,
              onSaved: (value) => _description = value!,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Save Event'),
            ),
          ],
        ),
      ),
    );
  }
}
