import 'package:flutter/material.dart';
import 'package:frontend/models/event.dart';
import 'package:frontend/screens/create_edit_event_screen.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../widgets/event_list_item.dart';
import '../widgets/event_filter.dart';

class EventListScreen extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  late List<Event> events = [];
  @override
  void initState() {
    // Fetch the events when the widget is initialized
    Future.microtask(
        () => Provider.of<EventProvider>(context, listen: false).fetchEvents());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Events')),
      body: Column(
        children: [
          EventFilter(),
          Expanded(
            child: Consumer<EventProvider>(
              builder: (context, eventProvider, child) {
                if (eventProvider.events.isEmpty) {
                  return Center(
                      child:
                          CircularProgressIndicator()); // Show loading indicator
                }
                return ListView.builder(
                  itemCount: eventProvider.events.length,
                  itemBuilder: (context, index) {
                    return EventListItem(event: eventProvider.events[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateEditEventScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
